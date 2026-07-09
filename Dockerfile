# multi-stage build

# first stage is app build process in executable file
FROM golang:1.26-alpine AS builder
WORKDIR /app
COPY . .
RUN GOOS=linux go build -o main cmd/main.go

# second stage is app run process. copy executable file from builder and run it
FROM alpine:latest
RUN addgroup -S lostcragroup && adduser -S lostcra -G lostcragroup
WORKDIR /home/lostcra/app/
RUN chown -R lostcra:lostcragroup /home/lostcra/app/
COPY --chown=lostcra:lostcragroup --from=builder /app/main .
CMD [ "./main" ]