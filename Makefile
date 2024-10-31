postgresinit:
	docker run --name postgres17 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d postgres:17.0-alpine3.20
postgres:
	docker exec -it postgres17 psql
createdb:
	docker exec -it postgres17 createdb --username=root --owner=root go-chat
dropdb:
	docker exec -it postgres17 dropdb go-chat
migrateup:
	migrate -path db/migrations -database "postgresql://root:password@localhost:5433/go-chat?sslmode=disable"
migratedown:
	migrate -path db/migrations -database "postgresql://root:password@localhost:5433/go-chat?sslmode=disable"
createDockerfile:
	docker build -t go-grpc-air .
container:
	docker run -p 8080:8080 --rm -v $(shell pwd):/app -v /app/tmp --name my-go-grpc go-grpc-air
proto:
	rm -rf pb/*
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
    proto/*.proto

.PHONY: postgresinit postgres createdb dropdb migrateup migratedown createDockerfile container proto