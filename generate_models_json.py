#!/usr/bin/env python3
'''Meant to be called on each folder to incrementally generate a bigger json'''
import os
import json
from hashlib import sha256
from sys import argv


def calc_checksum(hash_alg, path: str) -> str:
    '''Generate hexadecimal checksum of file.'''
    BLOCK_SIZE = 65536
    hasher = hash_alg()
    with open(path, 'rb') as fh:
        while True:
            buffer = fh.read(BLOCK_SIZE)
            if len(buffer) == 0:
                break
            hasher.update(buffer)
    return hasher.hexdigest()


def load_and_append(jsonin_path_models: str, model_archive: str, model_dir: str, base_dir: str, url_prefix: str) -> None:
    '''Loads data from the old json file and reads some from the new model'''
    # Load existing json
    if os.path.exists(jsonin_path_models):
        with open(jsonin_path_models, 'r') as infile:
            current_json = json.load(infile)
    else:
        current_json = {'models': []}

    # Load info from current file
    with open(model_dir + '/model_info.json', 'r') as fh:
        additional_json = json.load(fh)

    # Generate SHA256 hash of model archive
    additional_json["checksum"] = calc_checksum(sha256, model_archive)

    # Construct URL and append it to the json
    src, trg, modeltype = additional_json["shortName"].split('-')
    if modeltype == "tiny":
        modeltype = "tiny11" # The url for the tiny model contains tiny11

    url = url_prefix + "/" + base_dir + "/" + os.path.basename(model_archive)
    additional_json["url"] = url

    #include legacy namings so that we don't break the current interface
    additional_json["name"] = additional_json["modelName"]
    additional_json["code"] = additional_json["shortName"]

    # Put it in the json and regenerate it
    current_json['models'].append(additional_json)

    with open(jsonin_path_models, "w") as outfile:
        json.dump(current_json, outfile, indent=4)

if __name__ == '__main__':
    if len(argv) != 6:
        print("Usage:", argv[0], "models.json path-to-model-archive.tar.gz path-to-model-dir-containing-model_info.json, model-parent-dir, url-prefix")
    else:
        load_and_append(*argv[1:])
