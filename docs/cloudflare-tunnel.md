# Cloudflare Tunnel Setup

Cloudflare Tunnel creates a secure outbound connection from your NAS to Cloudflare.
No port forwarding, no exposed ports, bypasses Double NAT completely — all for free.

---

## How It Works

```
Friends/Dad → Cloudflare → encrypted tunnel → your NAS → Plex
```

Your NAS reaches OUT to Cloudflare so nothing needs to be open on your router.

---

## Step 1 — Create the Tunnel

1. Go to https://one.dash.cloudflare.com
2. **Networks → Tunnels → Create a Tunnel**
3. Choose **Cloudflared**
4. Name it `plex`
5. Skip the install instructions (you're using Docker instead)
6. Copy the tunnel token shown
7. Paste it into `.env` as `CLOUDFLARE_TUNNEL_TOKEN`

---

## Step 2 — Start the Container

```bash
cd /volume1/docker
sudo docker compose up -d cloudflared
sudo docker logs cloudflared
```

You should see `Connected to Cloudflare` in the logs.
Go back to the Cloudflare tunnel page — status should show **Connected**.

---

## Step 3 — Add a Public Hostname

In the Cloudflare tunnel dashboard:

1. Click your tunnel → **Edit**
2. Go to **Public Hostname** tab
3. Click **Add a public hostname**

| Field | Value |
|---|---|
| Subdomain | `plex` |
| Domain | `trycloudflare.com` (free) or your own domain |
| Service Type | `HTTP` |
| URL | `192.168.100.10:32400` |

4. Save

Your Plex will now be accessible at:
`https://plex.trycloudflare.com` (or your custom subdomain)

---

## Step 4 — Set Custom Server URL in Plex

1. Plex Web → **Settings → Network**
2. Find **Custom server access URLs**
3. Add: `https://plex.trycloudflare.com`
4. Save

---

## Upgrading to a Custom Domain Later

1. Buy a domain on Cloudflare (~$8/year) — it's automatically added to your account
2. Go back to your tunnel → **Public Hostname**
3. Change domain from `trycloudflare.com` to your own domain
4. Update the custom URL in Plex settings
5. Done — stable permanent URL that never changes

---

## Important Notes

- The free `trycloudflare.com` URL **changes on every container restart**
- For stability, either avoid restarting cloudflared or get a proper domain
- Cloudflare free tier has no bandwidth limits for tunnels
- All traffic is encrypted end-to-end
