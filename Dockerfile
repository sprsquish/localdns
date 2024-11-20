FROM --platform=$BUILDPLATFORM golang:1.23 AS base

WORKDIR /src

COPY ./src/go.mod ./src/go.sum ./
RUN go mod download

FROM --platform=$BUILDPLATFORM base AS build
COPY ./src/ .

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
  go build -o /app ./cmd

FROM gcr.io/distroless/static

COPY --from=build /app /app

CMD ["/app"]
