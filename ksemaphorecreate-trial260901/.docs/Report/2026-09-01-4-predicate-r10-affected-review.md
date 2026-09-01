# Semaphore predicate r10 affected-only review

状态：`review interrupted`（无结论，已由 r11 取代）

Predicate revision：`predicate-r10-f37032130dcc`。在 trial 根运行 `sha256sum lib/*.v | sort | sha256sum` 得到 manifest hash `f37032130dcc99388b7caee8329c75ad65192715a69d5ee4b4a84f236cd5a933`。权威 C、配置、scope 和 trusted 列表未变。

r10 包含 r9 对 `PRED-R8-01..05` 的全部修复：task-owned `(task,id,priority,name,exstatus)` 线性 borrow，删除 semaphore 对 task 字段的持久 ownership 和不可保持 Sorted，精确 waiter 构造子与单步 guarantee，以及 critical protocol/counter/conditional memory/static-runtime lifecycle 组合接口。详细修复与 dependency closure 记录见 `2026-09-01-3-predicate-r9-affected-review.md`。

r10 额外关闭 main 自审发现的直接依赖：

- `SemaphoreEnterCritical` 构造子现在直接要求 `SemaphoreCanEnter handlers`，因此 STS 自身不再允许 handler depth 65535 时的溢出进入。
- `SemaphoreCriticalLifecycleStep` 以正式 phase transition 连接 `SemaphoreBeforeProtocolInstall` 与 `SemaphoreAfterProtocolInstall`，并要求 `SemaphoreProtocolInstallEffect`将空 semaphore state 原样转交；这与两个 spatial lifecycle 端点共同表达 static/BSS 零 counter → installed outside/depth-0。

## 机械检查

- Rocq 8.20.1 `make clean && make -j2` 全量编译通过，`make -q` 通过。
- `rg -n '\b(Parameter|Axiom|Admitted|admit)\b' lib --glob '*.v'`：零匹配。
- 未运行 QCP parser/symbolic、closure script、VC 生成或 proof。

## Affected-only review 记录

独立 reviewer 开始后，main 在 spec dependency 自审中确认 lock/unlock wrapper 还需要两个精确 C 中间态：ghost enter 后 counter 自增前，以及 counter 自减后 ghost guarantee 提交前。复审在给出结论前被中止；r10 不是 `review-passed` revision。
