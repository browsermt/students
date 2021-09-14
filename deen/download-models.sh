#!/bin/bash

wget -nc -P ende.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.tiny11/model.npz
wget -nc -P ende.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.tiny11/model.intgemm.bin
wget -nc -P ende.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.tiny11/model.intgemm.alphas.bin
wget -nc -P ende.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.tiny11/lex.s2t.gz
wget -nc -P ende.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.tiny11/lex.s2t.bin
wget -nc -P ende.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/vocab.deen.spm

wget -nc -P ende.student.base/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.base/model.npz
wget -nc -P ende.student.base/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.base/model.intgemm.bin
wget -nc -P ende.student.base/ http://data.statmt.org/svetlana/bergamot/models/deen/ende.student.base/model.intgemm.alphas.bin
cp ende.student.tiny11/lex.s2t.gz     ende.student.base/
cp ende.student.tiny11/lex.s2t.bin     ende.student.base/
cp ende.student.tiny11/vocab.deen.spm ende.student.base/

wget -nc -P deen.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.tiny11/model.npz
wget -nc -P deen.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.tiny11/model.intgemm.bin
wget -nc -P deen.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.tiny11/model.intgemm.alphas.bin
wget -nc -P deen.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.tiny11/lex.s2t.gz
wget -nc -P deen.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.tiny11/lex.s2t.bin
wget -nc -P deen.student.tiny11/ http://data.statmt.org/svetlana/bergamot/models/deen/vocab.deen.spm

wget -nc -P deen.student.base/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.base/model.npz
wget -nc -P deen.student.base/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.base/model.intgemm.bin
wget -nc -P deen.student.base/ http://data.statmt.org/svetlana/bergamot/models/deen/deen.student.base/model.intgemm.alphas.bin
cp deen.student.tiny11/lex.s2t.gz     deen.student.base/
cp deen.student.tiny11/lex.s2t.bin     deen.student.base/
cp deen.student.tiny11/vocab.deen.spm deen.student.base/

