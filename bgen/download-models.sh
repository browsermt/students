#!/usr/bin/env bash

for lang in bgen enbg
do
	for model in tiny11 tiny11-nonfinetune
	do
		mkdir -p $lang.student.$model
		cd $lang.student.$model
		wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/model.npz
		wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/model.npz.decoder.yml
		wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/model.alphas.npz
		wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/model.intgemm.bin
		wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/model.intgemm.alphas.bin
                wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/lex.s2t.bin
		wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/lex.s2t.pruned.gz
		wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/vocab.bgen.spm
		cd ..
	done
done

for lang in bgen enbg
do
        for model in teacher0 teacher1
        do
                mkdir -p $lang.$model
                cd $lang.$model
                wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/model.npz
                wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/model.npz.decoder.yml
                wget -nc http://data.statmt.org/bergamot/models/bgen/$lang/$model/vocab.bgen.spm
                cd ..
        done
done

# Download testsets

wget -nc http://data.statmt.org/bergamot/models/bgen/government.bg.bg.gz
wget -nc http://data.statmt.org/bergamot/models/bgen/government.bg.en.gz
