local _, zui = ...

local function CreateRectangle(name, parent, x, y)
    local f = CreateFrame("Frame", name, parent or UIParent)
    f:SetSize(zui.settings.anchorWidth, zui.settings.anchorHeight)
    f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
    f:SetFrameStrata("BACKGROUND")

    -- Background
    f.bg = f:CreateTexture(nil, "BACKGROUND")
    f.bg:SetAllPoints(true)
    f.bg:SetColorTexture(0, 0, 0, 0.25) -- Black, 30% opacity

    -- Border (using 4 textures for 1px border)
    local borderColor = {0, 0, 0, 1} -- Black, fully opaque

    -- Top
    f.top = f:CreateTexture(nil, "BORDER")
    f.top:SetColorTexture(unpack(borderColor))
    f.top:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    f.top:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    f.top:SetHeight(1)

    -- Bottom
    f.bottom = f:CreateTexture(nil, "BORDER")
    f.bottom:SetColorTexture(unpack(borderColor))
    f.bottom:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
    f.bottom:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
    f.bottom:SetHeight(1)

    -- Left
    f.left = f:CreateTexture(nil, "BORDER")
    f.left:SetColorTexture(unpack(borderColor))
    f.left:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    f.left:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
    f.left:SetWidth(1)

    -- Right
    f.right = f:CreateTexture(nil, "BORDER")
    f.right:SetColorTexture(unpack(borderColor))
    f.right:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    f.right:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
    f.right:SetWidth(1)

    return f
end
local function createAnchors()
    local w = zui.settings.anchorWidth
    local h = zui.settings.anchorHeight

    -- Create and anchor rightAnchor (bottom right of screen)
    zui.frames.rightAnchor = CreateRectangle("ZUIRightAnchor", UIParent)
    zui.frames.rightAnchor:ClearAllPoints()
    zui.frames.rightAnchor:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -1, 1)
    zui.frames.rightAnchor:SetSize(w, h)
    zui.frames.rightAnchor:EnableMouse(true)
    zui.frames.rightAnchor:SetMouseClickEnabled(false)

    -- Create and anchor leftAnchor (bottom left of screen)
    zui.frames.leftAnchor = CreateRectangle("ZUILeftAnchor", UIParent)
    zui.frames.leftAnchor:ClearAllPoints()
    zui.frames.leftAnchor:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1)
    zui.frames.leftAnchor:SetSize(w, h)
    zui.frames.leftAnchor:EnableMouse(true)
    zui.frames.leftAnchor:SetMouseClickEnabled(false)
end

local function updateAnchors()
    -- Safely grab settings (with sane defaults)
    local w = tonumber(zui.settings.anchorWidth) or 420
    local h = tonumber(zui.settings.anchorHeight) or 200

    -- Helper to update one anchor
    local function resize(anchor, point, relPoint, x, y)
        if not anchor then return end
        anchor:ClearAllPoints()
        anchor:SetPoint(point, UIParent, relPoint, x, y)
        anchor:SetSize(w, h)
    end

    -- Apply to left & right
    resize(zui.frames.leftAnchor,  "BOTTOMLEFT",  "BOTTOMLEFT",  1,  1)
    resize(zui.frames.rightAnchor, "BOTTOMRIGHT", "BOTTOMRIGHT", -1,  1)
end

zui.frames.BG = CreateFrame("Frame", "ZUI Settings", UIParent, "BackdropTemplate")
zui.frames.BG:SetSize(690, 420)
zui.frames.BG:SetPoint("CENTER")
zui.frames.BG:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
zui.frames.BG:SetBackdropColor(0, 0, 0, 0.6)
zui.frames.BG:SetMovable(true)
zui.frames.BG:EnableMouse(true)
zui.frames.BG:RegisterForDrag("LeftButton")
zui.frames.BG:SetScript("OnDragStart", zui.frames.BG.StartMoving)
zui.frames.BG:SetScript("OnDragStop", zui.frames.BG.StopMovingOrSizing)
zui.frames.BG:Hide()

-- Left and Right Panel Frames
zui.frames.leftBG = CreateFrame("Frame", nil, zui.frames.BG, "BackdropTemplate")
zui.frames.leftBG:SetSize(200, 358)
zui.frames.leftBG:SetPoint("TOPLEFT", zui.frames.BG, "TOPLEFT", 8, -20)
zui.frames.leftBG:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
zui.frames.leftBG:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

zui.frames.rightBG = CreateFrame("Frame", nil, zui.frames.BG, "BackdropTemplate")
zui.frames.rightBG:SetSize(472, 358)
zui.frames.rightBG:SetPoint("TOPRIGHT", zui.frames.BG, "TOPRIGHT", -8, -20)
zui.frames.rightBG:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
zui.frames.rightBG:SetBackdropColor(0.1, 0.1, 0.1, 0.8)

