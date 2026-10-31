# Pi-hole Setup

Pi-hole filters DNS requests for devices that use it as their DNS resolver. In this repository, Pi-hole uses **host networking**, so it shares the NAS network namespace and needs access to DNS port 53.

> **Important:** Do not assume that stopping or disabling a service named `dnsmasq` is safe on UGOS. It may be involved in NAS networking, DHCP, local name resolution, or other system functions. Identify the process and its dependencies before changing host services.

## 1. Check Port 53 Before Starting

Over SSH, inspect what is listening:

```bash
sudo ss -tulpn | grep ':53'
```

If something is using port 53, identify the process and determine whether UGOS depends on it. Do not run `systemctl stop dnsmasq` or `systemctl disable dnsmasq` as a generic fix. If you cannot confidently establish that the service can be stopped without affecting UGOS, leave it running and do not start Pi-hole in host-network mode yet.

Also check whether your router currently provides DHCP and DNS. Avoid moving DHCP responsibilities to Pi-hole unless you have planned the migration and can recover router access.

## 2. Pi-hole v6 Environment Variables

The Compose file currently uses these legacy names:

- `WEBPASSWORD`
- `PIHOLE_DNS_`
- `DNSMASQ_LISTENING`

Pi-hole v6 uses the `FTLCONF_...` naming convention for these settings. The corresponding v6 variables are:

| Legacy variable in current Compose | Pi-hole v6 variable |
|---|---|
| `WEBPASSWORD` | `FTLCONF_webserver_api_password` |
| `PIHOLE_DNS_` | `FTLCONF_dns_upstreams` |
| `DNSMASQ_LISTENING` | `FTLCONF_dns_listeningMode` |

The web port setting `FTLCONF_webserver_port=8053` is already using the v6 format.

**This repository's Compose file has not been migrated automatically.** Before changing it on an existing NAS, back up `CONFIG_ROOT/pihole`, check the running Pi-hole version and current settings, and confirm that the new variables preserve the intended configuration. Environment variables set through `FTLCONF_...` become read-only in Pi-hole's UI/CLI while they remain defined.

See the [official Pi-hole Docker configuration](https://docs.pi-hole.net/docker/configuration/) and [v5-to-v6 migration guide](https://docs.pi-hole.net/docker/upgrading/v5-v6/).

## 3. Start and Verify

Only after port 53 is available and the Compose configuration has been reviewed:

```bash
sudo docker compose config
sudo docker compose up -d pihole
sudo docker logs --tail=100 pihole
```

Open `http://NAS_IP:8053/admin`. The configured password must match the effective Pi-hole v6 setting or the password already stored in its persistent configuration.

## 4. Configure Router DNS

If Pi-hole is healthy and resolving queries:

1. Open your router's LAN/DHCP DNS settings.
2. Set the primary DNS to the NAS LAN IP.
3. Decide on a fallback resolver deliberately. A public secondary DNS may allow devices to bypass Pi-hole rather than acting as a true failover.
4. Apply the change to one test device first.
5. Confirm normal browsing and local NAS access before changing the whole network.

Keep router DHCP enabled unless you intentionally plan to migrate DHCP to Pi-hole.

## 5. DHCP (Optional)

Only use Pi-hole as the DHCP server if your router supports disabling its own DHCP service and you have planned the change. Never run two DHCP servers on the same LAN.

Before enabling it, record the router's current LAN address, DHCP range, reservations, and recovery procedure.

## 6. Verify DNS

From a client configured to use Pi-hole:

```bash
nslookup example.com NAS_IP
```

Use Pi-hole's query log to confirm that the request arrived. A blocked domain may return a sinkhole address or a configured blocking response; do not rely on one fixed answer for every blocklist.

## 7. Backups

Back up the persistent `CONFIG_ROOT/pihole` directory before upgrades or configuration changes. Keep a copy of the router's DNS/DHCP settings so you can revert clients if the NAS is unavailable.
