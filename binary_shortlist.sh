#!/bin/env bash

# # Download data and models
# for i in $(ls -d */ | grep -v "train-student"); do
#   echo $i
#   cd $i
#   bash download-data.sh
#   bash download-models.sh
#   cd ..
# done

# Generate binary shortlists
MARIAN_CONV=/home/qianqianzhu/workspace/browsermt/marian-dev/build/marian-conv
for i in $(find * -maxdepth 1 -type d | grep  ".*/.*.student.*."); do
  echo $i
  cd $i
  vocab_file=$(ls vocab*)
  $MARIAN_CONV --shortlist lex.s2t.gz 50 50 0 --dump lex.s2t.bin --vocabs $vocab_file $vocab_file
  cd ../..
done