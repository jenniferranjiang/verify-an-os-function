# invalid_inputs 完成记录

三个顶层 VC return_wit_6/7/8 及各自 split_goal_1 均 Qed。依据实际非法参数 guard：非法负 timeout、负 ID、超过 65535 的 ID，证明 abs_semaphore_obtain 选择 ret(-1)，原 LastSeen 状态与 continuation 保持。未修改规格、注解、依赖或新增假设。

旧轮 group_09__invalid_input_return 的同名 proofs 均未完成，因此本轮直接证明，没有复用旧证明。

精确 group-check 成功：exit 0，JSON status passed，elapsed_seconds 35.440673；重编译当前 goal/auto/manual/group wrapper。仅修改本组授权六个 proof spans。现停止全部写入，等待 main finalize-delivery。
