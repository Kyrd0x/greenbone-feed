# Greenbone Feed Snapshot

![Greenbone logo](https://www.greenbone.net/wp-content/uploads/Gb_New-logo_horizontal_head.png)

This repository publishes a daily ZIP snapshot of the [Greenbone Community Feed](https://www.greenbone.net/en/community-edition/), intended for OpenVAS/GVM scanners that **cannot use `rsync` directly** due to firewall or offline constraints.

---

## 📦 What's Included in Each Release

- `scap-data` — SCAP Security Guide data
- `cert-data` — CERT advisories
- `vt-data/notus` — Notus-based tests
- `vt-data/nasl` — NASL-based tests
- `data-feed` — GVM metadata

Everything is packaged as:  
**`greenbone-feed.zip`**

---

## 📥 How to Set Up Automatic Feed Sync on a Scanner

This setup is for scanner hosts with internet access but **no rsync support**, relying on GitHub HTTPS instead.

### 1. Install Dependencies

Make sure these are available:

```bash
sudo apt update
sudo apt install -y curl jq unzip
```

### 2. Save the Feed Sync Script

Save ```check-greenbone-feed.sh``` to ```/usr/local/bin/check-greenbone-feed.sh``` and make it executable:

```bash
# onliner todo
chmod +x /usr/local/bin/check-greenbone-feed.sh
```

### 3. Add to Crontab

To check and update the feed every day at 5:00 AM, run:

```bash
sudo crontab -e
```

Add this line:
```bash
0 5 * * * /usr/local/bin/check-greenbone-feed.sh >> /var/log/greenbone-feed-check.log 2>&1
```
## 📦 Manual Download Option

If the scanner has no internet at all, you can manually:

1. Download the ZIP from the [Releases](https://github.com/Kyrd0x/greenbone-feed/releases) page

2. Transfer it to the scanner (via USB, etc.)

3. Unzip and copy files into the proper locations as shown in the script

## 🔐 Disclaimer
The data in this repo originates from the Greenbone Community Feed.
You must comply with Greenbone’s terms of use.

> Maintained automatically via GitHub Actions — for offline & restricted OpenVAS environments.