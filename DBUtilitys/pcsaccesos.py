import random
import datetime

# List of possible values for the 'proposito' column
proposito_values = ['A', 'B', 'C']

# List of possible values for the 'estadodeusodelentorno' column
estadodeusodelentorno_values = ['Value1', 'Value2', 'Value3']

# List of possible values for the 'detalleestadodeusodelentorno' column
detalleestadodeusodelentorno_values = ['Detail1', 'Detail2', 'Detail3']

insert_statements = []

for i in range(5000):
    pc = f'PC{i}'
    fechallamada = datetime.datetime.now()
    usuario = f'User{i}'
    ip = f'192.168.0.{i}'
    espermitido = random.choice([True, False])
    versionplugin = f'Plugin{i}'
    usuariolantikorigen = f'LantikUser{i}'
    usuarioinetumorigen = f'InetumUser{i}'
    proposito = random.choice(proposito_values)
    estadodeusodelentorno = random.choice(estadodeusodelentorno_values)
    detalleestadodeusodelentorno = random.choice(detalleestadodeusodelentorno_values)
    fechaultimaactualizacionentorno = datetime.datetime.now()
    estadodelaactualizacionlocal = f'LocalUpdateState{i}'
    ejecucion_id = f'00000000000000000000000000000000'
    mailenviado = random.choice([True, False])
    tratadoporvalidacion = random.choice([True, False])
    fechaenviomail = datetime.datetime.now()
    fechaultimaactualizacionhechaenelsistema = datetime.datetime.now()

    insert_statement = f"INSERT INTO pcsaccesos (pc, fechallamada, usuario, ip, espermitido, versionplugin, " \
                       f"usuariolantikorigen, usuarioinetumorigen, proposito, estadodeusodelentorno, detalleestadodeusodelentorno," \
                       f" fechaultimaactualizacionentorno, estadodelaactualizacionlocal, ejecucion_id, mailenviado, " \
                       f"tratadoporvalidacion, fechaenviomail, fechaultimaactualizacionhechaenelsistema) " \
                       f"VALUES ('{pc}', '{fechallamada}', '{usuario}', '{ip}', {espermitido}, '{versionplugin}', " \
                       f"'{usuariolantikorigen}', '{usuarioinetumorigen}', '{proposito}', '{estadodeusodelentorno}', " \
                       f"'{detalleestadodeusodelentorno}', '{fechaultimaactualizacionentorno}', " \
                       f"'{estadodelaactualizacionlocal}', '{ejecucion_id}', {mailenviado}, {tratadoporvalidacion}, " \
                       f"'{fechaenviomail}', '{fechaultimaactualizacionhechaenelsistema}');"
    insert_statements.append(insert_statement)

with open('inserts.sql', 'w') as f:
    for statement in insert_statements:
        f.write(statement + '\n')
