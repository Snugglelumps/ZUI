local _, SnugUI = ...

local questButtonParent = CreateFrame("Frame", "QuestButtonFrame", UIParent, "BackdropTemplate")
questButtonParent:SetSize(40, 40)
questButtonParent:SetPoint("CENTER")
questButtonParent:SetFrameStrata("LOW")
questButtonParent:SetMovable(true)
questButtonParent:SetUserPlaced(true)
questButtonParent:Hide()
SnugUI.frames.questButtonParent = questButtonParent

local function updateQuestItemButtons()
    local anchored = {}
    local firstButton = nil

    for i = 1, 10 do
        local button = _G["WatchFrameItem"..i]
        if not button then break end
        if button:IsShown() and button:GetParent() then
            button:SetMovable(true)
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
            firstButton.keyLabel:SetPoint("TOPRIGHT", firstButton, "TOPRIGHT", -2, -2)
            firstButton.keyLabel:SetTextColor(1, 1, 1)
        end

        firstButton.keyLabel:SetText(SnugUI.settings.qol.questHotkey:upper())
    end
end

SnugUI.loginTrigger(function()
    if not SnugUI.settings.qol.questButton then return end
    C_Timer.After(4, updateQuestItemButtons) -- MONSTER delay, i hate it but its needed. blizzard is super slow creating the watchframe, and we change its position in minimap.lua. it seems like there is an amount of time after the frame is created/moved that it is not ready. essentially we wait for blizz, wait 2 seconds, move it, wait another 2 seconds.
    table.insert(SnugUI.commitRegistry, updateQuestItemButtons)
    local f = CreateFrame("Frame")
    f:RegisterEvent("QUEST_LOG_UPDATE")
    f:SetScript("OnEvent", function()
        updateQuestItemButtons()
    end)
end)