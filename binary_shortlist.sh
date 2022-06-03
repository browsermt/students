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
  $MARIAN_CONV --shortlist lex.s2t.gz 100 100 0 --dump lex.s2t.bin --vocabs $vocab_file $vocab_file
  cd ../..
done

# Copy binary shortlist files into each folder
scp csen/csen.student.base/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/8bit-students/csen/base
scp csen/csen.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/8bit-students/csen/tiny11
scp csen/encs.student.base/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/8bit-students/encs/base
scp csen/encs.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/8bit-students/encs/tiny11

scp deen/ende.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11

scp esen/esen.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/romang/bergamot/models/esen/esen.student.tiny11
scp esen/enes.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/romang/bergamot/models/esen/enes.student.tiny11

scp eten/eten.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/romang/bergamot/models/eten/eten.student.tiny11
scp eten/enet.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/romang/bergamot/models/eten/enet.student.tiny11

scp isen/isen.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/isen/isen.student.tiny11

scp nben/nben.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/nben/nben.student.tiny11/

scp nnen/nnen.student.tiny11/lex.s2t.bin $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/nnen/nnen.student.tiny11/
