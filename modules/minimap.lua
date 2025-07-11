local _, SnugUI = ...

SnugUI.frames.minimapBorder = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
local function SnugUIMinimap()
    local toHide = {
            MinimapBorder,
            MinimapBorderTop,
            MinimapZoneTextButton,
            MinimapZoneText,
            MinimapZoomIn,
            MinimapZoomOut,
            MiniMapTrackingButtonBorder,
            MiniMapTrackingBackground,
            MiniMapWorldMapButton, -- id like to make this as setting, but its just SOOOO ugly. maybe ill rebuild it.
        }
    for _, frame in ipairs(toHide) do
        if frame then frame:Hide() end
    end
    -- Remove clocks background textures
    for i = 1, TimeManagerClockButton:GetNumRegions() do
        local region = select(i, TimeManagerClockButton:GetRegions())
        if region and region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
        end
    end

    C_Timer.After(1, function()
        MiniMapWorldMapButton:Hide() -- the only frame that needs a delay...
    end)

    -- Add a 1px black border around the minimap
    Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
    local border = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
    border:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -0.5, 0.5)
    border:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0.5, -0.5)
    border:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 0.5,
    })
    border:SetBackdropBorderColor(0, 0, 0, 1)
    border:SetFrameStrata("LOW")
    border:Show()

    --#fuckthecluster
    WatchFrame:ClearAllPoints()
    WatchFrame:SetPoint("TOP", Minimap, "BOTTOMRIGHT", 0, -25)
    WatchFrame:SetClampedToScreen(true)
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("RIGHT", Minimap, "TOPLEFT", -25, -25)
    if GameTimeFrame then
        GameTimeFrame:ClearAllPoints()
        GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)

        local scale = tonumber(SnugUI.settings.minimap.scale) or 1
        local size = scale * 0.45
        if GameTimeFrame:GetScale() ~= size then
            GameTimeFrame:SetScale(size)
        end
    end
    if TimeManagerClockButton then
    TimeManagerClockButton:ClearAllPoints()
    TimeManagerClockButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -15, -8)
    end
    if MiniMapTracking then
        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 6, -7)
    end
    -- the math here is kinda random. the intent was to derive the width of the negative space around the
    -- minimap as it scales, and use that to calculate our offsets. the scaling is a bit of a black box to
    -- me, for now ive settled on some random numbers doing the job. if you know the answer hmu.
    offset = -math.abs(30 - ( 8 * SnugUI.settings.minimap.scale)  )
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", offset, offset)
    Minimap:SetClampedToScreen(false)
end

local function blizzardMinimap()
    Minimap:SetMaskTexture("interface\\masks\\circlemaskscalable")
end

function applyMinimapStyle()
    if SnugUI.settings.minimap.style == "SnugUI" then
        SnugUIMinimap()
    end
    if SnugUI.settings.minimap.style == "Blizzard" then
        blizzardMinimap()
    end
end

local previousScale
SnugUI.functions.applyMinimapScale = function() -- in namespace for onvaluechanged slider in main.lua
    local currentScale = SnugUI.settings.minimap.scale
    if previousScale == currentScale then return end
        MinimapCluster:SetScale(currentScale)
    previousScale = currentScale
end

local function lockMinimapTracker()
    if MiniMapTrackingIcon then
        MiniMapTrackingIcon:SetTexture(136460)
        local inHook = false
        hooksecurefunc(MiniMapTrackingIcon, "SetTexture", function(self, texture)
            if inHook then return end  -- Prevent recursion
            if texture ~= 136460 then
                inHook = true
                self:SetTexture(136460)
                inHook = false
            end
        end)
    end
end

---<===========================================================================================================>---<<AUX
SnugUI.loginTrigger(function()
    --C_Timer.After(0, applyMinimapStyle) --probably ditch if not needed. cant recall why I delayed them at recall
    --C_Timer.After(0, function()         --maybe before my loginqueue? idk.
    --    SnugUI.functions.applyMinimapScale()
    --end)
    applyMinimapStyle()
    SnugUI.functions.applyMinimapScale()
    table.insert(SnugUI.commitRegistry, function()
        SnugUI.functions.applyMinimapScale()
    end)
end)

SnugUI.loginTrigger(function()
    if not SnugUI.settings.minimap.lockTracker then return end
    lockMinimapTracker()
end)
