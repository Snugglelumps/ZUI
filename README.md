# SnugUI

_A clean, focused UI enhancement addon for World of Warcraft._

## ✨ Intent

> SnugUI is built on the idea that a unified, end-to-end UI should be clean, efficient, and visually cohesive — not a patchwork of mismatched styles. While many UI overhauls are impressively comprehensive, they can be overwhelming to configure and maintain. SnugUI aims to do less, better.
> 
> The goal is simplicity with intention. SnugUI strives for minimal overhead and maximum clarity. Even as we add creature comforts like user settings, the addon will always prioritize performance and visual harmony.
> 
> And while we could offer full customization, SnugUI follows a focused aesthetic — one that I personally enjoy. I know that's a little opinionated, but I hope you'll like it too.



### What SnugUI Covers

**SnugUI** is intentionally minimal and only customizes a few core interface elements. It is designed to interface with:

  - [****Prat 3.0****](https://www.curseforge.com/wow/addons/prat-3-0) by [sylvanaar](https://github.com/sylvanaar)
  - [****Details! Damage Meter****](https://www.curseforge.com/wow/addons/details) by [Tercioo](https://github.com/Tercioo)

It does *not* modify action bars, unit frames, or other general UI components. These are already masterfully handled by other authors. For those, I personally recommend the following:

* [**Shadowed Unit Frames**](https://www.curseforge.com/wow/addons/shadowed-unit-frames) by [Shadowed103](https://github.com/Shadowed)
* [**Bartender4**](https://www.curseforge.com/wow/addons/bartender4) by [nevcairiel](https://github.com/Nevcairiel) and [Contributors](https://github.com/Nevcairiel/Bartender4/graphs/contributors)
* [**Masque**](https://www.curseforge.com/wow/addons/masque) by [StormFX](https://github.com/SFX-WoW) – [Credits](https://github.com/SFX-WoW/Masque?tab=readme-ov-file#Top)
* **Masque: SnugUI** -- *Coming Soon*


Special Thanks:
  - [****DevTool****](https://www.curseforge.com/wow/addons/devtool) by [brittyazel](https://github.com/brittyazel)
  - [****TextureAtlasViewer****](https://www.curseforge.com/wow/addons/textureatlasviewer) by [LanceDH](https://github.com/LanceDH)

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
  - Optional Details! import profile.
  - Responsively resizes to match the anchor.

- **Chat Tab Restyling**:
  - Choose between Blizzards old clunky tabs or the new clunky ones I wrote.

- **Minimap Tweaks**:
  - Recenters and declutters the minimap.
  - Removes border fluff for a cleaner aesthetic.

---

## 🧩 Compatibility

**SnugUI** is fully compatible with **WoW Classic: Cataclysm** and will continue to receive support and updates for **WoW Classic: Mists of Pandaria** upon its release.

We aim to maintain seamless integration with relevant addons across Classic expansions.

---

## 📦 Installation

1. Download or clone the addon into your `Interface/AddOns/` directory.
2. Folder must be named: `SnugUI`
3. Use `/sui` in game to open the settings panel.

- Very shortly SnugUI and Masque_SnugUI will be on CurseForge

---

## 🐛 Debug Mode

You can enable debug mode manually inside init.lua:

```lua
SnugUI.settings.debug = true
 ```
 
## 📁 Index

### 1.0: Initialization (`init.lua`)

### 2.0: UI Base Frame (`frames.lua`)
- 2.1: Anchors  
- 2.2: Layout  
- 2.3: Predeclare  
- 2.4: Sidebar  
- 2.5: Border  
- 2.6: Labels  

### 3.0: Main Logic and Panel Content (`main.lua`)
- 3.1: Reload Indicator  
- 3.2: Anchor Dimensions  
- 3.3: Anchor Assignments  
- 3.4: Minimap Settings  
- 3.5: Chat Settings  
- 3.6: Details! Panel  
- 3.7: Buttons and Commands  
- 3.8: About Page
