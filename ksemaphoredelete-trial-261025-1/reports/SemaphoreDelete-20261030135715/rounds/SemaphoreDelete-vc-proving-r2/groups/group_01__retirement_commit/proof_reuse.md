# retirement_commit r2 reuse

Reuse the two assigned witness proofs and their full helper closure from the same group in SemaphoreDelete-vc-proving-r1. The current seed is an exact prefix of that historical library, both lemma declarations match, and frozen external dependency hashes match. Helper propositions and proof bodies are preserved verbatim.

The sole supplemental import repair is removing Bool.Bool from `From Coq Require Import Lia Bool.Bool Sorting.Permutation.`. The r2 candidate therefore uses `From Coq Require Import Lia Sorting.Permutation.`; this avoids overriding assertion && when the merger hoists imports.

Before saving the candidate, Rocq MCP rocq_compile checked the corrected complete helper library together with the current two unchanged goal Definitions and their historical proofs in the trial workspace. It returned success: true and empty output. The formal controller group-check remains the final group validation.
