# Pi-hole Setup

Pi-hole blocks ads and trackers network-wide at the DNS level — no browser extension needed on any device.

## Before Starting — Free Port 53

The UGREEN NAS runs its own DNS service on port 53 which conflicts with Pi-hole.
Disable it first:

1. UGOS Web UI → **Network → DNS**
2. Disable the local DNS resolver
3. Save

Now Pi-hole can bind to port 53 properly using `network_mode: host`.

## First Login

Open `http://NAS_IP:8053/admin`
Password is whatever you set as `PIHOLE_PASSWORD` in `.env`.

## Set Pi-hole as Your Router DNS

1. Log into your router (usually `192.168.1.1`)
2. Find **DHCP / DNS settings**
3. Set **Primary DNS** → your NAS IP
4. Set **Secondary DNS** → `1.1.1.1` (fallback if NAS is rebooting)
5. Save and reboot router

All devices on the network now use Pi-hole automatically.

## Enable DHCP (Optional)

If you want Pi-hole to handle DHCP (assigns IPs to devices) instead of your router:

1. Pi-hole Admin → **Settings → DHCP**
2. Enable DHCP server
3. Set IP range (e.g. `192.168.1.100` to `192.168.1.200`)
4. Set Gateway to your router IP
5. Save
6. Disable DHCP on your router to avoid conflicts

## Add Block Lists

**Group Management → Adlists → Add**

Recommended:
- `https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts`
- `https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt`
- `https://blocklistproject.github.io/Lists/malware.txt`

After adding: **Tools → Update Gravity**

## Verify It's Working
```bash
nslookup doubleclick.net NAS_IP
# Should return 0.0.0.0 (blocked)
```

## Whitelist Common False Positives

**Whitelist** these if things break:
- `clients4.google.com`
- `clients2.google.com`
- `s.youtube.com`
