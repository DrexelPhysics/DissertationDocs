#!/bin/bash

set -e # exit immediately on failed command
set -o pipefail # pipes fail if any stage fails

KFILE='./data/spring-constants'
AVGFILE='./data/averaged-data'
ASYFILE='./v-dep.asy'

ASYPLOTS=""
GPPLOTS=""
while read LINE
do
    Kprecise=`echo "$LINE" | sed 's/.*= \([0-9.]*\) +.*/\1/'`
    K=`python -c "print('{:.2f}'.format($Kprecise))"`
    FILE="v-dep.d/v_dep_$K"
    Kindex=`echo "$LINE" | sed 's/K(\([0-9.]*\)) =.*/\1/'`
    case "$Kindex" in
	0)
	    PEN="psoft"
	    ;;
	1)
	    PEN="pmed"
	    ;;
	2)
	    PEN="phard"
	    ;;
    esac
    ASYPLOTS=$(echo -e "$ASYPLOTS\ngraphFile(\"$FILE.dat\", xscale, yscale, $PEN, m8,
          markroutine=marksize(\"$FILE.dat\", $PEN, m8, 10), t=units(\"$K\",\"pN/nm\"), dots=true);")
    ASYPLOTS=$(echo -e "$ASYPLOTS\ngraphFile(\"$FILE.fit.dat\", xscale, yscale, $PEN,
          t=units(\"$K\",\"pN/nm\"));")
    GPPLOTS="$GPPLOTS, '$FILE.dat' using 1:2:(sqrt(\$4)) with points pt 6 pointsize variable t '$K (pN/nm)'"
    GPPLOTS="$GPPLOTS, '$FILE.fit.dat' using 1:2 with lines notitle"
done < <(tac "$KFILE")
GPPLOTS="${GPPLOTS:2}" # remove leading ' ,'

cat > "$ASYFILE" <<HEREDOC
import wtk_graph;

size(15cm,10cm,IgnoreAspect);

scale(Log, Linear);
real xscale=1;
real yscale=1;
$ASYPLOTS

//xlimits(1,3e3);
//ylimits(90,620);

label(sLabel("Pulling speed dependence"), point(N),N);
xaxis(sLabel("Pulling speed (nm/s)"),BottomTop,LeftTicks);
yaxis(sLabel("Unfolding force (pN)"),LeftRight,RightTicks);

add(legend(),point(E),20E,UnFill);
HEREDOC
