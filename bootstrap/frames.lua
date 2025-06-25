-- frames.lua - contains only frame creation and layout, no logic

if not ZUISettings or not ZUISettings.anchorAssignments then
    error("ZUISettings or ZUISettings.anchorAssignments not initialized! Make sure init.lua runs first.")
end

ZUISettingsFrame = CreateFrame("Frame", "ZUISettingsFrame", UIParent, "BackdropTemplate")
ZUISettingsFrame:SetSize(690, 420)
ZUISettingsFrame:SetPoint("CENTER")
ZUISettingsFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
ZUISettingsFrame:SetBackdropColor(0, 0, 0, 0.6)
ZUISettingsFrame:SetMovable(true)
ZUISettingsFrame:EnableMouse(true)
ZUISettingsFrame:RegisterForDrag("LeftButton")
ZUISettingsFrame:SetScript("OnDragStart", ZUISettingsFrame.StartMoving)
ZUISettingsFrame:SetScript("OnDragStop", ZUISettingsFrame.StopMovingOrSizing)
ZUISettingsFrame:Hide()

-- Left and Right Panel Frames
ZUISLeft = CreateFrame("Frame", nil, ZUISettingsFrame, "BackdropTemplate")
ZUISLeft:SetSize(200, 358)
ZUISLeft:SetPoint("TOPLEFT", ZUISettingsFrame, "TOPLEFT", 8, -20)
ZUISLeft:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
ZUISLeft:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

ZUISRight = CreateFrame("Frame", nil, ZUISettingsFrame, "BackdropTemplate")
ZUISRight:SetSize(472, 358)
ZUISRight:SetPoint("TOPRIGHT", ZUISettingsFrame, "TOPRIGHT", -8, -20)
ZUISRight:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
ZUISRight:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

-- Predeclare right-side content panels
ZUISRight_AboutPanel = CreateFrame("Frame", "ZUISRight_AboutPanel", ZUISRight)
ZUISRight_AboutPanel:SetAllPoints()
ZUISRight_AboutPanel:Hide()

ZUISRight_GeneralPanel = CreateFrame("Frame", "ZUISRight_GeneralPanel", ZUISRight)
ZUISRight_GeneralPanel:SetAllPoints()
ZUISRight_GeneralPanel:Hide()

ZUISRight_ChatPanel = CreateFrame("Frame", "ZUISRight_ChatPanel", ZUISRight)
ZUISRight_ChatPanel:SetAllPoints()
ZUISRight_ChatPanel:Hide()

ZUISRight_ProfilesPanel = CreateFrame("Frame", "ZUISRight_ProfilesPanel", ZUISRight)
ZUISRight_ProfilesPanel:SetAllPoints()
ZUISRight_ProfilesPanel:Hide()

ZUIProfiles_DetailsPanel = CreateFrame("Frame", "ZUIProfiles_DetailsPanel", ZUISRight)
ZUIProfiles_DetailsPanel:SetAllPoints()
ZUIProfiles_DetailsPanel:Hide()

ZUIProfiles_PratPanel = CreateFrame("Frame", "ZUIProfiles_PratPanel", ZUISRight)
ZUIProfiles_PratPanel:SetAllPoints()
ZUIProfiles_PratPanel:Hide()

ZUIProfiles_MasquePanel = CreateFrame("Frame", "ZUIProfiles_MasquePanel", ZUISRight)
ZUIProfiles_MasquePanel:SetAllPoints()
ZUIProfiles_MasquePanel:Hide()

