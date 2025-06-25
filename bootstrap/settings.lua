if not ZUISettings or not ZUISettings.anchorAssignments then
    error("ZUISettings or ZUISettings.anchorAssignments not initialized! Make sure init.lua runs first.")
end

function ZUICommitSettings()
    for _, callback in ipairs(ZUICommitRegistry) do
        if type(callback) == "function" then
            pcall(callback) -- safe call with error suppression
        end
    end
end
------------------------------------------------------------------------------------------------------------------------
--- ZUI Settings Frame
------------------------------------------------------------------------------------------------------------------------
local ZUISettingsFrame = CreateFrame("Frame", "ZUISettingsFrame", UIParent, "BackdropTemplate")
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
        offsetAX = -8,   -- trim in from left
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

-- Universal corner creator
local function AddCornerPiece(cfg)
    local tex = cfg.parent:CreateTexture(nil, cfg.layer or "ARTWORK")
    tex:SetTexture(cfg.texture)
    tex:SetTexCoord(unpack(cfg.texCoord))
    -- tex:SetPoint(cfg.point, cfg.parent, cfg.point, cfg.offsetX or 0, cfg.offsetY or 0)
    local offset = cfg.outset or 0
    local x = (cfg.offsetX or 0) + (cfg.point:find("LEFT") and -offset or offset)
    local y = (cfg.offsetY or 0) + (cfg.point:find("TOP") and offset or -offset)
    tex:SetPoint(cfg.point, cfg.parent, cfg.point, x, y)
    tex:SetSize(cfg.size, cfg.size)
    if cfg.rotation then tex:SetRotation(cfg.rotation) end
    return tex
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


local ZUISLeft = CreateFrame("Frame", nil, ZUISettingsFrame, "BackdropTemplate")
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

local ZUISRight = CreateFrame("Frame", nil, ZUISettingsFrame, "BackdropTemplate")
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

-- Bottom-left Apply Button
local applyButton = CreateFrame("Button", nil, ZUISettingsFrame, "UIPanelButtonTemplate")
applyButton:SetSize(100, 24)
applyButton:SetPoint("BOTTOMLEFT", 10, 10)
applyButton:SetText("Apply")
applyButton:SetScript("OnClick", ZUICommitSettings)

-- Bottom-left Reload UI Button (next to Apply)
local reloadButton = CreateFrame("Button", nil, ZUISettingsFrame, "UIPanelButtonTemplate")
reloadButton:SetSize(100, 24)
reloadButton:SetPoint("LEFT", applyButton, "RIGHT", 10, 0)
reloadButton:SetText("Reload UI")
reloadButton:SetScript("OnClick", ReloadUI)

-- Bottom-right Close UI Button
local closeButton = CreateFrame("Button", nil, ZUISettingsFrame, "UIPanelButtonTemplate")
closeButton:SetSize(100, 24)
closeButton:SetPoint("BOTTOMRIGHT", -10, 10)
closeButton:SetText("Close")
closeButton:SetScript("OnClick", function()
    ZUISettingsFrame:Hide()
end)

---- ScrollFrame inside content
--local scrollFrame = CreateFrame("ScrollFrame", nil, ZUISRight, "UIPanelScrollFrameTemplate")
--scrollFrame:SetPoint("TOPLEFT", ZUISRight, "TOPLEFT", 0, -8)
--scrollFrame:SetPoint("BOTTOMRIGHT", ZUISRight, "BOTTOMRIGHT", -28, 8)
------------------------------------------------------------------------------------------------------------------------
--- END ZUI Settings Frame
------------------------------------------------------------------------------------------------------------------------
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

local sidebarLabels = { "About", "General", "Chat", "Profiles" }
local sidebarButtons = {}
local subButtons = {}
local subVisible = false
local startY = -30
local spacing = -28
local currentYOffset = startY

local function ClearSidebarHighlights()
    for _, b in pairs(sidebarButtons) do
        if b.highlight then b.highlight:Hide() end
    end
    for _, b in ipairs(subButtons) do
        if b.highlight then b.highlight:Hide() end
    end
end

local function ToggleSubButtons()
    subVisible = not subVisible
    for _, btn in ipairs(subButtons) do
        btn:SetShown(subVisible)
    end
    local symbol = subVisible and "−" or "+"
    sidebarButtons["Profiles"].toggleText:SetText(symbol)
end

