# outer_scan delivery

所有 13 个 assigned proof spans 已完成，并保留指定 proof modes 与全部未分配声明。

- manager 展开沿现有 OSHeap 桥转换字段与完整字节数组，复用原 bytes existential，保留 bucket frame 和全部纯条件。
- 外层扫描初始化及递增按 allocid_index_scan_inv 的前缀定义证明。
- idmax + 7、index + 1 与 index * 8 的整数界限从 id_map_bytes_ok 及商界推导。
- 未修改 accepted predicate、spec、statement、import 或任何组外文件；未新增库或顶层 helper。
- 历史相关证明为占位，因此未复用历史 proof。

验证：group-development exit 0 / status passed（79.201048 秒）；group-check exit 0 / status passed（104.919159 秒）。Forbidden lemma/tactic 扫描零命中。无 annotation gap。
