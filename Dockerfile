FROM --platform=$BUILDPLATFORM golang:alpine AS build-base
RUN apk add build-base

FROM build-base as build
WORKDIR /proxy
COPY . .
RUN GOPATH=/proxy CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' cmd/go-proxy.go


FROM --platform=$BUILDPLATFORM alpine AS runtime
WORKDIR /proxy
COPY --from=build /proxy/go-proxy .
ENTRYPOINT ["./go-proxy"]