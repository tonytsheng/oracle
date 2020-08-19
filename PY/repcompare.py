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

sql_rowcount = open("rowcount.sql", w)
sql_rowcount.write("set serveroutput on;\n")
sql_rowcount.write("set colsep '|';\n")
sql_rowcount.write("declare val number;\n")
sql_rowcount.write("begin\n")
sql_rowcount.write("  for t in (select table_name from user_tables order by \
    table_name) loop\n")
sql_rowcount.write("   execute immediate 'select count(*) from || t.table_name \
    into val;\n")
sql_rowcount.write("    dbms_output.put_line (t.table_name || ":" || val);\n")
sql_rowcount.write("end loop;\n")
sql_rowcount.write("end;\n")
sql_rowcount.write("\n")
sql_rowcount.write("exit\n")
sql_rowcount.close()
