#!/bin/bash

# Config
REPO="Kyrd0x/greenbone-feed"
LOCAL_DATE_FILE="/var/lib/openvas/feed.date"
TMP_JSON="/tmp/latest-release.json"
TMP_ZIP="/tmp/greenbone-feed.zip"
TMP_DIR="/tmp/greenbone-feed"

# 1. Get latest release metadata
curl -s "https://api.github.com/repos/$REPO/releases/latest" -o "$TMP_JSON"

# 2. Extract release date (YYYY-MM-DD) from tag or name
RELEASE_DATE=$(jq -r '.tag_name' "$TMP_JSON" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')

if [ -z "$RELEASE_DATE" ]; then
  echo "❌ Could not extract release date from tag"
  exit 1
fi

# 3. Read local last synced date
LOCAL_DATE=$(cat "$LOCAL_DATE_FILE" 2>/dev/null || echo "")

if [ "$RELEASE_DATE" = "$LOCAL_DATE" ]; then
  echo "✅ Feed is up to date (Last synced: $LOCAL_DATE)"
  exit 0
fi

echo "⬇️ New feed detected (Release date: $RELEASE_DATE). Downloading..."

# 4. Download and extract ZIP
ZIP_URL=$(jq -r '.assets[] | select(.name=="greenbone-feed.zip") | .browser_download_url' "$TMP_JSON")
curl -L -o "$TMP_ZIP" "$ZIP_URL"
rm -rf "$TMP_DIR"
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# 5. Update feed locations
echo "⚙️ Installing new feed files..."

# Notus
sudo rm -rf /var/lib/notus/notus
sudo cp -r "$TMP_DIR/vulnerability-feed/vt-data/notus" /var/lib/notus

# NASL plugins
sudo rm -rf /var/lib/openvas/plugins/*
sudo cp -r "$TMP_DIR/vulnerability-feed/vt-data/nasl/"* /var/lib/openvas/plugins/

# SCAP and CERT data
sudo cp -r "$TMP_DIR/vulnerability-feed/scap-data/"* /var/lib/gvm/scap-data/
sudo cp -r "$TMP_DIR/vulnerability-feed/cert-data/"* /var/lib/gvm/cert-data/

# Data-feed for gvmd
sudo cp -r "$TMP_DIR/data-feed/"* /var/lib/gvm/data-objects/gvmd/

# 6. Save new date
echo "$RELEASE_DATE" | sudo tee "$LOCAL_DATE_FILE" > /dev/null

# 7. Cleanup
rm -f "$TMP_ZIP" "$TMP_JSON"
rm -rf "$TMP_DIR"

echo "✅ Feed updated to $RELEASE_DATE"