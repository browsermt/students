# Slovene-English NMT Systems

## Students

| system                                  |  size | BLEU |
| ----------------------------------------| ----- | ---- |
| opusmt teacher big gmqeng beam 6        | 232MB | 31.8 |
| student tiny11, beam 1                  |  65MB | 28.3 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 28.8 |

Notes:
 - BLEU scores for WMT21 test, sacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
