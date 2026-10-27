/*@ Import Coq Require Import CRTOS_Verify.lib.KTaskWakeup */

#include "m_ktask.h"
#include "ready_views_strategy.h"
#include "task_sched_view.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.RRR_ReadyInsert */

/*@ Extern Coq
      (TaskDescriptorAbs :: *)
      (TaskSchedMemberAbs :: *)
      (OsAssignReadyVectorAbs :: *)
      (DL_Node :: * => *)
 */
/*@ Extern Coq
      (task_fields_except_sched :
        StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs -> Assertion)
      (task_fields_except_two_sched :
        StableGlobalState -> VarGlobalState -> Z -> TaskDescriptorAbs ->
        Z -> TaskDescriptorAbs -> Assertion)
      (KTASK_MAX_ADVANCE : Z)
      (ready_task_node : Z -> DL_Node Z)
      (getPtr : {A} -> DL_Node A -> Z)
      (Build_DL_Node : {A} -> A -> Z -> DL_Node A)
      (task_addr_aligned :
        Z -> OsAssignReadyVectorAbs -> Prop)
      (rrr_bucket_insert :
        (Z -> option TaskDescriptorAbs) -> TaskSchedMemberAbs ->
        DL_Node Z -> list(DL_Node Z) -> list(DL_Node Z) -> Prop)
      (os_assign_ready_vector_replace_bucket :
        OsAssignReadyVectorAbs -> Z -> list(DL_Node Z) ->
        OsAssignReadyVectorAbs)
      (rrr_ready_bucket_head : Z -> Z -> Z)
      (store_rrr_vector_except :
        Z -> Z -> list(DL_Node Z) ->
        OsAssignReadyVectorAbs -> Assertion)
      (store_ready_dll_focus :
        Z -> list(DL_Node Z) ->
        DL_Node Z -> list(DL_Node Z) -> Assertion)
      (store_ready_dll_frame :
        Z -> list(DL_Node Z) ->
        DL_Node Z -> list(DL_Node Z) -> Assertion)
      (store_ready_dll_head_frame :
        Z -> list(DL_Node Z) ->
        Z -> Assertion)
      (store_ready_dll_tail_frame :
        Z -> list(DL_Node Z) ->
        Z -> Assertion)
      (store_ready_dll_tail_view :
        Z -> list(DL_Node Z) ->
        Z -> Assertion)
      (store_ready_dll_next_frame :
        Z -> list(DL_Node Z) ->
        DL_Node Z -> list(DL_Node Z) -> Z -> Assertion)
      (store_ready_scan :
        Z -> Z ->
        list(DL_Node Z) -> list(DL_Node Z) -> Assertion)
      (ready_prefix_scanned :
        (Z -> option TaskDescriptorAbs) -> Z -> list(DL_Node Z) -> Prop)
      (ready_node_rest_timeslice_gt :
        (Z -> option TaskDescriptorAbs) -> Z -> DL_Node Z -> Prop)
      (ready_node_rest_timeslice_le :
        (Z -> option TaskDescriptorAbs) -> Z -> DL_Node Z -> Prop)
      (ready_bucket_owners_aligned : list(DL_Node Z) -> Prop)
      (store_os_assign_ready_vector :
        Z -> OsAssignReadyVectorAbs -> Assertion)

      (occupy_dll_node : Z -> Assertion)
 */

/*@ include strategies "ready_views.strategies" */
/*@ include strategies "task_sched_view.strategies" */

