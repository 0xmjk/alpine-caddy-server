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

