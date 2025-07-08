# SnugUI

_A clean, focused UI enhancement addon for World of Warcraft._

## ✨ Intent

> **SnugUI** is built to be clean, simple, and cohesive — nothing more. It's meant for people who just want their UI to feel unified and polished without having to dig through a hundred toggles or style overrides.
>
> There’s no magic behind it — just straightforward code and a focused aesthetic. SnugUI doesn't try to do everything, and that’s by design. You don’t need much to make the UI feel good: a couple of rectangles, a proper action bar, and maybe some minimap tweaks. That’s the goal.
> 
>It’s not as customizable or feature-packed as the big UI overhauls — partly because I’m not that advanced a coder, but mostly because it doesn’t need to be. The big projects aim to solve all the problems with the WoW UI, and they do. I just wanted to solve one — make things feel clean and cohesive. Hopefully, I pulled it off.
> 


### What SnugUI Covers

**SnugUI** really only covers the corners of the UI, that is the chat, a space for Details! and the minimap, I'd reccomend the following:

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

### **Chat Enhancements**  

- **Snaps the chat frame** to your chosen anchor.
- **Repositions the edit box** so it respects the anchor's size and placement.
- **Chat Tab Restyling**:  
  - Choose between Blizzard’s old clunky tabs… or the new clunky ones I wrote.

### **Minimap Tweaks**  

- **Recenters and declutters** the minimap layout.
- **Optional style override** that matches the rest of SnugUI's aesthetic.
- **Removes fluff** like decorative borders and extra UI noise.
- **Locks the tracking icon** (optionally), so it remains a magnifying glass.
- **Lets you scale it** to fit your setup.

---

## 🧩 Compatibility

**SnugUI** is fully compatible with **WoW Classic: Cataclysm** and will continue to receive support and updates for **WoW Classic: Mists of Pandaria** upon its release.

We aim to maintain seamless integration with relevant addons across Classic expansions.

---

## 📦 Installation

### ✅ Easy Install (Recommended)
You can install **SnugUI** using any addon manager that supports CurseForge:

- [**CurseForge**](https://www.curseforge.com/wow/addons/snugui)
- [**WowUp**](https://wowup.io/) (make sure CurseForge is enabled as a source)

Just search for `SnugUI` and click install — you’re good to go.

---

### 🛠 Manual Install (GitHub)

1. Download or clone the repo from GitHub:  
   [https://github.com/Snugglelumps/SnugUI](https://github.com/Snugglelumps/SnugUI)

2. Place the folder in your WoW AddOns directory:
``` 
World of Warcraft/_retail_/Interface/AddOns/SnugUI
```
3. Make sure the folder is named exactly: **SnugUI**
4. Launch the game and type */sui* to open the settings panel

---

### 🎨 Optional Setup: UI Profile Imports

SnugUI includes pre-built profiles for a few popular addons to help keep your whole interface consistent.

To access them:

1. Type `/sui` in-game to open the SnugUI settings panel.
2. Go to the **“Profiles”** tab.
3. Copy the export strings for any supported addon.
4. Import them directly into the addon’s profile settings.

Currently supported:
- **Details!**
- **Shadowed Unit Frames**
- **WeakAuras**

> These are completely optional — SnugUI works fine without them, but importing the profiles can help everything look and feel more unified.

---

## 🐛 Debug Mode

You can enable debug mode manually inside init.lua:
I am constantly pruning debug code out as I learn/features are completed.

```lua
SnugUI.settings.debug = true
 ```