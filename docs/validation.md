# 可复现验证与边界

## 本地结果（2026-11-11）

固定 moonc `0.10.18+6c83a7f62`，moon `0.1.20261028`。wasm-gc、wasm、JS 的严格 check/build/test 均通过，每个目标 293 项测试；counter、simulate、external 三个用户工作流全部运行成功。独立 Python 对实际导出的 DIMACS 求解后，再将赋值交给 MoonBit 解码与重放；JS 往返通过。Windows native 严格 check 通过，但当前主机缺少 MSVC C++/Windows SDK，不能在本机完成 native 构建、测试与运行。Linux native 由公开 CI 独立执行，以对应提交实际日志为准。

`moon info` 与 `moon fmt --check` 通过。插桩测试 293/293，官方 coverage summary 为 834/986 个位置（包含测试未调用的示例入口）；该统计不等于分支覆盖率或正确性证明。独立整数参考共 2599 组、穷举 SAT 180 个、可达状态系统 32 个；参考生成器只有 Python 标准库依赖。

## 代码量口径

以下为真实生产 MoonBit 文件物理行数；不含测试、生成接口、示例、配置、文档及纯派生方法转发 `extends.mbt`。总计 **1815 行**。按 skill 的物理行口径包含自然空行与代码块分隔，没有为了计数增加空函数或重复代码。额外更严格地排除空白、注释和纯括号行后是 1276 行；两种口径不混用。

|文件|物理行|
|---|---:|
|arithmetic.mbt|100|
|blast.mbt|84|
|bmc.mbt|46|
|cnf.mbt|122|
|decode.mbt|45|
|dimacs.mbt|171|
|evaluate.mbt|152|
|gates.mbt|120|
|lex.mbt|115|
|parser.mbt|295|
|query.mbt|92|
|replay.mbt|89|
|solver.mbt|151|
|trace_json.mbt|136|
|types.mbt|97|

## 测试信任边界

SAT、CNF 和具体求值之间存在交叉验证，但不是机器证明；外部 UNSAT 声明没有证明证书校验，库自带 BMC 只依赖自身求解器。外部 SAT 必须提供完整一致赋值、满足全部子句并通过具体重放。预算耗尽是 Unknown；有界安全只覆盖选定 bad 和给定前缀。生产规模性能、完整 BTOR2 和无界证明均不属于版本 0.1.0 的承诺。
