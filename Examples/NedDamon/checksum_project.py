#!/usr/bin/python

import os, fnmatch

def recursive_glob(pattern,treeroot=os.getcwd()):
  results = []
  for base, dirs, files in os.walk(treeroot):
    goodfiles = fnmatch.filter(files, pattern)
    results.extend(os.path.join(base, f) for f in goodfiles)
  return results

def check_bibtex():

  Jabbrv_filename = "bibliographies/Jabbrv.txt"
  J = dict()
  for line in open(Jabbrv_filename,'r'):
      a,b = [x.strip() for x in line.split(':')]
      J[a] = b

  removed_cat = [ "issn","pmid","note",'isbn','url','annote',"month","doi"]


  for filename in recursive_glob("*.bib"):

      JREV = J.values()
      FIN = open(filename,'r')
      raw = [x.strip() for x in FIN]
      FIN.close()

      F = []

      for r in raw:
          data = r.split('=')
          title = data[0].strip().lower()
          if title == "journal":
              jx = data[1].strip().replace('{','').replace('}','')[:-1]
              jx = jx.replace(':','')

              if jx not in J:
                  if jx not in JREV:
                      print "%s not found in abbr database" % jx, filename

              else:
                  jx = J[jx]

              data = ['journal={%s},' % jx]

          else:
              data = [r]


          if title not in removed_cat:
              F.append(''.join(data))

      FOUT = open(filename, 'w')
      for f in F:
          FOUT.write('%s\n'%f)

      FOUT.close()

    
check_bibtex()


bad_opt = ["bibliographystyle","author","draftmarksetup","bibliography","equation","operatorname","array","texttt","align","frac","tikzpicture","align"]
B = ' '.join(['--add-tex-command="%s pPoO"' %x for x in bad_opt])

S = ''

for filename in recursive_glob("*.tex"):
  if "supplement" not in filename and "bundled_packages" not in filename:
    S = "aspell -t %s check %s " % (B, filename)
    os.system(S)
  


#print S
