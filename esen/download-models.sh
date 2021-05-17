#!/bin/bash

for pair in esen enes; do
    wget -nc -P $pair.teacher.bigx2/ http://data.statmt.org/romang/bergamot/models/esen/$pair.teacher.bigx2/model{1,2}.npz
    wget -nc -P $pair.teacher.bigx2/ http://data.statmt.org/romang/bergamot/models/esen/vocab.esen.spm

    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/$pair.student.tiny11/model.npz
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/$pair.student.tiny11/model.intgemm.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/$pair.student.tiny11/model.intgemm.alphas.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/$pair.student.tiny11/lex.s2t.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/esen/vocab.esen.spm
done

