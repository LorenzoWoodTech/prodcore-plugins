#!/bin/zsh
# Installs or updates Prodcore Plugins (Quad Cortex Automator + PartyKeys) on
# this Mac from the latest release. Run it again to update. Quit Live first:
# replacing the app drops any of its plugins Live is running.
#
#   curl -fsSL https://raw.githubusercontent.com/LorenzoWoodTech/prodcore-plugins/main/install.sh | zsh
set -euo pipefail
for host in Live "Logic Pro" MainStage; do
    if pgrep -xq "$host"; then
        echo "Quit $host first: installing replaces the app, which drops any of its plugins $host is running." >&2
        exit 1
    fi
done
app="Prodcore Plugins.app"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
echo "Downloading the latest Prodcore Plugins…"
curl -fsSL -o "$tmp/ProdcorePlugins.zip" "https://github.com/LorenzoWoodTech/prodcore-plugins/releases/latest/download/ProdcorePlugins.zip"
ditto -x -k "$tmp/ProdcorePlugins.zip" "$tmp"
[ -d "$tmp/$app" ] || { echo "The download holds no $app." >&2; exit 1; }
# Downloaded apps carry the quarantine flag Gatekeeper checks; a build that
# isn't notarized yet would otherwise be refused on first open.
xattr -dr com.apple.quarantine "$tmp/$app"
# The Quad Cortex Automator used to install as its own app; this one carries it now.
old="/Applications/Quad Cortex Automator.app"
if [ -d "$old" ]; then
    pluginkit -r "$old/Contents/PlugIns/QuadCortexAutomatorExtension.appex" 2>/dev/null || true
    rm -rf "$old"
fi
rm -rf "/Applications/$app"
ditto "$tmp/$app" "/Applications/$app"
# Opening it once registers the plugins with the system.
open "/Applications/$app"
version=$(defaults read "/Applications/$app/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "?")
build=$(defaults read "/Applications/$app/Contents/Info" CFBundleVersion 2>/dev/null || echo "?")
echo "Installed Prodcore Plugins $version ($build) in /Applications. Now rescan plug-ins in Live: Settings ▸ Plug-Ins ▸ Rescan."
