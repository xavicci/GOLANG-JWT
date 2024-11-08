postgresinit:
	docker run --name postgres_container -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d mobillibre-db:latest
postgres:
	docker exec -it postgres_container psql
createdb:
	docker exec -it postgres_container createdb --username=geouser --owner=geouser simple_bank
dropdb:
	docker exec -it postgres_container dropdb simple_bank
migrateup:
	migrate -path db/migration -database "postgresql://geouser:Lovecraft.00@localhost:5432/simple_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://geouser:Lovecraft.00@localhost:5432/simple_bank?sslmode=disable" -verbose down
createDockerfile:
	docker build -t go-grpc-air .
grpccontainer:
	docker run -p 8080:8080 --rm -v $(shell pwd):/app -v /app/tmp --name my-go-grpc go-grpc-air
proto:
	rm -rf pb/*
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
    proto/*.proto
dbcontainer:
	docker-compose -f /Users/xavicci/Desktop/MobilLibre/docker-compose.yml up -d
sqlc:
	sqlc generate

.PHONY: postgresinit postgres createdb dropdb migrateup migratedown createDockerfile grpccontainer proto dbcontainer sqlc