-- Title Frame
local titleFrame = CreateFrame("Frame", nil, ZUISettingsFrame, "BackdropTemplate")
titleFrame:SetSize(100, 36)
titleFrame:SetPoint("TOP", ZUISettingsFrame, "TOP", 0, 18)
local texMid = titleFrame:CreateTexture(nil, "OVERLAY")
texMid:SetTexture("interface/framegeneral/uiframediamondmetalheader2x")
texMid:SetTexCoord(0, 0.5, 0.00390625, 0.30859375)
texMid:SetSize(36, 39)
texMid:SetPoint("CENTER", titleFrame, "CENTER")
local texLeft = titleFrame:CreateTexture(nil, "OVERLAY")
texLeft:SetTexture("interface/framegeneral/uiframediamondmetalheader2x")
texLeft:SetTexCoord(0.0078125, 0.5078125, 0.31640625, 0.62109375)
texLeft:SetSize(32, 39)
texLeft:SetPoint("LEFT", titleFrame, "LEFT", 0, 0)
local texRight = titleFrame:CreateTexture(nil, "OVERLAY")
texRight:SetTexture("interface/framegeneral/uiframediamondmetalheader2x")
texRight:SetTexCoord(0.0078125, 0.5078125, 0.62890625, 0.93359375)
texRight:SetSize(32, 39)
texRight:SetPoint("RIGHT", titleFrame, "RIGHT", 0, 0)

titleFrame:SetBackdropColor(1, 0.1, 0.1, 0.9)
local label = titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
label:SetPoint("CENTER")
label:SetText("ZUI Settings")




--local sidebarLabels = { "About", "General", "Chat", "Profiles" }
--local sidebarButtons = {}
--local subButtons = {}
--local subVisible = false
--local startY = -30
--local spacing = -28
--local currentYOffset = startY
--
--local function ClearSidebarHighlights()
--    for _, b in pairs(sidebarButtons) do
--        if b.highlight then b.highlight:Hide() end
--    end
--    for _, b in ipairs(subButtons) do
--        if b.highlight then b.highlight:Hide() end
--    end
--end
--
--local function ToggleSubButtons()
--    subVisible = not subVisible
--    for _, btn in ipairs(subButtons) do
--        btn:SetShown(subVisible)
--    end
--    local symbol = subVisible and "−" or "+"
--    sidebarButtons["Profiles"].toggleText:SetText(symbol)
--end
--
--local function ShowPanel(name)
--    -- Hide all main panels
--    ZUISRight_AboutPanel:Hide()
--    ZUISRight_GeneralPanel:Hide()
--    ZUISRight_ChatPanel:Hide()
--    ZUISRight_ProfilesPanel:Hide()
--
--    -- Hide all sub-panels too
--    ZUIProfiles_DetailsPanel:Hide()
--    ZUIProfiles_PratPanel:Hide()
--    ZUIProfiles_MasquePanel:Hide()
--
--    -- Show selected
--    if name == "About" then
--        ZUISRight_AboutPanel:Show()
--    elseif name == "General" then
--        ZUISRight_GeneralPanel:Show()
--    elseif name == "Chat" then
--        ZUISRight_ChatPanel:Show()
--    elseif name == "Profiles" then
--        ZUISRight_ProfilesPanel:Show()
--    elseif name == "Details!" then
--        --ZUISRight_ProfilesPanel:Show()
--        ZUIProfiles_DetailsPanel:Show()
--    elseif name == "Prat 3.0" then
--        --ZUISRight_ProfilesPanel:Show()
--        ZUIProfiles_PratPanel:Show()
--    elseif name == "Masque" then
--        --ZUISRight_ProfilesPanel:Show()
--        ZUIProfiles_MasquePanel:Show()
--    end
--end
--
--
--for _, label in ipairs(sidebarLabels) do
--    local btn = CreateFrame("Button", nil, ZUISLeft)
--    btn:SetSize(180, 24)
--    btn:SetPoint("TOPLEFT", 10, currentYOffset)
--    -- HiglightWrapper
--    local highlightWrapper = CreateFrame("Frame", nil, btn)
--    highlightWrapper:SetPoint("TOPLEFT", -4, 0)
--    highlightWrapper:SetPoint("BOTTOMRIGHT", 4, 0)
--    highlightWrapper:SetClipsChildren(true)
--    -- Highlight
--    local highlight = highlightWrapper:CreateTexture(nil, "BACKGROUND")
--    highlight:SetPoint("TOPLEFT", -20, 0)
--    highlight:SetPoint("BOTTOMRIGHT", 20, 0)
--    highlight:SetTexture("interface/common/search")
--    highlight:SetTexCoord(0.001953125, 0.248046875, 0.6171875, 0.828125)
--    highlight:SetAlpha(.7)
--    highlight:Hide()
--    btn.highlight = highlight
--
--    -- Label
--    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--    text:SetPoint("LEFT", btn, "LEFT", 4, 0)
--    text:SetText(label)
--    btn.text = text
--
--    if label == "Profiles" then
--        local toggle = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--        toggle:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
--        toggle:SetText("+")
--        btn.toggleText = toggle
--
--        btn:SetScript("OnClick", function()
--            ClearSidebarHighlights()
--            btn.highlight:Show()
--            ToggleSubButtons()
--        end)
--    else
--        btn:SetScript("OnClick", function()
--            ClearSidebarHighlights()
--            btn.highlight:Show()
--            print("ZUI Sidebar clicked:", label)
--            ShowPanel(label)
--        end)
--    end
--
--    btn:SetScript("OnEnter", function()
--        text:SetTextColor(1, 1, 1)
--    end)
--    btn:SetScript("OnLeave", function()
--        text:SetTextColor(1, 0.82, 0)
--    end)
--
--    sidebarButtons[label] = btn
--    currentYOffset = currentYOffset + spacing
--end
--
--
---- Sub-buttons under "Profiles"
--local subLabels = { "Details!", "Prat 3.0", "Masque" }
--for _, label in ipairs(subLabels) do
--    local btn = CreateFrame("Button", nil, ZUISLeft)
--    btn:SetSize(160, 22)
--    btn:SetPoint("TOPLEFT", 20, currentYOffset)
--    btn:SetShown(false)
--
--    -- Highlight
--    local highlight = btn:CreateTexture(nil, "BACKGROUND")
--    highlight:SetAllPoints()
--    highlight:SetTexture("interface/garrison/garrisonmissionui1")
--    highlight:SetTexCoord(0.001953125, 0.783203125, 0.6513671875, 0.7001953125)
--    highlight:SetAlpha(0.8)
--    highlight:Hide()
--    btn.highlight = highlight
--
--    -- Label
--    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
--    text:SetPoint("LEFT", btn, "LEFT", 8, 0)
--    text:SetText(label)
--    --text:SetTextColor(1, 1, 1, 1)
--    btn.text = text
--
--    btn:SetScript("OnClick", function()
--        ClearSidebarHighlights()
--        btn.highlight:Show()
--        print("ZUI Sub clicked:", label)
--        ShowPanel(label)
--    end)
--
--    btn:SetScript("OnEnter", function()
--        text:SetTextColor(1, 1, 1)
--    end)
--    btn:SetScript("OnLeave", function()
--        text:SetTextColor(1, 0.82, 0)
--    end)
--
--    table.insert(subButtons, btn)
--    currentYOffset = currentYOffset + spacing
--end

