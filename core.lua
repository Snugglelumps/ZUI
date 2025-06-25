if not ZUISettings or not ZUISettings.anchorAssignments then
    error("ZUISettings or ZUISettings.anchorAssignments not initialized! Make sure init.lua runs first.")
end





-- Bottom button logic
ZUIButton_Apply:SetScript("OnClick", function()
    print("[ZUI] Apply button clicked.")
    -- Hook for applying settings if needed
end)

ZUIButton_Reload:SetScript("OnClick", function()
    ReloadUI()
end)

ZUIButton_Close:SetScript("OnClick", function()
    ZUISettingsFrame:Hide()
end)







-- modules/details_panel.lua
-- Extracted population logic for the "Details!" export panel

local panel = ZUIProfiles_DetailsPanel

-- Header label
local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("TOPLEFT", 16, -16)
header:SetText("Use the string below to import the ZUI profile for Details!")

-- ScrollFrame container
local scrollFrame = CreateFrame("ScrollFrame", "ZUIDetailsExportScroll", panel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 16, -48)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 16)

-- Backdrop around scroll area
local bg = CreateFrame("Frame", nil, scrollFrame, "BackdropTemplate")
bg:SetPoint("TOPLEFT", -4, 4)
bg:SetPoint("BOTTOMRIGHT", 4, -4)
bg:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
bg:SetBackdropColor(0, 0, 0, 0.4)
bg:SetBackdropBorderColor(1, 1, 1, 0.6)

-- EditBox for export string
local exportBox = CreateFrame("EditBox", "ZUIDetailsExportBox", scrollFrame)
exportBox:SetMultiLine(true)
exportBox:SetFontObject("GameFontHighlightSmall")
exportBox:SetWidth(400)
exportBox:SetAutoFocus(false)
exportBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
exportBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
exportBox:SetScript("OnTextChanged", function(self)
    scrollFrame:UpdateScrollChildRect()
end)

scrollFrame:SetScrollChild(exportBox)
exportBox:SetText(Details_Profile or "No export data found.")

















function ZUICommitSettings()
    for _, callback in ipairs(ZUICommitRegistry) do
        if type(callback) == "function" then
            pcall(callback)
        end
    end
end

-- Slash command
SLASH_ZUI1 = "/zui"
SlashCmdList["ZUI"] = function()
    if ZUISettingsFrame:IsShown() then
        ZUISettingsFrame:Hide()
    else
        ZUISettingsFrame:Show()
    end
end

-- Auto-open on login if Debug is enabled
local debugFrame = CreateFrame("Frame")
debugFrame:RegisterEvent("PLAYER_LOGIN")
debugFrame:SetScript("OnEvent", function()
    C_Timer.After(0.1, function()
        if ZUISettings and ZUISettings.DebugMode then
            ZUISettingsFrame:Show()
        end
    end)
end)

-- Anchor Size Logic
local function UpdateAnchorSize()
    local w = tonumber(_G["ZUIAnchorWidthBox"] and ZUIAnchorWidthBox:GetText())
    local h = tonumber(_G["ZUIAnchorHeightBox"] and ZUIAnchorHeightBox:GetText())
    if w and h and w > 0 and h > 0 then
        leftAnchor:SetSize(w, h)
        rightAnchor:SetSize(w, h)
        ZUISettings.leftAnchorWidth = w
        ZUISettings.leftAnchorHeight = h
    end
end

local function RefreshSizeFields()
    if leftAnchor then
        local w = math.floor(leftAnchor:GetWidth() + 0.5)
        local h = math.floor(leftAnchor:GetHeight() + 0.5)
        if _G["ZUIAnchorWidthBox"] then ZUIAnchorWidthBox:SetText(w) end
        if _G["ZUIAnchorHeightBox"] then ZUIAnchorHeightBox:SetText(h) end
    end
end

-- Commit registration
do
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    ZUICommitRegistry = ZUICommitRegistry or {}
    table.insert(ZUICommitRegistry, UpdateAnchorSize)
    table.insert(ZUICommitRegistry, RefreshSizeFields)
end)
end