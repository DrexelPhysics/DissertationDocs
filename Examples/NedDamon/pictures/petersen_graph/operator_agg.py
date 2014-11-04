import scipy, sympy
from copy import deepcopy
#from gmpy import mpq, mpz
#from fractions import Fraction
#import tempfile, cPickle, distutils.dir_util
#import sys, os
#sys.path.append( "./custom_functions")
#from CFFLU import CFFLU_det
#from safe_multiprocessing import controlled_Pool

class partition:
    def __init__(self, inital_item=None):
        self.b, self.n = 0, 0
        self.members = set()
        if inital_item: self.add(inital_item)

    def __iter__(self):
        for item in self.members: yield item
        raise StopIteration

    def __str__(self):
        S = ','.join(["%s"%p for p in self.members])
        return "{%s}(%s, %s)" % (S, self.n, self.b)
    def __repr__(self): return str(self)

    def add(self, item): self.members.add(item)
    def delete(self, item):
        self.members.remove(item)
    def is_single(self): return len(self.members)==1
        

class state:
    def __init__(self,inital_item=None):
        self.parts = set()
        if inital_item: self.add(inital_item)

    def __iter__(self):
        for item in self.parts: yield item
        raise StopIteration

    def add(self, item):
        self.parts.add( partition(item) )

    def copy(self):
        S = state()
        for p in self.parts: S.parts.add(p)
        return S

    def __str__(self):
        S = ','.join(["%s"%p for p in self.parts])
        return "|%s>" % (S)
    def __repr__(self): return str(self)

    def find(self, v):
        for p in self.parts:
            if v in p: return p

    def join(self, v1, v2):
        p1 = self.find(v1)
        p2 = self.find(v2)

        if p1==p2:
            p1.b += 1
            return None

        
        p3 = partition()
       
        for v in p1: p3.add(v)
        for v in p2: p3.add(v)
        p3.b = p1.b + p2.b + 1
        p3.n = p1.n + p2.n

        self.parts.remove(p1)
        self.parts.remove(p2)
        self.parts.add(p3)

    def delete(self, v1):
        p = self.find(v1)
        p.n += 1

        if not p.is_single():
            p.delete(v1)
            return None
        
        self.parts.remove(p)
        name = "x%s_%s"%(p.n,p.b)
        return name



class state_poly:
    def __init__(self, empty=False):
        self.val = 0
        self.terms = dict()
        self.insert(None)
        

    def insert(self, item):
        s = state(item)
        name = str(s)
        self.terms[name] = s
        v = sympy.Symbol(name)
        self.val += v

    def __str__(self):  return str(self.val)
    def __repr__(self): return str(self)

    def op(self, op_name, *args):
        print "RUNNING %s"% op_name, len(self.terms)
        new_terms = dict()
        
        for key in self.terms:
            X = self.terms[key]

            r_val = getattr(X, op_name)(*args)
           
            new_key = str(X)
            new_terms[new_key] = X.copy()

            old_val = sympy.Symbol(key)
            new_val = sympy.Symbol(new_key)
            
            if(op_name=="delete" and r_val):
                new_coeff = sympy.Symbol(r_val) 
                self.val = self.val.subs(old_val,old_val*new_coeff)

            self.val = self.val.subs(old_val, new_val)

        self.terms = new_terms

        # Collect like terms
        for X in self.terms:
            self.val = sympy.collect(self.val, sympy.Symbol(X))
            #print "COLLECTING ON: ", X

    # convenience functions
    def A(self, i): self.op("add", i)
    def J(self, i,j): self.op("join", i,j)
    def D(self, i): self.op("delete", i)
 
    def W(self, i,j):
        P2 = deepcopy(self)
        P2.J(i,j)
        self.val += P2.val
        self.terms.update(P2.terms)

    def final(self):
        X = sympy.Symbol("|>")
        return self.val.as_coefficient(X).expand()
        

if __name__ == "__main__":
    P = state_poly()

    P.A(1)
    P.A(2)
    P.A(3)
    P.W(1,2)
    P.W(2,3)
    P.D(1)
    P.D(2)
    P.D(3)
    print P.final()

