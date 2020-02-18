# Estonian-English NMT systems

Teacher and student models for Estonian.


## Teachers

_newstest2018_, cased BLEU

| system | et-en | en-et | comment |
|--------|-------|-------|---------|
| [NICT WMT18](http://www.statmt.org/wmt18/pdf/WMT046.pdf)      | 30.7  | 25.2  | SMT+NMT
| [Tilde WMT18](http://www.statmt.org/wmt18/pdf/WMT050.pdf)     | 29.46 | 23.57 |
| [Edinburgh WMT18](http://www.statmt.org/wmt18/pdf/WMT039.pdf) | 29.4  | 22.7  | Ens. of RNNs and transformers
||||
| transformer-big fine-tuned #1                                 | 34.4  | 27.2  |
| transformer-big fine-tuned #2                                 | 34.5  | 27.0  |
| + ensemble x2 (teacher)                                       | 34.7  | 27.5  | WMT18 constrained system


Notes:

* BLEU scores for Estonian newstest2018 from sacreBLEU:
  BLEU+case.mixed+lang.en-et+numrefs.1+smooth.exp+test.wmt18+tok.13a+version.1.4.2
* A transformer-big model has been trained on 80M/100M back-translations
  (en-et/et-en respectively), then fine-tuned on 1M cleaned WMT18 parallel data.
  It's a constrained WMT18 system.


## Students


### Estonian-English

| system | size (MB) | wmt18 (BLEU) | speed CPU (sec) | speed GPU |
|--------|----------:|--------------|-----------------|-----------|
| teacher ensemble x2, beam 4         | 2x 798MB | 34.7  | --  | 110s |
| student tiny11, beam 1              |     65MB | 31.9  | 37s | 2.3s |
| student tiny11, beam 1, packed8avx2 |     46MB | 31.4  | 33s | --   |


### English-Estonian

| system | size (MB) | wmt18 (BLEU) | speed CPU (sec) | speed GPU |
|--------|----------:|--------------|-----------------|-----------|
| teacher ensemble x2, beam 4         | 2x 798MB | 27.5  | --  | 116s |
| student tiny11, beam 1              |     65MB | 25.7  | 39s | 3.0s |
| student tiny11, beam 1, packed8avx2 |     46MB | 25.6  | 37s | --   |


Notes:

* Students are tiny transformers: 256 emb., 1536 FFN, 6-layer encoder, 2-layer
  decoder (not tied) with SSRU units (tiny11).
* Trained on teacher-generated parallel data, back- and forward-translations,
  with guided alignments.
* Evaluated on newstest2018, which consists of 2,000 sentences (ca. 40k English
  tokens and 30k Estonian tokens).
* Tested with marian-dev v1.8.40 compiled with FBGEMM (on elli):
  * CPU: Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.10GHz (avx2), single thread,
    mini-batch 32, beam size 1, lexical shortlist
  * GPU: GeForce GTX 1080 Ti, mini-batch 64, beam size 1

