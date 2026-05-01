# Tailscale Setup

Tailscale creates an encrypted peer-to-peer VPN mesh. Once set up you can access
all your NAS services from anywhere using private Tailscale IPs — no port forwarding,
no exposed ports, no dynamic DNS needed.

---

## Before Starting

1. Create a free account at https://tailscale.com
2. Go to https://login.tailscale.com/admin/settings/keys
3. Click **Generate auth key**
4. Toggle **Reusable** ON — this lets the container re-authenticate after reboots
5. Copy the key and paste it into `.env` as `TAILSCALE_AUTHKEY`

---

## First-Time Verification

After `docker compose up -d`, check Tailscale joined your network:

```bash
sudo docker exec tailscale tailscale status
```

Get your NAS Tailscale IP:
```bash
sudo docker exec tailscale tailscale ip
# Returns something like 100.64.0.1
```

---

## Access Services Remotely

Install the Tailscale app on your phone or laptop and sign in with the same account.
You're now on the same private network as your NAS wherever you are.

Replace `NAS_IP` with your Tailscale IP (e.g. `100.x.x.x`):

| Service | Remote URL |
|---|---|
| qBittorrent | `http://100.x.x.x:8080` |
| Prowlarr | `http://100.x.x.x:9696` |
| Sonarr | `http://100.x.x.x:8989` |
| Radarr | `http://100.x.x.x:7878` |
| Plex | `http://100.x.x.x:32400/web` |
| Pi-hole | `http://100.x.x.x:8053/admin` |

---

## Use Pi-hole Remotely via Tailscale

You can route DNS through Pi-hole even when away from home:

1. Go to Tailscale Admin → **DNS**
2. Add your NAS Tailscale IP as a **Global Nameserver**
3. Enable **Override local DNS**

Now all your devices use Pi-hole's ad-blocking even on mobile data.

---

## Troubleshooting

If Tailscale loses connection after a reboot:
```bash
sudo docker exec tailscale tailscale up
```

Check connection status:
```bash
sudo docker exec tailscale tailscale status
```
