#!/usr/bin/env python3

"""Convertor from yaml to json

This script allows to convert an input yaml
file into a json format file.

This script require two arguments, the input
file and the output file.
"""

import argparse
import json
import sys
import yaml

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert YAML to JSON")
    parser.add_argument("infile", type=argparse.FileType(mode="r", encoding="utf-8"))
    parser.add_argument("outfile", type=argparse.FileType(mode="w", encoding="utf-8"))

    try:
        args = parser.parse_args()
        data = yaml.safe_load(args.infile)
        json.dump(data, args.outfile, indent="  ")
    except Exception as ex:
        print(ex)
        exit(1)
