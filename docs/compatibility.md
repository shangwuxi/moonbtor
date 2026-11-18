# BTOR2 兼容矩阵（0.2.0）

目标是对齐常用 BTOR2 标准语义与模型工作流，而非以自定义子集作为最终项目终点。以下描述当前版本，不将目标能力冒充完成。

|输入/运算族|解析和类型检查|具体执行|CNF 与重放|
|---|---|---|---|
|bitvec、非嵌套 array sort|支持|精确完整位序列|支持完整地址域|
|input/state/output、init/next/constraint/bad|支持|同步、未约束状态非确定|支持|
|const/constd/consth、zero/one/ones、负引用|支持|任意受限位宽|支持|
|not/neg/inc/dec、redand/redor/redxor|支持|支持|支持|
|and/or/xor/xnor/nand/nor、iff/implies|支持|支持|支持|
|add/sub/mul、udiv/urem/sdiv/srem/smod|支持|支持标准边界语义|支持|
|eq/neq、ult/ulte/ugt/ugte、slt/slte/sgt/sgte|支持|支持|支持|
|sll/srl/sra、rol/ror、slice/concat/uext/sext|支持|支持|支持|
|uaddo/saddo/usubo/ssubo/umulo/smulo/sdivo|支持|支持|支持|
|数组 read/write、ite、eq/neq、元素常量初始化|支持|支持完整有限地址域|支持|
|fair/justice|支持|可观测每项目标|显式 lasso 查询及 typed 重放|
|嵌套数组|明确拒绝|未实现|未实现|
|标准 BTOR2 witness 文件|未实现|内存 TypedTrace 可用|仅本项目标量 JSON v1|
|无界安全/活性证明|非文件解析问题|未实现|只支持有界安全和满足条件的闭环|

## 精确语义

位向量模 2^w。无符号除零得全一，余数为被除数；带符号除零遵循符号规则。最小带符号值除 -1 回绕并由 sdivo 报溢出。srem 跟随被除数符号，smod 跟随除数符号；除数为零时保留被除数。旋转量对位宽取模。

数组完整展平：地址 0、1、…，每格低位在前，读写使用全部地址位。相等比较所有元素。数组 init 可以引用同 sort 数组，或使用元素 sort 的真实常量填充所有地址。普通 input 不能作为初始化来源。init/next 需引用已声明节点，排序和类型错误带行号返回。

fair/justice 闭环满足条件而非违反条件；循环区间不重复计算末帧。普通安全查询对包含公平条件的模型报错，调用者不能忽略它们。缺少 init/next 保持标准非确定语义。

## 资源与接口限制

默认 max_width=4096、max_line_length=16384；数组完整展开不超过 1000000 位；乘除等工作预算 20000000 单位。ParseLimits/BmcOptions 另限制文本、节点、深度、CNF 和求解工作。达到保护阈值即返回 Diagnostic 或 Unknown，不返回伪造结果。

旧 UInt64 API 仅用于整个模型非数组且 <=64 位。宽位向量/数组使用 TypedFrame、check_typed、decode_typed、replay_typed。TypedTrace 尚无文件 codec。超大模型、嵌套数组和标准 witness 是后续兼容工作，不把资源拒绝说成语义近似，也不把 4096 位解析说成 4096 位乘法可解。
