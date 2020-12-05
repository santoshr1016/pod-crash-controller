# Start from the latest golang base image
FROM golang:latest as builder

# Set the Current Working Directory inside the container
WORKDIR /go/src/github.com/santoshr1016/pod-crash-controller

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependancies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o pod-crash-controller


######## Start a new stage from scratch #######
FROM scratch as final

COPY --from=builder /go/src/github.com/santoshr1016/pod-crash-controller .

# Command to run the executable
CMD ["./pod-crash-controller"]