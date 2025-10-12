#!/bin/bash
set -e

# === CONFIGURATION ===
USERNAME="mrshah63"
REPO="my-apt-repo"
TAG="v1.0"  # same tag you used in your GitHub Release

DIST_DIR="dists/stable/main/binary-amd64"
POOL_DIR="pool/main"

# Create directories if missing
mkdir -p "$DIST_DIR"

# === GENERATE Packages file ===
echo "Generating Packages file..."

> "$DIST_DIR/Packages"

for file in $POOL_DIR/*.deb; do
    [ -e "$file" ] || continue

    FILENAME=$(basename "$file")
    URL="https://github.com/$USERNAME/$REPO/releases/download/$TAG/$FILENAME"

    echo "Processing: $FILENAME"
    SIZE=$(stat -c%s "$file")
    MD5=$(md5sum "$file" | cut -d ' ' -f1)
    SHA1=$(sha1sum "$file" | cut -d ' ' -f1)
    SHA256=$(sha256sum "$file" | cut -d ' ' -f1)

    cat <<EOF >> "$DIST_DIR/Packages"
Package: ${FILENAME%%_*}
Version: 1.0
Architecture: amd64
Maintainer: DarkMatter <darkmatter@example.com>
Filename: $URL
Size: $SIZE
MD5sum: $MD5
SHA1: $SHA1
SHA256: $SHA256
Section: custom
Priority: optional
Description: Custom package $FILENAME

EOF
done

# === Compress Packages file ===
gzip -fk "$DIST_DIR/Packages"
echo "✅ Packages and Packages.gz generated."

# === Generate Release file ===
echo "Generating Release file..."
RELEASE_FILE="dists/stable/Release"

cat > "$RELEASE_FILE" <<EOF
Origin: DarkMatter Repo
Label: DarkMatter
Suite: stable
Codename: stable
Version: 1.0
Architectures: amd64
Date: $(date -Ru)
Description: APT repository for DarkMatter Linux tools

EOF

# Add MD5Sum and SHA256 sections
echo "MD5Sum:" >> "$RELEASE_FILE"
for f in $(find dists/stable -type f -name "Packages*"); do
    HASH=$(md5sum "$f" | awk '{print $1}')
    SIZE=$(stat -c%s "$f")
    RELPATH=$(echo "$f" | sed 's|^dists/stable/||')
    echo "  $HASH $SIZE $RELPATH" >> "$RELEASE_FILE"
done

echo "" >> "$RELEASE_FILE"
echo "SHA256:" >> "$RELEASE_FILE"
for f in $(find dists/stable -type f -name "Packages*"); do
    HASH=$(sha256sum "$f" | awk '{print $1}')
    SIZE=$(stat -c%s "$f")
    RELPATH=$(echo "$f" | sed 's|^dists/stable/||')
    echo "  $HASH $SIZE $RELPATH" >> "$RELEASE_FILE"
done

echo "✅ Release file generated successfully!"
