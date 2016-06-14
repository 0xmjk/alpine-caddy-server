#!/bin/sh

ulimit -n 1048576
su-exec nobody:nobody /caddy/caddy -agree=true -conf=/etc/caddy/Caddyfile
