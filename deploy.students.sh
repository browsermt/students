#!/usr/bin/env bash

cd deen/ende.student.base

tar -czvf ende.student.base.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.deen.spm
scp ende.student.base.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/deen/

cd ../ende.student.tiny11
tar -czvf ende.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.deen.spm
scp ende.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/deen/

cd ../../eten/enet.student.tiny11

tar -czvf enet.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.eten.spm
scp enet.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/eten/

cd ../eten.student.tiny11
tar -czvf eten.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.eten.spm
scp eten.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/eten/

cd ../../esen/enes.student.tiny11
tar -czvf enes.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.esen.spm
scp enes.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/esen/

cd ../esen.student.tiny11
tar -czvf esen.student.tiny11.tar.gz config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz vocab.esen.spm
scp esen.student.tiny11.tar.gz s1031254@magni.inf.ed.ac.uk:/mnt/vali0/www/data.statmt.org/bergamot/models/esen/
