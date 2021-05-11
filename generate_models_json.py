#!/usr/bin/env python3
'''Meant to be called on each folder to incrementally generate a bigger json'''
import os
import json
from sys import argv

def load_and_append(jsonin_path_models: str, model_dir: str, base_dir: str, url_prefix: str) -> None:
    '''Loads data from the old json file and reads some from the new model'''
    # Load existing json
    if os.path.exists(jsonin_path_models):
        infile = open(jsonin_path_models, 'r')
        current_json = json.load(infile)
        infile.close()
    else:
        current_json = {'models': []}

    # Load info from current file
    inmodel = open(model_dir + '/model_info.json', 'r')
    additional_json = json.load(inmodel)
    inmodel.close()

    # Construct URL and append it to the json
    src, trg, modeltype = additional_json["shortname"].split('-')
    if modeltype == "tiny":
        modeltype = "tiny11" # The url for the tiny model contains tiny11

    url = url_prefix + "/" + base_dir + "/" + src + trg + ".student." + modeltype + ".tar.gz"
    additional_json["url"] = url

    #include legacy namings so that we don't break the current interface
    additional_json["name"] = additional_json["modelName"]
    additional_json["code"] = additional_json["shortname"]

    # Put it in the json and regenerate it
    current_json['models'].append(additional_json)

    outfile = open(jsonin_path_models, "w")
    json.dump(current_json, outfile, indent=4)
    outfile.close()

if __name__ == '__main__':
    if len(argv) != 5:
        print("Usage:", argv[0], "models.json path-to-model-dir-containing-model_info.json, model-parent-dir, url-prefix")
    else:
        load_and_append(argv[1], argv[2], argv[3], argv[4])
