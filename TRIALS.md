# Historical trial archive

All past CRTOS trials are collected in this one branch:
`trial-archive`.
This shared archive contains all thirteen archived trials.

- `keventcreate-trial-260928-2`
- `keventcreate-trial-261101-1`
- `keventdelete-trial-261103-1`
- `kmutexcreate-trial-260928-2`
- `kmutexcreate-trial-261101-1`
- `kmutexdelete-trial-261103-1`
- `ksemaphorecreate-trial-260928-1`
- `ksemaphorecreate-trial-261012-1`
- `ksemaphorecreate-trial-261019-1`
- `ksemaphorecreate-trial-261019-2`
- `ksemaphorecreate-trial-261019-3`
- `ksemaphorecreate-trial-261022-1`
- `ksemaphoredelete-trial-261025-1`

The original committed snapshots are preserved. Additional ignored source snapshots
from the oldest semaphore-create trial are retained at their original paths;
their presence does not imply successful verification. Rebuild compiled caches when needed.
See `.docs/trial-archive-index.json` for the inventory.

The two 2026-11-01 creation trials were added on 2026-11-03 from main
commit `744a8de96c742cf587e2f3fd8a49cb134808c29b`. Their tracked sources and evidence
are preserved unchanged; this archival update does not rerun verification.

The event-delete and mutex-delete trials were added on 2026-11-09 from the
working tree based on main commit `9a211c61e96bfcd3ca447ecbfa4e5e7d94fe4b8e`.
The archive preserves all currently present tracked files and all non-ignored
untracked files. Rebuildable Rocq outputs and temporary cache files were omitted;
this archival update does not rerun verification or make new verification claims.

Restore one trial from the main working directory when needed:

```sh
git fetch origin trial-archive
git restore --source=origin/trial-archive -- <trial-directory>
```
