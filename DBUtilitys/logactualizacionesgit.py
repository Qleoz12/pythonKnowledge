import random
import datetime

# List of possible values for the 'usuario' column
usuario_values = ['User1', 'User2', 'User3']

# List of possible values for the 'repo' column
repo_values = ['Repo1', 'Repo2', 'Repo3']

# List of possible values for the 'comentarios' column
comentarios_values = ['Update 1', 'Fix bug', 'New feature']

# List of possible values for the 'commit_id' column
commit_id_values = ['commit123', 'commit456', 'commit789']

insert_statements = []

for i in range(5000):
    usuario = random.choice(usuario_values)
    repo = random.choice(repo_values)
    fecha = datetime.datetime.now()
    comentarios = random.choice(comentarios_values)
    commit_id = random.choice(commit_id_values)

    insert_statement = f"INSERT INTO logactualizacionesgit (usuario, repo, fecha, comentarios, commit_id) " \
                       f"VALUES ('{usuario}', '{repo}', '{fecha}', '{comentarios}', '{commit_id}');"
    insert_statements.append(insert_statement)

with open('inserts_logactualizacionesgit.sql', 'w') as f:
    for statement in insert_statements:
        f.write(statement + '\n')