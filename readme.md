Construir un container desde un docker compose:
docker-compose up -d

## Dentro del Container /bin/bash
createdb --username=userbank --owner=userbank simple_bank
psql simple_bank -U userbank
dropdb simple_bank -U userbank