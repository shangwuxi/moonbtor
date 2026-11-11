#!/usr/bin/env python3
"""Run a real DIMACS roundtrip through an independent Python exhaustive SAT solver.
The tiny fixture has <=20 variables; this is a correctness oracle, not a scalable solver.
"""
from itertools import product
from pathlib import Path
import os,subprocess,sys
root=Path(__file__).resolve().parents[1]
target=sys.argv[1] if len(sys.argv)>1 else 'js'
cmd=['moon','run','examples/export','--target',target,'--quiet']
r=subprocess.run(cmd,cwd=str(root),check=True,stdout=subprocess.PIPE)
lines=[x for x in r.stdout.decode('utf-8').splitlines() if x and not x.startswith('c')]
header=lines.pop(0).split()
assert header[:2]==['p','cnf']
n,count=map(int,header[2:]);assert n<=20
clauses=[[int(x) for x in line.split()[:-1]] for line in lines]
assert count==len(clauses) and all(line.split()[-1]=='0' for line in lines)
bits=next(a for a in product([False,True],repeat=n) if all(any(a[abs(l)-1]==(l>0) for l in c) for c in clauses))
output='s SATISFIABLE\nv '+' '.join(str(i+1 if b else -(i+1)) for i,b in enumerate(bits))+' 0'
env=os.environ.copy();env['MOONBTOR_ASSIGNMENT']=output
subprocess.run(['moon','run','examples/external','--target',target,'--quiet'],cwd=str(root),env=env,check=True)
print('independent external roundtrip: %d variables, %d clauses'%(n,count))
