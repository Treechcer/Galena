import os
import sys

os.chdir(os.path.dirname(sys.argv[0]))

for i in range(1, 5):

    inp=""
    while inp != "yes" and inp != "no":
        inp = input(f"Do you want to init node{i}? [yes, no]: ").lower()

    with open(f"node{i}.sh", "w") as f:
        if inp == "yes":
            f.write(f'#!/bin/bash\nnode{i}=1\necho "$node{i}"')
        else:
            f.write(f'#!/bin/bash\nnode{i}=0\necho "$node{i}"')