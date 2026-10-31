# Prowlarr & FlareSolverr

Prowlarr manages indexers and synchronizes them with Sonarr, Sonarr Anime, and Radarr. FlareSolverr is an optional helper for indexers that require browser challenge handling; it does not guarantee that an indexer will work.

## Prowlarr Setup

1. Open `http://NAS_IP:9696`.
2. Configure authentication under **Settings → General**.
3. Add only indexers you are permitted to use and that are compatible with your apps.

## Add FlareSolverr (Optional)

If an indexer supports FlareSolverr:

1. Open the indexer's settings in Prowlarr.
2. Configure its FlareSolverr proxy with URL `http://flaresolverr:8191`.
3. Test the indexer.

FlareSolverr is reachable by the service name because the containers share the default Compose network.

## Connect the *arr Applications

Go to **Settings → Apps → + Add Application**. Add each app separately.

| Application | Prowlarr URL | Application URL |
|---|---|---|
| Sonarr | `http://prowlarr:9696` | `http://sonarr:8989` |
| Sonarr Anime | `http://prowlarr:9696` | `http://sonarr-anime:8989` |
| Radarr | `http://prowlarr:9696` | `http://radarr:7878` |

For each entry:
1. Select the correct application type.
2. Enter the internal service URL shown above.
3. Copy the API key from that app's **Settings → General** page.
4. Test and save.

Prowlarr can then synchronize compatible indexers to the connected applications.

## Troubleshooting

- Confirm all relevant containers are running: `sudo docker compose ps`.
- Test service-to-service URLs using Docker service names and container ports, not the NAS-published host port.
- Check the Prowlarr and target app logs.
- A FlareSolverr proxy cannot solve every challenge and should not be treated as a guarantee of indexer availability.
