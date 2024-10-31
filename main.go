package main

import (
	"API-CRUD-GRPC/db"
	"API-CRUD-GRPC/gapi"
	"API-CRUD-GRPC/pb"
	"API-CRUD-GRPC/util"

	//"database/sql"
	"context"
	"log"
	"net"

	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}
	conn, err := pgxpool.New(context.Background(), config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}
	store := db.NewStore(conn)
	runGrpcServer(config, store)

}

func runGrpcServer(config util.Config, store db.Store) {
	server, err := gapi.NewServer(config, store)
	if err != nil {
		log.Fatal("cannot create server:", err)
	}
	gprcServer := grpc.NewServer()
	pb.RegisterUserServiceServer(gprcServer, server)
	reflection.Register(gprcServer)
	listener, err := net.Listen("tcp", config.GRPCServerAddress)
	if err != nil {
		log.Fatal("cannot listen on port 8080:", err)
	}
	log.Printf("start gRPC server at %s", listener.Addr().String())
	err = gprcServer.Serve(listener)
	if err != nil {
		log.Fatal("cannot start gRPC server:", err)
	}
}
