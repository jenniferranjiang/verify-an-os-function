本组状态：基础设施阻塞，证明草稿尚未获得 Rocq 验收。

已完整阅读 group-worker-proving 技能与必读文档，只修改本组分配的七个 proof spans。入口、扫描推进、id 自增上下界证明均已写入草稿，未改语义输入、声明或其他组文件。

交接给定的 coq-debug 命令已实际退出，returncode=1，JSON status=failed。其依赖编译 coqc 在 VC/AllocId_goal.v 第 104 行字符 89–92 遇到 `Syntax error: [name] expected after '(' (in [closed_binder])`。当前位置是 `(end: Z)`；`end` 为 Rocq 保留字。失败发生于生成 goal，未进入本组 manual，因此不表示现有证明已通过或存在 annotation gap。debug script 尚未创建。

需要主流程修复生成标识符或 controller 规范化，并重新生成/准备当前输入，随后交还同一 owner 做正式证明检查。worker 未修改 goal、controller、load path 或共享谓词。未无条件重复运行相同检查。所有已启动命令均已实际退出。当前草稿针对原始 binder 名编写，修复后可能需适配变量名并继续 proof debugging。
