FROM library/golang:1.12-alpine AS build
# Use library/golang image to build cli53 as the available binary
# on GitHub does not work in alpine distribution

ENV CLI53_VERSION 0.8.15
RUN apk add --no-cache --update --virtual .build-deps git make \
    && git clone https://github.com/barnybug/cli53.git /go/src/github.com/barnybug/cli53 \
    && cd /go/src/github.com/barnybug/cli53 \
    && git checkout ${CLI53_VERSION} \
    && make build \
    && apk del .build-deps


FROM library/alpine:3.9.2
LABEL maintainer "Joan Font <jfont@habitissimo.com>"

ENV AWSCLI_VERSION 1.16.120

COPY --from=build /go/src/github.com/barnybug/cli53/cli53 /usr/bin/cli53

RUN apk add --update --no-cache openssl ca-certificates python python-dev py-pip jq tar \
    && pip install awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /
ENTRYPOINT ["./entrypoint.sh"]
