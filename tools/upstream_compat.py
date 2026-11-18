#!/usr/bin/env python3
"""Fetch pinned upstream examples into a PRIVATE evidence directory, not repo.
This checks parsing only, not solver equivalence or industrial scalability.
Usage: python tools/upstream_compat.py PRIVATE_REPORT_DIRECTORY
"""
import base64, hashlib, json, os, subprocess, sys, urllib.request
from pathlib import Path
REV='e6941e37e056084ab6e51c5c1eee6233089a330d'
ROOT=Path(__file__).resolve().parents[1]
def api(path):
    u='https://api.github.com/repos/Boolector/btor2tools/'+path
    with urllib.request.urlopen(urllib.request.Request(u,headers={'User-Agent':'moonbtor-compatibility'}),timeout=25) as r:return json.load(r)
def main():
    dest=Path(sys.argv[1]).resolve()
    if dest==ROOT or ROOT in dest.parents:raise SystemExit('Evidence must be outside source repository')
    dest.mkdir(parents=True,exist_ok=True)
    tree=api('git/trees/'+REV+'?recursive=1')
    fixtures=[f for f in tree['tree'] if f['path'].startswith('examples/btorsim/') and f['path'].endswith('.btor2')]
    report=[]
    for f in fixtures:
      data=api('git/blobs/'+f['sha'])
      raw=base64.b64decode(data['content']); src=raw.decode()
      if len(src)>24000:
        report.append({'path':f['path'],'status':'not-run','reason':'environment transport limit, not parser rejection','size':len(raw)})
        continue
      env=os.environ.copy();env['MOONBTOR_SOURCE']=src
      r=subprocess.run(['moon','run','examples/compat','--target','js','--quiet'],cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
      record={'path':f['path'],'sha256':hashlib.sha256(raw).hexdigest(),'status':'pass' if r.returncode==0 else 'fail','exit_code':r.returncode,'result':r.stdout.decode(errors='replace').strip(),'diagnostic':r.stderr.decode(errors='replace').strip()}
      report.append(record)
      print(json.dumps(record))
    license_data=api('contents/LICENSE.txt?ref='+REV)
    (dest/'upstream-LICENSE.txt').write_bytes(base64.b64decode(license_data['content']))
    (dest/'upstream-compat.json').write_text(json.dumps({'repository':'Boolector/btor2tools','revision':REV,'scope':'parser only','fixtures':report},indent=2),encoding='utf-8')
    assert all(r['status']!='fail' for r in report)
if __name__=='__main__':main()
