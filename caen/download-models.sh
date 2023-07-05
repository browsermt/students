#!/bin/bash

for pair in caen; do
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.npz
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/model.intgemm.alphas.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/lex.s2t.bin
    wget -nc -P $pair.student.tiny11/ http://data.statmt.org/bergamot/models/$pair/$pair.student.tiny11/vocab.$pair.spm
done
