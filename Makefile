.PHONY: setup up down logs pull restart

setup:
	mkdir -p /volume1/data/torrents/movies
	mkdir -p /volume1/data/torrents/tv
	mkdir -p /volume1/data/media/movies
	mkdir -p /volume1/data/media/tv
	mkdir -p /volume1/docker/config/qbittorrent
	mkdir -p /volume1/docker/config/prowlarr
	mkdir -p /volume1/docker/config/sonarr
	mkdir -p /volume1/docker/config/radarr
	mkdir -p /volume1/docker/config/plex
	mkdir -p /volume1/docker/config/pihole/etc-pihole
	mkdir -p /volume1/docker/config/pihole/etc-dnsmasq.d
	@echo "✅ Folder structure created."

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose down && docker compose up -d

logs:
	docker compose logs -f

pull:
	docker compose pull && docker compose up -d
