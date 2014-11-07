#!/bin/bash
#
# Extract v,f,k data.  Ignore index, temperature, etc.

set -e # exit immediately on failed command
set -o pipefail # pipes fail if any stage fails

BASE_DATA_DIR="$HOME/rsrch/data"
SCALED_DATA_DIR="scaled_unfold"
CALIBRATION_DATA_DIR="calibration"

EXTRACT_UNFOLDS="$HOME/src/lab/analysis/sawmodel/extract_unfolds.py"
SCALE_UNFOLD="$HOME/src/lab/analysis/sawtooth_worming-0.1/scale_unfold.py"

DATA_DAYS[8]=20090114
#DATA_DAYS[9]=20090128   # No good sawteeth
DATA_DAYS[10]=20090203
#DATA_DAYS[11]=20090211  # No good sawteeth
DATA_DAYS[12]=20090212
DATA_DAYS[13]=20090214
DATA_DAYS[14]=20090219
DATA_DAYS[15]=20090222

echo -e "#Unfolding force (pN)\tUnfolding rate (nm/s)\tSpring constant (pN/nm)\tLoading rate (pN/s)\tDatafile"

function NotEmpty ()
{
    NAME=$1
    VALUE=$2
    if [ -z "$VALUE" ]; then
	echo "Error parsing"
	echo "$UNFOLD_LINE"
	echo "$NAME not defined.  File format must have changed."
	exit 1
    fi
}

FIELD_INDEX=""
function FieldIndex ()
{
    LINE="$1"
    TITLE_REGEXP="$2"
    FIELD_INDEX=`echo "$LINE" | sed 's/\t/\n/g' | grep -n "$TITLE_REGEXP" | cut -d: -f1`
}

for DAY in ${DATA_DAYS[*]}
do
    echo "---Processing day $DAY---" >&2
    DATAFILE_FIELD=""
    FORCE_FIELD=""
    LAST_DATAFILE="" # Caching for efficiency
    while read UNFOLD_LINE
    do
	echo "Parsing '$UNFOLD_LINE'" >&2
	if [ "${UNFOLD_LINE:0:1}" == "#" ] ; then
	    # reading the header line
	    FieldIndex "$UNFOLD_LINE" "Datafile"
	    DATAFILE_FIELD="$FIELD_INDEX"
	    FieldIndex "$UNFOLD_LINE" "Force (pN)"
	    FORCE_FIELD="$FIELD_INDEX"
	    FieldIndex "$UNFOLD_LINE" "Stiffness (pN/nm)"
	    STIFFNESS_FIELD="$FIELD_INDEX"
	    NotEmpty 'Datafile field' "$DATAFILE_FIELD"
	    NotEmpty 'Force field' "$FORCE_FIELD"
	    NotEmpty 'Stiffness field' "$STIFFNESS_FIELD"
	    continue
	fi
	NotEmpty "$DAY extraction header" "$DATAFILE_FIELD"
	DATAFILE=`echo "$UNFOLD_LINE" | cut -f $DATAFILE_FIELD`
        NotEmpty 'Datafile' "$DATAFILE"
	DATAFILE="$BASE_DATA_DIR/$SCALED_DATA_DIR/$DATAFILE"
	UNFOLDING_FORCE=`echo "$UNFOLD_LINE" | cut -f $FORCE_FIELD`
	NotEmpty 'Unfolding force' "$UNFOLDING_FORCE"
	STIFFNESS=`echo "$UNFOLD_LINE" | cut -f $STIFFNESS_FIELD`
	NotEmpty 'Stiffness' "$STIFFNESS"
	if [ "$DATAFILE" != "$LAST_DATAFILE" ]; then
	    UNFOLDING_RATE=`sed -n 's/^Unfold rate (nm\/s):\t//p' "${DATAFILE}_param"`
	    NotEmpty 'Unfolding rate' "$UNFOLDING_RATE"
	    SPRING_CONSTANT_STRING=`$SCALE_UNFOLD --print-k "$DATAFILE"`
	    NotEmpty 'Spring constant string' "$SPRING_CONSTANT_STRING"
	    SPRING_CONSTANT_N_PER_M=`echo "$SPRING_CONSTANT_STRING" | sed -n 's/ N\/m$//p'`
	    NotEmpty 'Spring constant (N/m)' "$SPRING_CONSTANT_N_PER_M"
	    SPRING_CONSTANT=`echo "print ($SPRING_CONSTANT_N_PER_M * 1e3)" | python`
	    NotEmpty 'Spring constant (pN/nm)' "$SPRING_CONSTANT"
	fi
	LOADING_RATE=`python -c "print $STIFFNESS * $UNFOLDING_RATE"` # pN/s
	echo -e "$UNFOLDING_FORCE\t$UNFOLDING_RATE\t$SPRING_CONSTANT\t$LOADING_RATE\t$DATAFILE"
	LAST_DATAFILE="$DATAFILE"
    done < <(cd $BASE_DATA_DIR/$SCALED_DATA_DIR/ && $EXTRACT_UNFOLDS ${DAY}_select_fit.xml)
done

exit 0
