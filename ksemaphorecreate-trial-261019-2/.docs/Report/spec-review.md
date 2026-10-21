# Spec 独立审阅

**review-passed**：`S-261019-2-r1`，固定依赖已通过 predicate 审阅的
`P-261019-2-r2`。审阅文件为 `checks/spec-revision.json` 中的 9 个 canonical C
文件和 3 个 headers；独立重算全部 SHA-256 一致。该 manifest 的 SHA-256 为
`f5da6bfb057410c3c03d099293ea884cf3b0c7f32be710fb49120c467a31982d`。
未发现影响本次规格设计正确性的未解决问题。

源码、配置和 ABI 以 `checks/source-hashes.json`、`source-analysis.md` 和
`checks/abi-compile.txt` 为依据：权威目录为
`Ubiquitous/XiZi_IIoT_Macro`，board 为 `stm32f103-nano`，Cortex-M3 ILP32、非 SMP，
ID 容量 128、hash bucket 16。审阅中独立读取目标、ID、双链、critical 正文和关键
headers/config，并再次运行只读 source token/hash 检查，9 个真实函数体全部一致。

## 范围与源码一致性

从 KSemaphoreCreate 的固定 done 分派重新追踪，非 trusted 闭包恰为
KSemaphoreCreate、_SemaphoreCreate、CriticalAreaLock、CriticalAreaUnLock、
IdInsertObj、AllocId、InsertObj、InitDoubleLinkList、DoubleLinkListInsertNodeAfter。
每个函数恰有一份同名 active canonical body。共检查 19 处 declaration-only
API；其中所有非 trusted 合同与 canonical 连同签名去空白后相同，没有裸 call。

仅 x_malloc、x_free、memset、DisableLocalInterrupt、EnableLocalInterrupt、KPrintf
按用户指定语义 trusted；未读取其函数体，没有把 CriticalArea wrappers 算作 trusted。
重复出现的 KPrintf 合同一致。allocator 和 memset 对本次 32 字节对象的约定、free
消费完整全零未发布对象、打印 emp 到 emp，均没有扩展用户给出的保证。

已核对的等价归一包括：唯一不变 done 表改为直接调用；static 函数与计数槽使用
对应 slice external 声明；IRQ 宏展开；局部空 KDEBUG 宏保留空语句；NULL_PARAM_CHECK
保留打印和无限循环；KDBG_IPC=0 日志保留不可达的两次打印。没有改变控制流、
释放顺序、赋值顺序、位运算或返回值。类型保持完整字段顺序；32 字节 Semaphore、
12 字节 IdNode/IdManager 和三个嵌入链表位置与原 headers 的 ILP32 编译证据一致。
没有声称执行 ARM 交叉编译或证明机器码等价。

## 路径、行为与资源

三个顶层入口分别表达 IRQ 开启、IRQ 已关但尚未取得投影、真正 nested；每个
入口都显式列出 -5 与合法 ID 返回。未要求计数初值为 0、禁止 65535、限制空系统
或额外限定线程上下文。uint16 参数范围来自 C 类型。

- malloc NULL 直接返回 -5，不虚构一次临界区。ID 满时保持 manager 与私有对象
  原值，free 消费完整 zero owner，随后仍执行 unlock。成功时返回最低空 ID，
  value 等于输入、pend_list 自环为空，ID/hash 与管理链均完成头部插入。
- AllocId 两个 -1 出口与首次零 bit 搜索一致，包括通用 manager 的尾部有效范围
  检查。IdInsertObj 失败精确保留 id/prev/next，成功转交 ID 容器；InsertObj 覆盖
  lazy zero bucket 与已初始化 bucket。NULL 参数路径保留为不返回的执行，Ensure
  只约束真正返回的分支，没有宣称这些路径终止。
- InitDoubleLinkList 两次 store 有完整两字段权限；插入函数允许空链时 head 与
  old-next 同址，并保留 DLL 其余节点及 payload。新节点的分离 owner 排除非法
  重叠，不额外要求源码不需要的三地址全异。
- 每处 load/store 均可追溯到已审阅的 manager、private ID、DLL、object body 或
  critical_nest 谓词。32 字节整体清零和失败释放包含实际 padding；成功过程中
  ID link、管理 link 与对象余项交接后没有重复 owner。成功 unlock 后没有再访问
  已发布对象。
- CriticalAreaLock 的真实 Disable 调用返回 saved mask，之后才执行 uint16++；
  UnLock 先做条件 --，再恢复 mask。outer 与 nested 资源交接分别明确，saved=1
  不等同于已经取得投影。nested 保留原 anchor，返还新投影及真实计数结果，包含
  65535→0→0。传给 Enable 的计数是 wrapper 已递减后的数值。

抽象 program 使用同一 reviewed `safeExec`、LastSeen/ExactSeen 和 continuation。
IRQ 开启时允许既有全局 rely 推进；masked/nested 使用精确状态。锁内发布只改变
semaphore 分量，其余全局纯状态原样保留；不触达的物理内存使用稳定 heap frame。
本闭包跨 IRQ 的 frames 为状态观察 full、token empty 的普通 heap 资源，不承诺
任意不稳定 ghost observation 也可跨 IRQ 转换。协议的非空 carrier、CPU 排他权和
静态初始化来源沿用 predicate 审阅，不在 spec 层另造模型。

## 检查边界

Predicate 全量编译、header 69 个词汇与 4 个 continuation 类型检查、8 项协议
回归均基于 P-r2 通过；9 个 C 切片的普通 ILP32 语法检查通过。独立审阅另检查了
所有 caller-local 合同一致性、实际逻辑参数、返回路径与 source token/hash。
这些检查不运行 QCP parser、closure、symbolic、VC、orchestrator 或 C 实现证明。

本结论是可供用户确认的规格设计结论，**不表示 KSemaphoreCreate 已完成实现验证**。
后续实现阶段仍需证明字段/字节桥接、抽象更新和所有 C proof obligations；已明确的
初始化命题也没有被当成当前假设或已证定理。
