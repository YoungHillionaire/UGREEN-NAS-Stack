# Bazarr Setup

Bazarr automatically downloads subtitles for all your movies and TV shows
by connecting to Sonarr and Radarr and monitoring your media library.

---

## First Login

Open `http://NAS_IP:6767`

---

## Connect Sonarr

**Settings → Sonarr**

| Field | Value |
|---|---|
| Host | NAS IP |
| Port | `8989` |
| API Key | From Sonarr → Settings → General |
| Base URL | *(leave empty)* |

Toggle **Enabled** → Test → Save

---

## Connect Radarr

**Settings → Radarr**

| Field | Value |
|---|---|
| Host | NAS IP |
| Port | `7878` |
| API Key | From Radarr → Settings → General |
| Base URL | *(leave empty)* |

Toggle **Enabled** → Test → Save

---

## Connect Sonarr Anime

**Settings → Sonarr** → Add a second Sonarr instance

| Field | Value |
|---|---|
| Host | NAS IP |
| Port | `8990` |
| API Key | From Sonarr Anime → Settings → General |

Toggle **Enabled** → Test → Save

---

## Add Subtitle Providers

**Settings → Providers → + Add**

Recommended free providers:
- **OpenSubtitles.com** — create a free account at opensubtitles.com
- **Subscene** 
- **Addic7ed** — good for TV shows

For anime subtitles add:
- **Jimaku** — dedicated anime subtitle provider

---

## Language Settings

**Settings → Languages → + Add Language Profile**

1. Name: `English`
2. Add language: `English`
3. Toggle **Enabled**
4. Save

Then assign this profile to movies and shows under:
- **Settings → Sonarr → Default Settings → Language Profile**
- **Settings → Radarr → Default Settings → Language Profile**

---

## Sync Existing Library

After setup, force a sync to grab subtitles for everything already downloaded:

**System → Tasks → Update all episodes subtitles**
**System → Tasks → Update all movies subtitles**

This runs in the background — check **System → Logs** to monitor progress.
