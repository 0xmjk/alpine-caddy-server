FROM alpine:3.4
ARG HUGO_RELEASE
ENV HUGO_RELEASE ${HUGO_RELEASE:-0.15}
ARG FEATURES
ENV FEATURES ${FEATURES:-git,hugo,mailout}
ADD https://caddyserver.com/download/build?os=linux&arch=amd64&features=${FEATURES} /caddy.tar.gz
RUN mkdir /caddy && \
    tar -zxvf /caddy.tar.gz -C /caddy 
ADD https://github.com/spf13/hugo/releases/download/v${HUGO_RELEASE}/hugo_${HUGO_RELEASE}_linux_amd64.tar.gz /
RUN mkdir /hugo && \
    tar -zxvf /hugo_${HUGO_RELEASE}_linux_amd64.tar.gz -C /hugo hugo_${HUGO_RELEASE}_linux_amd64/LICENSE.md hugo_${HUGO_RELEASE}_linux_amd64/hugo_${HUGO_RELEASE}_linux_amd64 && \
    mv /hugo/hugo_${HUGO_RELEASE}_linux_amd64/LICENSE.md /hugo/ && \
    mv /hugo/hugo_${HUGO_RELEASE}_linux_amd64/hugo_${HUGO_RELEASE}_linux_amd64 /hugo/hugo && \
    rm -rf /hugo/hugo_${HUGO_RELEASE}_linux_amd64
RUN apk add --no-cache su-exec git 
RUN mkdir /srv/www && \
    mkdir /srv/git && \
    mkdir /.caddy && \
    chown nobody:nobody /srv/www /srv/git /.caddy
ADD start.sh /
VOLUME /etc/caddy
ENTRYPOINT ["/start.sh"]

