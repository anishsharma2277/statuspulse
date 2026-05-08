IMAGE_NAME=statuspulse:local

build:
	docker build -t $(IMAGE_NAME) .

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

test:
	curl -f http://localhost:8000/health

clean:
	docker compose down -v --rmi local

shell:
	docker exec -it statuspulse-app /bin/sh
