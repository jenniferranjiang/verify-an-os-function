from pathlib import Path
import json
root=Path(__file__).resolve().parents[1]
registry=json.loads((root/'checks/implementation-runs.json').read_text())
rows=[]
for target,entry in registry['runs'].items():
 s=json.loads((root/'reports'/entry['run']/'controller_state.json').read_text())
 groups=s['attempts'].get(s['current'].get('vc-proving'),{}).get('groups',{})
 accepted=sum(g['status']=='accepted' for g in groups.values())
 active=[name+' ('+g['status']+')' for name,g in groups.items() if g['status'] in ['running','returned']]
 detail=', '.join(active) or ('final-check通过' if s['phase']=='done' else '等待派发/检查')
 rows.append(f"| {target} | `{entry['run']}` | {s['phase']} | {accepted}/{len(groups)} | {detail} |")
p=root/'.docs/Report/status.md';s=p.read_text();start=s.index('| FindEventById |',s.index('## 实现实时进度'));end=s.index('\n\n',start);p.write_text(s[:start]+'\n'.join(rows)+s[end:]);print('\n'.join(rows))
