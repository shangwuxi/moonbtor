# MoonBTOR 选题与有界语义查重（2026-11-11）

实际执行已安装 osc2026-guide 的 Project Research Guide；比赛依据仍为 builder 固定九月章程，不冒充八月规则。实际开始日期晚于记录的截止日期，不保证本届资格。

## 需求与候选

|领域候选|真实任务/成熟依据|实现核心与完成判据|决定|
|---|---|---|---|
|生存分析|医学统计/可靠性团队对删失样本估计风险；R survival、lifelines|KM/Cox/风险与置信区间，参考数值对照|淘汰：Lyl66655/moon-survival@0.2.4 已有直接完整实现，实际检查 KM/Cox/测试|
|射频 Touchstone|仪表、射频设计与产线团队交换网络参数；IBIS Touchstone、scikit-rf|文件解析、S/Y/Z、级联、去嵌入；标准文件与数值对照|淘汰：guolei-dev/touchstone@0.2.1 的实际源码/接口/analysis_test 直接重合|
|BTOR2 状态机|硬件工程师查安全边界；集成者导出 SAT 查询；教学者重放时序反例；Boolector/btor2tools|类型化位向量、同步 init/next、约束和 bad、逐时间帧 CNF、安全查询及独立具体重放；Python 整数参考/穷举状态参考|通过有界门禁并原子预留|

评分（广度/需求/复用/低重合/深度/验证/可行/维护，1–5）：BTOR2=4/4/5/4/5/5/4/4=35。两个直接替代候选属硬失败，不以分数救回。无参与者访谈或使用经验声明。需求依据为成熟 BTOR2/硬件验证工作流，三类下游为合理迁移场景而非已确认客户。

## 检索范围与结果限制

实际 `moon search <keyword> --limit 100 --json`：survival、netcdf、nmea、metar、taf、aviation、bvh、motion capture、skeleton、miniseed、seismic、rinex、gnss、petri、rete、rule engine、information theory、wavelet、touchstone、s-parameter、radio frequency、scikit-rf、impedance、edf、biosignal、cpio、btor、ephemeris、sgp4、hdf5、btor2、boolector、bounded model checking、model checker、bitvector、bitblast、aiger、SAT solver、transition system、hardware verification、有界模型检测。模糊检索 metar 等达100上限，不据此排除后续结果。核心 BTOR2/boolector 无结果仅为辅助证据。

GitHub 指定账号隔离 helper 的实际 repository/code 搜索 `per_page=100`：btor2、boolector、bounded model、MoonBit hackathon btor；code 的 bad state/bitvector/bitblast/symbolic execution/bounded model checking。宽关键词有噪音与索引上限；BTOR2/boolector 代码及仓库查询0，不声称绝对不存在。读取 moonbitlang/awesome-moonbit 官方清单。raw.githubusercontent.com 部分 TLS 不可达，改用官方 GitHub contents API，不关闭 TLS 验证。

检索月饼详情和实际官方下载 ZIP；README/API/源码/测试作为主要证据，未执行第三方测试。所有原始命令和下载快照保存在仓库外本地验收证据目录，不把这些日志伪装成申报书。

## 能力对照与独立必要性

|相邻项目|已检查实际内容|重合与边界|
|---|---|---|
|oyjh0381/moonbdd@0.1.0|analysis.mbt、analysis_test、模型计数和接口|高度相邻：Boolean ROBDD/关系/符号状态分析；不是 BTOR2 word-level 类型语义、逐帧展开和反例再执行|
|length-super/moonctl|model/check/oracle_test、接口|显式 Kripke CTL 固定点、见证；BTOR2 有符号/模算术同步状态是不同输入模型，不重做 CTL|
|NaIWaniubi/moonprove|Fourier/solver 与 verify 测试|MoonBit AST 符号执行与线性整数约束；不是 BTOR2 位向量转移系统|
|Lyhdsba/fusekite|SAT solver、接口、组合逻辑测试|高度相邻：SOP/POS、74HC 和小型 QF_BV；MoonBTOR 的中心是状态/时序文件模型，不再包装组合逻辑化简|
|moonbit-community/pomegranate|SAT/Dimacs、src/bmc_test.mbt|bmc 测试读取已编码的 CNF 文件，不是 BTOR2 前端；DIMACS 可用于协作接入现成求解器|
|moonbit-community/z0|README、SMT2/Bool+EUF 实际接口与测试|通用求解器，不声称创新 SAT/SMT；本项目提供专用前端和重放|
|yzfyzf12345678/moonbit-rtl|model/checker/formal_checks 与测试|Verilog 解析/规则检查；不替代综合器或 RTL 编译|

永久注册表完整标题与相关指纹已读取：MoonBench、MoonContract、MoonRecur、MoonShard、MoonSPDX/MoonPolicyProof、MoonPetri、MoonConcept、MoonWFST、MoonZDD 等全部保持保留；无状态机文件/字级时序展开核心重合。注册表使用同目录 share-none 独占锁、锁内重新读取、临时文件和原子替换；首次 Replace 空备份参数失败未写入，重读后带非空仓库外备份成功，不覆盖并发更新。

## 交付边界

不是完整 BTOR2/SMT/无界证明工具：数组、fair/justice、活性、归纳证明、大规模工业 CDCL 和原生求解器 FFI 均不承诺。预算耗尽必须 Unknown，不能当安全。独立建设的理由是统一 BTOR2 验证、时帧展开、输入/状态归属和反例重放，而不是重做 BDD/SAT 基础库。实现前结论仅为：在已记录检索范围内未发现成熟直接替代。

参考：[BTOR2](https://github.com/Boolector/btor2tools)、[官方清单](https://github.com/moonbitlang/awesome-moonbit)、[月饼](https://mooncakes.io/)。仅依据公开规格原创实现；未复制相邻项目或上游源码。
