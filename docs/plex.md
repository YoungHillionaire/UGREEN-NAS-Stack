# Plex Setup

## Claim Token (First Run Only)

For a new Plex server:

1. Open [plex.tv/claim](https://plex.tv/claim) while signed in.
2. Copy the temporary claim token.
3. Put it in the local `.env` as `PLEX_CLAIM=claim-...`.
4. Start Plex promptly; the token expires after a short time.

After the server is claimed, remove the token from `.env`. Do not commit or share it.

## Initial Setup

Open `http://NAS_IP:32400/web`, sign in, and give the server a name.

## Add Libraries

Under **Settings → Libraries → Add Library**:

- Movies: `/data/media/movies`
- TV Shows: `/data/media/tv`
- Anime (optional): `/data/media/anime`

These are paths inside the Plex container, not NAS host paths.

## Hardware Transcoding (Intel QuickSync)

The Compose file passes `/dev/dri` into the container. In Plex:

1. Open **Settings → Transcoder**.
2. Enable **Use hardware acceleration when available**.
3. Enable hardware-accelerated video encoding if supported.
4. Save and test a transcode.

Hardware transcoding availability depends on Plex Pass, the installed image/driver, supported codecs, and the media format. During playback, inspect the Plex dashboard for the `(hw)` indicator.

## Remote Access

For private access, prefer [Tailscale](tailscale.md). Plex's own remote-access feature and third-party tunnels have different networking and client requirements; do not assume a Cloudflare Tunnel will work for every Plex client or streaming mode.

Do not publish the NAS administration or *arr services just to make Plex reachable. Review Plex's current remote-access documentation and test with the actual clients you use.
