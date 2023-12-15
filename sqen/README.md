# Albanian-English models

## BLEU scores

| system                                  |  size | flores200 | neulab TED test |
| ----------------------------------------| ----- | ---- | ---- |
| teacher base beam 6                     | 236MB | 33.6 | 51.7 |
| student tiny11, beam 1                  |  65MB | 26.1 | 45.3 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 26.0 | 43.8 |

Notes:
 - SacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
 - Flores200 test set is Tosk Albanian, neulab talks does not specify the dialect.
