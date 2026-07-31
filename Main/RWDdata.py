import os
import getpass
import json

def construct(name, init, run):
    return {"name" : name, "init" : init, "run" :run}

def main():
    homeDir = (os.path.join("/home/", getpass.getuser()) + "/")
    saveFile = os.path.join(homeDir, ".Galeta.json")
    if not os.path.exists(saveFile):
        with open(saveFile, "a") as f:
            pass

    consJSON = []
    with open(saveFile, "a+") as f:
        oldData = json.loads(f.read())
        for cons in os.listdir("constructs"):
            if not cons in oldData:
                consJSON.append(construct(cons, 0, "-----"))

        f.write(json.dumps(consJSON))
            

if __name__ == "__main__":
    main()