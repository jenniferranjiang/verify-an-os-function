# zero_layout

完成两个 malloc/memset 纯范围 VC，以及零字节转换 VC 的三个 split 和 aggressive 分派层。

- `event_byte_layout__zero_layout` 从已审 Event 顶层布局公理和已有 IdNode/DLL 偏移事实推导全部字段地址。
- `four_zero_uint__zero_layout` 使用现有四零字节到指针存储转换，再证明同一 4 字节载体满足 UInt 存储条件。
- `event_zero_bytes__zero_layout` 逐段拆分全部 36 字节，保留 [2,4) padding，转换 ID、两个 UInt 和六个指针槽，按真实地址折叠 EventZero。非空和对齐条件来自 VC 明确前提。

证明在 controller staged workspace 的 Rocq MCP 中逐步检查；最终以 controller group-check 验收。没有修改契约或生成的 witness 陈述，没有引入额外公理。使用的 ABI 信任为已审 EventLayoutABI 的大小/顶层偏移事实与已有 StructFieldOffsetAxiom 子字段布局事实。

无 annotation/spec 缺口。未读取当前 sibling 输出；helper 仅追加到本组 library，均使用 `__zero_layout` 后缀。

最终 `group-check` 返回退出码 0、`status: passed`；实际重新编译 case library、goal、auto、manual 与 group wrapper，耗时 86.17 秒。
