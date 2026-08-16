# This builds all constructs to Cron Jobs from all constructs in folder ./constructs
import os
import json
import subprocess
import getpass

from RWDdata import *

global constructs

def runCommands(commands, inputs = []):
    canUser = True
    try:
        import userdata # pyright: ignore[reportMissingImports]
    except:
        print("File 'userdata.py' wasn't found, user can't be used!")
        canUser = False
    os.chdir("constructs")
    for com in commands:
        counter = 1
        for input in inputs:
            com = com.replace(f"${counter}", input)
            counter += 1
        if canUser:
            com = com.replace("$usr", userdata.getUserName())

        #subprocess.run(f"bash -c 'echo {com}'", shell=True, check=True)
        subprocess.run(com, shell=True)

    os.chdir("..")

def getArguments(con, argObj):
    inputs = []

    if argObj not in con['data']:
        return []

    for ask in con['data'][argObj]['arguments']:
        if ask['isNecesarry']:
            inp = ""
            while (inp == "" or len(inp) == 0):
                inp = input(f"The construct want to have input for '{ask['name']}' with description '{ask['comment']}' of type '{ask['type']}': ")
            inputs.append(inp)
        elif not ask['isNecesarry']:
            inp = input(f"The construct want to have input for '{ask['name']}' with description '{ask['comment']}' of type '{ask['type']}' with default value '{ask['defaultValue']}': ")

            if len(inp) == 0:
                inp = ask['defaultValue']

            inputs.append(inp)

    return inputs

def wasInit(cursor, db, name):
    result = cursor.execute(f"SELECT init FROM {db} WHERE name = ? LIMIT 1", (name,)).fetchone()
    if result and result[0] == 1:
        return True
    return False

def doWork(type, constructName):
    try:
        with open(os.path.join(os.getcwd(), "constructs", constructName + ".json"), "r") as file:
            try:
                JSONconstruct = json.loads(file.read())
            except:
                print("Aborting, incorrect file.")
    except FileNotFoundError:
        if os.getcwd() != "/home/" + getpass.getuser() + "/ServerData":
            try:
                os.chdir("/home/" + getpass.getuser() + "/ServerData")
                doWork(type, constructName)
            except:
                print("Aborting, could not find the file. Check current dir?")

def constructBuilder(arg=""):
    conn, cursor = getDB()
    initDBTables(cursor)
    
    constructs = os.listdir("constructs")
    writeAllConstructs(conn, cursor, constructs)

    for construct in constructs:
        with open(os.path.join(os.getcwd(), "constructs", construct), "r") as file:
            if file.name.split(".")[1] != "json":
                continue
            JSONconstruct = json.loads(file.read())
            #print(JSONconstruct)

            if ("initRun" in JSONconstruct and not wasInit(cursor, "constructs", construct)):
                runCommands(JSONconstruct['initRun'], getArguments(JSONconstruct, "initRun"))
                writeInit(conn, cursor, "constructs", construct)

            if (JSONconstruct['run']['type'] == "boot" and arg == "boot"):
                #Boot can't require arguments!
                runCommands(JSONconstruct['boot'], [])

    stopConnection(conn)

if __name__ == "__main__":
    constructBuilder()
