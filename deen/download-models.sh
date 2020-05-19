#!/bin/bash

wget -nc -P ende.student.tiny11/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11/model.npz
wget -nc -P ende.student.tiny11/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11/lex.s2t.gz
wget -nc -P ende.student.tiny11/ http://data.statmt.org/romang/bergamot/models/deen/vocab.deen.spm

wget -nc -P ende.student.base/ http://data.statmt.org/romang/bergamot/models/deen/ende.student.base/model.npz
cp ende.student.tiny11/lex.s2t.gz     ende.student.base/
cp ende.student.tiny11/vocab.deen.spm ende.student.base/

