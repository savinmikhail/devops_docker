.PHONY: start bash

start:
	docker build -t module3 . && docker run -d --name module3 -p 8080:80 module3:latest

bash:
	docker exec -it module3 bash

down:
	docker stop module3 && docker rm module3
