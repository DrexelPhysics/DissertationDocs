#!/bin/bash

set -e # exit immediately on failed command
set -o pipefail # pipes fail if any stage fails

KFILE='./data/spring-constants'
AVGFILE='./data/averaged-data'

while read LINE
do
    Kprecise=`echo "$LINE" | sed 's/.*= \([0-9.]*\) +.*/\1/'`
    K=`python -c "print('{:.2f}'.format($Kprecise))"`
    FILE="v-dep.d/v_dep_$K"
    echo "clearing $FILE"
    > "$FILE.dat"
    rm -f "$FILE.fit"
done < <(tac "$KFILE")

while read DATA
do
    V=`echo "$DATA" | awk '{print $1}'`
    K=`echo "$DATA" | awk '{print $2}'`
    F=`echo "$DATA" | awk '{print $3}'`
    Fstd=`echo "$DATA" | awk '{print $4}'`
    N=`echo "$DATA" | awk '{print $5}'`
    FILE="v-dep.d/v_dep_$K"
    echo "adding $V, $F, $Fstd, $N to $FILE.dat"
    echo -e "$V\t$F\t$Fstd\t$N" >> "$FILE.dat"
done < <(cat "$AVGFILE" | grep -v '^#')
