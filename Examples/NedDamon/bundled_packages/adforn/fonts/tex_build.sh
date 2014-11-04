#!/bin/bash

# Installs the fonts on my Ubuntu sytem - your results may vary!

texdir=$(kpsewhich -expand-var='$TEXMFLOCAL' | sed 's/:.*//')
fontname=$"OrnementsADF"

mkdir -p $texdir/fonts/map/dvips/$fontname
mkdir -p $texdir/fonts/tfm/public/$fontname
mkdir -p $texdir/fonts/type1/public/$fontname
mkdir -p $texdir/tex/latex/$fontname

cp *.map $texdir/fonts/map/dvips/$fontname
cp *.tfm $texdir/fonts/tfm/public/$fontname
cp *.pfb $texdir/fonts/type1/public/$fontname
cp *.sty $texdir/tex/latex/$fontname

#rm -rf prodint
mktexlsr
updmap-sys --enable Map=$fontname.map