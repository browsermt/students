import argparse
import json
import struct
from collections import namedtuple

# magic(uint64_t), lrParametersDims(uint64_t)
Header_fmt = "<1Q1Q"
Header_len = struct.calcsize(Header_fmt)

QE_MAGIC_NUMBER = 8704388732126802304


def from_qe_file(file):
    magic, paramDim = struct.unpack(Header_fmt, file.read(Header_len))

    if magic != QE_MAGIC_NUMBER:
        print("Invalid quality estimator file.")
        exit(1)

    # scale_[N] + mean_[N] + coef_[N] + intercept_
    lrParams_fmt = f"<{3*paramDim+1}f"

    lrParams_size = struct.calcsize(lrParams_fmt)

    params = list(struct.unpack(lrParams_fmt, file.read(lrParams_size)))

    lrParams = {}
    lrParams["scale_"] = params[:paramDim]
    lrParams["mean_"] = params[paramDim : 2 * paramDim]
    lrParams["coef_"] = params[2 * paramDim : 3 * paramDim]
    lrParams["intercept_"] = params[3 * paramDim]

    return lrParams


def to_binary(lrParams):

    paramDims = len(lrParams["scale_"])

    if paramDims != len(lrParams["mean_"]) and paramDims != len(
        lrParams["coef_"]
    ):
        print("Invalid LR parameters.")
        exit(1)

    lrParams_fmt = f"<{3*paramDims+1}f"

    params = (
        lrParams["scale_"]
        + lrParams["mean_"]
        + lrParams["coef_"]
        + [lrParams["intercept_"]]
    )

    return struct.pack(Header_fmt, QE_MAGIC_NUMBER, paramDims) + struct.pack(
        lrParams_fmt, *params
    )


parser = argparse.ArgumentParser(description="Read and write quality estimator files.")
parser.add_argument(
    "--to_json", type=argparse.FileType("rb"), help="Read quality estimator file"
)
parser.add_argument(
    "--from_json",
    type=argparse.FileType("r"),
    help="Read json file and generate quality estimator binary",
)
parser.add_argument(
    "--out",
    type=argparse.FileType("wb"),
    help="Output generated data from to_json or from_json option",
)

args = parser.parse_args()

output = None

if args.to_json:
    output = json.dumps(from_qe_file(args.to_json), indent=3)
elif args.from_json:
    output = to_binary(json.loads(args.from_json.read()))

if output is None:
    exit(0)

if args.out:
    args.out.write(output.encode("UTF-8") if type(output) is str else output)
    args.out.close()
else:
    print(output)
