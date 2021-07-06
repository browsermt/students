# English-Farsi NMT Systems

## BLEU scores

| system                                  |  size | valid|test2012|test2013|
| ----------------------------------------| ----- | ---- | ------ | ------ |
| teacher base beam 6                     | 236MB | 14.2 |   13.6 |  12.0  |
| student tiny11, beam 1                  |  65MB | 13.1 |   11.8 |  10.8  |
| student tiny11, beam 1, intgemm8        |  17MB | 12.9 |   11.7 |  10.9  |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 13.2 |   12.0 |  10.8  |

Notes: 
 - valid (test2011) and test sets are from IWSLT
 - SacreBLEU signature: BLEU+case.mixed+numrefs.1+smooth.exp+tok.13a+version.1.5.1
