# NMT models for Bergamot

Teacher and student NMT models are described in subdirectories.


## Instructions

1. Download and compile the latest marian-dev in the upper directory:

        bash install.sh

    The compilation requires MKL and gperftools, see [the Marian
    documentation](https://marian-nmt.github.io/docs/#installation) to find
    which packages are needed on Ubuntu.

2. Go to a subdirectory, download data and model files:

        cd eten
        bash download-data.sh
        bash download-models.sh

3. Go to a model directory and run scripts:

        cd eten.student.tiny11.corpus5b.corpus7.align
        bash eval.sh -d 0       # -d 0 means use first GPU
        bash speed.cpu.sh
        bash speed.gpu.sh -d 0
        bash align.sh           # generates alignment

    See individual scripts for details.

