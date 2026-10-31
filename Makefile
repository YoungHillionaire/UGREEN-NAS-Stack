.PHONY: setup up down logs pull restart

# Read only path settings from .env; do not parse secrets as Make syntax.
# Defaults preserve the documented UGREEN volume layout.
CONFIG_ROOT ?= $(shell sed -n 's/^CONFIG_ROOT=//p' .env 2>/dev/null | tail -n 1)
DATA_ROOT ?= $(shell sed -n 's/^DATA_ROOT=//p' .env 2>/dev/null | tail -n 1)
CONFIG_ROOT := $(if $(strip $(CONFIG_ROOT)),$(CONFIG_ROOT),/volume1/docker/config)
DATA_ROOT := $(if $(strip $(DATA_ROOT)),$(DATA_ROOT),/volume1/data)

setup:
	mkdir -p "$(DATA_ROOT)/torrents/movies"
	mkdir -p "$(DATA_ROOT)/torrents/tv"
	mkdir -p "$(DATA_ROOT)/torrents/anime"
	mkdir -p "$(DATA_ROOT)/media/movies"
	mkdir -p "$(DATA_ROOT)/media/tv"
	mkdir -p "$(DATA_ROOT)/media/anime"
	mkdir -p "$(CONFIG_ROOT)/qbittorrent"
	mkdir -p "$(CONFIG_ROOT)/prowlarr"
	mkdir -p "$(CONFIG_ROOT)/sonarr"
	mkdir -p "$(CONFIG_ROOT)/sonarr-anime"
	mkdir -p "$(CONFIG_ROOT)/radarr"
	mkdir -p "$(CONFIG_ROOT)/plex"
	mkdir -p "$(CONFIG_ROOT)/jellyfin"
	mkdir -p "$(CONFIG_ROOT)/bazarr"
	mkdir -p "$(CONFIG_ROOT)/pihole/etc-pihole"
	mkdir -p "$(CONFIG_ROOT)/pihole/etc-dnsmasq.d"
	@echo "Folder structure created under:"
	@echo "  DATA_ROOT=$(DATA_ROOT)"
	@echo "  CONFIG_ROOT=$(CONFIG_ROOT)"

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose down && docker compose up -d

logs:
	docker compose logs -f

# Pulling and applying newer images can change application behaviour.
# Back up app configuration and review release notes before running this target.
pull:
	docker compose pull && docker compose up -d
