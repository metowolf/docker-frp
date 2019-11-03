FROM alpine as builder

LABEL maintainer="metowolf <i@i-meto.com>"

ARG FRP_VERSION=0.29.1
ARG TIMEZONE='Asia/Shanghai'

RUN apk update \
  && apk add --no-cache \
    upx \
  && wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
  && tar zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz \
  && cd frp_${FRP_VERSION}_linux_amd64 \
  && upx frpc frps \
  && cd .. \
  && mv frp_${FRP_VERSION}_linux_amd64 /usr/local/frp


FROM alpine:3.10

LABEL maintainer="metowolf <i@i-meto.com>"

COPY --from=builder /usr/local/frp /usr/local/frp

RUN apk add --no-cache tzdata \
  && ln -s /usr/local/frp/frpc /usr/bin/frpc \
  && ln -s /usr/local/frp/frps /usr/bin/frps \
  && install -m644 /usr/local/frp/*.ini /etc

CMD ["frps", "-c", "/etc/frp/frps.ini"]
