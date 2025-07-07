local _, SnugUI = ...

local questButtonParent = CreateFrame("Frame", "QuestButtonFrame", UIParent, "BackdropTemplate")
questButtonParent:SetSize(44, 44)
questButtonParent:SetPoint("CENTER")
questButtonParent:SetFrameStrata("LOW")
questButtonParent:SetMovable(true)
questButtonParent:SetUserPlaced(true)

SnugUI.frames.questButtonParent = questButtonParent

local function initQuestItemFrame()
    local frameNames = {}
    for i = 1, 10 do
        frameNames[i] = "WatchFrameItem" .. i
    end

    local function tryHookQuestButtons()
        for _, frameName in ipairs(frameNames) do
            local button = _G[frameName]
            if button and not button.__SnugUI_Hooked then
                hooksecurefunc(button, "SetPoint", function()
                    if SnugUI and SnugUI.functions.updateQuestItemButtons then
                        SnugUI.functions.updateQuestItemButtons()
                    end
                end)
                button.__SnugUI_Hooked = true
            end
        end
    end
    tryHookQuestButtons()
    --had a "SetParent" hook, add back if needed.
end

local isUpdatingQuestButtons = false
function SnugUI.functions.updateQuestItemButtons()
    if isUpdatingQuestButtons then return end
    isUpdatingQuestButtons = true
    local anchored = {}
    local firstButton = nil

    for i = 1, 10 do
        local button = _G["WatchFrameItem"..i]
        if not button then break end

        if button:IsShown() then
            button:EnableMouse(true)
            button:RegisterForDrag("LeftButton")
            button:SetScript("OnDragStart", function()
                SnugUI.frames.questButtonParent:StartMoving()
            end)
            button:SetScript("OnDragStop", function()
                SnugUI.frames.questButtonParent:StopMovingOrSizing()
            end)
            button:SetScale(1.4)
            button:SetFrameStrata("MEDIUM")

            button:ClearAllPoints()
            if #anchored == 0 then
                button:SetPoint("CENTER", SnugUI.frames.questButtonParent, "CENTER", 0, 0)
                firstButton = button
            else
                button:SetPoint("LEFT", anchored[#anchored], "RIGHT", 5, 0)
            end
            table.insert(anchored, button)
        end
    end

    if firstButton and SnugUI.settings.qol.questHotkey then
        SetOverrideBindingClick(firstButton, true, SnugUI.settings.qol.questHotkey, firstButton:GetName(), "LeftButton")

        if not firstButton.keyLabel then
            firstButton.keyLabel = firstButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            firstButton.keyLabel:SetPoint("TOPLEFT", firstButton, "TOPLEFT", 2, -2)
            firstButton.keyLabel:SetTextColor(1, 1, 1)
        end

        firstButton.keyLabel:SetText(SnugUI.settings.qol.questHotkey:upper())
    end
    isUpdatingQuestButtons = false
end

SnugUI.loginTrigger(function()
    if not SnugUI.settings.qol.questButton then return end
    initQuestItemFrame()
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
    eventFrame:SetScript("OnEvent", function()
        SnugUI.functions.updateQuestItemButtons()
    end)
end)