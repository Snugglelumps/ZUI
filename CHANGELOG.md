# ZUI Addon Changelog  
_Last updated: 2025-06-28_

### 1. Initial anchor system created  
Introduced `leftAnchor` and `rightAnchor` frames with borders and background textures.

### 2. Anchor assignment UI  
Implemented dropdowns to select 'Chat' or 'Details!' content for each anchor, with mutual exclusivity.

### 3. Tab system toggle  
Added setting to switch between 'Blizzard' and 'ZUI' chat tab styles, including conditional logic for toggling and persisting.

### 4. Details anchoring  
Integrated logic to hook `OnSizeChanged` and re-anchor the Details! window dynamically.

### 5. Improved tab styling  
Modified Blizzard tab textures and fonts; introduced logic to hide default tab artwork.

### 6. Global exposure of anchor frames  
Assigned `ZUI_LeftAnchor` and `ZUI_RightAnchor` to `_G` for WeakAuras compatibility.

### 7. ZUI settings persistence fix  
Moved `zui.assertSettings()` to an `ADDON_LOADED` event with addon name check, fixing issues where defaults overwrote user settings.

### 8. ReloadUI indicator  
Added visual reload notice on settings that require it, such as minimap and tab system changes.

### 9. Settings UI modularization  
Wrapped all dropdown setups in `PLAYER_LOGIN` event blocks to ensure SavedVariables are loaded.

### 10. Minimap styling  
Implemented logic to reposition and lock `MiniMapTrackingIcon` texture. Addressed recursive `SetTexture` issue.

### 11. WeakAuras frame selection  
Enabled click-through behavior on anchor frames while still allowing UI interaction.

### 12. **Global Exposure Removed; Unified Initialization Timing**
* **Replaced** all prior global frame exposure with explicit namespace references under `zui.frames`, `zui.panels`, etc., for clarity and encapsulation.
* **Global frame exposure** (e.g., `_G["ZUI_LeftAnchor"]`) was phased out unless absolutely necessary (e.g., WeakAuras compatibility), and such exposure is now explicitly handled where needed.
* **Standardized settings assertion** to fire on the `ADDON_LOADED` event scoped to `ZUI`, ensuring SavedVariables are available before defaults are asserted.
* **All other module logic** and UI setup now consistently runs inside `PLAYER_LOGIN` handlers, resolving numerous timing conflicts and improving startup reliability.