local sidebarLabels = { "About", "General", "Chat", "Profiles" }
local subLabels     = { "Details", "Prat 3.0", "Masque" }

local sidebarButtons = {}
local subButtons     = {}
local subVisible     = false

-- Map of panel names to their frames
local panelMap = {
    About     = ZUISRight_AboutPanel,
    General   = ZUISRight_GeneralPanel,
    Chat      = ZUISRight_ChatPanel,
    Profiles  = ZUISRight_ProfilesPanel,
    Details = ZUIProfiles_DetailsPanel,
    ["Prat 3.0"] = ZUIProfiles_PratPanel,
    Masque    = ZUIProfiles_MasquePanel,
}

-- Utility to hide highlights on a set of buttons
local function HideHighlights(buttons)
    for _, btn in pairs(buttons) do
        if btn.highlight then btn.highlight:Hide() end
    end
end

-- Clear all sidebar and sub-button highlights
local function ClearSidebarHighlights()
    HideHighlights(sidebarButtons)
    HideHighlights(subButtons)
end

-- Show only the selected panel
local function ShowPanel(name)
    for _, panel in pairs(panelMap) do
        panel:Hide()
    end
    if panelMap[name] then
        panelMap[name]:Show()
    end
end

-- Toggle visibility of sub-buttons under Profiles
local function ToggleSubButtons()
    subVisible = not subVisible
    for _, btn in ipairs(subButtons) do
        btn:SetShown(subVisible)
    end
    sidebarButtons["Profiles"].toggleText:SetText(subVisible and "−" or "+")
end

