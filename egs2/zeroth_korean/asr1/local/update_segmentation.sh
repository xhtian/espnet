#!/bin/bash

# Copyright 2017 Lucas Jo (Atlas Guide)
# Apache 2.0

# do this when the segmentation rule is changed
dataDir=$1
lmDir=$2

trans=$dataDir/text
echo "Re-segment transcripts: $trans --------------------------------------------"
if [ ! -f $trans ]; then
	echo "transcription file is not found in "$dataDir
	exit 1
fi
cp $trans $trans".old"
awk '{print $1}' $trans".old" > $trans"_tmp_index"
cut -d' ' -f2- $trans".old" |\
	sed -E 's/\s+/ /g; s/^\s//g; s/\s$//g' |\
	morfessor -e 'utf-8' -l $lmDir/zeroth_morfessor.seg -T - -o - \
	--output-format '{analysis} ' --output-newlines \
	--nosplit-re '[0-9\[\]\(\){}a-zA-Z&.,\-]+' \
	| paste -d" " $trans"_tmp_index" - > $trans
rm -f $trans"_tmp_index"

