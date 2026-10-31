# Jellyfin Setup

Jellyfin is a free and open-source media server. In this stack it reads the same media directories as Plex, so it does not need a separate media copy.

## First Login

Open `http://NAS_IP:8096` and follow the setup wizard:

1. Choose your language.
2. Create an administrator username and strong password.
3. Add your libraries using the paths below.

## Add Libraries

Under **Dashboard → Libraries → Add Media Library**:

**Movies**
- Content type: Movies
- Display name: Movies
- Folder: `/data/media/movies`

**TV Shows**
- Content type: Shows
- Display name: TV
- Folder: `/data/media/tv`

**Anime**
- Content type: Shows
- Display name: Anime
- Folder: `/data/media/anime`

## Hardware Transcoding (Intel QuickSync)

The Compose file passes `/dev/dri` into the container. To enable hardware acceleration:

1. Open **Dashboard → Playback → Transcoding**.
2. Select Intel QuickSync (QSV), if supported by the installed driver and hardware.
3. Enable only the codecs supported by your hardware.
4. Save and test playback.

If hardware acceleration is unavailable, check that the NAS exposes `/dev/dri`, that the container can access the device, and that the installed Jellyfin image includes compatible drivers.

## Remote Access

Prefer a private VPN such as Tailscale for remote access. Do not expose Jellyfin's administration interface directly to the public internet without a deliberate security plan, authentication, and an understanding of the risks.

If you choose a reverse proxy or tunnel, configure it specifically for Jellyfin and test the web client and native apps. Do not assume that every proxy or tunnel supports every streaming protocol or client feature.

## Users and Sharing

Create separate accounts under **Dashboard → Users**. Use strong passwords and grant each account only the permissions it needs.
