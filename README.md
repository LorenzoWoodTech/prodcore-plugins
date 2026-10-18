# Prodcore Plugins — releases

Installers for **Prodcore Plugins**, the macOS app that carries the Quad Cortex Automator and PartyKeys Audio Units. Needs macOS 15 or later; Prodcore itself isn't required.

## Install or update (show Macs)

Quit Live first, then in Terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/LorenzoWoodTech/prodcore-plugins/main/install.sh | zsh
```

Then rescan plug-ins in Live (Settings ▸ Plug-Ins ▸ Rescan). Run the same line again whenever a new release is out — it replaces the app in `/Applications`.

Builds are published from the Prodcore repo's `Plugins/release.sh`.
