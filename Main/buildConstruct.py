# This builds all constructs to Cron Jobs from all constructs in folder ./constructs
import os
import json
import subprocess

from RWDdata import *

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

def wasInit(cursor, db, name):
    result = cursor.execute(f"SELECT init FROM {db} WHERE name = ? LIMIT 1", (name,)).fetchone()
    if result and result[0] == 1:
        return True
    return False

def main():
    conn, cursor = getDB()
    initDBTables(cursor)
    
    constructs = os.listdir("constructs")
    writeAllConstructs(conn, cursor, constructs)

    for construct in constructs:
        with open(os.path.join(os.getcwd(), "constructs", construct), "r") as file:
            JSONconstruct = json.loads(file.read())
            #print(JSONconstruct)

            if (JSONconstruct["run"]["type"] == "never" and "initRun" in JSONconstruct and not wasInit(cursor, "constructs", construct)):
                runCommands(JSONconstruct["initRun"], getArguments(JSONconstruct, "initRun"))
                writeInit(conn, cursor, "constructs", construct)


    stopConnection(conn)

if __name__ == "__main__":
    main()