local function ShowPanel(name)
    -- Hide all main panels
    ZUISRight_AboutPanel:Hide()
    ZUISRight_GeneralPanel:Hide()
    ZUISRight_ChatPanel:Hide()
    ZUISRight_ProfilesPanel:Hide()

    -- Hide all sub-panels too
    ZUIProfiles_DetailsPanel:Hide()
    ZUIProfiles_PratPanel:Hide()
    ZUIProfiles_MasquePanel:Hide()

    -- Show selected
    if name == "About" then
        ZUISRight_AboutPanel:Show()
    elseif name == "General" then
        ZUISRight_GeneralPanel:Show()
    elseif name == "Chat" then
        ZUISRight_ChatPanel:Show()
    elseif name == "Profiles" then
        ZUISRight_ProfilesPanel:Show()
    elseif name == "Details!" then
        --ZUISRight_ProfilesPanel:Show()
        ZUIProfiles_DetailsPanel:Show()
    elseif name == "Prat 3.0" then
        --ZUISRight_ProfilesPanel:Show()
        ZUIProfiles_PratPanel:Show()
    elseif name == "Masque" then
        --ZUISRight_ProfilesPanel:Show()
        ZUIProfiles_MasquePanel:Show()
    end
end


for _, label in ipairs(sidebarLabels) do
    local btn = CreateFrame("Button", nil, ZUISLeft)
    btn:SetSize(180, 24)
    btn:SetPoint("TOPLEFT", 10, currentYOffset)
    -- HiglightWrapper
    local highlightWrapper = CreateFrame("Frame", nil, btn)
    highlightWrapper:SetPoint("TOPLEFT", -4, 0)
    highlightWrapper:SetPoint("BOTTOMRIGHT", 4, 0)
    highlightWrapper:SetClipsChildren(true)
    -- Highlight
    local highlight = highlightWrapper:CreateTexture(nil, "BACKGROUND")
    highlight:SetPoint("TOPLEFT", -20, 0)
    highlight:SetPoint("BOTTOMRIGHT", 20, 0)
    highlight:SetTexture("interface/common/search")
    highlight:SetTexCoord(0.001953125, 0.248046875, 0.6171875, 0.828125)
    highlight:SetAlpha(.7)
    highlight:Hide()
    btn.highlight = highlight

    -- Label
    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("LEFT", btn, "LEFT", 4, 0)
    text:SetText(label)
    btn.text = text

    if label == "Profiles" then
        local toggle = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        toggle:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
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

    btn:SetScript("OnEnter", function()
        text:SetTextColor(1, 1, 1)
    end)
    btn:SetScript("OnLeave", function()
        text:SetTextColor(1, 0.82, 0)
    end)

    sidebarButtons[label] = btn
    currentYOffset = currentYOffset + spacing
end

-- Sub-buttons under "Profiles"
local subLabels = { "Details!", "Prat 3.0", "Masque" }
for _, label in ipairs(subLabels) do
    local btn = CreateFrame("Button", nil, ZUISLeft)
    btn:SetSize(160, 22)
    btn:SetPoint("TOPLEFT", 20, currentYOffset)
    btn:SetShown(false)

    -- Highlight
    local highlight = btn:CreateTexture(nil, "BACKGROUND")
    highlight:SetAllPoints()
    highlight:SetTexture("interface/garrison/garrisonmissionui1")
    highlight:SetTexCoord(0.001953125, 0.783203125, 0.6513671875, 0.7001953125)
    highlight:SetAlpha(0.8)
    highlight:Hide()
    btn.highlight = highlight

    -- Label
    local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("LEFT", btn, "LEFT", 8, 0)
    text:SetText(label)
    --text:SetTextColor(1, 1, 1, 1)
    btn.text = text

    btn:SetScript("OnClick", function()
        ClearSidebarHighlights()
        btn.highlight:Show()
        print("ZUI Sub clicked:", label)
        ShowPanel(label)
    end)

    btn:SetScript("OnEnter", function()
        text:SetTextColor(1, 1, 1)
    end)
    btn:SetScript("OnLeave", function()
        text:SetTextColor(1, 0.82, 0)
    end)

    table.insert(subButtons, btn)
    currentYOffset = currentYOffset + spacing
end


------------------------------------------------------------------------------------------------------------------------
--- Content
------------------------------------------------------------------------------------------------------------------------
    ---------------------------------
    --- About Panel               ---
    ---------------------------------

local text = ZUISRight_AboutPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("TOPLEFT", 16, -16)
text:SetText("About Tab")

    ---------------------------------
    --- General Panel             ---
    ---------------------------------
ZUISRight_GeneralPanel:SetAllPoints()
ZUISRight_GeneralPanel:Hide()
local text = ZUISRight_GeneralPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("TOPLEFT", 16, -16)
text:SetText("General Tab")
                                                    --------------------------------------------------------------------
                                                    -- Anchor Size Configuration
                                                    --------------------------------------------------------------------
