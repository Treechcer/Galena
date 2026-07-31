# This builds all constructs to Cron Jobs from all constructs in folder ./constructs
import os
import json
import subprocess

global constructs

def runCommands(commands, inputs = []):
    for com in commands:
        counter = 1
        for input in inputs:
            com = com.replace(f"${counter}", input)
            counter += 1

        print(com)
        subprocess.run(com, shell=True)

def getArguments(con, argObj):
    inputs = []
    for ask in con["data"][argObj]["arguments"]:
        if ask["isNecesarry"]:
            inputs.append(input(f"The construct want to have input for '{ask["name"]}' with description '{ask["comment"]}' of type '{ask["type"]}': "))
        elif not ask["isNecesarry"]:
            inp = input(f"The construct want to have input for '{ask["name"]}' with description '{ask["comment"]}' of type '{ask["type"]}' with default value '{ask["defaultValue"]}': ")

            if len(inp) == 0:
                inp = ask["defaultValue"]

            inputs.append(inp)

    return inputs

def main():
    constructs = os.listdir("constructs")

    for construct in constructs:
        with open(os.path.join(os.getcwd(), "constructs", construct), "r") as file:
            JSONconstruct = json.loads(file.read())
            #print(JSONconstruct)

            if (JSONconstruct["run"]["type"] == "never" and "initRun" in JSONconstruct):
                runCommands(JSONconstruct["initRun"], getArguments(JSONconstruct, "initRun"))

if __name__ == "__main__":
    main()