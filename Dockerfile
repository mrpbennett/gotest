FROM golang:1.25.3-alpine AS build
WORKDIR /app

# Copy go.mod (and go.sum if it exists) first to leverage Docker layer caching.
COPY go.* ./
RUN go mod download

# Copy the rest of the application source code.
COPY . .

# Build a statically-linked binary for Linux.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o gotest .

FROM scratch
WORKDIR /

# Copy the compiled binary from the builder stage.
COPY --from=build /app/gotest /gotest

# Run the application.
ENTRYPOINT ["/gotest"]
