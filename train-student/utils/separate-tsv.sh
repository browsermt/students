#!/bin/bash
# 
# Utility script to seperate europarl like datasets into two separate files.

set -x;

FILE=$1
SRC=$2
TGT=$3

pigz -dc $FILE | cut -f 1 | pigz > $FILE.$SRC.gz
pigz -dc $FILE.$SRC.gz | head -n 3 
pigz -dc $FILE | cut -f 2 | pigz > $FILE.$TGT.gz
pigz -dc $FILE.$TGT.gz | head -n 3 
