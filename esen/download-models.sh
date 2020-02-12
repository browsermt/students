#!/bin/bash

for pair in esen enes; do
    wget -nc -P $pair.teacher.bigx2/ http://data.statmt.org/romang/bergamot/models/esen/$pair.teacher.bigx2/model{1,2}.npz
    wget -nc -P $pair.teacher.bigx2/ http://data.statmt.org/romang/bergamot/models/esen/vocab.esen.spm
done

wget -nc -P esen.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/esen.student.tiny11/model.npz
wget -nc -P esen.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/esen.student.tiny11/lex.s2t.gz
wget -nc -P esen.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/vocab.esen.spm
