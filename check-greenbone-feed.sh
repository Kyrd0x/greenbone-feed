#!/bin/bash

# Config
REPO="Kyrd0x/greenbone-feed"
LOCAL_HASH_FILE="/var/lib/openvas/feed.sha256"
TMP_JSON="/tmp/latest-release.json"
TMP_ZIP="/tmp/greenbone-feed.zip"
TMP_DIR="/tmp/greenbone-feed"

# 1. Get latest release metadata
curl -s "https://api.github.com/repos/$REPO/releases/latest" -o "$TMP_JSON"

# 2. Extract ZIP hash from release body
REMOTE_HASH=$(jq -r '.assets[] | select(.name=="greenbone-feed.zip") | .digest' "$TMP_JSON" | sed 's/^sha256://')

if [ -z "$REMOTE_HASH" ]; then
  echo "❌ No SHA256 hash found for greenbone-feed.zip"
  exit 1
fi

# 3. Compare with local hash
LOCAL_HASH=$(cat "$LOCAL_HASH_FILE" 2>/dev/null || echo "")

if [ "$REMOTE_HASH" = "$LOCAL_HASH" ]; then
  echo "✅ Feed is up to date"
  exit 0
fi

echo "⬇️ New feed detected. Downloading..."

# 4. Download and extract ZIP
curl -L -o "$TMP_ZIP" "https://github.com/$REPO/releases/latest/download/greenbone-feed.zip"
rm -rf "$TMP_DIR"
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# 5. Update feed locations
echo "⚙️ Installing new feed files..."

# Notus
sudo rm -rf /var/lib/notus/notus
sudo cp -r "$TMP_DIR/vulnerability-feed/vt-data/notus" /var/lib/notus

# OpenVAS NASL plugins
sudo rm -rf /var/lib/openvas/plugins/*
sudo cp -r "$TMP_DIR/vulnerability-feed/vt-data/nasl/"* /var/lib/openvas/plugins/

# SCAP and CERT data
sudo cp -r "$TMP_DIR/vulnerability-feed/scap-data/"* /var/lib/gvm/scap-data/
sudo cp -r "$TMP_DIR/vulnerability-feed/cert-data/"* /var/lib/gvm/cert-data/

# Data-feed for gvmd
sudo cp -r "$TMP_DIR/data-feed/"* /var/lib/gvm/data-objects/gvmd/

# 6. Save new hash
echo "$REMOTE_HASH" | sudo tee "$LOCAL_HASH_FILE" > /dev/null

# 7. Cleanup
rm -f "$TMP_ZIP" "$TMP_JSON"
rm -rf "$TMP_DIR"

echo "✅ Feed updated successfully."