CLEAN_TARGETS = ["aux","log","toc","lof","lot","bbl","blg","out","log","~","bak"]

import os, fnmatch
def recursive_glob(pattern,treeroot=os.getcwd()):
  results = []
  for base, dirs, files in os.walk(treeroot):
    goodfiles = fnmatch.filter(files, pattern)
    results.extend(os.path.join(base, f) for f in goodfiles)
  return results

for target in CLEAN_TARGETS:
    for filename in recursive_glob("*%s"%target):
        print filename.split('/')[-1],
        os.remove(filename)
print
