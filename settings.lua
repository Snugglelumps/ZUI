if not ZUISettings or not ZUISettings.anchorAssignments then
    error("ZUISettings or ZUISettings.anchorAssignments not initialized! Make sure init.lua runs first.")
end

-- Main Frame
local ZUISettingsFrame = CreateFrame("Frame", "ZUISettingsFrame", UIParent, "BasicFrameTemplateWithInset")
ZUISettingsFrame:SetSize(325, 420)
ZUISettingsFrame:SetPoint("CENTER", 0, 50)
ZUISettingsFrame:SetAlpha(0.7)
ZUISettingsFrame:Hide()

ZUISettingsFrame.title = ZUISettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
ZUISettingsFrame.title:SetPoint("TOP", 0, -6)
ZUISettingsFrame.title:SetText("ZUI Settings")

ZUISettingsFrame:SetMovable(true)
ZUISettingsFrame:EnableMouse(true)
ZUISettingsFrame:RegisterForDrag("LeftButton")
ZUISettingsFrame:SetScript("OnDragStart", ZUISettingsFrame.StartMoving)
ZUISettingsFrame:SetScript("OnDragStop", ZUISettingsFrame.StopMovingOrSizing)

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

------------------------------------------------------------------------
-- Tab Setup
------------------------------------------------------------------------
local tabs = {}
local tabNames = {"Anchors"}

local function SelectTab(selectedIndex)
    for i, tab in ipairs(tabs) do
        if i == selectedIndex then
            tab.panel:Show()
            PanelTemplates_SelectTab(tab)
            --if tab:GetText() == "Extra" and debugCheckbox then
            --    debugCheckbox:SetChecked(ZUISettings.DebugMode)
            --end
        else
            tab.panel:Hide()
            PanelTemplates_DeselectTab(tab)
        end
    end
end

local previousTab

for i, name in ipairs(tabNames) do
    local tab = CreateFrame("Button", "ZUISettingsTab"..i, ZUISettingsFrame, "OptionsFrameTabButtonTemplate")
    tab:SetText(name)
    tab:SetID(i)

    if previousTab then
        tab:SetPoint("LEFT", previousTab, "RIGHT", -16, 0) -- 2px space between tabs
    else
        tab:SetPoint("TOPLEFT", ZUISettingsFrame, "TOPLEFT", 0, -28) -- initial anchor
    end

    tab:SetScript("OnClick", function(self)
        SelectTab(self:GetID())
    end)

    previousTab = tab


    local panel = CreateFrame("Frame", nil, ZUISettingsFrame)
    panel:SetPoint("TOPLEFT", 10, -50)
    panel:SetPoint("BOTTOMRIGHT", -10, 60)
    panel:Hide()

    tab.panel = panel
    tabs[i] = tab
end

-- Set default tab to 1 ("Anchors")
SelectTab(1)


------------------------------------------------------------------------
-- Anchors Tab Content (Width & Height + Anchor Assignments)
------------------------------------------------------------------------

    local anchorsPanel = tabs[1].panel

    --------------------------------------------------------------------
    -- Size Configuration
    --------------------------------------------------------------------
    local widthLabel = anchorsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    widthLabel:SetPoint("TOPLEFT", 16, -16)
    widthLabel:SetText("Width:")

    local heightLabel = anchorsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    heightLabel:SetPoint("TOPLEFT", widthLabel, "BOTTOMLEFT", 0, -18)
    heightLabel:SetText("Height:")

    local widthBox = CreateFrame("EditBox", nil, anchorsPanel, "InputBoxTemplate")
    widthBox:SetSize(80, 24)
    widthBox:SetPoint("LEFT", widthLabel, "RIGHT", 8, 0)
    widthBox:SetAutoFocus(false)
    widthBox:SetNumeric(true)

    local heightBox = CreateFrame("EditBox", nil, anchorsPanel, "InputBoxTemplate")
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
    if not tabs or not tabs[1] or not tabs[1].panel then
        print("Error: anchorsPanel not initialized, check tab creation order.")
        return
    end

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

    -- ✅ Correct call
    CreateAnchorDropdown(anchorsPanel, "Left Anchor Content:", "left", 0, -130)
    CreateAnchorDropdown(anchorsPanel, "Right Anchor Content:", "right", 165, -130)

------------------------------------------------------------------------
-- Bottom Buttons (Always Visible)
------------------------------------------------------------------------

function ZUICommitSettings()
    for _, callback in ipairs(ZUICommitRegistry) do
        if type(callback) == "function" then
            pcall(callback) -- safe call with error suppression
        end
    end
end

local buttonWidth, spacing, bottomOffset = 80, 10, 20
local totalWidth = buttonWidth * 3 + spacing * 2
local startX = -(totalWidth / 2)

-- Apply Button (right, symmetric to reload)
local applyButton = CreateFrame("Button", nil, ZUISettingsFrame, "UIPanelButtonTemplate")
applyButton:SetSize(buttonWidth, 22)
applyButton:SetPoint("BOTTOMLEFT", ZUISettingsFrame, "BOTTOM", startX, bottomOffset)
applyButton:SetText("Apply")
applyButton:SetScript("OnClick", function()
    ZUICommitSettings()
end)

local reloadButton = CreateFrame("Button", nil, ZUISettingsFrame, "UIPanelButtonTemplate")
reloadButton:SetSize(buttonWidth, 22)
reloadButton:SetPoint("BOTTOMLEFT", ZUISettingsFrame, "BOTTOM", startX + (buttonWidth + spacing) * 2, bottomOffset)
reloadButton:SetText("Reload UI")
reloadButton:SetScript("OnClick", ReloadUI)

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


local SettingsFrame = CreateFrame("Frame", "ZUI Settings", UIParent, "BasicFrameTemplateWithInset")