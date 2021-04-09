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
        # rename files for consistency
		mv model.8bit-finetuned.npz model.npz
        mv model.8bit-finetuned.alphas.npz model.alphas.npz
		mv model.8bit-finetuned.intgemm8.bin model.intgemm.bin
		mv model.8bit-finetuned.intgemm8.alphas.bin model.intgemm.alphas.bin
		mv vocab.spm vocab.csen.spm
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
		# rename files for consistency
		mv vocab.spm vocab.csen.spm
		cd ..
	done
done
