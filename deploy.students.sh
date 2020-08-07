#!/usr/bin/env bash

cd deen/ende.student.base

tar -czvf ende.student.base.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.deen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp ende.student.base.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/deen/

cd ../ende.student.tiny11
tar -czvf ende.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.deen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp ende.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/deen/

cd ../../eten/enet.student.tiny11

tar -czvf enet.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.eten.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp enet.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/eten/

cd ../eten.student.tiny11
tar -czvf eten.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.eten.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp eten.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/eten/

cd ../../esen/enes.student.tiny11
tar -czvf enes.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.esen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp enes.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/esen/

cd ../esen.student.tiny11
tar -czvf esen.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.esen.spm catalog-entry.yml server.intgemm8bitalpha.yml
scp esen.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/esen/
