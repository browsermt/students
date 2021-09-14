# English-German NMT systems

Teacher and student models for English-German and German-English directions.


## English-German

Evaluated on _newstest2016-2020_, cased detokenized BLEU.

| model               | wmt16 | wmt17 | wmt18 | wmt19 | wmt20 |
|---------------------|-------|-------|-------|-------|-------|
| teacher ensemble 3x | 43.0  | 35.9  | 51.8  | 46.5  | 34.2  | 
| student base        | 41.7  | 33.6  | 49.7  | 46.0  | 34.6  |
| student tiny11      | 40.4  | 32.4  | 48.5  | 45.0  | 33.5  |


Evaluated on _newstest2019_, which consists of 1,997 sentences.

| system                                   | size (MB) | BLEU | CPU (sec) | GPU (sec) |
|------------------------------------------|-----------|------|-----------|-----------|
| teacher ensemble 3x                      | 3x ~800MB | 46.5 |     --    |      42.3 |
| student base, beam 1                     |     163MB | 46.0 |     145.8 |       3.3 |
| student base, beam 1, packed8avx512      |      89MB | 45.9 |      77.9 |       --  |
| student base, beam 1, intgemm8           |      42MB | 45.8 |     104.9 |       --  |
| student base, beam 1, intgemm8alphas     |      41MB | 45.7 |      79.8 |       --  |
| student tiny11, beam 1                   |      65MB | 45.0 |      53.1 |       3.0 |
| student tiny11, beam 1, packed8avx512    |      46MB | 45.0 |      32.5 |       --  |
| student tiny11, beam 1, intgemm8         |      17MB | 44.8 |      46.3 |       --  |
| student tiny11, beam 1, intgemm8alphas   |      17MB | 44.7 |      31.8 |       --  |


Teacher is the efficiency task submission, a 3x ensemble of
/fs/meili0/heafield/matching/en-de/models.teacher/{en-de\_1,en-de\_3,uli}/tuneoldwmt-split/model.npz.best-translation.npz
with --normalize 1.2


## German-English 

Evaluated on _newstest2016-2020_, cased detokenized BLEU.

| model               | wmt16 | wmt17 | wmt18 | wmt19 | wmt20 |
|---------------------|-------|-------|-------|-------|-------|
| teacher ensemble 4x | 45.9  | 40.7  | 48.9  | 43.6  | 31.9  |
| student base        | 42.6  | 37.6  | 46.4  | 41.9  | 33.1  |
| student tiny11      | 40.4  | 35.6  | 44.2  | 40.1  | 30.7  |


Evaluated on _newstest2019_, which consists of 1,997 sentences.

| system                                   | size (MB) | BLEU | CPU (sec) | GPU (sec) |
|------------------------------------------|-----------|------|-----------|-----------|
| teacher ensemble 4x                      | 4x ~800MB | 43.6 |      --   |     58.7  |
| student base, beam 1                     |      89MB | 41.9 |      96.0 |      3.2  |
| student base, beam 1, packed8avx512      |      89MB | 41.9 |      53.5 |      --   |
| student base, beam 1, intgemm8           |      42MB | 41.8 |      72.0 |      --   |
| student base, beam 1, intgemm8alphas     |      41MB | 41.5 |      55.5 |      --   |
| student tiny11, beam 1                   |      65MB | 40.1 |      46.9 |      2.9  |
| student tiny11, beam 1, packed8avx512    |      46MB | 40.0 |      22.1 |      --   |
| student tiny11, beam 1, intgemm8         |      17MB | 39.2 |      19.2 |      --   |
| student tiny11, beam 1, intgemm8alphas   |      17MB | 39.3 |      21.4 |      --   |


Teacher is the efficiency task submission, a 4x ensemble of
/fs/meili0/heafield/matching/de-en/models.teacher/{uli,de-en\_4,de-en\_1,enc8-continue}/tuneorigwmt-split/model.npz.best-translation.npz 
with --normalize 0.8


## Notes:

* Evaluated using SacreBLEU: 
  BLEU+case.mixed+lang.de-en+numrefs.1+smooth.exp+test.wmt19+tok.13a+version.2.0.0
* Student 'tiny11' is a small transformer: 256 emb., 1536 FFN, 6-layer encoder,
  2-layer decoder (not tied) with SSRU units.
* Student 'base' is a small transformer: 512 emb., 2048 FFN, 6-layer encoder,
  2-layer decoder (not tied) with SSRU units.
* Trained on teacher-generated parallel data (back+forward translations) 
  with guided alignments.
* Tested with [marian-dev browser-mt](https://github.com/browsermt/marian-dev.git) (on surtr):
  * commit: dad4d507913a9bae995b0b51b6481259e33bc30f
  * built with -DUSE\_FBGEMM=on
  * GPU: NVIDIA GeForce RTX 3090
    mini-batch 32, beam size 1
  * CPU: AMD EPYC 7282 16-Core Processor @ 3.2GHz, single thread
    mini-batch 32, beam size 1, lexical shortlist