-- Predeclare right-side content panels
zui.panels.about = CreateFrame("Frame", nil, zui.frames.rightBG)
zui.panels.about:SetAllPoints()
zui.panels.about:Hide()

zui.panels.general = CreateFrame("Frame", nil, zui.frames.rightBG)
zui.panels.general:SetAllPoints()
zui.panels.general:Hide()

zui.panels.chat = CreateFrame("Frame", nil, zui.frames.rightBG)
zui.panels.chat:SetAllPoints()
zui.panels.chat:Hide()

zui.panels.profiles = CreateFrame("Frame", nil, zui.frames.rightBG)
zui.panels.profiles:SetAllPoints()
zui.panels.profiles:Hide()

zui.panels.details = CreateFrame("Frame", nil, zui.frames.rightBG)
zui.panels.details:SetAllPoints()
zui.panels.details:Hide()

zui.panels.prat = CreateFrame("Frame", nil, zui.frames.rightBG)
zui.panels.prat:SetAllPoints()
zui.panels.prat:Hide()

zui.panels.masque = CreateFrame("Frame", nil, zui.frames.rightBG)
zui.panels.masque:SetAllPoints()
zui.panels.masque:Hide()

-- Title Frame
local titleFrame = CreateFrame("Frame", nil, zui.frames.BG, "BackdropTemplate")
titleFrame:SetSize(100, 36)
titleFrame:SetPoint("TOP", zui.frames.BG, "TOP", 0, 18)
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

-- Sidebar Buttons
local sidebarLabels = { "About", "General", "Chat", "Profiles" }
local subLabels     = { "Details!", "Prat 3.0", "WeakAuras" }

local sidebarButtons = {}
local subButtons     = {}
local subVisible     = false

-- Map of panel names to their frames
local panelMap = {
    About     = zui.panels.about,
    General   = zui.panels.general,
    Chat      = zui.panels.chat,
    Profiles  = zui.panels.profiles,
    ["Details!"] = zui.panels.details,
    ["Prat 3.0"] = zui.panels.prat,
    WeakAuras    = zui.panels.masque,
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
local startY, spacing = -5, -28
local yOffset = startY

-- Create main sidebar buttons
for _, label in ipairs(sidebarLabels) do
    local btn = CreateFrame("Button", nil, zui.frames.leftBG)
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
    local btn = CreateFrame("Button", nil, zui.frames.leftBG)
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

zui.buttons.apply = CreateFrame("Button", nil, zui.frames.BG, "UIPanelButtonTemplate")
zui.buttons.apply:SetSize(100, 24)
zui.buttons.apply:SetPoint("BOTTOMLEFT", 10, 10)
zui.buttons.apply:SetText("Apply")

zui.buttons.reload = CreateFrame("Button", nil, zui.frames.BG, "UIPanelButtonTemplate")
zui.buttons.reload:SetSize(100, 24)
zui.buttons.reload:SetPoint("LEFT", zui.buttons.apply, "RIGHT", 10, 0)
zui.buttons.reload:SetText("Reload UI")

zui.buttons.close = CreateFrame("Button", nil, zui.frames.BG, "UIPanelButtonTemplate")
zui.buttons.close:SetSize(100, 24)
zui.buttons.close:SetPoint("BOTTOMRIGHT", -10, 10)
zui.buttons.close:SetText("Close")

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
    cfg.parent = zui.frames.BG
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
    cfg.parent = zui.frames.BG
    AddCornerPiece(cfg)
end
---<<===================================================================================================== General Panel
local l = zui.panels.general:CreateFontString(nil, "OVERLAY", "GameFontNormal")
l:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
l:SetPoint("TOP", 0, -16)
l:SetText("Anchor Dimensions")

local l = zui.panels.general:CreateFontString(nil, "OVERLAY", "GameFontNormal")
l:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
l:SetPoint("TOP", 0, -116)
l:SetText("Anchor Content")

local l = zui.panels.general:CreateFontString(nil, "OVERLAY", "GameFontNormal")
l:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
l:SetPoint("TOP", 0, -216)
l:SetText("Minimap Style")

---<<===================================================================================================== init on login
local f = CreateFrame("Frame") --- this is for very special boys and girls that throw fits if you take their toys
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    createAnchors()
end)

---<<========================================================================== zui.commitRegistry Function Registration
zui.loginTrigger(function()
        table.insert(zui.commitRegistry, updateAnchors)
end)