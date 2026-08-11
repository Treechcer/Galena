import os
import sys

os.chdir(os.path.dirname(sys.argv[0])) if sys.argv[0] != os.path.basename(__file__) else None

for i in range(1, 5):

    inp=""
    while inp != "yes" and inp != "no":
        inp = input(f"Do you want to init node{i}? [yes, no]: ").lower()

    with open(f"node{i}.sh", "w") as f:
        value = 1 if inp == "yes" else 0

        code = f"""#!/bin/bash
get_node_num(){{
    node{i}={value}
    echo "$node{i}"
}}
"""

        f.write(code)
