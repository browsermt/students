# Catalan-English NMT Systems

## Students

| system                                  |  size | BLEU | COMET | CPU(s) | GPU(s) |
| ----------------------------------------| ----- | ---- | ----- | ------ | ------ |
| opusmt teacher big cat+oci+eng beam 6   | 887MB | 45.4 | 0.770 |  -   |  16.86  |
| student tiny11, beam 1                  |  65MB | 43.0 | 0.721 |  9.3  |  1.57  |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 43.1 | 0.720 |  5.7  | - |

Notes:
 - BLEU scores for Flores200 devtest, sacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
 - Teacher [Tatoeba-MT-models/cat+oci+spa-eng/opusTCv20210807+bt_transformer-big_2022-03-13](https://opus.nlpl.eu/leaderboard/index.php?model1=unknown&model2=unknown&test=all&scoreslang=all&model=Tatoeba-MT-models%2Fcat%2Boci%2Bspa-eng%2FopusTCv20210807%2Bbt_transformer-big_2022-03-13&src=cat&trg=eng&start=0&end=9&pkg=opusmt). Download [zip](https://object.pouta.csc.fi/OPUS-MT-leaderboard/models/Tatoeba-MT-models/cat+oci+spa-eng/opusTCv20210807+bt_transformer-big_2022-03-13.eval.zip)
 - Tested with browsermt/marian-dev 1.10.24:
    - GPU: NVIDIA GeForce RTX 2080 Ti, mini-batch 64, beam 1
    - CPU: Intel(R) Core(TM) i9-9940X CPU @ 3.30GHz, single thread, mini-batch 16, beam size 1, lexical shortlist