-- Sidebar layout parameters
local startY, spacing = -30, -28
local yOffset = startY

-- Create main sidebar buttons
for _, label in ipairs(sidebarLabels) do
    local btn = CreateFrame("Button", nil, ZUISLeft)
    btn:SetSize(180, 24)
    btn:SetPoint("TOPLEFT", 10, yOffset)

    -- Highlight wrapper and texture
    local wrapper = CreateFrame("Frame", nil, btn)
    wrapper:SetPoint("TOPLEFT", -4, 0)
    wrapper:SetPoint("BOTTOMRIGHT", 4, 0)
    wrapper:SetClipsChildren(true)

    local highlight = wrapper:CreateTexture(nil, "BACKGROUND")
    highlight:SetPoint("TOPLEFT", -20, 0)
    highlight:SetPoint("BOTTOMRIGHT", 20, 0)
    highlight:SetTexture("interface/common/search")
    highlight:SetTexCoord(0.001953125, 0.248046875, 0.6171875, 0.828125)
    highlight:SetAlpha(0.7)
    highlight:Hide()
    btn.highlight = highlight

    -- Button label
    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("LEFT", 4, 0)
    text:SetText(label)
    btn.text = text

    -- Profiles toggle indicator
    if label == "Profiles" then
        local toggle = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        toggle:SetPoint("RIGHT", -4, 0)
        toggle:SetText("+")
        btn.toggleText = toggle

        btn:SetScript("OnClick", function()
            ClearSidebarHighlights()
            btn.highlight:Show()
            ToggleSubButtons()
        end)
    else
        btn:SetScript("OnClick", function()
            ClearSidebarHighlights()
            btn.highlight:Show()
            print("ZUI Sidebar clicked:", label)
            ShowPanel(label)
        end)
    end

    btn:SetScript("OnEnter", function() text:SetTextColor(1, 1, 1) end)
    btn:SetScript("OnLeave", function() text:SetTextColor(1, 0.82, 0) end)

    sidebarButtons[label] = btn
    yOffset = yOffset + spacing
end

-- Create sub-buttons under Profiles
for _, label in ipairs(subLabels) do
    local btn = CreateFrame("Button", nil, ZUISLeft)
    btn:SetSize(160, 22)
    btn:SetPoint("TOPLEFT", 20, yOffset)
    btn:Hide()

    local highlight = btn:CreateTexture(nil, "BACKGROUND")
    highlight:SetAllPoints()
    highlight:SetTexture("interface/garrison/garrisonmissionui1")
    highlight:SetTexCoord(0.001953125, 0.783203125, 0.6513671875, 0.7001953125)
    highlight:SetAlpha(0.8)
    highlight:Hide()
    btn.highlight = highlight

    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("LEFT", 8, 0)
    text:SetText(label)
    btn.text = text

    btn:SetScript("OnClick", function()
        ClearSidebarHighlights()
        btn.highlight:Show()
        print("ZUI Sub clicked:", label)
        ShowPanel(label)
    end)

    btn:SetScript("OnEnter", function() text:SetTextColor(1, 1, 1) end)
    btn:SetScript("OnLeave", function() text:SetTextColor(1, 0.82, 0) end)

    table.insert(subButtons, btn)
    yOffset = yOffset + spacing
end





























-- Bottom Buttons
ZUIButton_Apply = CreateFrame("Button", "ZUIButton_Apply", ZUISettingsFrame, "UIPanelButtonTemplate")
ZUIButton_Apply:SetSize(100, 24)
ZUIButton_Apply:SetPoint("BOTTOMLEFT", 10, 10)
ZUIButton_Apply:SetText("Apply")

ZUIButton_Reload = CreateFrame("Button", "ZUIButton_Reload", ZUISettingsFrame, "UIPanelButtonTemplate")
ZUIButton_Reload:SetSize(100, 24)
ZUIButton_Reload:SetPoint("LEFT", ZUIButton_Apply, "RIGHT", 10, 0)
ZUIButton_Reload:SetText("Reload UI")

ZUIButton_Close = CreateFrame("Button", "ZUIButton_Close", ZUISettingsFrame, "UIPanelButtonTemplate")
ZUIButton_Close:SetSize(100, 24)
ZUIButton_Close:SetPoint("BOTTOMRIGHT", -10, 10)
ZUIButton_Close:SetText("Close")

