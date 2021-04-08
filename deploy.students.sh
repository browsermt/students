#!/usr/bin/env bash

set -e

echo "Deploying deen..."
cd deen/ende.student.base

tar -czvf ende.student.base.tar.gz --transform 's,^,ende.student.base/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.deen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp ende.student.base.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/deen/

echo "Deploying ende..."
cd ../ende.student.tiny11
tar -czvf ende.student.tiny11.tar.gz --transform 's,^,ende.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.deen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp ende.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/deen/

echo "Deploying enet..."
cd ../../eten/enet.student.tiny11

tar -czvf enet.student.tiny11.tar.gz --transform 's,^,enet.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.eten.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp enet.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/eten/

echo "Deploying eten..."
cd ../eten.student.tiny11
tar -czvf eten.student.tiny11.tar.gz --transform 's,^,eten.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.eten.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp eten.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/eten/

echo "Deploying enes..."
cd ../../esen/enes.student.tiny11
tar -czvf enes.student.tiny11.tar.gz --transform 's,^,enes.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.esen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp enes.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/esen/

echo "Deploying esen..."
cd ../esen.student.tiny11
tar -czvf esen.student.tiny11.tar.gz --transform 's,^,esen.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.esen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp esen.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/esen/

echo "Deploying isen..."
cd ../../isen/isen.student.tiny11
tar -czvf isen.student.tiny11.tar.gz --transform 's,^,isen.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.isen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp isen.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/isen/

echo "Deploying nben..."
cd ../../nben/nben.student.tiny11
cp ../nben.teacher.base/vocab.nben.spm ./
tar -czvf nben.student.tiny11.tar.gz --transform 's,^,nben.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.nben.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp nben.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/nben/

echo "Deploying nnen..."
cd ../../nnen/nnen.student.tiny11
cp ../nnen.teacher.base/vocab.nnen.spm ./
tar -czvf nnen.student.tiny11.tar.gz --transform 's,^,nnen.student.tiny11/,' config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.nnen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp nnen.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/nnen/

echo "Deploying csen base..."
cd ../../csen/csen.student.base
tar -czvf csen.student.base.tar.gz --transform 's,^,csen.student.base/,' config.intgemm8bitalpha.yml model.8bit-finetuned.intgemm8.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp csen.student.base.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/csen/

echo "Deploying csen tiny..."
cd ../csen.student.tiny11
tar -czvf csen.student.tiny11.tar.gz --transform 's,^,csen.student.tiny11/,' config.intgemm8bitalpha.yml model.8bit-finetuned.intgemm8.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp csen.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/csen/

echo "Deploying encs base..."
cd ../encs.student.base
tar -czvf encs.student.base.tar.gz --transform 's,^,encs.student.base/,' config.intgemm8bitalpha.yml model.8bit-finetuned.intgemm8.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp encs.student.base.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/csen/

echo "Deploying encs tiny..."
cd ../encs.student.tiny11
tar -czvf encs.student.tiny11.tar.gz --transform 's,^,encs.student.tiny11/,' config.intgemm8bitalpha.yml model.8bit-finetuned.intgemm8.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp encs.student.tiny11.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/csen/
