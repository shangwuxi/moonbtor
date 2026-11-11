# MoonBTOR

[![验证](https://github.com/shangwuxi/moonbtor/actions/workflows/ci.yml/badge.svg)](https://github.com/shangwuxi/moonbtor/actions/workflows/ci.yml)

MoonBTOR 将 **BTOR2 的位向量安全片段**转成可执行的同步状态模型和有界 SAT 查询。它供硬件/嵌入式开发者定位有限步内的错误，供工具集成者导出 DIMACS 并重放求解结果，也供教学与测试系统逐帧执行模型。实现主要使用 MoonBit，无第三方 SAT 运行依赖。

查询返回最短反例、`BoundedSafe(k)` 或 `Unknown(reason)`。**`BoundedSafe(k)` 仅表示 0 到 k 帧内没有符合约束的所选 bad 状态，不是无界证明。** 反例先核对每个 CNF 子句，再通过独立具体求值器检查初始化、每次同步更新、每帧约束和末帧 bad。

## 安装

模块：[`shangwuxi/moonbtor@0.1.0`](https://mooncakes.io/docs/shangwuxi/moonbtor)。需要官方 MoonBit，`moonc >= 0.10.16`；本版本固定验证 `0.10.18+6c83a7f62`（moon `0.1.20261028`）。旧编译器可能不支持当前 `moon.mod` / `moon.pkg` 语法。

在自己的 MoonBit 工程中执行：

```sh
moon add shangwuxi/moonbtor@0.1.0
```

在消费者的 `moon.pkg` 添加：

```moonbit
import {
  "shangwuxi/moonbtor",
}
```

默认与推荐目标为 `wasm-gc`；支持 `wasm`、`js`、`native`。JS 需要 Node.js；原生目标需要 MoonBit 支持的 C 编译环境。Linux 四目标由公开 CI 验证，具体工具链以 CI 配置为准。

## 快速开始

```sh
git clone https://github.com/shangwuxi/moonbtor.git
cd moonbtor
moon run examples/counter
moon run examples/simulate
moon run examples/external
```

计数器输出状态 `0,1,2,3`、反例 JSON 与 `shortest bad frame = 3`。以下是可直接放入消费者 `main.mbt` 的完整程序：

```moonbit
fn main {
  let source =
    "1 sort bitvec 2\n2 sort bitvec 1\n3 zero 1\n4 state 1 count\n5 init 1 4 3\n6 inc 1 4\n7 next 1 4 6\n8 constd 1 3\n9 eq 2 4 8\n10 bad 9 overflow"
  let model = @moonbtor.parse(source).unwrap()
  match model.check(5).unwrap() {
    Counterexample(trace) => println(trace.to_json_string())
    BoundedSafe(k) => println("bounded safe through frame \{k}")
    Unknown(reason) => println(reason)
  }
}
```

`examples/counter` 中的断言确认较短界限 2 是 `BoundedSafe(2)`，界限 5 找到末帧为 3 的反例。状态在每帧开头观察；深度 0 就检查初始帧。多个 `bad` 按声明顺序选择：`model.check(5, bad_index=1)`；默认选择第 0 个，空 bad 列表返回 API 错误。

## 三个完整工作流

|使用者与输入|处理|输出与可运行入口|
|---|---|---|
|硬件工程师的计数器 BTOR2 文件内容|语法/类型检查、逐帧展开、有限资源求解、具体重放|最短越界轨迹与 JSON，`examples/counter`|
|工具集成者的状态模型与外部 SAT 结果|导出实际 DIMACS；严格校验 SAT 赋值；解码输入和状态；再求值|可重放反例，`examples/export`、`examples/external` 与 `tools/external_roundtrip.py`|
|教学/测试系统的逐拍输入序列|`observe`、同步 `step`、JSON 往返、初值/转移/约束复核|累加器状态 `0,2,5`，跳帧篡改被拒绝，`examples/simulate`|

### 具体执行

`Frame { state, inputs }` 数组按 `state_ports()` / `input_ports()` 的声明顺序赋值。`observe(frame)` 返回模算术后的输出、bad 真值、约束是否成立及 `next_state`。它只观察，不自动强制初始条件或约束。

`step(frame, next_inputs, free_next)` 同时计算所有有 `next` 的状态。`free_next` 依次为没有 `next` 的状态提供下一帧值，缺失或多余都报错。没有 `init` 的状态初始值、没有 `next` 的状态后继值是**非确定的**，不会被默认为零或保持。`replay(trace)` 才负责完整轨迹的合法性；它要求末帧所选 bad 为真，不要求此前 bad 为假。

### 外部求解器集成

```sh
moon run examples/export --target js --quiet > query.cnf
python tools/external_roundtrip.py js
```

第二条命令读取实际导出的 CNF，用独立 Python 穷举求解，再通过子进程环境将 SAT 输出交给 MoonBit 检查。只适用于该小样例（4 个变量），不替代工业求解器。实际集成可用 `query.formula().to_dimacs()`、`formula.parse_assignment(output)`、`query.decode(bits)`；`query.literals(frame, node_id)` 返回原 BTOR2 节点在对应帧的低位优先 literal 副本。

接受的外部结果格式为一行 `s SATISFIABLE` 加一到多行 `v`，整个赋值以 `0` 结束；每个变量必须恰好出现一次。`UNSATISFIABLE` / `UNKNOWN` 不是反例，不能传入此解码器。部分赋值、重复变量、越界、未终止或不满足子句均被拒绝。求解器通过 `MOONBTOR_ASSIGNMENT` 传结果的例子只用于集成演示。

### 反例文件

`trace.to_json_string()` 与 `parse_trace(text)` 使用本项目 schema v1，**不是标准 BTOR2 witness 文件格式**。`state`、`inputs` 的整数编码为十进制字符串，避免其他 JSON 消费者的数字精度问题：

```json
{"version":1,"bad_index":0,"frames":[{"state":["0"],"inputs":[]}]}
```

JSON 解析只验证格式和边界；必须继续调用相应模型的 `replay`。帧以数组次序编号，最多 65 帧，值必须是 0..4294967295 的字符串。字段缺失、额外字段、重复键、负数、数字类型取代字符串均被拒绝。

## 支持的 BTOR2 片段

- `sort bitvec`，宽度 1–32，正且严格递增的 ID（不超过 2147483647），只引用已定义节点。
- `input`、`state`、`init`、`next`、`bad`、`constraint`、`output`。
- 常量 `const` / `constd` / `consth`、`zero` / `one` / `ones`。
- `not neg inc dec redand redor redxor`；`and or xor nand nor xnor`；`add sub mul`。
- `eq neq ult ulte ugt ugte slt slte sgt sgte`；`sll srl sra`；`iff implies ite`；`concat slice uext sext`。
- 行尾 `;` 注释、可选单个符号、CRLF。相同宽度的 bitvec sort 等价。

所有算术按声明宽度截断。有符号比较使用补码；大于等于位宽的逻辑移位为零，算术右移填符号位。`init` 的来源 ID 必须严格小于状态 ID，且其表达式不能直接或间接依赖输入；每个状态最多一个 `init` 和一个 `next`。

明确不支持：数组、负引用 ID、64 位及任意精度向量、除法/余数、旋转、溢出谓词、fair/justice/活性、标准 BTOR2 witness、归纳/无界证明、Verilog/SMT 编译、CDCL、原生求解器绑定。遇到不支持的标签返回带行号诊断，不静默降级。完整硬件验证请使用成熟专用工具。

## 资源与错误

`ParseLimits` 默认最大 20,000 行、每行 4,096 字符、10,000 值节点、32 位；文本硬上限 8,000,000 字符。`Limits` 默认 50,000 SAT 变量、200,000 子句、每个 exact-frame 查询 2,000,000 次扫描步骤、96 层决策；硬上限见 [cnf.mbt](cnf.mbt)。单次查询深度 0–64，总展开位数不超过 1,000,000。

分配或求解预算耗尽时 `check` 返回 `Unknown`；参数错误返回 `Err(Diagnostic)`。DPLL 递归最多 128 层，工作预算在两个分支之间共享。检查界限 k 会从 0 到 k 构建独立查询，每次具有新的工作预算；这是最短反例策略，不是增量 SAT。相同界限与约束下的全部失败才得到 `BoundedSafe`；约束不可满足时结论可能空真，不表示系统有可达执行。

## 开发与复现

```sh
moon info
moon fmt --check
moon check --deny-warn
moon build --deny-warn
moon test --deny-warn
python tools/generate_oracles.py
moon fmt
moon test --deny-warn
python tools/external_roundtrip.py js
```

用 `--target wasm` / `js` / `native` 重复检查、构建、测试和例子。[CI](.github/workflows/ci.yml) 固定官方编译器与 core 的版本及 SHA256，重建独立参考，检查接口和格式，执行四目标检查/构建/测试、三个用户流程、JS/原生外部求解往返以及 wasm-gc 插桩覆盖率。

目前 293 项测试包括 2,599 组独立 Python 整数参考（每组同时验证具体结果、正确结果 CNF 可满足及错误结果不可满足）、180 个独立穷举 SAT 实例和 32 个独立可达状态系统。另有布尔门完整真值表、边界语法、32 位溢出、符号移位、预算、初始化和反例篡改测试。生成测试不计核心代码量；未对生产规模模型性能作保证。

源码布局：根目录 `.mbt` 是可复用引擎；`*_test.mbt` 为外部 API 测试，`*_wbtest.mbt` 为门级测试；`examples/` 是可运行集成；`tools/` 为独立参考及工程工具；[架构](docs/architecture.md) 解释信任边界；[查重记录](docs/competition/duplicate-check.md) 记录有范围限制的生态检索。

## 许可证与来源

MIT，见 [LICENSE](LICENSE)。原创实现参考公开 [BTOR2/btor2tools](https://github.com/Boolector/btor2tools) 语法与解析约束；没有复制上游或相邻项目实现，没有捆绑第三方模型数据。详见 [NOTICE.md](NOTICE.md)。相邻的 SAT/BDD/CTL 项目可用于合作或替换求解后端，本项目的中心是 BTOR2 字级转移语义、时间展开和反例重放，未声称发明 SAT 算法或生态唯一。

AI 参与调研、代码、测试、调试、文档和工程配置；测试可复现，支持范围以本 README 和公开接口为准。本项目尚无形式化认证或已确认客户部署。工程交付不代表比赛官方验收或报名资格认定。
