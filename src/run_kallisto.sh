#!/bin/bash

set  -e

function usage() {
	echo "Usage: $0 READ1 READ2 OUTPUTFOLDER [THREADS]"
	echo " "
	echo "  READ1        first read pair (read1.fastq.gz)"
	echo "  READ2        second read pair (read2.fastq.gz)"
	echo "  OUTPUTFOLDER output directory (sample123result)"
	echo "  THREADS      optional thread count (default: 6)"
	echo " "
	echo "  -h help"

	exit
}
if [ $# -eq 0 ]
then
	echo "No arguments supplied"
	usage
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	usage
fi

if [ $# -lt 3 ] || [ $# -gt 4 ]; then
	usage
fi


read1=$1
read2=$2

outputfolder=$3
threads=${4:-6}
echo $outputfolder

REF=/opt/index_grch38_encode44/gencode_v44.idx

kallisto quant -t $threads -i $REF \
	-o $outputfolder \
	       $read1 $read2

#kallisto quant -t ${threads} -i $REF -o ./CDMD8304_muscle_kallisto_grch38 CDMD8304_muscle_S3_R1_001.fastq.gz CDMD8304_muscle_S3_R2_001.fastq.gz
