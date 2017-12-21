FROM alpine:3.4
ARG HUGO_RELEASE
ENV HUGO_RELEASE ${HUGO_RELEASE:-0.31.1}
ARG FEATURES
ENV FEATURES ${FEATURES:-http.git,http.hugo,http.mailout}
ARG CADDY_LICENSE
ENV CADDY_LICENSE ${CADDY_LICENSE:-personal}
ADD https://caddyserver.com/download/linux/amd64?plugins=${FEATURES}&license=${CADDY_LICENSE} /caddy.tar.gz
RUN mkdir /caddy && \
    tar -zxvf /caddy.tar.gz -C /caddy 
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_RELEASE}/hugo_${HUGO_RELEASE}_Linux-64bit.tar.gz /
RUN mkdir /hugo && \
    tar -zxvf /hugo_${HUGO_RELEASE}_Linux-64bit.tar.gz -C /hugo
RUN apk add --no-cache su-exec git libcap openssh
RUN /usr/sbin/setcap cap_net_bind_service=+ep /caddy/caddy
RUN mkdir /.caddy && \
    mkdir /.ssh && \
    chown nobody:nobody /srv /.caddy /.ssh
RUN echo StrictHostKeyChecking no >> /etc/ssh/ssh_config
ADD start.sh /
VOLUME /etc/caddy
VOLUME /.caddy
VOLUME /srv
EXPOSE 443
EXPOSE 80
ENTRYPOINT ["/start.sh"]

