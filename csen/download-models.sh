#!/usr/bin/env bash

for lang in csen encs
do
	for model in base tiny11
	do
		mkdir -p $lang.student.$model
		cd $lang.student.$model
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/model.8bit-finetuned.npz
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/model.8bit-finetuned.alphas.npz
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/model.8bit-finetuned.intgemm8.bin
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/model.8bit-finetuned.intgemm8.alphas.bin
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/lex.s2t.gz
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/lex.s2t.bin
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/vocab.spm
		cd ..
	done
done

mkdir -p non-finetuned
cd non-finetuned
for lang in csen encs
do
	for model in base tiny11
	do
		mkdir -p $lang.student.$model
		cd $lang.student.$model
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/model.npz.best-bleu-detok.npz
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/lex.s2t.gz
		wget -nc http://data.statmt.org/bergamot/models/8bit-students/$lang/$model/vocab.spm
		cd ..
	done
done
