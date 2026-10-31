# Bazarr Setup

Bazarr manages subtitles for media tracked by Sonarr and Radarr. It uses the same media directory mount as the media servers.

## First Login

Open `http://NAS_IP:6767` and configure authentication under the application settings.

## Connect Sonarr

Under **Settings → Sonarr**, configure:

| Field | Value |
|---|---|
| Address | NAS IP or reachable host |
| Port | `8989` |
| API Key | Sonarr → Settings → General |
| Base URL | Leave empty unless you configured one |

Test and save.

## Connect Radarr

Under **Settings → Radarr**, configure:

| Field | Value |
|---|---|
| Address | NAS IP or reachable host |
| Port | `7878` |
| API Key | Radarr → Settings → General |
| Base URL | Leave empty unless you configured one |

Test and save.

## Connect Sonarr Anime (Optional)

If your installed Bazarr version supports an additional Sonarr instance, add Sonarr Anime separately:

| Field | Value |
|---|---|
| Address | NAS IP or reachable host |
| Port | `8990` |
| API Key | Sonarr Anime → Settings → General |

Test and save. Confirm that the Bazarr version and configuration support the extra instance before relying on it.

## Path Mapping

Bazarr's Compose mount is `${DATA_ROOT}/media:/data/media`. Its media paths should therefore match the paths returned by Sonarr/Radarr, such as `/data/media/movies` and `/data/media/tv`. Avoid adding a remote path mapping unless the reported paths actually differ.

## Subtitle Providers and Languages

1. Configure only providers for which you have valid accounts/credentials and that are currently supported by your Bazarr version.
2. Create a language profile under **Settings → Languages**.
3. Assign the profile to the relevant movies and series.
4. Test on a small number of items before running a full-library search.

Provider availability, authentication requirements, and menu names can change between releases; use the provider's current documentation if a setting is missing.

## Existing Library

Run a subtitle search or sync task on a small sample first. A full-library search can create substantial provider traffic and may be subject to rate limits.
