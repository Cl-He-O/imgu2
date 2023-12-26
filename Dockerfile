
FROM golang:alpine as builder
WORKDIR /app
RUN apk add --no-cache vips-dev libheif-dev glib-dev bash gcc musl-dev
COPY ./go.mod ./go.sum ./
RUN go mod download
COPY ./ ./
RUN bash build.sh

FROM alpine:latest
WORKDIR /app
VOLUME [ "/app/sqlite", "/app/uploads" ]
RUN apk add --no-cache vips libheif glib vips-poppler
COPY --from=builder /app/imgu2 ./
RUN touch /app/.env
EXPOSE 3000
CMD [ "./imgu2", "-sqlite", "/app/sqlite/db.sqlite", "-listen", "0.0.0.0:3000"]