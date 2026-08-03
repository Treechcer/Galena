import os
import getpass
import sqlite3
import json

class column:
    def __init__(self):
        self.column = []
        self.data = []
        self.types = []

    def addData(self, column, data, types):
        self.column.append(column)
        self.data.append(data)
        self.types.append(types)

    def getDataForQuery(self):
        column = "("

        for col in self.column:
            column += col + ", "

        column = column[:-2]
        column += ")"

        data = "("

        dat = self.data

        for integ in range(len(self.data)):
            if self.types[integ] == "INTEGER":
                data += str(dat[integ]) + ", "
            elif self.types[integ] == "TEXT":
                data += "'" + str(dat[integ]) + "', "

        data = data[:-2]
        data += ")"

        return column, data

def initDBTables(cursor):
    cursor.execute("""CREATE TABLE IF NOT EXISTS constructs(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    init INTEGER,
    runType TEXT)""")

def getDirectory():
    return (os.path.join("/home/", getpass.getuser()) + "/")

def getDBFile():
    return os.path.join(getDirectory(), ".Galeta.db")

def getDB():
    dbFile = getDBFile()

    #init DB
    conn = sqlite3.connect(dbFile)
    cursor = conn.cursor()

    return conn, cursor

def getDataByCondition(cursor, db, condition, data):
    return cursor.execute(f"SELECT * FROM {db} WHERE {condition} = ? LIMIT 1", (data,)).fetchone() is not None

def getData(cursor, db):
    return cursor.execute(f"SELECT * FROM {db}").fetchall()

def addData(connection, cursor, db, column, data):
    cursor.execute(f"INSERT INTO {db} ({column}) VALUES ({data})")
    connection.commit()

def writeInit(connection, cursor, db, name):
    cursor.execute(f"UPDATE {db} SET init = 1 WHERE name = ?", (name,))
    connection.commit()

def writeAllConstructs(connection, cursor, constrcts):
    for const in constrcts:
        if const.split(".")[1] != "json":
            continue
        
        if not getDataByCondition(cursor, "constructs", "name", const):
            jsonData = ""
            with open(os.path.join("constructs", const), "r") as f:
                jsonData = json.loads(f.read())
            cursor.execute("INSERT INTO constructs (name, init, runType) VALUES (?, ?, ?)", (const, 0, jsonData['run']['type']))

    connection.commit()

def stopConnection(conn):
    conn.close()