user="weblogic"
password="welcome1"
url="t3://localhost:7001"
#myServerName="myserver"
#myDomain="mydomain"
# import os

def login():
  connect(user,password,url)

def getMachines():
  machines = cmo.getMachines()
  for m in machines:
    print (m)

def getServers():
  serverConfig()
  servers = cmo.getServers()
  print (servers)
  return servers

def takeThreadDump():
  serverConfig()
  servers = cmo.getServers()
  for s in servers:
    name = s.getName()
    serverConfig()
    cd('/Servers/'+name)
    fileName='dump'+name+'.'+now+'.dmp'
    print('s :'+name+' ::: ' +fileName)
    threadDump('true', fileName, name)

def getJvmUsage():
## jvm usage
  serverConfig()
  servers = cmo.getServers()
  domainRuntime()
  print '===========   JVM Usage  =============='
  print '                TotalJVM   FreeJVM     UsedJVM    Used%'
  for s in servers:
    name = s.getName()
    cd('/ServerRuntimes/'+name+'/JVMRuntime/'+name)
    freejvm = int(get('HeapFreeCurrent'))/(1024*1024)
    totaljvm = int(get('HeapSizeCurrent'))/(1024*1024)
    usedjvm = (totaljvm - freejvm)
    usedpercent = float(float(usedjvm)/float(totaljvm))*100
    if (usedpercent > 80.0):
      print '%14s    %4d MB    %4d MB   %4d MB  %4.2f   <--- high usage' % (name,totaljvm,freejvm,usedjvm,usedpercent)
    else:
      print '%14s    %4d MB    %4d MB   %4d MB  %4.2f ' % (name,totaljvm,freejvm,usedjvm,usedpercent)

def getStatus(server):
  cd('/ServerLifeCycleRuntimes/' + server.getName())
  return cmo.getState()

def getHealth(server):
  cd('/ServerRuntimes/' + server.getName())
  tState = cmo.getHealthState().getState()
  if (tState == 0):
    return 'OK'

def getThreadstat(server, type):
  cd('ServerRuntimes/' +server.getName() + '/ThreadPoolRuntime/ThreadPoolRuntime')
  if (type =='S'):
    return int(cmo.getStuckThreadCount())
  elif (type=='H'):
    return int(cmo.getHoggingThreadCount())

def monitorReport():
  serverConfig()
  servers = cmo.getServers()
  domainRuntime()
  print '===========   Monitor Report =============='
  print '              StuckThreads    HoggingThreads'

  for msrvr in servers:
    mName = msrvr.getName()
    mState =''
    hState = ''
    sCnt = 0 
    hCnt = 0 

    if (mName != 'AdminServer'):
      mState = getStatus(msrvr)
      if (mState == 'RUNNING'):
        hState = getHealth(msrvr)
        sCnt = getThreadstat(msrvr,'S')
        hCnt = getThreadstat(msrvr,'H')
        print '%s   %5d          %5d' %(mName,sCnt,hCnt)

# :: MAIN ::
from datetime import datetime
now=str(datetime.today().strftime('%Y%m%d.%H%M%S'))
login()
getJvmUsage()
monitorReport()
takeThreadDump()
exit()
