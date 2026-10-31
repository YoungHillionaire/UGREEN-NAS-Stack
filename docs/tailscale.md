# Tailscale Setup

Tailscale provides an encrypted private network between your devices. It is the recommended way to reach NAS services remotely without publishing their administration interfaces to the internet.

## Before Starting

1. Create an account at [Tailscale](https://tailscale.com).
2. Generate an auth key in the [Tailscale admin console](https://login.tailscale.com/admin/settings/keys).
3. Use a key with permissions and expiry settings appropriate to your security requirements.
4. Store it in the local `.env` as `TAILSCALE_AUTHKEY`. Never commit or share this key.

## Important: Preserve Tailscale State

The current Compose file uses host networking and persists Tailscale state at:

`/var/lib/tailscale` (host path) → `/var/lib/tailscale` (container path)

That state preserves the NAS device identity across container restarts. Do not delete, empty, or casually remap this directory. Changing it can cause the NAS to appear as a new Tailscale device and may require reauthorization.

Back up or protect this directory according to your NAS backup plan. Do not copy its contents into a public repository.

## First-Time Verification

After starting the service:

```bash
sudo docker compose ps tailscale
sudo docker logs --tail=100 tailscale
sudo docker exec tailscale tailscale status
sudo docker exec tailscale tailscale ip
```

The IP output should include the NAS's Tailscale address.

## Access Services Remotely

Install Tailscale on your phone or computer and sign in to the same tailnet. Use the NAS Tailscale IP to reach services:

| Service | URL |
|---|---|
| qBittorrent | `http://TAILSCALE_IP:8080` |
| Prowlarr | `http://TAILSCALE_IP:9696` |
| Sonarr | `http://TAILSCALE_IP:8989` |
| Sonarr Anime | `http://TAILSCALE_IP:8990` |
| Radarr | `http://TAILSCALE_IP:7878` |
| Plex | `http://TAILSCALE_IP:32400/web` |
| Jellyfin | `http://TAILSCALE_IP:8096` |
| Pi-hole | `http://TAILSCALE_IP:8053/admin` |
| Bazarr | `http://TAILSCALE_IP:6767` |

These services are intended for trusted devices in your tailnet. Use Tailscale ACLs/grants and device approval to control who can reach them.

## Optional: Use Pi-hole for Tailnet DNS

You can configure Pi-hole as a nameserver in Tailscale's DNS settings, but do this only after Pi-hole is stable on the LAN. Confirm that the NAS can resolve external names and that clients can still reach local services before enabling global DNS override.

## Troubleshooting

```bash
sudo docker exec tailscale tailscale status
sudo docker logs --tail=100 tailscale
```

If the node is disconnected, inspect the logs and auth-key expiry first. Do not delete the state directory as a troubleshooting shortcut.
