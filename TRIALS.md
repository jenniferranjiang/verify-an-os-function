# Historical trial archive

All past CRTOS trials are collected in this one branch:
`archive/ksemaphoredelete-trial-261025-1`.
The branch name is retained; it contains all nine trials, not just the deletion trial.

- `keventcreate-trial-260928-2`
- `kmutexcreate-trial-260928-2`
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

Restore one trial from the main working directory when needed:

```sh
git fetch origin archive/ksemaphoredelete-trial-261025-1
git restore --source=origin/archive/ksemaphoredelete-trial-261025-1 -- <trial-directory>
```
