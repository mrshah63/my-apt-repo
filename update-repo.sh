#!/bin/bash
# ============================================================
#  DarkMatter APT Repo Updater
#  Automatically rebuilds and publishes repo metadata
# ============================================================

set -e

# === CONFIG ===
DIST="stable"
COMPONENT="main"
ARCH="amd64"
REPO_PATH="$HOME/Desktop/my-apt-repo"
DIST_PATH="$REPO_PATH/dists/$DIST"
POOL_PATH="$REPO_PATH/pool/$COMPONENT"

echo "🔧 Updating DarkMatter APT repo..."
cd "$REPO_PATH"

# === Step 1: Generate Packages files ===
echo "📦 Generating Packages files..."
mkdir -p "$DIST_PATH/$COMPONENT/binary-$ARCH"
cd "$POOL_PATH"
apt-ftparchive packages . > "$DIST_PATH/$COMPONENT/binary-$ARCH/Packages"
gzip -fk "$DIST_PATH/$COMPONENT/binary-$ARCH/Packages"

# === Step 2: Generate Release file ===
echo "🧾 Generating Release file..."
cd "$DIST_PATH"
apt-ftparchive release . > Release

# === Step 3: Add metadata headers ===
echo "✍️  Adding repository metadata..."
# Insert standard fields at the top of Release file
TMPFILE=$(mktemp)
cat > "$TMPFILE" <<EOF
Origin: DarkMatter Repo
Label: DarkMatter
Suite: $DIST
Codename: $DIST
Version: 1.0
Architectures: $ARCH
Components: $COMPONENT
Description: DarkMatter Custom APT Repository
Date: $(date -Ru)

EOF
cat Release >> "$TMPFILE"
mv "$TMPFILE" Release

# === Step 4: Commit and push ===
echo "🚀 Committing and pushing changes to GitHub..."
cd "$REPO_PATH"
git add dists
git commit -m "Auto-update APT repo after adding package"
git push origin main

# === Done ===
echo "✅ Repository updated and pushed successfully!"
echo "Now you can run: sudo apt clean && sudo apt update"
