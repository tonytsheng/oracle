import csv
import time
import socket
import array
import os
from collections impot defaultdict

# PrintMsg
def PrintMsg (msg):
    print (time.strftime("%Y-%m-%d %H:%M:%S") + ": " + msg)

# ExecSQL
def ExecSql (user, pw, file_in, file_out):
    sqlcall = "sqlplus -S " + user + "/" + pw + "@" + sid + "@" + file_in + \
        " | egrep -v '\---|rows|COUNT|PL\/SQL' | sed '/^$/d' > file_out
    os.systemcall(sqlcall)

host = socket.gethostname().split('.',1)[0]
PrintMsg("HOST: " + host)
ssirep = "/home/user/dba_arch/scripts/install/ssi/rep." + host
PrintMsg("SSI_REP: " + ssirep)
