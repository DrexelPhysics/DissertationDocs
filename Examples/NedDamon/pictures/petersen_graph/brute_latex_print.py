
prefix = "data/"
fin1  = "chi_peterson.txt"
FIN1  = open("%s%s"%(prefix,fin1),'r')

def count_dupes(dupedList):
   uniqueSet = set(item for item in dupedList)
   return [(item, dupedList.count(item)) for item in uniqueSet]


BS = dict()

for line in FIN1:
    g, K = line.strip().split(':')
    K = eval(K)
    g = int(g)

    if g not in BS: BS[g]=[]


    S = ""
    for item in count_dupes(K):
        if item[1] >1:
            S += "\\CHI{%s,}{%s}^{%s} " % (item[0][0],item[0][1], item[1])
        else: 
            S += "\\CHI{%s,}{%s} " % (item[0][0],item[0][1])

    BS[g].append(S)

keys = BS.keys()
for k in sorted(keys):
    if len(BS[k])>1:
        print " &+ %s (%s) \\\\" % (k, ' + '.join(BS[k])) 
    else:
        print " &+ %s %s \\\\" % (k, ' + '.join(BS[k])) 

print sorted(keys)
print sum(sorted(keys)), 2**15

