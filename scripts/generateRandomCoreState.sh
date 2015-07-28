#!/bin/sh

#!/bin/sh
if [ "$#" -ne 1 ] 
then
  echo "Usage: $0 WIDTH HEIGHT EV_COUNT" >&2
  exit 1
fi

WIDTH=$1
HEIGHT=$2
EV_COUNT=$3
MAX_CODE=3

function randomDir {
	DIR=$(( $RANDOM % 4 ))
	case $DIR in
		0 ) echo "N"
			;;
		1 ) echo "E"
			;;
		2 ) echo "S"
			;;
		3 ) echo "W"
			;;
	esac
}

function generateEV {
	X=$(( $RANDOM % $WIDTH ))
	Y=$(( $RANDOM % $HEIGHT ))
	C=$(randomDir)
    echo "EV:"$X","$Y","$C","$1
}

function generateEVs {
    for (( i=1; i<=$EV_COUNT; i++ ))
    do
		generateEV $i
    done
}

function generateNext {
    NEXT=$(( $RANDOM % $EV_COUNT ))
    echo "NEXT:"$NEXT
}

function generateMatrix {
    for (( y=1; y<=$HEIGHT; y++ ))
    do
	    for (( x=1; x<=$WIDTH; x++ ))
	    do
			CODE=$(( ( $RANDOM % $2 ) + $1 ))
			echo $CODE" \c"
	    done
	    echo
    done
}

function generateCoreState {
	generateEVs
	generateNext
    echo "-"
    generateMatrix 1 $MAX_CODE
    echo "-"
    generateMatrix 0 1
}

generateCoreState  