# Етап 1 — збірка
FROM golang:1.22 AS builder

WORKDIR /go/src/app
COPY . .
ARG TARGETARCH
RUN make build TARGETARCH=$TARGETARCH

# Етап 2 — мінімальний образ з Alpine для сертифікатів
FROM alpine:latest AS certs
RUN apk --no-cache add ca-certificates

# Фінальний етап — мінімальний образ scratch
FROM scratch

WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["./kbot", "start"]
