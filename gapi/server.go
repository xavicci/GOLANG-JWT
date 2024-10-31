package gapi

import (
	"API-CRUD-GRPC/db"
	"API-CRUD-GRPC/pb"
	"API-CRUD-GRPC/token"
	"API-CRUD-GRPC/util"
	"fmt"
)

type Server struct {
	pb.UnimplementedUserServiceServer
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
}

func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	return server, nil
}
