#!/bin/bash

for pair in nnen; do
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/model.npz
    wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/vocab.$pair.spm

    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.npz
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.intgemm.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.intgemm.alphas.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/lex.s2t.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/vocab.$pair.spm
done
