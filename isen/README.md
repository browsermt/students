# Icelandic-English NMT Systems

## Students

| system                                  |  size | BLEU | COMET | CPU(s) | GPU(s) |
| ----------------------------------------| ----- | ---- | ----- | ------ | ------ |
| opusmt teacher big gmqeng beam 6        | 887MB | 34.4 | 57.8 |  -   |  14.07  |
| student base, beam 1                    | 163MB | 33.8 | 57.7 |  -    |  2.06  |
| student base, beam 1, intgemm8alphas    |  42MB | 33.8 | 57.9 | 12.0  | - |
| student tiny11, beam 1                  |  65MB | 32.7 | 57.9 |  9.3  |  1.11  |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 32.4 | 56.8 |  5.2  | - |

Notes:
 - BLEU scores for WMT21 test, sacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
 - Teacher [Tatoeba-MT-models/gmq-eng/opusTCv20210807+bt\_transformer-big\_2022-03-09](https://opus.nlpl.eu/leaderboard/index.php?pkg=Tatoeba-MT-models&test=all&scoreslang=isl-eng&model=gmq-eng%2FopusTCv20210807%2Bbt_transformer-big_2022-03-09&src=isl&trg=eng&start=0&end=9&modelsource=scores). Download [zip](https://object.pouta.csc.fi/Tatoeba-MT-models/gmq-eng/opusTCv20210807+bt_transformer-big_2022-03-09.zip)
 - Transformer tiny and base students distilled using ParIce, EUBookshop, OpenSubstitles, CCMatrix, WikiMatrix, QED, bible-uedin, CCAligned and ELRC\*. Also translated monolingual data from Althingi and Sedlabanki datasets from ELRC-Share. Vocabulary is not shared with teacher, it is trained on distilled data.
 - Tested with browsermt/marian-dev 1.10.24:
    - GPU: NVIDIA GeForce RTX 2080 Ti, mini-batch 64, beam 1
    - CPU: Intel(R) Core(TM) i9-9940X CPU @ 3.30GHz, single thread, mini-batch 16, beam size 1, lexical shortlist