local widthLabel = ZUISRight_GeneralPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
widthLabel:SetPoint("TOPLEFT", 16, -16)
widthLabel:SetText("Width:")

local heightLabel = ZUISRight_GeneralPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
heightLabel:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 0, -18)
heightLabel:SetText("Height:")

local widthBox = CreateFrame("EditBox", nil, ZUISRight_GeneralPanel, "InputBoxTemplate")
widthBox:SetSize(80, 24)
widthBox:SetPoint("LEFT", widthLabel, "RIGHT", 8, 0)
widthBox:SetAutoFocus(false)
widthBox:SetNumeric(true)

local heightBox = CreateFrame("EditBox", nil, ZUISRight_GeneralPanel, "InputBoxTemplate")
heightBox:SetSize(80, 24)
heightBox:SetPoint("LEFT", heightLabel, "RIGHT", 8, 0)
heightBox:SetAutoFocus(false)
heightBox:SetNumeric(true)

local function UpdateAnchorSize()
    local w = tonumber(widthBox:GetText())
    local h = tonumber(heightBox:GetText())
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
        widthBox:SetText(w)
        heightBox:SetText(h)
    end
end

widthBox:SetScript("OnEnterPressed", function(self) UpdateAnchorSize() self:ClearFocus() end)
heightBox:SetScript("OnEnterPressed", function(self) UpdateAnchorSize() self:ClearFocus() end)
ZUISettingsFrame:HookScript("OnShow", RefreshSizeFields)

                                                    --------------------------------------------------------------------
                                                    -- Anchor Dropdowns (Left & Right Assignment)
                                                    --------------------------------------------------------------------
local anchorOptions = { "", "Chat", "Details!" }

