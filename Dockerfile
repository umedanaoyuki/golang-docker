####################### Build stage #######################
FROM golang:1.25.5-alpine3.23 AS builder

WORKDIR /web-service-gin

# go installで必要
RUN apk add --no-cache git


RUN go install github.com/air-verse/air@latest

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# airを実行（ホットリロード有効）
CMD ["air", "-c", ".air.toml"]

RUN go build -o main ./main.go

EXPOSE 8080

####################### Run stage #######################
FROM alpine:3.23

WORKDIR /app

COPY --from=builder /web-service-gin/main .

COPY .env .
COPY wait-for.sh .

RUN chmod +x wait-for.sh

EXPOSE 8080

CMD [ "./main" ]