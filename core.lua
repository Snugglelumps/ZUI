local _, zui = ...

ZUISettings = ZUISettings or {}
zui.settings = ZUISettings

function ShowReloadUIIndicator()
    zui.settings.reloadUI = zui.settings.reloadUI or false
    if zui.settings.reloadUI then return end

    local reloadButton = zui.buttons.reload
    if not reloadButton then return end

    if not reloadButton.reloadNote then
        local note = reloadButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        note:SetPoint("LEFT", reloadButton, "RIGHT", 10, 0)
        note:SetText("|cffffcc00**Reload required|r")
        reloadButton.reloadNote = note
    end

    reloadButton.reloadNote:Show()

    zui.settings.reloadUI = true
end
---<<================================================================================================== anchorDimensions
local function initAnchorDimensions()
    local panel = zui.panels.general

    local widthInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    widthInput:SetSize(60, 20)
    widthInput:SetPoint("TOP", panel, "TOP", -69, -42)
    widthInput:SetAutoFocus(false)
    widthInput:SetNumeric(true)
    widthInput:SetText(tostring(zui.settings.anchorWidth))
    widthInput:SetScript("OnTextChanged", function(self)
        local value = tonumber(self:GetText())
        zui.settings.anchorWidth = value
    end)
    local widthLabel = widthInput:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("TOPLEFT", widthInput, "BOTTOMLEFT", 0, -4)
    widthLabel:SetText("Width")

    local heightInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    heightInput:SetSize(60, 20)
    heightInput:SetPoint("TOP", panel, "TOP", 69, -42)
    heightInput:SetAutoFocus(false)
    heightInput:SetNumeric(true)
    heightInput:SetText(tostring(zui.settings.anchorHeight))
    heightInput:SetScript("OnTextChanged", function(self)
        local value = tonumber(self:GetText())
        zui.settings.anchorHeight = value
    end)
    local heightLabel = heightInput:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", heightInput, "BOTTOMLEFT", 0, -4)
    heightLabel:SetText("Height")
end

---<<================================================================================================= anchorAssignments
local anchorOptions = { "", "Chat", "Details!" }

local function CreateAnchorDropdown(parent, key, x, y)

        local dropdown = CreateFrame("Frame", "ZUIAnchorDropdown" .. key, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOP", parent, "TOP", x, y)
    UIDropDownMenu_SetWidth(dropdown, 120)

    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, option in ipairs(anchorOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = (option == "") and "—" or option
            info.value = option
            info.checked = (zui.settings.anchorAssignments[key] == option)
            info.func = function(selfArg)
                -- Enforce unique assignment
                local otherKey = (key == "left") and "right" or "left"
                if zui.settings.anchorAssignments[otherKey] == selfArg.value then
                    zui.settings.anchorAssignments[otherKey] = ""
                    local otherDrop = _G["ZUIAnchorDropdown" .. otherKey]
                    if otherDrop then
                        UIDropDownMenu_SetSelectedValue(otherDrop, "")
                        _G[otherDrop:GetName().."Text"]:SetText("—")
                    end
                end

                -- Save and update
                zui.settings.anchorAssignments[key] = selfArg.value
                UIDropDownMenu_SetSelectedValue(dropdown, selfArg.value)
                _G[dropdown:GetName().."Text"]:SetText((selfArg.value == "") and "—" or selfArg.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    local value = zui.settings.anchorAssignments[key]
    if not tContains(anchorOptions, value) then
        value = ""
        zui.settings.anchorAssignments[key] = value
    end
    UIDropDownMenu_SetSelectedValue(dropdown, value)
    _G[dropdown:GetName().."Text"]:SetText((value == "") and "—" or value)

    return dropdown
end

local function initAnchorAssignments()
    CreateAnchorDropdown(zui.panels.general, "left", -100, -142)
    CreateAnchorDropdown(zui.panels.general, "right", 100, -142)
end

---<<================================================================================================== Minimap Settings

local minimapStyleOptions = { "ZUI", "Blizzard" }

local function initMinimapSettings()
    local panel = zui.panels.general

    local dropdown = CreateFrame("Frame", "ZUIMinimapStyleDropdown", panel, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOP", panel, "TOP", 0, -242)
    UIDropDownMenu_SetWidth(dropdown, 120)

    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, option in ipairs(minimapStyleOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option
            info.value = option
            info.checked = (zui.settings.minimapStyle == option)
            info.func = function(selfArg)
                zui.settings.minimapStyle = selfArg.value
                UIDropDownMenu_SetSelectedValue(dropdown, selfArg.value)
                _G[dropdown:GetName() .. "Text"]:SetText(selfArg.value)
                ShowReloadUIIndicator()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    local value = zui.settings.minimapStyle
    if not tContains(minimapStyleOptions, value) then
        value = "ZUI"
        zui.settings.minimapStyle = value
    end
    UIDropDownMenu_SetSelectedValue(dropdown, value)
    _G[dropdown:GetName() .. "Text"]:SetText(value)
end

---<<===================================================================================================== Chat Settings
local tabOptions = { "ZUI", "Blizzard" }
local function CreateTabSystemDropdown()
    local panel = zui.panels.chat

    local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", 16, -16)
    label:SetText("Tab System:")

    local dropdown = CreateFrame("Frame", "ZUITabSystemDropdown", panel, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", label, "BOTTOMLEFT", -16, -4)
    UIDropDownMenu_SetWidth(dropdown, 120)

    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, option in ipairs(tabOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option
            info.value = option
            info.checked = (zui.settings.tabSystem == option)
            info.func = function(selfArg)
                zui.settings.tabSystem = selfArg.value
                UIDropDownMenu_SetSelectedValue(dropdown, selfArg.value)
                _G[dropdown:GetName() .. "Text"]:SetText(selfArg.value)
                ShowReloadUIIndicator()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    local value = zui.settings.tabSystem
    if not tContains(tabOptions, value) then
        value = "ZUI"
        zui.settings.tabSystem = value
    end
    UIDropDownMenu_SetSelectedValue(dropdown, value)
    _G[dropdown:GetName() .. "Text"]:SetText(value)
end

---<<==================================================================================================== Details! Panel
local panel = zui.panels.details

local header = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
header:SetPoint("TOPLEFT", 16, -16)
header:SetText("Use the string below to import the ZUI profile for Details!")

local scrollFrame = CreateFrame("ScrollFrame", "ZUIDetailsExportScroll", panel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 16, -48)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 16)

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

---<<============================================================================================== Buttons and Commands
SLASH_ZUI1 = "/zui"
SlashCmdList["ZUI"] = function()
    if zui.frames.BG:IsShown() then
        zui.frames.BG:Hide()
    else
        zui.frames.BG:Show()
    end
end
zui.loginTrigger(function()
    C_Timer.After(0.1, function()
        if zui.settings.debug then
            zui.frames.BG:Show()
        end
    end)
end)

zui.buttons.apply:SetScript("OnClick", function()
    for _, func in ipairs(zui.commitRegistry) do
        if type(func) == "function" then
            pcall(func)
        end
    end
end)

zui.buttons.reload:SetScript("OnClick", function()
    ReloadUI()
end)

zui.buttons.close:SetScript("OnClick", function()
    zui.frames.BG:Hide()
end)

---<<===================================================================================================== init on login
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    initAnchorDimensions()
    initAnchorAssignments()
    initMinimapSettings()
    CreateTabSystemDropdown()
end)
