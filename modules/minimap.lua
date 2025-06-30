local _, zui = ...

-- Formats the minimap to be similarly styled to ZUI
local function ZUIMinimapFormat()
    Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
    Minimap:SetScale(1.40625)

    -- Add a 1px black border around the minimap
    local border = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
    border:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -0.5, 0.5)
    border:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0.5, -0.5)
    border:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 0.5,
    })
    border:SetBackdropBorderColor(0, 0, 0, 1)
    border:SetFrameStrata("LOW")

    -- Hide Unwanted Minimap Elements
    local toHide = {
        MinimapBorder,
        MinimapBorderTop,
        MinimapZoneTextButton,
        MinimapZoneText,
        MinimapZoomIn,
        MinimapZoomOut,
        MiniMapTrackingButtonBorder,
        MiniMapTrackingBackground,
    }
    for _, frame in ipairs(toHide) do
        if frame then frame:Hide() end
    end

    -- Hide world map button safely (waits until it exists)
    local waitFrame = CreateFrame("Frame")
    waitFrame:SetScript("OnUpdate", function(self)
        local btn = _G["MiniMapWorldMapButton"]
        if btn then
            btn:Hide()
            self:SetScript("OnUpdate", nil)
        end
    end)

    -- Reposition minimap cluster
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -30, 15)

    -- Move GameTimeFrame to the top right of the minimap
    if GameTimeFrame then
        GameTimeFrame:ClearAllPoints()
        GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
    end

    -- Quest Tracker (WatchFrame)
    if WatchFrame then
        WatchFrame:ClearAllPoints()
        WatchFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 20, -20)
        WatchFrame:SetClampedToScreen(true)
        WatchFrame:SetMovable(true)
        WatchFrame:SetUserPlaced(true)
    end
end

local function ZUIMinimapClock()
        if TimeManagerClockButton then
        TimeManagerClockButton:ClearAllPoints()
        TimeManagerClockButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -15, -8)

        -- Remove background textures
        for i = 1, TimeManagerClockButton:GetNumRegions() do
            local region = select(i, TimeManagerClockButton:GetRegions())
            if region and region:GetObjectType() == "Texture" then
                region:SetTexture(nil)
            end
        end

        if TimeManagerClockTicker then
            TimeManagerClockTicker:SetScale(1.1)
        end
    end
end

-- forces the tracking icon to always be the magnifying glass
local function ZUIMinimapTracker()
    if MiniMapTracking then
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 6, -7)
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
end

local function ZUIMinimapHooks() -- thought Id have more than one haha
    hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function() -- Repositions buff frame
        BuffFrame:ClearAllPoints()
        BuffFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPLEFT", 0, -29)
    end)

end

local function applyMinimapStyle()
    local style = zui.settings.minimapStyle
    if style == "ZUI" then
        ZUIMinimapFormat()
        ZUIMinimapClock()
        ZUIMinimapHooks()
        ZUIMinimapTracker()
    elseif style == "Blizzard" then
        Minimap:SetMaskTexture("interface\\masks\\circlemaskscalable")
        Minimap:SetScale(1)
    end
end

---<===========================================================================================================>---<<AUX
zui.loginTrigger(function()
    -- Initialization
    applyMinimapStyle()
end)