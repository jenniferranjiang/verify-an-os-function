# zero_bytes completion

Proved the assigned three split witnesses and their aggressive-pre-process parent using the frozen current statements. The parent dispatches spatial, link non-null, and pending-list non-null goals with Goal_apply.

Added two fully proved helpers with suffix __zero_bytes. The complete 36-byte conversion splits off the last four bytes, reuses the shared semaphore_zero_bytes_fields conversion for the first 32 bytes, converts offsets 14 and 15 into UChar slots, converts the final four bytes into a null pointer, and reconstructs MutexZero with existing mutex ABI facts. Padding [2,4) remains owned exactly once. No new assumptions or changes to contracts, source, predicates, or shared libraries.

Both helpers and all assigned witnesses were developed to Qed through actual Rocq MCP. Controller group-development passed (exit 0). Controller group-check passed (exit 0, JSON status passed; elapsed 34.680182 seconds), compiling the library, goal, auto, manual, and group wrapper against 198 shared compiled dependencies.

All writes stopped after terminal report; ready for main finalize-delivery.
