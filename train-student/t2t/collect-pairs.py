from argparse import ArgumentParser
import warnings

class ParallelWriter:
    def __init__(self, prefix, src_lang, tgt_lang):
        self.prefix = prefix
        self.src_lang = src_lang
        self.tgt_lang = tgt_lang

        def open_file(prefix, lang):
            fpath = '{}.{}'.format(prefix, lang)
            return open(fpath, 'w+')

        self.src_file = open_file(prefix, src_lang)
        self.tgt_file = open_file(prefix, tgt_lang)
    
    def __enter__(self):
        return self
    
    def add(self, src, tgt):
        self.src_file.write(src + '\n')
        self.tgt_file.write(tgt + '\n')
    
    def __exit__(self, *args, **kwargs):
        self.src_file.close()
        self.tgt_file.close()

    def add_nbest(self, src, nbest):
        for tgt in nbest:
            self.add(src, tgt)


def main(args):
    prefix = '{}.t2tproc'.format(args.source)
    with open(args.source) as source_lines,                             \
         open(args.t2t_output) as generated_outputs,                    \
         ParallelWriter(prefix, args.src_lang, args.tgt_lang) as writer:

        for source, generated_output in zip(source_lines, generated_outputs):
            nbest = generated_output.split('\t')
            if args.nbest != -1:
                assert len(nbest) == args.nbest, "nbest does not seem matching, please inspect."
            writer.add_nbest(source, nbest)



if __name__ == '__main__':
    parser = ArgumentParser(description='Utility to generate parallel data from tensor2tensor translation outputs') 
    parser.add_argument('--source', type=str, required=True, help='Path to source data used for t2t-decoder')
    parser.add_argument('--src-lang', type=str, required=True, help='Source language')
    parser.add_argument('--tgt-lang', type=str, required=True, help='Target language')
    parser.add_argument('--t2t-output', type=str, required=True, help='Path to t2t-decoder output file')
    parser.add_argument('--nbest', type=int, required=False, default=-1, help='nbest used for T2T decoding')

    args = parser.parse_args()
    main(args)