local function CreateAnchorDropdown(parent, labelText, anchorKey, x, y)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", x, y)
    label:SetText(labelText)

    local dropdown = CreateFrame("Frame", "ZUIAnchorDropdown" .. anchorKey, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", label, "BOTTOMLEFT", -16, -4)

    -- Defensive fallback
    ZUISettings.anchorAssignments = ZUISettings.anchorAssignments or { left = "", right = "" }

    local function OnSelect(option)
        local otherKey = (anchorKey == "left") and "right" or "left"
        if ZUISettings.anchorAssignments[otherKey] == option then
            ZUISettings.anchorAssignments[otherKey] = ""
            local otherDrop = _G["ZUIAnchorDropdown" .. otherKey]
            if otherDrop then
                UIDropDownMenu_SetSelectedValue(otherDrop, "")
                _G[otherDrop:GetName().."Text"]:SetText("—")
            end
        end

        ZUISettings.anchorAssignments[anchorKey] = option
        UIDropDownMenu_SetSelectedValue(dropdown, option)
        _G[dropdown:GetName().."Text"]:SetText((option == "") and "—" or option)
    end

    UIDropDownMenu_Initialize(dropdown, function(_, level)
        for _, option in ipairs(anchorOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = (option == "") and "—" or option
            info.value = option
            info.checked = (ZUISettings.anchorAssignments[anchorKey] == option)
            info.func = function() OnSelect(option) end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    UIDropDownMenu_SetWidth(dropdown, 120)

    C_Timer.After(0, function()
        local selected = ZUISettings.anchorAssignments[anchorKey]
        if not tContains(anchorOptions, selected) then
            selected = ""
            ZUISettings.anchorAssignments[anchorKey] = ""
        end
        UIDropDownMenu_SetSelectedValue(dropdown, selected)
        _G[dropdown:GetName().."Text"]:SetText((selected == "") and "—" or selected)
    end)

    return dropdown
end

CreateAnchorDropdown(ZUISRight_GeneralPanel, "Left Anchor Content:", "left", 0, -130)
CreateAnchorDropdown(ZUISRight_GeneralPanel, "Right Anchor Content:", "right", 165, -130)

    ---------------------------------
    --- Chat Panel                ---
    ---------------------------------

-- Label for the EditBox
local widthLabel = ZUISRight_ChatPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
widthLabel:SetPoint("TOPLEFT", 20, -20)
widthLabel:SetText("Chat Width:")

-- EditBox for width setting
local widthBox = CreateFrame("EditBox", nil, ZUISRight_ChatPanel, "InputBoxTemplate")
widthBox:SetSize(80, 24)
widthBox:SetPoint("LEFT", widthLabel, "RIGHT", 8, 0)
widthBox:SetAutoFocus(false)
widthBox:SetNumeric(true)

    ---------------------------------
    --- Profiles Panel            ---
    ---------------------------------

local text = ZUISRight_ProfilesPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("TOPLEFT", 16, -16)
text:SetText("General Tab")

                                                    --------------------------------------------------------------------
                                                    --- Profiles Sub Panels
                                                    --------------------------------------------------------------------


local text = ZUIProfiles_DetailsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("TOPLEFT", 16, -16)
text:SetText("Use the string below to import the ZUI profile for Details!")
local scrollFrame = CreateFrame("ScrollFrame", nil, ZUIProfiles_DetailsPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 16, -48)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 16) -- leave room for scrollbar
local scrollFrameBackground = CreateFrame("ScrollFrame", nil, scrollFrame, "BackdropTemplate")
scrollFrameBackground:SetPoint("TOPLEFT", -4, 4)
scrollFrameBackground:SetPoint("BOTTOMRIGHT", 4, -4)
scrollFrameBackground:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
scrollFrameBackground:SetBackdropColor(0, 0, 0, 0.4)
scrollFrameBackground:SetBackdropBorderColor(1, 1, 1, 0.6) -- white border

local exportBox = CreateFrame("EditBox", nil, scrollFrame)
exportBox:SetMultiLine(true)
exportBox:SetFontObject("GameFontHighlightSmall")
exportBox:SetWidth(400) -- will auto-expand height
exportBox:SetAutoFocus(false)
exportBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
exportBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
exportBox:SetScript("OnTextChanged", function(self)
    scrollFrame:UpdateScrollChildRect()
end)

scrollFrame:SetScrollChild(exportBox)
exportBox:SetText(Details_Profile or "No export data found.")



local text = ZUIProfiles_PratPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("TOPLEFT", 16, -16)
text:SetText("Use the string below to import the ZUI profile for Prat 3.0:")
local scrollFrame = CreateFrame("ScrollFrame", nil, ZUIProfiles_PratPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 16, -48)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 16) -- leave room for scrollbar
local scrollFrameBackground = CreateFrame("ScrollFrame", nil, scrollFrame, "BackdropTemplate")
scrollFrameBackground:SetPoint("TOPLEFT", -4, 4)
scrollFrameBackground:SetPoint("BOTTOMRIGHT", 4, -4)
scrollFrameBackground:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
scrollFrameBackground:SetBackdropColor(0, 0, 0, 0.4)
scrollFrameBackground:SetBackdropBorderColor(1, 1, 1, 0.6) -- white border

local exportBox = CreateFrame("EditBox", nil, scrollFrame)
exportBox:SetMultiLine(true)
exportBox:SetFontObject("GameFontHighlightSmall")
exportBox:SetWidth(400) -- will auto-expand height
exportBox:SetAutoFocus(false)
exportBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
exportBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
exportBox:SetScript("OnTextChanged", function(self)
    scrollFrame:UpdateScrollChildRect()
end)

scrollFrame:SetScrollChild(exportBox)
exportBox:SetText(Prat_Profile or "No export data found.")


local text = ZUIProfiles_MasquePanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("TOPLEFT", 16, -16)
text:SetText("Use the string below to import the ZUI profile for Masque")
local scrollFrame = CreateFrame("ScrollFrame", nil, ZUIProfiles_MasquePanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 16, -48)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 16) -- leave room for scrollbar
local scrollFrameBackground = CreateFrame("ScrollFrame", nil, scrollFrame, "BackdropTemplate")
scrollFrameBackground:SetPoint("TOPLEFT", -4, 4)
scrollFrameBackground:SetPoint("BOTTOMRIGHT", 4, -4)
scrollFrameBackground:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
scrollFrameBackground:SetBackdropColor(0, 0, 0, 0.4)
scrollFrameBackground:SetBackdropBorderColor(1, 1, 1, 0.6) -- white border

local exportBox = CreateFrame("EditBox", nil, scrollFrame)
exportBox:SetMultiLine(true)
exportBox:SetFontObject("GameFontHighlightSmall")
exportBox:SetWidth(400) -- will auto-expand height
exportBox:SetAutoFocus(false)
exportBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
exportBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
exportBox:SetScript("OnTextChanged", function(self)
    scrollFrame:UpdateScrollChildRect()
end)

scrollFrame:SetScrollChild(exportBox)
exportBox:SetText(Masque_Profile or "No export data found.")


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

SLASH_ZUI1 = "/zui"
SlashCmdList["ZUI"] = function()
    if ZUISettingsFrame:IsShown() then
        ZUISettingsFrame:Hide()
    else
        ZUISettingsFrame:Show()
    end
end

------------------------------------------------------------------------------------------------------------------------
--- ZUICommitRegistry Function Registration
------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    ZUICommitRegistry = ZUICommitRegistry or {}

    -- Add the anchor update logic
    table.insert(ZUICommitRegistry, UpdateAnchorSize)
    table.insert(ZUICommitRegistry, RefreshSizeFields)
end)
