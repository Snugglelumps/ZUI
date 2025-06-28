# ZUI

_A clean, focused UI enhancement addon for World of Warcraft._

## ✨ Intent

> “This addon reflects my personal aesthetic and workflow preferences. It’s not trying to be everything to everyone — just a clean, focused experience that works great out of the box.”

ZUI aims to improve positioning, visual clarity, and addon integration without becoming bloated or overly configurable.

### What ZUI Covers

**ZUI** is intentionally minimal and only customizes a few core interface elements:

* **Chat Frame / Prat 3.0**
* **Details!**
* **Minimap**

It does *not* modify action bars, unit frames, or other general UI components. These are already masterfully handled by other authors. For those, I personally recommend the following:

* [**Shadowed Unit Frames**](https://www.curseforge.com/wow/addons/shadowed-unit-frames) by [Shadowed103](https://github.com/Shadowed)
* [**Bartender4**](https://www.curseforge.com/wow/addons/bartender4) by [nevcairiel](https://github.com/Nevcairiel) and [Contributors](https://github.com/Nevcairiel/Bartender4/graphs/contributors)
* [**Masque**](https://www.curseforge.com/wow/addons/masque) by [StormFX](https://github.com/SFX-WoW) – [Credits](https://github.com/SFX-WoW/Masque?tab=readme-ov-file#Top)
* **Masque: ZUI** -- *Coming Soon*


Other recommended addons:
  - [****Prat 3.0****](https://www.curseforge.com/wow/addons/prat-3-0) by [sylvanaar](https://github.com/sylvanaar)
  - [****Details!****](https://www.curseforge.com/wow/addons/details) by [Tercioo](https://github.com/Tercioo)

---
## 🔧 Features

- **UI Anchor Panels**:  
  Creates two clean anchor frames in the bottom corners of the screen. These serve as target zones for positioning UI elements (currently supports `Chat` and `Details!`).

- **Settings Panel**:
  - Adjust anchor dimensions (width and height).
  - Assign addons to anchor zones (`Chat/Prat`, `Details!`, or neither).
  - Changes are only applied when the **Apply** button is clicked — no accidental repositions.
  - Optional **Reload UI** button.

- **Details! Integration**:
  - Snaps Details! to the right anchor (if selected).
  - Applies styling (e.g. hides title bar, bar area, locks position).
  - Responsively resizes to match the anchor.

- **Chat Tab Restyling**:
  - Removes Blizzard's default tab textures.
  - Replaces them with slim, inline text labels next to the chat frame.

- **Minimap Tweaks**:
  - Recenters and declutters the minimap.
  - Removes border fluff for a cleaner aesthetic.

---

## 🧩 Compatibility

**ZUI** is fully compatible with **WoW Classic: Cataclysm** and will continue to receive support and updates for **WoW Classic: Mists of Pandaria** upon its release.

We aim to maintain seamless integration with relevant addons across Classic expansions.

---

## ⚠️ Philosophy

ZUI isn’t trying to be a universal solution.

This addon is for players who already know what they want:
- Clean structure
- Sharp edges
- No bloat

No drag-to-resize, no popup menus, no profiles.  
ZUI is a statement — not a toolkit.

---

## 📦 Installation

1. Download or clone the addon into your `Interface/AddOns/` directory.
2. Folder must be named: `ZUI`
3. Use `/zui` in game to open the settings panel.

---

## 🐛 Debug Mode

You can enable debug mode manually inside init.lua:

```lua
zui.settings.debug = true
