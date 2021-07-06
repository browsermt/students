#!/bin/bash

for pair in faen; do
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/model1.npz
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/model2.npz
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/model3.npz
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/model4.npz
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/tc.fa
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/tc.en
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/$pair.bpe
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/vocab.$pair.yml



    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.npz
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.intgemm.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.intgemm.alphas.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/lex.s2t.gz
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/lex.s2t.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/vocab.$pair.spm
done
