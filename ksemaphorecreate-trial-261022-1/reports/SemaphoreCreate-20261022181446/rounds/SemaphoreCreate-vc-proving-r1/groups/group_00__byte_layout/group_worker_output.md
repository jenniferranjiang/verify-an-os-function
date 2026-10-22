# Byte layout proof

The four assigned split statements are proved against the frozen current inputs. The two embedded-node nonzero obligations use the explicit `semaphore_field_offsets_trusted` layout premise and malloc positivity. The alignment obligation follows from the existing allocation alignment. The spatial obligation instantiates the proved `KSemaphoreCreateTrial.SemaphoreByteLayout.semaphore_zero_bytes_object` conversion with allocation bounds, alignment, and the explicit layout premise, retaining `OutsideCritical` as a frame. The conversion preserves all 32 bytes, including padding; no memset contract is strengthened.

Only the five assigned proof spans were edited. No helper, predicate, specification, axiom, statement, or library seed was changed. The top-level witness uses the assigned aggressive route and its four corresponding split lemmas.

Validation: the exact handoff `coq-check --target-kind group-check --group byte_layout` exited 0 with JSON `status: passed`; the current manual, goal, auto, library and group wrapper were compiled.
