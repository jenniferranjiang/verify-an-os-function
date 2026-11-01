# LinklistResumeAll annotation（模型适配后续跑）

沿用原候选注解、三项 wand restore 视图与获准的 int32 参数拆句。冻结 predicate/spec 不变。首个 run 的真实基础设施失败保留，未把旧报告改成成功。

本 run 使用主线程已独立复核的 NULL_PARAM_CHECK_1 API 边界，仅作用于 recorded parser input；canonical 保留真实 NULL 无限循环，helper 不计为本地实现证明。当前在按新 handoff 执行 design、symexec、post-lib 检查。

模型适配后的 symexec 仍 -11；去除全部 body 注解亦复现，故进一步由主线程限定测试透明一阶 parser 名称。新增 resume_nodes_parser 的定义精确为 List.map sched_link_node xs，canonical 原 map 表达式和规格正文不改；只新增 Extern 声明。工具侧将核对精确定义，再尝试对 annotation 中简单标识符参数作等义替换。

透明 alias 加入后的 design check passed（60.065445s）。原 symexec 实测仍 returncode=-11（0.288s），无 stderr；receipt 明确记录 11 处一阶 alias 改写、NULL_PARAM_CHECK_1 API 边界与 2 处 NONE 精确展开全部生效。当前 parser input 是 `evidence/parser-normalization/2908b39b420987ac779dfdf3d7575278a142ed48e2a74db0a484f7b9703795da/LinklistResumeAll.c`。本次尝试不能被表述为修复成功，不继续扩大语义假设。

## 终态：基础设施阻塞

主线程确认停止本轮新尝试。已撤销新增且实测无效的 resume_nodes_parser 定义、其专用 Import DLL 与 C Extern 声明；原 map、冻结契约、三项基线 wand view 和完整候选注解全部保留。未修改旧 blocked run。撤销后 case lib 回到本 run design check 已通过的精确内容；没有把失败的 alias 尝试当作有效修复。

当前保留的工具配置包含已独立复核的 NULL_PARAM_CHECK_1 API 边界及精确 NONE 展开，但它们未消除 -11。当前完整候选（alias 撤销后）的实际失败记录为 `evidence/parser-normalization/4da1ce70a056769036e4456636eb7f4925ddd1a68b81e49e65781e94322fe952/LinklistResumeAll.c`，returncode -11，0.189s，无 stderr。新配置下移除所有 body 注解的更小输入仍 -11（2.806s），记录为 `evidence/parser-normalization/d53eaeee853d48175f4875993f4e72e7203e4dce4e43dcaafd51fd7ba9683126/LinklistResumeAll.c`；因此这不是仅靠增补某一个 loop invariant 或 field view 就已解决的问题。

各方案实测结果：NONE 展开消除了最早 token269 预处理错误；空循环体归一未消除崩溃（已由主线程撤销）；NULL_PARAM_CHECK_1 合法模型仍崩溃；透明一阶 map alias 仍崩溃（本次撤销）。原始 C 加单条 NULL-loop Inv 的早期最小失败以及正常缺 Inv 的对照仍保存在旧 run 的证据中，不篡改历史。

尚未生成/发布本函数 VC，没有 post-symexec lib 检查或实现完成结论。修复边界是 QCP driver/parser/entailment 工具缺陷或有证据的严格等义输入适配，不能加强 Require、弱化 Ensure、删除真实路径或引入无依据假设规避。终态报告写入后停止修改，交 main finalize-delivery。
