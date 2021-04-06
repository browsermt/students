# Norwegian Nynorsk-English NMT Systems

## Students

| system                                  |  size | BLEU | CPU(s) | GPU(s) |
| ----------------------------------------| ----- | ---- | ------ | ------ |
| teacher base beam 6                     | 200MB | 44.6 |   -    |  16.4  |
| student tiny11, beam 1                  |  49MB | 42.0 |  26.0  |   3.3  |
| student tiny11, beam 1, intgemm8        |  13MB | 41.8 |  18.0  | - |
| student tiny11, beam 1, intgemm8alphas  |  13MB | 41.7 |  17.0  | - |

Notes:
 - BLEU scores for self-crawled TED Talks test, sacreBLEU signature: BLEU+case.mixed+numrefs.1+smooth.exp+tok.13a+version.1.4.14
 - Transformer Base teacher has been trained with OpenSubtitles, JW300 and WikiMatrix data cleaned with the tools provided in this repository. All the corpora has been obtained translating the Bokmål data with Apertium nob-nno.
 - Tested with browsermt/marian-dev 1.9.36:
    - GPU: NVIDIA GeForce RTX 2080 Ti, mini-batch 64, beam 1
    - CPU: Intel(R) Core(TM) i9-9940X CPU @ 3.30GHz, single thread, mini-batch 16, beam size 1, lexical shortlist
