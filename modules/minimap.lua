-- Minimap Customization Addon

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function()
    ------------------------------------------------------------------------
    -- Minimap Appearance
    ------------------------------------------------------------------------
    -- Make the minimap square
    Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")

    -- Scale up the minimap
    Minimap:SetScale(1.40625)

    -- Add a 1px black border around the minimap
    local border = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
    border:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -0.5, 0.5)
    border:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0.5, -0.5)
    border:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8", -- That is the name of the texture, not a color, color is changed elsewhere
        edgeSize = 0.5,
    })
    border:SetBackdropBorderColor(0, 0, 0, 1)
    border:SetFrameStrata("LOW")

    ------------------------------------------------------------------------
    -- Hide Unwanted Minimap Elements
    ------------------------------------------------------------------------
    if MinimapBorder then MinimapBorder:Hide() end
    if MinimapBorderTop then MinimapBorderTop:Hide() end
    if MinimapZoneTextButton then MinimapZoneTextButton:Hide() end
    if MinimapZoneText then MinimapZoneText:Hide() end
    if MinimapZoomIn then MinimapZoomIn:Hide() end
    if MinimapZoomOut then MinimapZoomOut:Hide() end
    if MiniMapTrackingButtonBorder then MiniMapTrackingButtonBorder:Hide() end
    if MiniMapTrackingBackground then MiniMapTrackingBackground:Hide() end

    -- Hide world map button safely (waits until it exists)
    local waitFrame = CreateFrame("Frame")
    waitFrame:SetScript("OnUpdate", function(self)
        local btn = _G["MiniMapWorldMapButton"]
        if btn then
            btn:Hide()
            self:SetScript("OnUpdate", nil)
        end
    end)

    ------------------------------------------------------------------------
    -- Reposition Minimap and Related Frames
    ------------------------------------------------------------------------
    -- Reposition minimap cluster
    MinimapCluster:ClearAllPoints()
    MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -30, 15)

    -- Move GameTimeFrame to the top right of the minimap
    if GameTimeFrame then
        GameTimeFrame:ClearAllPoints()
        GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
    end

    -- Persistently reposition BuffFrame using hooksecurefunc
    hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
        BuffFrame:ClearAllPoints()
        BuffFrame:SetPoint("TOPRIGHT", MinimapCluster, "TOPLEFT", 0, -29)
    end)

    -- Reposition tracking button
    if MiniMapTracking then
        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 6, -7)
        -- Lock MiniMapTrackingIcon to magnifying glass (file ID 136460)
        if MiniMapTrackingIcon then
            MiniMapTrackingIcon:SetTexture(136460)
            hooksecurefunc(MiniMapTrackingIcon, "SetTexture", function(self)
                self:SetTexture(136460)
            end)
        end
    end

    -- Time Manager Clock Button adjustments
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

        -- Scale up the clock text
        TimeManagerClockTicker:SetScale(1.1)
    end

    -- Quest Tracker (WatchFrame)
    C_Timer.After(0.1, function()
        if WatchFrame and Minimap then
            WatchFrame:ClearAllPoints()
            WatchFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 20, -20)
            WatchFrame:SetClampedToScreen(true) -- Optional
            WatchFrame:SetMovable(true)
            WatchFrame:SetUserPlaced(true)
        else
        end
    end)
end)