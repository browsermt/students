# NMT models for Bergamot

Teacher and student NMT models are described in subdirectories. We have
prepared models for the following language pairs:

- Estonian-English
- English-Estonian
- Spanish-English
- English-Spanish
- English-German


## Instructions

1. Download and compile the latest marian-dev in the upper directory:

        bash install.sh

    The compilation requires MKL and gperftools, see [the Marian
    documentation](https://marian-nmt.github.io/docs/#installation) to find
    which packages are needed on Ubuntu.

2. Go to a subdirectory, download data and model files, e.g.:

        cd eten
        bash download-data.sh
        bash download-models.sh

    See _README_ file for more details.

3. Go to a model directory and run the evaluation script, e.g.:

        cd eten.student.tiny11
        bash eval.sh -d 0       # -d 0 means use first GPU

    or benchmarking scripts:

        bash speed.gpu.sh -d 0
        bash speed.cpu.sh
        bash speed.cpu.packed8.sh   # requires CPU with avx2

    See individual scripts for details.