void RoundRobinRemainReadyVectorInsert(struct TaskDescriptor *task, struct OsAssignReadyVector* ready_table)
/*@ With (sg : StableGlobalState)
         (st : VarGlobalState)
         (desc : TaskDescriptorAbs)
         (before : OsAssignReadyVectorAbs)
    Require
      before == st.os_assign.assignReadyVector &&
      ready_table == assign_ready_vector_addr(sg) &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      task_fields(sg, st) *
      assign_ready_pending(sg, st) *
      occupy_dll_node(sched_link_of(task))
    Ensure
      task != 0 && ready_table != 0 &&
      st.os_tasks.task_desc_map(task) == Some(desc) &&
      exists new_bucket,
        rrr_bucket_insert(
          st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task),
          Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
          new_bucket) &&
        task_fields(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio, new_bucket), st)) *
        assign_ready_pending(sg, replace_global_ready_vector(
          os_assign_ready_vector_replace_bucket(
            before, desc.tdSchedMember.tsmCurPrio, new_bucket), st))
 */
{
    /* sched 标量从 task_inv 局部借出，循环内 current cell 每次取还。 */
  DoubleLinklistType* node = NONE;
	DoubleLinklistType* tail = NONE;
	DoubleLinklistType* head = NONE;
	struct TaskDescriptor *tmp = NONE;

    NULL_PARAM_CHECK_1(task);
    NULL_PARAM_CHECK_1(ready_table);

    /*@ before == st.os_assign.assignReadyVector &&
        ready_table@pre == assign_ready_vector_addr(sg) &&
        st.os_tasks.task_desc_map(task) == Some(desc) &&
        task_fields(sg, st) *
        assign_ready_pending(sg, st)
        which implies
        assign_ready_published(st) &&
        0 <= desc.tdSchedMember.tsmCurPrio &&
        desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX &&
        task_addr_aligned(task, before) &&
        task_fields(sg, st) *
        assign_ready_pending(sg, st)
 */

    head = &ready_table->priority_ready_vector[
      task->task_dync_sched_member.cur_prio];

    if ( task->task_dync_sched_member.advance_cnt < KTASK_MAX_ADVANCE_PROCESS_TIME ) {
		
		
		
		
		/*@ Inv Assert exists prefix_scan suffix_scan tail_value tmp_value,
		      before == st.os_assign.assignReadyVector &&
              ready_table@pre == assign_ready_vector_addr(sg) &&
              assign_ready_published(st) &&
              task == task@pre && ready_table == ready_table@pre &&
		      task@pre != 0 && ready_table@pre != 0 &&
		      tail == tail_value &&
		      head == rrr_ready_bucket_head(
		        ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
		      desc.tdSchedMember.tsmAdvanceCnt < KTASK_MAX_ADVANCE &&
		      (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
		      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) == Znth(
		        desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) &&
		      tmp == tmp_value &&
		      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) == app(prefix_scan, suffix_scan) &&
		      ready_prefix_scanned(
		        st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
		        prefix_scan) &&
		      ready_bucket_owners_aligned(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) &&
		      store_ready_scan(rrr_ready_bucket_head(
		          ready_table@pre, desc.tdSchedMember.tsmCurPrio), node, prefix_scan, suffix_scan) *
		      store_rrr_vector_except(ready_table@pre, desc.tdSchedMember.tsmCurPrio, Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), before) *
		      store_task_status(
		        &(task@pre->task_dync_sched_member.stat),
		        desc.tdSchedMember.tsmStat) *
		      store_uchar(
		        &(task@pre->task_dync_sched_member.advance_cnt),
		        desc.tdSchedMember.tsmAdvanceCnt) *
		      store_uchar(
		        &(task@pre->task_dync_sched_member.cur_prio),
		        desc.tdSchedMember.tsmCurPrio) *
		      store_uint(
		        &(task@pre->task_dync_sched_member.origin_timeslice),
		        desc.tdSchedMember.tsmOriginTimeslice) *
		      store_uint(
		        &(task@pre->task_dync_sched_member.rest_timeslice),
		        desc.tdSchedMember.tsmRestTimeslice) *
		      store_uint(
		        &(task@pre->task_dync_sched_member.bitmap_column),
		        desc.tdSchedMember.tsmBitmapColumn) *
		      occupy_dll_node(sched_link_of(task@pre)) *
          task_fields_except_sched(sg, st, task@pre, desc)
 */
		for (node = head->node_next;
		     node != head;
		     node = node->node_next) {
			/*@ Given prefix_scan suffix_scan tail_value tmp_value  */
			/*@ node != rrr_ready_bucket_head(
			      ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
			    store_ready_scan(rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio), node, prefix_scan, suffix_scan)
			    which implies
			    exists current_task current_link scan_rest,
			      suffix_scan ==
			        cons(Build_DL_Node(current_task, current_link), scan_rest) &&
			      node == current_link &&
			      store_ready_dll_focus(rrr_ready_bucket_head(
			          ready_table@pre, desc.tdSchedMember.tsmCurPrio), prefix_scan, Build_DL_Node(current_task, current_link), scan_rest)
			  */
			/*@ Given current_task current_link scan_rest  */
			/*@ assign_ready_published(st) &&
                before == st.os_assign.assignReadyVector &&
                0 <= desc.tdSchedMember.tsmCurPrio &&
                Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) == Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) &&
                Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) == app(prefix_scan, suffix_scan) &&
			    suffix_scan ==
			      cons(Build_DL_Node(current_task, current_link), scan_rest) &&
			    ready_bucket_owners_aligned(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) &&
			    store_ready_dll_focus(rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio), prefix_scan, Build_DL_Node(current_task, current_link), scan_rest) *
          task_fields_except_sched(sg, st, task@pre, desc) *
          occupy_dll_node(sched_link_of(task@pre))
which implies
			    exists current_desc,
			      current_task != 0 && current_task != task@pre &&
			      addr_aligned(current_task, ALIGN_SIZE) &&
			      current_link == sched_link_of(current_task) &&
			      st.os_tasks.task_desc_map(current_task) == Some(current_desc) &&
			      store_ready_dll_frame(rrr_ready_bucket_head(
				          ready_table@pre, desc.tdSchedMember.tsmCurPrio), prefix_scan, Build_DL_Node(current_task, current_link), scan_rest) *
			      store_task_status(
			        &(current_task->task_dync_sched_member.stat),
			        current_desc.tdSchedMember.tsmStat) *
			      store_uchar(
			        &(current_task->task_dync_sched_member.advance_cnt),
			        current_desc.tdSchedMember.tsmAdvanceCnt) *
			      store_uchar(
			        &(current_task->task_dync_sched_member.cur_prio),
			        current_desc.tdSchedMember.tsmCurPrio) *
			      store_uint(
			        &(current_task->task_dync_sched_member.origin_timeslice),
			        current_desc.tdSchedMember.tsmOriginTimeslice) *
			      store_uint(
			        &(current_task->task_dync_sched_member.rest_timeslice),
			        current_desc.tdSchedMember.tsmRestTimeslice) *
			      store_uint(
			        &(current_task->task_dync_sched_member.bitmap_column),
			        current_desc.tdSchedMember.tsmBitmapColumn) *
          task_fields_except_two_sched(sg, st, task@pre, desc, current_task, current_desc) *
          occupy_dll_node(sched_link_of(task@pre))
 */
			/*@ Given current_desc  */
			tmp = CONTAINER_OF_TASK_SCHED(node)
			    /*@ where task_ptr = current_task  */;
			if (task->task_dync_sched_member.rest_timeslice < tmp->task_dync_sched_member.rest_timeslice) {
				/*@ tmp == current_task &&
				    current_task != 0 &&
				    current_link == sched_link_of(current_task) &&
				    st.os_tasks.task_desc_map(current_task) == Some(current_desc) &&
				    Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
				      app(prefix_scan,
				        cons(Build_DL_Node(current_task, current_link), scan_rest)) &&
				    node == current_link &&
				    node != rrr_ready_bucket_head(
				      ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
				    ready_prefix_scanned(
				      st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
				      prefix_scan) &&
				    ready_bucket_owners_aligned(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) &&
				    desc.tdSchedMember.tsmRestTimeslice <
				      current_desc.tdSchedMember.tsmRestTimeslice &&
				    store_ready_dll_frame(rrr_ready_bucket_head(
				        ready_table@pre, desc.tdSchedMember.tsmCurPrio), prefix_scan, Build_DL_Node(current_task, current_link), scan_rest) *
				    store_task_status(
				      &(current_task->task_dync_sched_member.stat),
				      current_desc.tdSchedMember.tsmStat) *
				    store_uchar(
				      &(current_task->task_dync_sched_member.advance_cnt),
				      current_desc.tdSchedMember.tsmAdvanceCnt) *
				    store_uchar(
				      &(current_task->task_dync_sched_member.cur_prio),
				      current_desc.tdSchedMember.tsmCurPrio) *
				    store_uint(
				      &(current_task->task_dync_sched_member.origin_timeslice),
				      current_desc.tdSchedMember.tsmOriginTimeslice) *
				    store_uint(
				      &(tmp->task_dync_sched_member.rest_timeslice),
				      current_desc.tdSchedMember.tsmRestTimeslice) *
				    store_uint(
				      &(current_task->task_dync_sched_member.bitmap_column),
				      current_desc.tdSchedMember.tsmBitmapColumn) *
          task_fields_except_two_sched(sg, st, task@pre, desc, current_task, current_desc)
which implies
				    tmp == current_task &&
				    Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
				      app(prefix_scan,
				        cons(Build_DL_Node(current_task, current_link), scan_rest)) &&
				    node == current_link &&
				    node != rrr_ready_bucket_head(
				      ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
				    ready_prefix_scanned(
				      st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
				      prefix_scan) &&
				    ready_node_rest_timeslice_gt(
				      st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
				      Build_DL_Node(current_task, current_link)) &&
				    store_priority_ready_bucket(rrr_ready_bucket_head(
				        ready_table@pre, desc.tdSchedMember.tsmCurPrio), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) *
          task_fields_except_sched(sg, st, task@pre, desc)
 */
				break;
			}
			/*@ tmp == current_task &&
			    current_task != 0 &&
			    current_link == sched_link_of(current_task) &&
			    st.os_tasks.task_desc_map(current_task) == Some(current_desc) &&
			    Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
			      app(prefix_scan,
			        cons(Build_DL_Node(current_task, current_link), scan_rest)) &&
			    node == current_link &&
			    ready_prefix_scanned(
			      st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			      prefix_scan) &&
			    ready_bucket_owners_aligned(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) &&
			    current_desc.tdSchedMember.tsmRestTimeslice <=
			      desc.tdSchedMember.tsmRestTimeslice &&
			    store_ready_dll_frame(rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio), prefix_scan, Build_DL_Node(current_task, current_link), scan_rest) *
			    store_task_status(
			      &(current_task->task_dync_sched_member.stat),
			      current_desc.tdSchedMember.tsmStat) *
			    store_uchar(
			      &(current_task->task_dync_sched_member.advance_cnt),
			      current_desc.tdSchedMember.tsmAdvanceCnt) *
			    store_uchar(
			      &(current_task->task_dync_sched_member.cur_prio),
			      current_desc.tdSchedMember.tsmCurPrio) *
			    store_uint(
			      &(current_task->task_dync_sched_member.origin_timeslice),
			      current_desc.tdSchedMember.tsmOriginTimeslice) *
			    store_uint(
			      &(tmp->task_dync_sched_member.rest_timeslice),
			      current_desc.tdSchedMember.tsmRestTimeslice) *
			    store_uint(
			      &(current_task->task_dync_sched_member.bitmap_column),
			      current_desc.tdSchedMember.tsmBitmapColumn) *
          task_fields_except_two_sched(sg, st, task@pre, desc, current_task, current_desc)
which implies
			    exists next_link,
			      tmp == current_task &&
			      node == current_link &&
			      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
			        app(prefix_scan,
			          cons(Build_DL_Node(current_task, current_link), scan_rest)) &&
			      ready_prefix_scanned(
			        st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			        prefix_scan) &&
			      ready_node_rest_timeslice_le(
			        st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			        Build_DL_Node(current_task, current_link)) &&
			      store_ptr(&(node->node_next), next_link) *
			      store_ready_dll_next_frame(rrr_ready_bucket_head(
			          ready_table@pre, desc.tdSchedMember.tsmCurPrio), prefix_scan, Build_DL_Node(current_task, current_link), scan_rest, next_link) *
			      (current_link == sched_link_of(current_task) && emp) *
          task_fields_except_sched(sg, st, task@pre, desc)
 */
			/*@ Given next_link  */
		}

		/*@ Assert exists prefix_stop suffix_stop tail_value tmp_value,
		      before == st.os_assign.assignReadyVector &&
              ready_table@pre == assign_ready_vector_addr(sg) &&
              assign_ready_published(st) &&
              task == task@pre && ready_table == ready_table@pre &&
		      task@pre != 0 && ready_table@pre != 0 &&
		      tail == tail_value && tmp == tmp_value &&
		      head == rrr_ready_bucket_head(
		        ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
		      desc.tdSchedMember.tsmAdvanceCnt < KTASK_MAX_ADVANCE &&
		      (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
		      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
		        Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) &&
		      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) == app(prefix_stop, suffix_stop) &&
		      ready_prefix_scanned(
		        st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
		        prefix_stop) &&
		      ((suffix_stop == nil &&
		        node == rrr_ready_bucket_head(
		          ready_table@pre, desc.tdSchedMember.tsmCurPrio)) ||
		       (exists current_task current_link scan_rest,
		          suffix_stop ==
		            cons(Build_DL_Node(current_task, current_link), scan_rest) &&
		          node == current_link &&
		          node != rrr_ready_bucket_head(
		            ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
		          ready_node_rest_timeslice_gt(
		            st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
		            Build_DL_Node(current_task, current_link)))) &&
		      store_priority_ready_bucket(rrr_ready_bucket_head(
		          ready_table@pre, desc.tdSchedMember.tsmCurPrio), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) *
		      store_rrr_vector_except(ready_table@pre, desc.tdSchedMember.tsmCurPrio, Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), before) *
		      store_task_status(
		        &(task@pre->task_dync_sched_member.stat),
		        desc.tdSchedMember.tsmStat) *
		      store_uchar(
		        &(task@pre->task_dync_sched_member.advance_cnt),
		        desc.tdSchedMember.tsmAdvanceCnt) *
		      store_uchar(
		        &(task@pre->task_dync_sched_member.cur_prio),
		        desc.tdSchedMember.tsmCurPrio) *
		      store_uint(
		        &(task@pre->task_dync_sched_member.origin_timeslice),
		        desc.tdSchedMember.tsmOriginTimeslice) *
		      store_uint(
		        &(task@pre->task_dync_sched_member.rest_timeslice),
		        desc.tdSchedMember.tsmRestTimeslice) *
		      store_uint(
		        &(task@pre->task_dync_sched_member.bitmap_column),
		        desc.tdSchedMember.tsmBitmapColumn) *
		      occupy_dll_node(sched_link_of(task@pre)) *
          task_fields_except_sched(sg, st, task@pre, desc)
 */
		/*@ Given prefix_stop suffix_stop tail_value tmp_value  */

		if ( node != head) {
			/*@ task == task@pre &&
			    task@pre != 0 && ready_table@pre != 0 &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
			    store_task_status(
			      &(task@pre->task_dync_sched_member.stat),
			      desc.tdSchedMember.tsmStat) *
			    store_uchar(
			      &(task@pre->task_dync_sched_member.advance_cnt),
			      desc.tdSchedMember.tsmAdvanceCnt) *
			    store_uchar(
			      &(task@pre->task_dync_sched_member.cur_prio),
			      desc.tdSchedMember.tsmCurPrio) *
			    store_uint(
			      &(task@pre->task_dync_sched_member.origin_timeslice),
			      desc.tdSchedMember.tsmOriginTimeslice) *
			    store_uint(
			      &(task@pre->task_dync_sched_member.rest_timeslice),
			      desc.tdSchedMember.tsmRestTimeslice) *
			    store_uint(
			      &(task@pre->task_dync_sched_member.bitmap_column),
			      desc.tdSchedMember.tsmBitmapColumn) *
			    occupy_dll_node(sched_link_of(task@pre)) *
          task_fields_except_sched(sg, st, task@pre, desc)
which implies
			    task == task@pre && task@pre != 0 && ready_table@pre != 0 &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
			    &(task->task_dync_sched_member.sched_link) != 0 &&
			    (&(task->task_dync_sched_member.sched_link) == sched_link_of(task) && emp) *
			    occupy_dll_node(
			      &(task->task_dync_sched_member.sched_link)) *
          task_fields(sg, st)
 */
			/*@ Assert
			      before == st.os_assign.assignReadyVector &&
              ready_table@pre == assign_ready_vector_addr(sg) &&
              assign_ready_published(st) &&
              task == task@pre && ready_table == ready_table@pre &&
			      task@pre != 0 && ready_table@pre != 0 &&
			      tail == tail_value && tmp == tmp_value &&
			      head == rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
			      desc.tdSchedMember.tsmAdvanceCnt < KTASK_MAX_ADVANCE &&
			      (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
			      &(task->task_dync_sched_member.sched_link) != 0 &&
			      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
			        Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) &&
			      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) == app(prefix_stop, suffix_stop) &&
			      ready_prefix_scanned(
			        st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			        prefix_stop) &&
			      (exists current_task current_link scan_rest,
			        suffix_stop ==
			          cons(Build_DL_Node(current_task, current_link), scan_rest) &&
			        node == current_link &&
			        ready_node_rest_timeslice_gt(
			          st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			          Build_DL_Node(current_task, current_link))) &&
			      store_priority_ready_bucket(rrr_ready_bucket_head(
			          ready_table@pre, desc.tdSchedMember.tsmCurPrio), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) *
			      store_rrr_vector_except(ready_table@pre, desc.tdSchedMember.tsmCurPrio, Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), before) *
			      (&(task->task_dync_sched_member.sched_link) == sched_link_of(task) && emp) *
			      occupy_dll_node(
			        &(task->task_dync_sched_member.sched_link)) *
          task_fields(sg, st)
 */
			/*@ Given current_task current_link scan_rest  */
			DoubleLinkListInsertNodeBefore(
			  node, &(task->task_dync_sched_member.sched_link))
			    /*@ where (rrr_ready_insert_before)
			          head = rrr_ready_bucket_head(
			            ready_table@pre, desc.tdSchedMember.tsmCurPrio),
			          prefix = prefix_stop,
			          current_task = current_task,
			          current_link = current_link,
			          task_ptr = task@pre,
			          suffix = scan_rest,
			          nodes = Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
			          ready_table_guard = ready_table@pre  */;
			/*@ before == st.os_assign.assignReadyVector &&
            ready_table@pre == assign_ready_vector_addr(sg) &&
            assign_ready_published(st) &&
            task@pre != 0 && ready_table@pre != 0 &&
			    desc.tdSchedMember.tsmAdvanceCnt < KTASK_MAX_ADVANCE &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
			    Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
			      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) &&
			    Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
			      app(prefix_stop,
			        cons(Build_DL_Node(current_task, current_link), scan_rest)) &&
			    ready_prefix_scanned(
			      st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			      prefix_stop) &&
			    ready_node_rest_timeslice_gt(
			      st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			      Build_DL_Node(current_task, current_link)) &&
			    store_priority_ready_bucket(rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio), app(prefix_stop,
			        cons(Build_DL_Node(
			          task@pre,
			          &(task@pre->task_dync_sched_member.sched_link)),
			          cons(Build_DL_Node(current_task, current_link), scan_rest)))) *
			    store_rrr_vector_except(ready_table@pre, desc.tdSchedMember.tsmCurPrio, Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), before) *
            task_fields(sg, st)
            which implies
			    task@pre != 0 && ready_table@pre != 0 &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
			    task_addr_aligned(task@pre, before) &&
			    exists new_bucket,
			      rrr_bucket_insert(
			        st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task@pre),
			        Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), new_bucket) &&
			      task_fields(sg, replace_global_ready_vector(
                os_assign_ready_vector_replace_bucket(before, desc.tdSchedMember.tsmCurPrio, new_bucket), st)) *
              assign_ready_pending(sg, replace_global_ready_vector(
                os_assign_ready_vector_replace_bucket(before, desc.tdSchedMember.tsmCurPrio, new_bucket), st))
			  */
		} else {

			tail = head->node_prev;
			/*@ task == task@pre && task@pre != 0 && ready_table@pre != 0 &&
				    head == rrr_ready_bucket_head(
			      ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
			    store_ready_dll_tail_view(rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), tail) *
			    store_task_status(
			      &(task@pre->task_dync_sched_member.stat),
			      desc.tdSchedMember.tsmStat) *
			    store_uchar(
			      &(task@pre->task_dync_sched_member.advance_cnt),
			      desc.tdSchedMember.tsmAdvanceCnt) *
			    store_uchar(
			      &(task@pre->task_dync_sched_member.cur_prio),
			      desc.tdSchedMember.tsmCurPrio) *
			    store_uint(
			      &(task@pre->task_dync_sched_member.origin_timeslice),
			      desc.tdSchedMember.tsmOriginTimeslice) *
			    store_uint(
			      &(task@pre->task_dync_sched_member.rest_timeslice),
			      desc.tdSchedMember.tsmRestTimeslice) *
			    store_uint(
			      &(task@pre->task_dync_sched_member.bitmap_column),
			      desc.tdSchedMember.tsmBitmapColumn) *
			    occupy_dll_node(sched_link_of(task@pre)) *
          task_fields_except_sched(sg, st, task@pre, desc)
which implies
			    task == task@pre && task@pre != 0 && ready_table@pre != 0 &&
				    head == rrr_ready_bucket_head(
			      ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
			    &(task->task_dync_sched_member.sched_link) != 0 &&
			    store_ready_dll_tail_view(rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), tail) *
			    (&(task->task_dync_sched_member.sched_link) == sched_link_of(task) && emp) *
			    occupy_dll_node(
			      &(task->task_dync_sched_member.sched_link)) *
          task_fields(sg, st)
 */
			DoubleLinkListInsertNodeAfter(
			  tail, &(task->task_dync_sched_member.sched_link))
			    /*@ where (rrr_ready_insert_after)
			          head = rrr_ready_bucket_head(
			            ready_table@pre, desc.tdSchedMember.tsmCurPrio),
			          nodes = Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
			          task_ptr = task@pre,
			          ready_table_guard = ready_table@pre  */;
			/*@ before == st.os_assign.assignReadyVector &&
            ready_table@pre == assign_ready_vector_addr(sg) &&
            assign_ready_published(st) &&
            task@pre != 0 && ready_table@pre != 0 &&
			    desc.tdSchedMember.tsmAdvanceCnt < KTASK_MAX_ADVANCE &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
			    Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
			      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) &&
			    ready_prefix_scanned(
			      st.os_tasks.task_desc_map, desc.tdSchedMember.tsmRestTimeslice,
			      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil)) &&
			    store_priority_ready_bucket(rrr_ready_bucket_head(
			        ready_table@pre, desc.tdSchedMember.tsmCurPrio), app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
			        cons(Build_DL_Node(
			          task@pre,
			          &(task@pre->task_dync_sched_member.sched_link)), nil))) *
			    store_rrr_vector_except(ready_table@pre, desc.tdSchedMember.tsmCurPrio, Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), before) *
            task_fields(sg, st)
            which implies
			    task@pre != 0 && ready_table@pre != 0 &&
			    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
			    task_addr_aligned(task@pre, before) &&
			    exists new_bucket,
			      rrr_bucket_insert(
			        st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task@pre),
			        Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), new_bucket) &&
			      task_fields(sg, replace_global_ready_vector(
                os_assign_ready_vector_replace_bucket(before, desc.tdSchedMember.tsmCurPrio, new_bucket), st)) *
              assign_ready_pending(sg, replace_global_ready_vector(
                os_assign_ready_vector_replace_bucket(before, desc.tdSchedMember.tsmCurPrio, new_bucket), st))
			  */
		}
	} else {
		
		

		tail = head->node_prev;
		/*@ task == task@pre && task@pre != 0 && ready_table@pre != 0 &&
		    head == rrr_ready_bucket_head(
		      ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
		    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
		    store_ready_dll_tail_view(rrr_ready_bucket_head(
		        ready_table@pre, desc.tdSchedMember.tsmCurPrio), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), tail) *
		    store_task_status(
		      &(task@pre->task_dync_sched_member.stat),
		      desc.tdSchedMember.tsmStat) *
		    store_uchar(
		      &(task@pre->task_dync_sched_member.advance_cnt),
		      desc.tdSchedMember.tsmAdvanceCnt) *
		    store_uchar(
		      &(task@pre->task_dync_sched_member.cur_prio),
		      desc.tdSchedMember.tsmCurPrio) *
		    store_uint(
		      &(task@pre->task_dync_sched_member.origin_timeslice),
		      desc.tdSchedMember.tsmOriginTimeslice) *
		    store_uint(
		      &(task@pre->task_dync_sched_member.rest_timeslice),
		      desc.tdSchedMember.tsmRestTimeslice) *
		    store_uint(
		      &(task@pre->task_dync_sched_member.bitmap_column),
		      desc.tdSchedMember.tsmBitmapColumn) *
		    occupy_dll_node(sched_link_of(task@pre)) *
          task_fields_except_sched(sg, st, task@pre, desc)
which implies
		    task == task@pre && task@pre != 0 && ready_table@pre != 0 &&
		    head == rrr_ready_bucket_head(
		      ready_table@pre, desc.tdSchedMember.tsmCurPrio) &&
		    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
		    &(task->task_dync_sched_member.sched_link) != 0 &&
		    store_ready_dll_tail_view(rrr_ready_bucket_head(
		        ready_table@pre, desc.tdSchedMember.tsmCurPrio), Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), tail) *
		    (&(task->task_dync_sched_member.sched_link) == sched_link_of(task) && emp) *
		    occupy_dll_node(
		      &(task->task_dync_sched_member.sched_link)) *
          task_fields(sg, st)
 */
		DoubleLinkListInsertNodeAfter(
		  tail, &(task->task_dync_sched_member.sched_link))
		    /*@ where (rrr_ready_insert_after)
		          head = rrr_ready_bucket_head(
		            ready_table@pre, desc.tdSchedMember.tsmCurPrio),
		          nodes = Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
		          task_ptr = task@pre,
		          ready_table_guard = ready_table@pre  */;
		/*@ before == st.os_assign.assignReadyVector &&
            ready_table@pre == assign_ready_vector_addr(sg) &&
            assign_ready_published(st) &&
            task@pre != 0 && ready_table@pre != 0 &&
		    KTASK_MAX_ADVANCE <= desc.tdSchedMember.tsmAdvanceCnt &&
		    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) && task_addr_aligned(task@pre, before) &&
		    Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) ==
		      Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil) &&
		    store_priority_ready_bucket(rrr_ready_bucket_head(
		        ready_table@pre, desc.tdSchedMember.tsmCurPrio), app(Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil),
		        cons(Build_DL_Node(
		          task@pre,
		          &(task@pre->task_dync_sched_member.sched_link)), nil))) *
		    store_rrr_vector_except(ready_table@pre, desc.tdSchedMember.tsmCurPrio, Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), before) *
            task_fields(sg, st)
            which implies
		    task@pre != 0 && ready_table@pre != 0 &&
		    (st.os_tasks.task_desc_map(task@pre) == Some(desc) &&
          0 <= desc.tdSchedMember.tsmCurPrio &&
          desc.tdSchedMember.tsmCurPrio < PRIORITY_MAX) &&
		    task_addr_aligned(task@pre, before) &&
		    exists new_bucket,
		      rrr_bucket_insert(
		        st.os_tasks.task_desc_map, desc.tdSchedMember, ready_task_node(task@pre),
		        Znth(desc.tdSchedMember.tsmCurPrio, before.orvBuckets, nil), new_bucket) &&
		      task_fields(sg, replace_global_ready_vector(
                os_assign_ready_vector_replace_bucket(before, desc.tdSchedMember.tsmCurPrio, new_bucket), st)) *
              assign_ready_pending(sg, replace_global_ready_vector(
                os_assign_ready_vector_replace_bucket(before, desc.tdSchedMember.tsmCurPrio, new_bucket), st))
		  */
	}

}
