# Farsi-English NMT Systems

## BLEU scores

| system                                  |  size | valid|test2012|test2013|
| ----------------------------------------| ----- | ---- | ------ | ------ |
| teacher base 4x beam 6 b6 n1            | 236MB | 32.6 |   31.1 |  34.4  |
| student tiny11, beam 1                  |  65MB | 29.9 |   25.3 |  27.9  |
| student tiny11, beam 1, intgemm8        |  17MB | 29.7 |   25.1 |  27.5  |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 29.8 |   25.1 |  27.7  |

Notes: 
 - valid (test2011) and test sets are from IWSLT
 - SacreBLEU signature: BLEU+case.mixed+numrefs.1+smooth.exp+tok.13a+version.1.5.1
