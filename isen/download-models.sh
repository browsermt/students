#!/bin/bash

for pair in isen; do
    for model in base tiny11; do
        wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/$pair.teacher.base/model.npz
        wget -nc -P $pair.teacher.base/ http://data.statmt.org/bergamot/models/$pair/vocab.$pair.spm

        wget -nc -P $pair.student.$model/ http://data.statmt.org/bergamot/models/$pair/$pair.student.$model/model.npz
        wget -nc -P $pair.student.$model/ http://data.statmt.org/bergamot/models/$pair/$pair.student.$model/model.intgemm.bin
        wget -nc -P $pair.student.$model/ http://data.statmt.org/bergamot/models/$pair/$pair.student.$model/model.intgemm.alphas.bin
        wget -nc -P $pair.student.$model/ http://data.statmt.org/bergamot/models/$pair/$pair.student.$model/lex.s2t.gz
        wget -nc -P $pair.student.$model/ http://data.statmt.org/bergamot/models/$pair/$pair.student.$model/lex.s2t.bin
        wget -nc -P $pair.student.$model/ http://data.statmt.org/bergamot/models/$pair/vocab.$pair.spm
    done
done
