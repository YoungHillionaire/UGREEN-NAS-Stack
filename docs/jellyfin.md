# Jellyfin Setup

Jellyfin is a free and open source media server — a great alternative or companion to Plex.
It points at the same `/data/media` folder as Plex so no extra disk space is used.

## Why Run Both?

- Jellyfin is 100% free — no Plex Pass needed for hardware transcoding or remote access
- Better subtitle support
- No account required for local streaming
- Great for sharing with people who don't have Plex accounts
- Plex for your main setup, Jellyfin as backup or for specific users

---

## First Login

Open `http://NAS_IP:8096`

Follow the setup wizard:
1. Set language
2. Create admin username and password
3. Add media libraries (see below)
4. Skip the rest for now

---

## Add Libraries

1. **Dashboard → Libraries → Add Media Library**

**Movies:**
- Content type: `Movies`
- Display name: `Movies`
- Folder: `/data/media/movies`

**TV Shows:**
- Content type: `Shows`
- Display name: `TV`
- Folder: `/data/media/tv`

**Anime:**
- Content type: `Shows`
- Display name: `Anime`
- Folder: `/data/media/anime`

---

## Hardware Transcoding (Intel QuickSync)

Already enabled via `/dev/dri` in the compose file.

To activate in Jellyfin:
1. **Dashboard → Playback → Transcoding**
2. Hardware acceleration: **Intel QuickSync (QSV)**
3. Enable all codec checkboxes
4. Save

No Jellyfin account or subscription needed — completely free.

---

## Remote Access

Unlike Plex, Jellyfin doesn't rely on a cloud service.
Remote access works by forwarding port `8096` on your router:

- External port: `8096`
- Internal port: `8096`
- IP: NAS IP
- Protocol: TCP

Then access from anywhere: `http://YOUR_PUBLIC_IP:8096`

---

## Users & Sharing

**Dashboard → Users → Add User**

Create accounts for family/friends — they log in directly to your Jellyfin server.
No third party account needed, everything stays on your NAS.