-- Universal border piece creator
local function AddBorderPiece(config)
    local tex = config.parent:CreateTexture(nil, config.layer or "BORDER")
    tex:SetTexture(config.texture)
    tex:SetTexCoord(unpack(config.texCoord))

    tex:SetPoint(config.pointA, config.parent, config.pointA, config.offsetAX or 0, config.offsetAY or 0)
    tex:SetPoint(config.pointB, config.parent, config.pointB, config.offsetBX or 0, config.offsetBY or 0)

    if config.width then tex:SetWidth(config.width) end
    if config.height then tex:SetHeight(config.height) end
    if config.rotation then tex:SetRotation(config.rotation) end
    if config.alpha then tex:SetAlpha(config.alpha) end
    return tex
end

-- Universal corner creator
local function AddCornerPiece(cfg)
    local tex = cfg.parent:CreateTexture(nil, cfg.layer or "ARTWORK")
    tex:SetTexture(cfg.texture)
    tex:SetTexCoord(unpack(cfg.texCoord))
    local offset = cfg.outset or 0
    local x = (cfg.offsetX or 0) + (cfg.point:find("LEFT") and -offset or offset)
    local y = (cfg.offsetY or 0) + (cfg.point:find("TOP") and offset or -offset)
    tex:SetPoint(cfg.point, cfg.parent, cfg.point, x, y)
    tex:SetSize(cfg.size, cfg.size)
    if cfg.rotation then tex:SetRotation(cfg.rotation) end
    return tex
end

-- Add border and corners to settings frame
local borderConfig = {
    top = {
        texture = "interface/framegeneral/uiframediamondmetal",
        texCoord = { 0, 0.5, 0.13671875, 0.26171875 },
        pointA = "TOPLEFT",
        pointB = "TOPRIGHT",
        height = 32,
        offsetAY = 8,
    },
    bottom = {
        texture = "interface/framegeneral/uiframediamondmetal",
        texCoord = { 0, 0.5, 0.00390625, 0.12890625 },
        pointA = "BOTTOMLEFT",
        pointB = "BOTTOMRIGHT",
        height = 32,
        offsetAY = -8,
    },
    left = {
        texture = "interface/framegeneral/uiframediamondmetalvertical",
        texCoord = { 0.0078125, 0.2578125, 0, 1 },
        pointA = "TOPLEFT",
        pointB = "BOTTOMLEFT",
        width = 32,
        offsetAX = -8,
    },
    right = {
        texture = "interface/framegeneral/uiframediamondmetalvertical",
        texCoord = { 0.2734375, 0.5234375, 0, 1 },
        pointA = "TOPRIGHT",
        pointB = "BOTTOMRIGHT",
        width = 32,
        offsetAX = 8,
    },
}
for _, cfg in pairs(borderConfig) do
    cfg.parent = ZUISettingsFrame
    AddBorderPiece(cfg)
end

local cornerConfig = {
    topleft = {
        texture = "interface/framegeneral/uiframediamondmetal",
        texCoord = { 0.015625, 0.515625, 0.53515625, 0.66015625 },
        point = "TOPLEFT",
        size = 32,
        outset = 8,
    },
    topright = {
        texture = "interface/framegeneral/uiframediamondmetal",
        texCoord = { 0.015625, 0.515625, 0.66796875, 0.79296875 },
        point = "TOPRIGHT",
        size = 32,
        outset = 8,
    },
    bottomleft = {
        texture = "interface/framegeneral/uiframediamondmetal",
        texCoord = { 0.015625, 0.515625, 0.26953125, 0.39453125 },
        point = "BOTTOMLEFT",
        size = 32,
        outset = 8,
    },
    bottomright = {
        texture = "interface/framegeneral/uiframediamondmetal",
        texCoord = { 0.015625, 0.515625, 0.40234375, 0.52734375 },
        point = "BOTTOMRIGHT",
        size = 32,
        outset = 8,
    },
}
for _, cfg in pairs(cornerConfig) do
    cfg.parent = ZUISettingsFrame
    AddCornerPiece(cfg)
end