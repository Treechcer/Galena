#This is the main file. 
#This will be used as:
#       - When boots, it signals to app signal to boot (if construct defines one)
#       - Will be able to remove constructs (if construct has it defined)
#       - Will be able to restart constructs (if defined)
#       - Will be able to reinstall constructs (if install and unistall are defined)
#       - Will be able to reboot constructs

import sys
import os
from buildConstruct import constructBuilder, doWork

def main():
    if len(sys.argv) <= 1:
        print("You have to parse some argument for manager to do stuff.")
        exit(1)

    os.chdir(os.path.dirname(sys.argv[0]))

    if len(sys.argv) >= 3:
        if sys.argv[1] == "restart":
            doWork(sys.argv[1], sys.argv[2])
        else:
            print(f"incorrect call of {sys.argv[1]} with apram {sys.argv[2]}")
    else:
        constructBuilder(sys.argv[1])

    

if __name__ == "__main__":
    main()