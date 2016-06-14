IMAGE=0xmjk/alpine-caddy-server

image:
	docker build -t $(IMAGE) .
interactive:
	docker run -it -p 8881:8881 --rm --volume /data/caddy:/etc/caddy --entrypoint sh $(IMAGE)
run:
	docker run -d -p 8881:8881 --volume /data/caddy:/etc/caddy --name caddy $(IMAGE) 
stop:
	docker rm -f caddy
rm:
	docker ps -a | grep $(IMAGE) | awk '{print $$1}' | xargs docker rm

