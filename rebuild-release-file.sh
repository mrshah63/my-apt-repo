#!/bin/bash
set -e

echo "🔄 Rebuilding APT repository metadata..."

REPO_PATH="$HOME/Desktop/my-apt-repo"
DIST_PATH="$REPO_PATH/dists/stable"
PKG_PATH="$DIST_PATH/main/binary-amd64"
POOL_PATH="$REPO_PATH/pool"

cd "$REPO_PATH"

echo "📦 Generating Packages files..."
mkdir -p "$PKG_PATH"

# ✅ Ensure relative paths for GitHub-hosted repos
dpkg-scanpackages -m pool /dev/null > "$PKG_PATH/Packages"
gzip -kf9 "$PKG_PATH/Packages"

# === Compute hashes and sizes ===
PKG_SIZE=$(stat -c%s "$PKG_PATH/Packages")
PKG_GZ_SIZE=$(stat -c%s "$PKG_PATH/Packages.gz")

PKG_MD5=$(md5sum "$PKG_PATH/Packages" | cut -d' ' -f1)
PKG_GZ_MD5=$(md5sum "$PKG_PATH/Packages.gz" | cut -d' ' -f1)
PKG_SHA1=$(sha1sum "$PKG_PATH/Packages" | cut -d' ' -f1)
PKG_GZ_SHA1=$(sha1sum "$PKG_PATH/Packages.gz" | cut -d' ' -f1)
PKG_SHA256=$(sha256sum "$PKG_PATH/Packages" | cut -d' ' -f1)
PKG_GZ_SHA256=$(sha256sum "$PKG_PATH/Packages.gz" | cut -d' ' -f1)

cat > "$DIST_PATH/Release" <<EOF
Origin: DarkMatter Repo
Label: DarkMatter
Suite: stable
Codename: stable
Version: 1.0
Architectures: amd64
Date: $(date -Ru)
Description: APT repository for DarkMatter Linux tools

MD5Sum:
 $PKG_MD5 $PKG_SIZE main/binary-amd64/Packages
 $PKG_GZ_MD5 $PKG_GZ_SIZE main/binary-amd64/Packages.gz

SHA1:
 $PKG_SHA1 $PKG_SIZE main/binary-amd64/Packages
 $PKG_GZ_SHA1 $PKG_GZ_SIZE main/binary-amd64/Packages.gz

SHA256:
 $PKG_SHA256 $PKG_SIZE main/binary-amd64/Packages
 $PKG_GZ_SHA256 $PKG_GZ_SIZE main/binary-amd64/Packages.gz
EOF

echo "✅ Release file rebuilt successfully!"

