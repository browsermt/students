from argparse import ArgumentParser
import sys
from utils import add_sentencepiece_args
from tokenizer import build_tokenizer

def parallel(tokenizer, line):
    src, tgt = line.split('\t')
    src_toks = tokenizer['src'](src)
    tgt_toks = tokenizer['tgt'](tgt)

    return '\t'.join([
        str(len(src_toks)), str(len(tgt_toks)), # Lengths
        src, tgt # Sentences
    ])

def monolingual(tokenizer, src):
    src_toks = tokenizer['src'](src)
    return '\t'.join([
        str(len(src_toks)), src
    ])


if __name__ == '__main__':
    parser = ArgumentParser(description='Print lengths of tsv parallel corpus or monolingual corpus')
    parser.add_argument('--dataset-type', type=str, required=True, choices=['parallel', 'monolingual'])
    add_sentencepiece_args(parser)

    transform_opts = {
        "parallel": parallel,
        "monolingual": monolingual
    }

    args = parser.parse_args()
    tokenizer = build_tokenizer(args)

    transform = transform_opts[args.dataset_type]

    for idx, line in enumerate(sys.stdin, 1):
        try:
            line = line.strip() # Remove trailing newline
            line = transform(tokenizer, line)
            sys.stdout.write(line + '\n')
        except:
            sys.stderr.write("Error in line {}: {}\n".format(idx, line))
        
