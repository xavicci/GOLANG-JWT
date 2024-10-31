FROM golang:1.23.2-bookworm

RUN apt-get update && apt-get install -y
RUN apt-get install -y protobuf-compiler 


WORKDIR /app

RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install github.com/air-verse/air@latest

RUN export PATH="$PATH:$(go env GOPATH)/bin"

COPY go.* ./

RUN go mod download

COPY . .

EXPOSE 8080

CMD ["air", "-c", ".air.toml"]