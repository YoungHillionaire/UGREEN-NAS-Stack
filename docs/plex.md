# Plex Setup

## Claim Token (First Run Only)

Before launching, get a claim token:
1. Go to https://plex.tv/claim while logged in
2. Copy the token (starts with `claim-`)
3. Paste into `.env` as `PLEX_CLAIM=claim-xxxxx`
4. Run `docker compose up -d` within 4 minutes

After first launch Plex stores auth internally — you can clear `PLEX_CLAIM` from `.env`.

## Initial Setup

1. Open `http://NAS_IP:32400/web`
2. Sign in with your Plex account
3. Name your server (e.g. `HussainNAS`)

## Add Libraries

1. **Settings → Libraries → Add Library**
2. **Movies** → Add Folder → `/data/media/movies`
3. **Add Library** again → **TV Shows** → `/data/media/tv`

Plex will scan automatically. Nothing shows until downloads complete.

## Hardware Transcoding (Intel QuickSync)

The DXP2800 N100/N305 supports Intel QuickSync — already enabled in `docker-compose.yml` via `/dev/dri`.

To activate in Plex:
1. **Settings → Transcoder**
2. Enable **Use hardware acceleration when available**
3. Enable **Use hardware-accelerated video encoding**
4. Save

> Requires a **Plex Pass** subscription. Without it, transcoding uses CPU which still works fine.

## Verify Transcoding
While something is playing/transcoding, check the Now Playing dashboard.
You should see `(hw)` next to the stream — that means QuickSync is active.
