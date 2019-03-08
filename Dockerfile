FROM library/golang:1.12-alpine AS build
# Use library/golang image to build cli53 as the available binary
# on GitHub does not work in alpine distribution

RUN apk add --no-cache --update --virtual .build-deps git \
    && GO15VENDOREXPERIMENT=1 go get github.com/barnybug/cli53/cmd/cli53 \
    && apk del .build-deps


FROM library/alpine:3.9.2
LABEL maintainer "Joan Font <jfont@habitissimo.com>"

ENV AWSCLI_VERSION 1.16.120

COPY --from=build /go/bin/cli53 /usr/bin/cli53

RUN apk add --update --no-cache python python-dev py-pip jq tar \
    && pip install awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /
ENTRYPOINT ["./entrypoint.sh"]
