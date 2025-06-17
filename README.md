# Greenbone Feed Snapshot

![Greenbone logo](https://www.greenbone.net/wp-content/uploads/Gb_New-logo_horizontal_head.png)

This repo automatically downloads the latest Greenbone Community Feed and uploads it as a ZIP file to GitHub Releases.

## What's inside

- scap-data
- cert-data
- vt-data (notus + nasl)
- data-feed

## How it works

- Runs every Monday at 03:00 UTC and on every push to `main`
- Detects the latest version (like `24.10`)
- Downloads the feed folders
- Zips them as `greenbone-feed.zip`
- Publishes a GitHub Release with the ZIP

## Download

Go to the [Releases](https://github.com/Kyrd0x/greenbone-feed/releases) to get the latest feed.

---