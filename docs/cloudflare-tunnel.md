# Cloudflare Tunnel Setup

Cloudflare Tunnel creates an outbound connection from your NAS to Cloudflare. It can publish a service without opening an inbound router port, but a public hostname still makes that service reachable from the internet unless you protect it with an access policy.

**Prefer Tailscale for private access to NAS administration tools.** Do not publish qBittorrent, Sonarr, Radarr, Prowlarr, Pi-hole, or other admin interfaces to the public internet.

## Choose the Right Tunnel Type

There are two different options:

- **Named Tunnel:** persistent tunnel managed in your Cloudflare account. For a normal public hostname such as `plex.example.com`, you need a domain/zone active in that Cloudflare account.
- **Quick Tunnel:** temporary development tunnel that creates a random `trycloudflare.com` URL. It is not a stable hostname and is not the named-tunnel setup used by this Compose service.

The Compose service in this repository runs a **named tunnel using a token**.

## 1. Create a Named Tunnel

1. Open the Cloudflare dashboard.
2. Go to **Networks → Tunnels** and create a tunnel using Cloudflared.
3. Give it a descriptive name, such as `ugreen-nas`.
4. Copy the tunnel token.
5. Put it in the local `.env` file as `CLOUDFLARE_TUNNEL_TOKEN=...`.

Do not commit the token or include it in screenshots, logs, or support requests.

## 2. Start the Container

Run this from the directory containing this repository's Compose file:

```bash
sudo docker compose config
sudo docker compose up -d cloudflared
sudo docker logs --tail=100 cloudflared
```

Confirm the tunnel reports a healthy connection in the Cloudflare dashboard.

## 3. Add a Public Hostname

In the Cloudflare dashboard, open the named tunnel and add a public hostname. Choose a domain/zone already active in your Cloudflare account.

Example for a custom domain:

| Field | Example |
|---|---|
| Subdomain | `plex` |
| Domain | `example.com` (your own Cloudflare-managed zone) |
| Service type | `HTTP` |
| URL | `http://NAS_LAN_IP:32400` |

Replace the example with your actual domain and NAS LAN address. The origin URL must be reachable from the cloudflared container. In this Compose file, cloudflared uses the default bridge network, while Plex uses host networking; use the NAS LAN IP and Plex port unless you have verified another reachable address.

The resulting hostname will be `https://plex.example.com`, not `https://plex.trycloudflare.com`.

## 4. Protect the Published Service

A public hostname is not private just because the origin is behind a tunnel.

- Add Cloudflare Access or another suitable authentication layer where compatible with the client.
- Do not expose administration interfaces or download clients.
- Check the service's own remote-access requirements and Cloudflare's current service terms before using a tunnel for media streaming.
- Test with the actual Plex clients you intend to use; browser playback and native client connectivity may behave differently.

For private access to the full NAS stack, use [Tailscale](tailscale.md) instead.

## Quick Tunnels (Temporary Testing Only)

A Quick Tunnel is a separate feature. It is started with a command such as:

```bash
cloudflared tunnel --url http://localhost:8080
```

Cloudflare assigns a random `trycloudflare.com` URL. The URL is temporary and stops working when the process stops. It does not create a stable named-tunnel hostname and is not configured by the token-based Compose service above.

See the [Cloudflare Tunnel setup guide](https://developers.cloudflare.com/tunnel/get-started/) and [Quick Tunnel documentation](https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/).
