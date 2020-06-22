# English-German NMT systems

Teacher and student models for German.
Only the English-German direction due to the availability of the En-De teacher.


## Teachers

_newstest2016-2019_, cased BLEU

| model              | wmt16 | wmt17 | wmt18 | wmt19 |
|--------------------|-------|-------|-------|-------|
| teacher esemble x4 | 42.5  | 35.0  | 50.7  | 42.5  |
| student base       | 40.1  | 33.0  | 48.4  | 42.5  |
| student tiny11     | 39.0  | 31.5  | 46.4  | 42.1  |

Notes:

* We used the sentence-level English-German system from Microsoft’s constrained
  submission to the WMT’19 News Translation Task as a teacher system
  ([Junczys-Dowmunt, 2019](https://www.aclweb.org/anthology/W19-5321.pdf)).
  It is the (4×c) configuration in Table 2 from the original paper.
* BLEU scores for German newstest2019 from sacreBLEU, e.g.:
  BLEU+case.mixed+lang.en-de+numrefs.1+smooth.exp+test.wmt19+tok.13a+version.1.4.7


## Students


### English-German

| system                                   | size (MB) | BLEU | CPU (sec) | GPU (sec) |
|------------------------------------------|----------:|------|-----------|-----------|
| teacher ensemble x4, beam 4              | 4x 1.5GB | 42.5 | --   | ~400s |
| student base, beam 1                     |    149MB | 42.5 | 48.1 | 3.5s |
| student base, beam 1, packed8avx512      |     46MB | 42.5 | 31.9 | --   |
| student base, beam 1, intgemm8           |     38MB | 42.4 | 25.0 | --   |
| student base, beam 1, intgemm8alphas     |     38MB | 42.5 | 23.0 | --   |
| student tiny11, beam 1                   |     65MB | 42.1 | 20.0 | 2.9s |
| student tiny11, beam 1, packed8avx512    |     46MB | 41.8 | 15.2 | --   |
| student tiny11, beam 1, intgemm8         |     17MB | 41.7 | 13.0 | --   |
| student tiny11, beam 1, intgemm8alphas   |     17MB | 41.8 | 12.3 | --   |


Notes:

* Student 'tiny11' is a small transformer: 256 emb., 1536 FFN, 6-layer encoder,
  2-layer decoder (not tied) with SSRU units.
* Student 'base' is a small transformer: 512 emb., 2048 FFN, 6-layer encoder,
  2-layer decoder (not tied) with SSRU units.
* Trained on teacher-generated parallel data (no back-translations) with guided
  alignments.
* Evaluated on newstest2019, which consists of 1,997 sentences.
* Tested with marian-dev v1.9.10 compiled with FBGEMM (on elli):
  * GPU: GeForce GTX 1080 Ti, mini-batch 64, beam size 1
* Tested with marian-dev branch intgemm-reintegrated-computestats compiled with FBGEMM (on var):
  * CPU: Intel(R) Xeon(R) Gold 6248 CPU @ 2.50GHz (avx512vnni), single thread,
    mini-batch 32, beam size 1, lexical shortlist

