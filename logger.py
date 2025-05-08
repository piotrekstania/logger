import os
import subprocess

def ouIsRunning(filename):
  filename = os.path.basename(filename)
  child = subprocess.Popen(['pgrep', '-f', filename], stdout=subprocess.PIPE, shell=False)
  response = child.communicate()[0]
  if len(response.split()) > 1:
    return True
  return False

if ouIsRunning(__file__):
  print("Script is running...")
  exit()


from questdb.ingress import Sender, TimestampNanos
dbconf = f'http::addr=localhost:9000;'

def log(lvl='info', source ='logger', message='', description=''):
   with Sender.from_conf(dbconf) as sender:
    sender.row(
        'logger_logs',
        symbols={'lvl': lvl, 'source' : source},
        columns={'message': message, 'description' : description},
        at=TimestampNanos.now())
    sender.flush()


log(message='uruchomienia loggera')

import json

try: 
    with open('conf.json', 'r') as file:
        conf = json.load(file)
    log(message='poprawne załadowanie pliku z konfiguracja')
except Exception as e:
   log(lvl='error', message='nie można załadować pliku z ustawieniami', description=repr(e))


print(conf)
