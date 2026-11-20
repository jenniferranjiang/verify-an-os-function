> 2026-11-21 更新：Dataqueue 已改为有效元素列表，本文旧 Dataqueue predicate/spec/实现结论不适用于新输入。Init、DeInit、Peak、Pop 的旧表示证明需重新适配；历史记录保留。见 [本轮设计与验证范围](../2026-11-21-FifoRepresentation/design.md)。

# PopDataqueue / PushDataqueue 新实验上下文

本轮仅设计和审阅，终点为 predicate 与完整调用闭包 spec 分别 review-passed。禁止启动 verification-orchestrator、运行 QCP parser/symbolic/closure script、生成 VC 或证明 C 实现；Rocq 编译和类型检查照常进行。旧实验的实现授权不用于本轮。

开始时全局工作树已有大量未提交改动（含 Dataqueue、Semaphore、构建、技能和旧实验报告）；本轮以实际工作树为基线，不以 HEAD 覆盖。开始前保存全部 lib `.v`、annotated C `.c/.h` 和根构建输入快照；基线清单 SHA-256：`bd158c231e839d772781533e8319e9833efc2cb9b256cd602384e7f759776a91`。快照仅供本轮比较，阶段结束后删除。

配置使用 `/home/xinra/crtoslatest`（只读），commit `a07641a0b58469ae3ea19317cce2cf48974989bb`；QCP 库 `/home/xinra/qcp-binary-democases`；Rocq 8.20.1 路径 `/home/xinra/.opam/pv-bench-8.20.1/bin`，与 tools/rocq/toolchain.json 一致。沿用 CRTOS_Verify 逻辑前缀、全局 lib/annotated_C 布局、当前生成式 Makefile 和 _CoqProject 输入配置。

已批准 DQ-02/03 副本修复及共享 ID 读取适配的授权依据见[既有源码错误记录](../2026-11-16-InitDataqueue-DataqueuePeak/source-errors.md)及[修改对照](../2026-11-16-InitDataqueue-DataqueuePeak/source-changes.md)。该记录明确修复授权继续有效且删除分析副本不撤销修复方案；本轮重新核对适用源码并落入 canonical 输入。旧实验的 review-passed/done 不充当本轮结论。

默认白名单001按适用条件处理 assertS 对临界区候选观察的检查，不扩展信任，也不把非真空性写成已证明结论。未配置用户补充白名单或源码处理文件。

| 输入 | SHA-256 |
|---|---|
| `.agents/verify-os.config.json` | `d27d3052c055040f1b88b5f6341a8b65aa66577b814295835a741a85c20fd027` |
| `.agents/skills/verify-an-os-function/references/TrustBase.md` | `a2201e7277938c1c45f3570c4224fa26724bc7d4f27027077f00d6d384ad35f7` |
| `.agents/skills/verify-an-os-function/references/ReviewWhitelist.md` | `936815c7f167b58e50dc3e4332133bea94146b91cc75b47781100743487313b4` |

源码内容版本（本轮读取，原仓库不修改）：

- `thread/data_queue.c`：`a8b12c43c3f2061df08320f50daaabda7ada033e40670c2d37ea2d8ef774f601`
- `thread/semaphore.c`：`dafd02bf7c6fa5a7324c6e0f824d9a1ddc1544c43f9e71aabeb902d832f30ab8`
- `thread/linklist.c`：`53eed893164c56e2eee7c4772eacba3d07cd4f31c71c388e326ed57a30103461`
- `thread/tick.c`：`ddf26d9067e046fc206ea3f15ad117fc23c9bfb0933ada2902a8ada18591771c`
- `include/xs_dataqueue.h`：`fb10a4ae331e8646d0cf26c3302c63d0b199e3bb6562d351a9130aa705454df8`

本轮与实际基线的核对：已有 lib `.v` 均保持原内容；新增8个库文件。既有正式C体未改，只有 dataqueue.h 增加本轮词汇/import，另新增9个canonical与semaphore_runtime_logic.h。_CoqProject及生成配置登记新输入，lib/index.md更新导航。没有改旧 VC、controller reports或verification_runs；已有审阅/证明未因共享定义语义变化失效，也未被本轮冒称为新证明。

构建检查：根 `make lib/dataqueue/KPopDataqueue.vo lib/dataqueue/KPushDataqueue.vo -j2` 成功，覆盖8新库与所需依赖；9新C使用 `gcc -m32 -std=c11 -fsyntax-only -Wall -Wextra -Iannotated_C/src/headers` 通过。新增17个term词汇（dataqueue.h 5个、runtime header 12个）以 `Check (symbol : signature)` 在相同工程映射下独立coqc通过。未运行QCP解析或symbolic。

阶段收尾：独立审阅两项均通过，版本与冻结哈希见[review.md](review.md)。已复核哈希和本轮报告链接，删除本轮临时基线及新库无需继续使用的辅助编译文件，保留全部8份新 `.vo`；未触碰既有缓存、旧证明或控制器恢复状态。本轮至设计审阅结束，不请求或启动实现阶段。

## 共享header按需启用（第一阶段窗口兼容修复）

第一阶段恢复时将dataqueue.h新增Pop/Push词汇块置于CRTOS_DATAQUEUE_WITH_OPERATIONS条件下，并在PopDataqueue.c/PushDataqueue.c include前定义该宏。两份C经同参数GCC预处理，忽略空白和新增guard结束注释后，包含formal注解的全部预处理文本与修改前完全相同；规格、body及import不变。Init/DeInit/Peak不再引入无关Pop/Push语义模块，保持已有生成前导。此为非语义include适配，不启动第二阶段workflow，也不把设计审阅改称实现证明。更新文件哈希如下（替代上方同文件旧值）：
- `annotated_C/src/headers/dataqueue.h`：`95fc4e87bb93606957b80da5e6796dee98229b51ff26f68ec5271b0cc5934c79`
- `annotated_C/src/kernel/dataqueue/PopDataqueue.c`：`0466f1d8340af4bb0535f65ac6eca45b5f7ab66f30a29b35ffdcf4c23eb9e569`
- `annotated_C/src/kernel/dataqueue/PushDataqueue.c`：`767436057dcae1d30a979210db1c9e2a76d5f0132f1e2695de8f8252a0fc073e`
