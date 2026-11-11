# 来源与许可证

MoonBTOR 是根据公开 BTOR2 规格独立实现的 MoonBit 项目，采用 MIT 许可证。
没有移植或复制 Boolector、btor2tools、相邻 MoonBit 项目的实现、测试向量或数据集；没有捆绑第三方求解器。

参考项目：[Boolector/btor2tools](https://github.com/Boolector/btor2tools)，MIT。
参考范围为 BTOR2 文本语法、位向量运算含义，以及上游解析器对 `init` 来源顺序和输入依赖的约束。
不声明与该项目完整兼容，不使用其项目标识代表官方认可。
上游原始版权声明保存在链接所指项目的 LICENSE.txt 中；仅阅读参考，没有再分发其源码或规格原文。

运行依赖为官方 `moonbitlang/core` 的 builtin、debug、json、env 模块，保留其各自许可证。
Python 工具只用标准库。布尔门的 Tseitin 编码、ripple carry、DPLL 和 BFS/穷举均按通用算法独立编写。
`oracle_*_test.mbt` 是本仓库 `tools/generate_oracles.py` 生成的独立数值/穷举参考，不是从求值器输出录制的快照。
所有模型样例为本项目自行编写，无保密硬件、个人信息或商业设计数据。

AI 参与了选题调研、实现、测试设计、调试、中文文档及工程配置。对正确性与来源的判断以可复现测试和明确的支持范围为依据。
当前没有形式化证明、第三方安全认证或真实客户部署声明。
