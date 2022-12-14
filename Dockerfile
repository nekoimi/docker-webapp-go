FROM golang:1.19.4 AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
ENV GOPROXY=https://mirrors.aliyun.com/goproxy/

WORKDIR /build
COPY . .
RUN go install
RUN go build --ldflags "-extldflags -static" -o webapp-go main.go

FROM alpine:3.16.3

LABEL maintainer="nekoimi <nekoimime@gmail.com>"

COPY --from=builder /build/webapp-go /go/bin/webapp-go

ENV TZ=Asia/Shanghai
ENV PORT=80

WORKDIR /workspace
RUN mkdir -p /public

EXPOSE 80

CMD ["/go/bin/webapp-go"]
