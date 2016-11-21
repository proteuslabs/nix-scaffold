#!/usr/bin/env python

import argparse
import os
import sys
import json

from subprocess import Popen, PIPE

dir_path = os.path.dirname(os.path.realpath(__file__))

parser = argparse.ArgumentParser(description="nix-scaffold")
parser.add_argument('path',
        help='path to a template to use for scaffolding')
parser.add_argument('-A', '--attribute',
        help='template attribute to build',
        default="")
parser.add_argument('-a', '--arg',
        help='define argument',
        nargs='?', action='append')

args = parser.parse_args()

p = Popen(
    [
        "nix-build", "--no-out-link",
        os.path.join(dir_path, 'default.nix'),
        "-A", "options",
        "--arg", "template", os.path.abspath(args.path),
        "--argstr", "templateAttr", args.attribute
    ],
    stdin=PIPE, stdout=PIPE, stderr=PIPE,
    bufsize = -1
)
output, error = p.communicate()

if p.returncode != 0:
    print "Error getting options:"
    print error
    sys.exit(1)

optionsFile = output.strip()

with open(optionsFile, 'r') as f:
    options = json.loads(f.read())

values = {}

passedArgs = dict((arg.split('=')[0], arg.split('=')[1]) for arg in args.arg or
        [])

print "Input arguments for template:"
for option in filter(
    lambda option: option["name"].startswith('arguments'), options
):
    if option["name"] in passedArgs:
        value = passedArgs[option["name"]]
    else:
        while True:
            sys.stdout.write("[%s:%s] - %s%s:" %(
                option["name"], option["type"],
                option["description"],
                " (default: %s)" %(option["default"],)
                    if "default" in option
                    else ''
            ))
            value = raw_input(' ')

            if not value:
                if "default" in option:
                    value = option["default"]
                else:
                    print "Option %s must have a value" %(option["name"],)
                    continue

            break

    if option["type"] == 'string':
        pass
    elif option["type"] == 'integer':
        value = int(value)
    elif option["type"] == 'attribute set':
        value = json.loads(value)
    else:
        raise Exception('%s type not supported' %(option["type"],))

    values[option['name']] = value

print values
