all: run

run:
	docker compose up -d

upgrade:
	docker compose pull && docker compose up -d

upgrade_clean:
	docker compose pull && docker compose up -d && docker image prune -af

stop:
	docker compose down

restart:
	docker compose restart

clean:
	docker image prune -af
