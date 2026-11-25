# MoonBTOR

[![验证](https://github.com/shangwuxi/moonbtor/actions/workflows/ci.yml/badge.svg)](https://github.com/shangwuxi/moonbtor/actions/workflows/ci.yml)

MoonBTOR 是用 MoonBit 实现的 BTOR2 状态模型执行与有界验证库。面向硬件模型调试、外部 SAT 工具集成、教学及测试系统，提供类型检查、精确位向量与数组执行、时序展开、DIMACS、反例解码和独立重放。

**0.2.0 不再将数组、除余或溢出谓词排除在项目目标之外**：已实现非嵌套数组、标准位向量算子、负引用，以及 fair/justice 的有限闭环查询。长期目标是对齐常用 BTOR2 标准输入与工作流；当前实现边界和资源上限见[兼容矩阵](docs/compatibility.md)，不声称无条件兼容所有模型或完成无界证明。

`0.3.0` 增加嵌套数组执行/CNF 与 BTOR2 SAT witness 编解码；功能及限制以源码和下方兼容矩阵为准。

## 安装与环境

模块：[`shangwuxi/moonbtor@0.3.0`](https://mooncakes.io/docs/shangwuxi/moonbtor)。要求 `moonc >= 0.10.16`，固定验收工具链 `moonc 0.10.18+6c83a7f62`、moon `0.1.20261028`。

```sh
moon add shangwuxi/moonbtor@0.3.0
```

在消费者 `moon.pkg` 导入：

```moonbit
import {
  "shangwuxi/moonbtor",
}
pkgtype(kind: "executable")
```

支持 `wasm-gc`（默认）、`wasm`、`js` 和 `native`；JS 需要 Node.js，native 需要支持的 C 编译环境。Linux 四目标由 CI 检查。生产库没有第三方 SAT 或 Python/Z3 运行依赖。

## 可复现快速开始

```sh
git clone https://github.com/shangwuxi/moonbtor.git
cd moonbtor
moon run examples/counter
moon run examples/memory
moon run examples/lasso
moon run examples/witness
moon run examples/simulate
python tools/external_roundtrip.py js
```

以下完整 `main.mbt` 可直接在消费者运行，输出第 3 帧到达 bad 的计数器反例：

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

`check` 返回最短反例、`BoundedSafe(k)` 或 `Unknown(reason)`。**BoundedSafe 仅表示 0..k 帧内没有符合约束的所选 bad，不是无界安全证明。** 多个 bad 按声明顺序选择，默认第 0 项，例如 `model.check(5, bad_index=1)`。深度 0 检查初始帧。

## 三个完整场景

|使用者及输入|处理过程|结果和入口|
|---|---|---|
|硬件工程师输入包含存储器的 BTOR2 模型|数组完整地址域位展开，求解初始化、读写和同步 next|找到 1 步存储器 bad；typed 解码并独立重放，`examples/memory`|
|验证工具集成者输入状态模型及外部 SAT 结果|导出 DIMACS，逐子句核验完整赋值，解码输入/状态，再具体执行|可重放反例；`examples/export`、`examples/external`、`tools/z3_interop.py`|
|教学或测试系统输入逐拍赋值或公平条件|具体求值与同步更新；或构建 fair/justice 闭环查询|累加器逐帧结果、篡改拒绝、0→1→0 公平闭环；`examples/simulate`、`examples/lasso`|

## 数据与 API

### 具体执行和类型

- `parse(text)` / `parse_with_limits(text, limits)` 做语法、引用、位宽及 sort 检查，错误返回包含行号的 Diagnostic。
- `typed_state_ports()` / `typed_input_ports()` 返回位宽、索引位宽、原节点 ID 和名称。普通位向量的 `index_width=0`。
- `TypedFrame { state, inputs }` 中每个端口是一组低位优先 `Array[Bool]`；数组按无符号地址从小到大连接各元素，每元素低位在前。**完整表示全部地址，不抽样、不哈希近似。**
- `observe_typed(frame)` 返回 outputs、next_state、bad、constraints_hold、fair 和 justice；`step_typed(frame, next_inputs, free_next)` 做同步更新。
- 缺少 init 的状态初值非确定，缺少 next 的状态后继非确定，不擅自假设零或保持。`free_next` 为无 next 状态依次指定后继。
- 兼容 API `Frame` / `observe` / `step` / `check` / `Trace` 只接受**整个模型非数组且位宽不超过 64**，超出返回错误而非截断。`check_typed`、`TypedTrace` 支持数组和宽位向量。

### 有界安全及外部求解

`model.query(depth)` 构建有限安全查询，`query.formula().to_dimacs()` 导出 CNF，`formula.parse_assignment(text)` 读取外部 SAT 输出，`query.decode_typed(bits)` 先检查所有 CNF 子句，再独立重放 init、next、constraint 和末帧 bad。`query.literals(frame, node_id)` 返回指定节点低位优先 literals 的副本。

SAT 文本必须包含一行 `s SATISFIABLE` 和以 `0` 结束的 `v` 赋值，每个变量恰好出现一次；部分/重复/越界赋值、UNKNOWN、UNSAT 都不是可解码反例。`tools/external_roundtrip.py` 是小实例独立枚举流程，不是工业求解器。

`check_typed(depth)` 使用内置有预算 DPLL。预算耗尽返回 Unknown，不冒充 UNSAT；大模型建议导出外部求解，但构建 CNF 同样有上限。

### fair / justice

`lasso_query(depth, loop_start, justice_index=Some(0))` 要求末帧状态等于指定循环起始帧，循环区间 `[loop_start, depth)` 内每个 fair 及所选 justice 组的每项目标至少出现一次。`decode_typed` / `replay_typed` 验证闭环条件。

**它寻找满足公平与 justice 条件的有限闭环，不是寻找 justice 违反，不是通用 LTL 或无界活性证明。** 含 fair/justice 的模型必须显式选择该接口，普通安全 query 拒绝，避免悄悄丢弃条件。

### 轨迹格式

`Model::read_witness(text)` 读取 BTOR2 `sat` 见证，按零基序号解析 `b`/`j` 声明、`#` 状态帧、`@` 输入帧、二进制值和单层数组索引，并复核初值、同步转移、约束、bad 命中及 justice/fair lasso。`Model::write_witness(trace)` 为可重放的有限 bad 轨迹或 justice lasso 写出对应文本。省略的自由值以零补全，不会搜索缺失赋值；读取时也接受 `[*]` 数组默认值扩展（不属于基本索引语法，不能假设所有工具都接受）。嵌套数组可执行和编码，但单层 `[index] value` 记录不能表示嵌套端口；需要读写此类端口记录时会明确报错。

`Trace.to_json_string()` / `parse_trace()` 是另一个本项目 schema v1，仅服务非数组、至多 64 位无符号标量；十进制值精确保留。它不替代 BTOR2 witness。

## 标准语义与运行边界

非嵌套数组 sort、读/写、数组 ite/eq/neq、数组 init/next；标准模算术、比较、移位、拼接/切片/扩展、旋转、除余及全部溢出谓词均有具体执行和 CNF 实现。除零、带符号最小值溢出、srem 与 smod 符号差异按 SMT 位向量语义处理。

默认解析位宽上限 4096，行长 16384；数组完整展平最多 1000000 位，运算估计最多 20000000 工作单位，另有节点、CNF、深度、DPLL 与 witness 文本/帧预算。大地址域/大乘除模型可解析但在执行或构建时明确拒绝。它们是资源保护，不是可求解规模承诺。浮点和无界证明尚未实现。详见[兼容矩阵](docs/compatibility.md)与[架构](docs/architecture.md)。

## 开发与验收

```sh
python tools/generate_oracles.py
python tools/generate_standard_oracles.py
moon info
moon fmt
moon fmt --check
moon check --deny-warn
moon build --deny-warn
moon test --deny-warn
moon test --target js --deny-warn
moon test --enable-coverage --deny-warn
moon coverage report -- -f summary
```

新增标准算子覆盖 1876 组独立 Python 数值样本，14 类算子、1/3/32/64 位；其中 952 组 1/3 位样本额外验证正确 CNF 可满足、错误结果不可满足和 typed 重放。32/64 位样本仅做具体值对照，不能混称全量符号验证。保留旧版算术、枚举可达性及对抗输入回归。

可选开发互通检查（Z3 不进入运行包）：

```sh
python -m pip install z3-solver==4.15.4.0
python tools/z3_interop.py js
python tools/upstream_compat.py PRIVATE_EVIDENCE_DIRECTORY
```

Z3 脚本独立核对全部 1876 组预期值，并实际完成存储器 CNF→Z3→typed 解码→重放。PRIVATE_EVIDENCE_DIRECTORY 须替换为仓库外路径。上游脚本固定 btor2tools 提交，仅检查上游例子解析，不等同完整求解兼容。测试层次与限制见[验证说明](docs/validation.md)。

## 许可证、参考与 AI

本项目采用 [MIT](LICENSE)。BTOR2 格式参考 [Boolector/btor2tools](https://github.com/Boolector/btor2tools)，位向量运算参考 [SMT-LIB FixedSizeBitVectors](https://smt-lib.org/theories-FixedSizeBitVectors.shtml)。未复制上游解析器或 SAT 实现；上游模型只在仓库外用于互通验证，其许可单独保留。实现与测试由 AI 辅助编写，技术责任和验证记录归本项目；来源及范围见 [NOTICE.md](NOTICE.md)。
