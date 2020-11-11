# Icelandic-English NMT Systems

## Students

| system                                  |  size | BLEU | CPU(s) | GPU(s) |
| ----------------------------------------| ----- | ---- | ------ | ------ |
| teacher base beam 6                     | 232MB | 25.6 |   -    |  7.56  |
| student tiny11, beam 1                  |  65MB | 23.6 |  10.8  |  0.89  |
| student tiny11, beam 1, intgemm8        |  17MB | 23.4 |   4.3  | - |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 23.7 |   4.1  | - |

Notes: 
 - BLEU scores for self-crawled TED Talks test, sacreBLEU signature: BLEU+case.mixed+numrefs.1+smooth.exp+tok.13a+version.1.4.14
 - Transformer Base teacher has been trained with ParIce, EUBookshop, JW300 and WikiMatrix bilingual corpora data cleaned with the tools provided in this repository.
 - Transformer Tiny student has also translated monolingual data from Althingi and Sedlabanki datasets from ELRC-Share.
 - Tested with browsermt/marian-dev 1.9.36:
    - GPU: NVIDIA GeForce RTX 2080 Ti, mini-batch 64, beam 1
    - CPU: Intel(R) Core(TM) i9-9940X CPU @ 3.30GHz, single thread, mini-batch 16, beam size 1, lexical shortlist
