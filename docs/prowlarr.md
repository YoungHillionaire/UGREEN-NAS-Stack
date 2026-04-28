# Prowlarr & FlareSolverr

Prowlarr manages all your indexers in one place and syncs them to Sonarr and Radarr automatically.
FlareSolverr lets Prowlarr access Cloudflare-protected indexers.

---

## Prowlarr Setup

### Authentication
1. Open `http://NAS_IP:9696`
2. Set a username and password when prompted

### Add FlareSolverr
1. **Settings → Indexers → + Add**
2. Search `FlareSolverr`
3. URL: `http://flaresolverr:8191`
4. Test → Save

### Add Indexers
1. **Indexers → Add Indexer**
2. Search for indexers (e.g. YTS, 1337x, ThePirateBay)
3. For Cloudflare-protected indexers, select FlareSolverr in the indexer settings
4. Test → Save

### Connect to Sonarr & Radarr
**Settings → Apps → + Add Application**

**Sonarr:**
| Field | Value |
|---|---|
| Prowlarr Server | `http://prowlarr:9696` |
| Sonarr Server | `http://sonarr:8989` |
| API Key | From Sonarr → Settings → General |

**Radarr:**
| Field | Value |
|---|---|
| Prowlarr Server | `http://prowlarr:9696` |
| Radarr Server | `http://radarr:7878` |
| API Key | From Radarr → Settings → General |

Test → Save for both. Prowlarr will now sync all indexers automatically.

---

## FlareSolverr

FlareSolverr runs a headless browser to solve Cloudflare challenges.
It runs on port `8191` and is used automatically by Prowlarr for protected indexers.

No further setup needed beyond adding it in Prowlarr as shown above.
