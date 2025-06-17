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