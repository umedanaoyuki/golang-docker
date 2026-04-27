FROM golang:1.25

WORKDIR /web-service-gin

# go installで必要
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN go install github.com/air-verse/air@latest

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# airを実行（ホットリロード有効）
CMD ["air", "-c", ".air.toml"]

EXPOSE 8080