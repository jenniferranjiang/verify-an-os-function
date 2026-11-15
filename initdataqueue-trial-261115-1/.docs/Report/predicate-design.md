# Dataqueue predicate 设计（draft）

本轮从源码重启点重新设计，尚未review-ready。仅当前trial；没有读取旧trial，也没有启动QCP。完整20字节本体使用raw byte representation唯一拥有，以QCP现有字节解码关系说明六个字段；不另加padding谓词。这样满足指南§6.1全字节归属和经验第9不重复padding，不使用显式padding例外。QCP当前 `CommonAssertion.v:490` 的 `struct_padding=emp` 不是额外字节owner。Init输入使用undef raw，不能假定未初始化字节值。

## 文件与基线

所有新增Dataqueue文件以空文件为基线，最终目标分别为全局 `lib/dataqueue/DataqueueState.v`、`lib/common/DataqueueInv.v`、`lib/dataqueue/KInitDataqueue.v`。下列副本仅因新VarGlobalState/STS引起实际接口类型改变而逐项适配，未修改纯State/配置/布局库直接import全局版本。各行原路径也是未来迁出目标；哈希对应引入时实际文件，可用于检验后续增量基线，不把复制内容算新成果。

| trial/lib 文件 | 全局来源/目标 | 基线SHA256 |
|---|---|---|
| `AssignInv.v` | `lib/assign/AssignInv.v` | `120fd63f189f825dacf833f1d66e12a1df4687847352c04b44ec48d337bd42f1` |
| `Bitmap.v` | `lib/assign/Bitmap.v` | `012c7741e3d97b0110d92e879ffcc96b1d7c1964b6503bd1bebb797dd512e835` |
| `KTaskOsAssign.v` | `lib/assign/KTaskOsAssign.v` | `5d816694be96c8bd3d7c875e1e7c1317a763acba6e9619e685cda527c5b2dd06` |
| `OsAssignReadyVector.v` | `lib/assign/OsAssignReadyVector.v` | `f02c406770b43a6652283ab9b44dab7791a3b16c17ee439fc9bd93034a697819` |
| `CrtosGlobState.v` | `lib/common/CrtosGlobState.v` | `c00205795c329edc84e5b669cbc32f1b49b2806d0156bdcfd8008eb20b7bd217` |
| `CrtosInv.v` | `lib/common/CrtosInv.v` | `500a98b54c4f1cc119c5cfc82db3d097d3d34c29aca8d2ab708c2876041a9d82` |
| `CrtosRules.v` | `lib/common/CrtosRules.v` | `8d03b2b887da9ad7710ade56d5d2a2fb1f3e8cac939469a38181e26f761bc467` |
| `ServiceSlotWf.v` | `lib/common/ServiceSlotWf.v` | `ebaac5cc570def28bed4f97ff3307178651e033da5372e8622de5779f0a09f84` |
| `dll.v` | `lib/common/dll.v` | `f7d2ec90ee7f03a5485fa4f2c961213e1c062cd572fe2fb368de5c54215feaa4` |
| `DelayInv.v` | `lib/delay/DelayInv.v` | `95fd7ede51de6797039c385ed3e1366d7091fb809cb4d756041f0ba5047a3628` |
| `KTaskDelayMem.v` | `lib/delay/KTaskDelayMem.v` | `22c3f8df686870f33515d132bcd0cd181bbf1fcce5bb49a2251897371c6dab59` |
| `KTaskUnSetDelay.v` | `lib/delay/KTaskUnSetDelay.v` | `e18b0aef269fb4d20b482f25da1724d21e707fa398a03caeac1c3fae33ed1198` |
| `EventInv.v` | `lib/event/EventInv.v` | `09f37faba5acac07978c0981dcdcae9951d475dd9bb82320ae7d803e9a437e54` |
| `EventLayoutABI.v` | `lib/event/EventLayoutABI.v` | `07def181414198799671fcf926f2dace8b99432461ac2aa87c9c55811177130c` |
| `idnode.v` | `lib/id/idnode.v` | `d0a166e0f64f6acf1323b5cb888751ccbf63adb1b15a6fa9fee4edb6bc1b9b58` |
| `IsrManagerInv.v` | `lib/isr/IsrManagerInv.v` | `dfeeaf4b4da88e766a05060dde98d22d92b8d1e9b31b27ab184d007558a5763d` |
| `DoubleLinkListSpec.v` | `lib/list/DoubleLinkListSpec.v` | `0a272fb06e4218d064f8be3f4d17843da27cd9e8b4edf2f493594df8a3e37e9e` |
| `NodeSelfLinked.v` | `lib/list/NodeSelfLinked.v` | `16f8b08c8af47d52f06055a4a9a92831ac10b5c7223dce6bd75b2deabe98eaf3` |
| `MutexInv.v` | `lib/mutex/MutexInv.v` | `b6f7307606028aea3c38e7237a6d2e07bd98a641b1e3743d649158014948c8cc` |
| `SemaphoreInv.v` | `lib/semaphore/SemaphoreInv.v` | `e50848bf49fe2f955e836cc39e0aa2a2a1bdd46faa7918d584c5b431e3e190ed` |
| `ExstatusInv.v` | `lib/task/ExstatusInv.v` | `b718e2f17dd9719e0bc1b593e37b81c6289ca33078483f476bb3b614e916f57a` |
| `KTaskSchedMember.v` | `lib/task/KTaskSchedMember.v` | `a4fd66a1ffc5b7d42f3031c5ae27ba19876e6291cda54c0d490f15e5b554a9c6` |
| `KTaskStackSetup.v` | `lib/task/KTaskStackSetup.v` | `7acf700b7cbd38e81594e1199128d51e0c79c8461d70943ef491951817557727` |
| `KTaskWakeup.v` | `lib/task/KTaskWakeup.v` | `aa8b34fdaf3bb44b7bb6de551a2af38098ff03d283b3bad39cd2cdec50eb9762` |
| `TaskInv.v` | `lib/task/TaskInv.v` | `43c880a099c152a83b838adf4ebd33c65df67784a0c9695497ff7f13f12beb07` |
| `TaskStatusMemory.v` | `lib/task/TaskStatusMemory.v` | `bda16faef54155629c40d76a353c3b17fb40e236db46afac745d4118566e9de1` |
| `TickInv.v` | `lib/tick/TickInv.v` | `f0f86e05ad3d274e286c09aa5dfbd9fcc39b2f948aa955649797b3ca0efc952e` |
