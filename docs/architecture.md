# 架构

1. parser / typed_parser / lex：顺序读取 BTOR2，检查 sort、引用与端口，常量变成低位优先位序列；负引用共享合成 not 节点。
2. types：不可外部构造的模型内部节点和公开端口/帧；数组携带元素宽和地址宽，完整展平有分配预算。
3. concrete_words / typed_evaluate：具体 Bool 数组运算、恢复除法、带符号修正、数组读写；不调用符号电路。
4. cnf / arithmetic / division / blast：逐节点精确位展开，Tseitin 门电路、桶式移位、除余及溢出电路；与具体计算代码分离。
5. query / lasso：初值、同步转移、逐帧约束及目标选择。lasso 末状态闭环并覆盖 fair/justice，不是无界活性证明。
6. solver / bmc / typed_bmc：有预算 DPLL；逐深度查找最短有限安全反例，预算耗尽返回 Unknown。
7. decode / typed_replay：先核验全部 CNF，再将赋值解码为 typed 端口，独立重放每次转移及目标；标量 API 和 schema v1 是受限兼容层。

公开 API 由 pkg.generated.mbti 检查；用户端口/帧数组不被执行器修改，返回值不暴露内部 CNF 可变存储。运行依赖仅 MoonBit 标准库。Python、Z3、上游模型只用于开发验证。

详细输入覆盖、非目标和资源限制见 compatibility.md；验证证据层次见 validation.md。
