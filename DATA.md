# 📦 SnugUI Namespace Structure

📂 SnugUI
├── ⚙️ settings (SavedVariables)
│   ├── ~~anchorAssignments~~
│   │   ├── ~~left~~
│   │   └── ~~right~~
│   ├── ~~anchorWidth~~
│   ├── ~~anchorHeight~~
│   ├── anchors
│   │   ├── leftAssignment
│   │   ├── rightAssignment
│   │   ├── width
│   │   └── height
│   ├── tabSystem
│   ├── ~~minimapStyle~~
│   ├── minimap
│   │   ├── style - toggles between SnugUI and a Blizzard-esq minimap
│   │   ├── scale - Will be static value for SnugUI, slider for Blizzard-esq
│   │   ├── lockTracker
│   │   ├── hideWorldMapButton
│   │   ├── 
│   │   └──
│   ├── qol
│   │   ├── questButton 
│   │   └── questHotkey
│   └── debug
│
├── 🧾 frames
│   ├── leftAnchor
│   └── rightAnchor
│
├── 🧾 panels
├── 🧾 buttons
├── 🧾 commitRegistry (functions to run on PLAYER_LOGIN)
│
├── 🛠️ loginTrigger(fn)
├── 🛠️ assertSettings()
│
└── 🧾 tabWordButtons (dynamic UI elements)


📂 File Modules
├── 📄 chat.lua
│   ├── 🛠️ Anchors ChatFrame1 and EditBox to assigned anchor
│   └── 🛠️ Hides default chat buttons
│
├── 📄 details.lua
│   └── 🛠️ Anchors Details! instance to assigned anchor
│
├── 📄 minimap.lua
│   ├── 🛠️ Formats Minimap to custom look
│   ├── 🛠️ Moves clock and tracking icon
│   └── 🛠️ Adjusts buff frame position
│
├── 📄 blizzard.lua
│   └── 🛠️ Hooks tooltip anchoring to right anchor
│
└── 📄 tabwords.lua
    ├── 🛠️ Creates clickable chat tab word buttons
    └── 🛠️ Replaces default tab textures/text

## Mantras
* Single-source truth
* Reaction only comes from action