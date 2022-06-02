#!/usr/bin/env bash

for lang in enpl plen
do
	for model in tiny11 
	do
		mkdir -p $lang.student.$model
		cd $lang.student.$model
		wget -nc http://data.statmt.org/bergamot/models/plen/$lang/$model/model.intgemm.alphas.bin
		wget -nc http://data.statmt.org/bergamot/models/plen/$lang/$model/lex.s2t.bin
		wget -nc http://data.statmt.org/bergamot/models/plen/$lang/$model/vocab.${lang}.spm -O vocab.plen.spm
		cd ..
	done
done
