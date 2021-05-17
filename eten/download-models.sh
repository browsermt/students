#!/bin/bash

for pair in eten enet; do
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/eten/$pair.student.tiny11/model.npz
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/eten/$pair.student.tiny11/model.intgemm.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/eten/$pair.student.tiny11/model.intgemm.alphas.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/eten/$pair.student.tiny11/lex.s2t.gz
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/eten/$pair.student.tiny11/lex.s2t.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/romang/bergamot/models/eten/vocab.eten.spm

    wget -nc -P $pair.teacher.bigx2/ http://data.statmt.org/romang/bergamot/models/eten/$pair.teacher.bigx2/model{1,2}.npz
    wget -nc -P $pair.teacher.bigx2/ http://data.statmt.org/romang/bergamot/models/eten/vocab.eten.spm
done
