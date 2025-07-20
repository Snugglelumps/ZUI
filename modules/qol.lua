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
                -- Hook SetParent, I know Im missing a hook, I *think* this is it. fingers crossed
                hooksecurefunc(button, "SetParent", function()
                    if SnugUI and SnugUI.functions.updateQuestItemButtons then
                        SnugUI.functions.updateQuestItemButtons()
                    end
                end)
                -- Hook Show, as Blizzard may re-show buttons on world transitions
                hooksecurefunc(button, "Show", function()
                    if SnugUI and SnugUI.functions.updateQuestItemButtons then
                        SnugUI.functions.updateQuestItemButtons()
                    end
                end)
                -- Hook SetShown, as Blizzard toggles visibility on world transitions
                hooksecurefunc(button, "SetShown", function()
                    if SnugUI and SnugUI.functions.updateQuestItemButtons then
                        SnugUI.functions.updateQuestItemButtons()
                    end
                end)
                -- Hook Hide, as Blizzard may hide buttons on world transitions
                hooksecurefunc(button, "Hide", function()
                    if SnugUI and SnugUI.functions.updateQuestItemButtons then
                        SnugUI.functions.updateQuestItemButtons()
                    end
                end)
                button.__SnugUI_Hooked = true
            end
        end
    end
    tryHookQuestButtons()
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
            -- Force parent to questButtonParent every update
            button:SetParent(SnugUI.frames.questButtonParent)

            button:ClearAllPoints()
            if #anchored == 0 then
                button:SetPoint("CENTER", SnugUI.frames.questButtonParent, "CENTER", 0, 0)
                firstButton = button
            else
                button:SetPoint("LEFT", anchored[#anchored], "RIGHT", 5, 0)
            end
            table.insert(anchored, button)
        end

        -- Only show keyLabel for the first button, hide for others
        if button.keyLabel then
            if button == firstButton and SnugUI.settings.qol.questHotkey then
                button.keyLabel:Show()
                button.keyLabel:SetText(SnugUI.settings.qol.questHotkey:upper())
            else
                button.keyLabel:Hide()
            end
        end
    end

    if firstButton and SnugUI.settings.qol.questHotkey then
        SetOverrideBindingClick(firstButton, true, SnugUI.settings.qol.questHotkey, firstButton:GetName(), "LeftButton")

        if not firstButton.keyLabel then
            firstButton.keyLabel = firstButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            firstButton.keyLabel:SetPoint("TOPLEFT", firstButton, "TOPLEFT", 2, -2)
            firstButton.keyLabel:SetTextColor(1, 1, 1)
        end
        firstButton.keyLabel:Show()
        firstButton.keyLabel:SetText(SnugUI.settings.qol.questHotkey:upper())
    end
    isUpdatingQuestButtons = false
end

SnugUI.loginTrigger(function()
    if not SnugUI.settings.qol.questButton then return end
    initQuestItemFrame()
    local eventFrame = CreateFrame("Frame")
    local events = {
        "QUEST_LOG_UPDATE",
        "QUEST_WATCH_UPDATE",
        "QUEST_ACCEPTED",
        "QUEST_REMOVED",
        "ZONE_CHANGED",
        "ZONE_CHANGED_INDOORS",
        "ZONE_CHANGED_NEW_AREA",
        "PLAYER_ENTERING_WORLD",
    }
    for _, event in ipairs(events) do
        eventFrame:RegisterEvent(event)
    end
    eventFrame:SetScript("OnEvent", function()
        SnugUI.functions.updateQuestItemButtons()
    end)
end)