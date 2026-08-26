import sys
import os

if os.path.exists(sys.argv[1]):
    constructs = os.listdir(sys.argv[1])

    cc = 0
    while cc < len(constructs):
        inp = input("Do you want to install construct: " + constructs[cc] + " [yes, no]: ").lower()

        if inp == "yes":
            cc += 1
        elif inp == "no":
            os.remove(os.path.join(sys.argv[1], constructs[cc]))
            cc += 1
        else:
            print("You have to say yes or no")
