#!/usr/bin/env python3
"""Z3 4.15.4: independent BV oracle and actual array CNF -> SAT -> replay.
Development dependency only: pip install z3-solver==4.15.4.0
"""
import itertools, os, random, subprocess, sys
from pathlib import Path
import z3
from generate_standard_oracles import OPS, evaluate
ROOT=Path(__file__).resolve().parents[1]
def zvalue(op,a,b,w):
    x,y=z3.BitVecVal(a,w),z3.BitVecVal(b,w)
    sx,sy=z3.SignExt(w,x),z3.SignExt(w,y)
    result={
      'udiv':lambda:z3.UDiv(x,y), 'urem':lambda:z3.URem(x,y),
      'sdiv':lambda:x/y, 'srem':lambda:z3.SRem(x,y), 'smod':lambda:x%y,
      'rol':lambda:z3.RotateLeft(x,y),'ror':lambda:z3.RotateRight(x,y),
      'uaddo':lambda:z3.ULT(x+y,x), 'usubo':lambda:z3.ULT(x,y),
      'umulo':lambda:z3.Extract(2*w-1,w,z3.ZeroExt(w,x)*z3.ZeroExt(w,y))!=0,
      'saddo':lambda:z3.SignExt(w,x+y)!=sx+sy,
      'ssubo':lambda:z3.SignExt(w,x-y)!=sx-sy,
      'smulo':lambda:z3.SignExt(w,x*y)!=sx*sy,
      'sdivo':lambda:z3.And(x==1<<(w-1),y==(1<<w)-1),
    }[op]()
    result=z3.simplify(result)
    return int(z3.is_true(result)) if z3.is_bool(result) else result.as_long()
def main():
    count=0
    for op in OPS:
      for w in [1,3,32,64]:
        m=(1<<w)-1
        pairs=list(itertools.product(range(1<<w),repeat=2)) if w<=3 else list(itertools.product([0,1,(1<<(w-1))-1,1<<(w-1),m],repeat=2))
        if w>3:
          rng=random.Random(730+w)
          pairs += [(rng.getrandbits(w),rng.getrandbits(w)) for _ in range(8)]
        for a,b in pairs:
          assert zvalue(op,a,b,w)==evaluate(op,a,b,w),(op,w,a,b)
          count+=1
    target=sys.argv[1] if len(sys.argv)>1 else 'js'
    env=os.environ.copy();env['MOONBTOR_ACTION']='export'
    cmd=['moon','run','examples/memory','--target',target,'--quiet']
    cnf=subprocess.run(cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,check=True).stdout.decode()
    lines=[x for x in cnf.splitlines() if x and not x.startswith('c')]
    _,_,n,k=lines.pop(0).split(); n,k=int(n),int(k)
    clauses=[[int(v) for v in s.split()[:-1]] for s in lines]
    assert len(clauses)==k
    variables=[None]+[z3.Bool('v'+str(i)) for i in range(1,n+1)]
    solver=z3.Solver()
    for clause in clauses:solver.add(z3.Or([variables[i] if i>0 else z3.Not(variables[-i]) for i in clause]))
    assert solver.check()==z3.sat
    m=solver.model()
    bits=[z3.is_true(m.eval(v,model_completion=True)) for v in variables[1:]]
    env['MOONBTOR_ACTION']='decode'
    env['MOONBTOR_ASSIGNMENT']='s SATISFIABLE\nv '+' '.join(str(i if bit else -i) for i,bit in enumerate(bits,1))+' 0'
    subprocess.run(cmd,cwd=ROOT,env=env,check=True)
    print('Z3 '+z3.get_version_string()+': '+str(count)+' BV vectors agree; array CNF '+str(n)+' variables '+str(k)+' clauses decoded and replayed')
if __name__=='__main__':main()
