createdb:
	docker exec -it postgres_bank createdb --username=userbank --owner=userbank simple_bank
dropdb:
	docker exec -it postgres_bank dropdb simple_bank -U userbank
postgres:
	docker exec -it postgres_bank psql simple_bank -U userbank
migrateup:
	migrate -path db/migration -database "postgresql://userbank:Lovecraft00@localhost:5432/simple_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://userbank:Lovecraft.00@localhost:5432/simple_bank?sslmode=disable" -verbose down
sqlc:
	sqlc generate
test:
	go test -v -cover ./...
.PHONY: dbbank, createdb, dropdb, postgres, migrateup, migratedown
