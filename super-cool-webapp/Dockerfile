FROM golang:1.21.6-bookworm AS build

WORKDIR /build

COPY go.mod main.go ./

RUN go mod download && \
    CGO_ENABLED=0 go build -o webapp ./main.go

FROM gcr.io/distroless/static-debian12:nonroot-amd64

LABEL org.opencontainers.image.source=https://github.com/gcleroux/flux-automation-CoP
LABEL org.opencontainers.image.description="This is a super cool webapp"

COPY --chown=nonroot --from=build /build/webapp /

ENTRYPOINT [ "/webapp" ]
