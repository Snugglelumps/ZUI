local _, zui = ...
-- Create a frame to hold the clickable tab words, positioned to the right of the chat box
local TabWordsFrame = CreateFrame("Frame", "ZacsTabWordsFrame", UIParent, "BackdropTemplate")

local function anchorTabWords()
    if ZUISettings.anchorAssignments.left == "Chat" then
        TabWordsFrame:ClearAllPoints()
        TabWordsFrame:SetPoint("TOPLEFT", ChatFrame1, "TOPRIGHT", 1, 2)
        TabWordsFrame:SetSize(100, 200)
        end
    if ZUISettings.anchorAssignments.right == "Chat" then
        TabWordsFrame:ClearAllPoints()
        TabWordsFrame:SetPoint("TOPRIGHT", ChatFrame1, "TOPLEFT", 1, 2)
        TabWordsFrame:SetSize(100, 200)
        end
end

-- Dev-only: semi-transparent black background for visual dev
local function debugFrame_TabWords()
    if zui.settings.debug then
        TabWordsFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
        TabWordsFrame:SetBackdropColor(0, 0, 0, .5) -- change here for alpha
    end
end

zui.tabWordButtons = {}
local function RefreshTabWords()
    local shownTabs = {}
    for i = 1, NUM_CHAT_WINDOWS do
        local tab = _G["ChatFrame" .. i .. "Tab"]
        local frame = _G["ChatFrame" .. i]
        if tab and frame and tab:IsShown() and frame.isDocked then
            table.insert(shownTabs, { tab = tab, index = i })
        end
    end

    local prevBtn
    local btnIndex = 1

    for _, info in ipairs(shownTabs) do
        local tab, idx = info.tab, info.index
        local btn = zui.tabWordButtons[btnIndex]

        if not btn then
            btn = CreateFrame("Button", nil, TabWordsFrame)
            local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetFont(GameFontNormal:GetFont(), 16)
            btn.text = text
            zui.tabWordButtons[btnIndex] = btn
        end

        -- Anchor and justification based on Chat anchor assignment
        local text = btn.text
        text:ClearAllPoints()

        if ZUISettings.anchorAssignments.left == "Chat" then
            text:SetPoint("TOPLEFT", btn, "TOPLEFT", -6, 8)
            text:SetPoint("RIGHT", btn, "RIGHT", 0, 0)
            text:SetJustifyH("LEFT")
        elseif ZUISettings.anchorAssignments.right == "Chat" then
            text:SetPoint("TOPRIGHT", btn, "TOPRIGHT", 6, 8)
            text:SetPoint("LEFT", btn, "LEFT", 0, 0)
            text:SetJustifyH("RIGHT")
        end

        text:SetJustifyV("TOP")
        text:SetTextColor(1, 0.82, 0)
        text:SetText("")              -- Clear first to force refresh
        text:SetText(tab:GetText())  -- Set actual tab label

        -- Anchor the button itself
        if not prevBtn then
            btn:SetPoint("TOPLEFT", TabWordsFrame, "TOPLEFT", 10, -10)
        else
            btn:SetPoint("TOPLEFT", prevBtn, "BOTTOMLEFT", 0, 0)
        end
        btn:SetPoint("RIGHT", TabWordsFrame, "RIGHT", -10, 0)

        btn.tabIndex = idx
        btn:Show()
        prevBtn = btn
        btnIndex = btnIndex + 1
    end

    -- Hide unused buttons
    for i = btnIndex, #zui.tabWordButtons do
        zui.tabWordButtons[i]:Hide()
    end
end

local function initTabWords() -- script setup for tabwords
    for _, btn in ipairs(zui.tabWordButtons) do
        btn:SetSize(180, 20)
        btn:RegisterForClicks("AnyUp")
        btn:SetAlpha(0)
        btn:SetScript("OnMouseUp", function(self, button)
            local chatTab = _G["ChatFrame"..self.tabIndex.."Tab"]
            FCF_Tab_OnClick(chatTab, button)
        end)
        -- Define mouse enter behavior to highlight button
        btn:SetScript("OnEnter", function(self)
            for _, b in ipairs(zui.tabWordButtons) do
                if b:IsShown() then
                    UIFrameFadeIn(b, 0.25, b:GetAlpha(), 1)
                end
            end
            self.text:SetTextColor(1, 1, 1)
        end)
        -- Define mouse leave behavior to fade button
        btn:SetScript("OnLeave", function(self)
            for _, b in ipairs(zui.tabWordButtons) do
                if b:IsShown() then
                    UIFrameFadeOut(b, 1, b:GetAlpha(), 0)
                end
            end
            self.text:SetTextColor(1, 0.82, 0)
        end)
    end
        -- Hide any unused buttons
    local btnIndex = 1
    for i = btnIndex, #zui.tabWordButtons do
        zui.tabWordButtons[i]:Hide()
    end
end

local function hideBlizzardChatTabStuff()
    local elements = { "Left", "Middle", "Right", "HighlightLeft", "HighlightMiddle", "HighlightRight" }

    for i = 1, NUM_CHAT_WINDOWS do
        local base = "ChatFrame" .. i .. "Tab"

        for _, suffix in ipairs(elements) do
            local region = _G[base .. suffix]
            if region then region:Hide() end
        end

        local tabText = _G[base .. "Text"]
        if tabText then
            tabText:SetFont("Fonts\\FRIZQT__.TTF", 12, "NONE") -- Adjust size/style here
        end
    end
end

local function HideGeneralDockManager()
-- This function deliberately disrupts the GeneralDockManager to prevent it from rendering on screen.
-- This is necessary because hiding the chat tabs (e.g. with Hide()) breaks TabWords' ability
-- to index them properly. Additionally, the combat log's extra buttons inherit alpha from their parent tab,
-- so fully hiding the tabs isn't viable. This controlled "break" is a workaround to keep them functional but invisible.
    if GeneralDockManager and GeneralDockManager:IsVisible() then
        GeneralDockManager:ClearAllPoints()
        GeneralDockManager:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
    end
end

for _, funcName in ipairs({"FCF_DockUpdate", "FCF_OpenNewWindow", "FCF_Close"}) do
    hooksecurefunc(funcName, RefreshTabWords)
end

---<<===================================================================================================== init on login
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    local system = zui.settings.tabSystem
    if system == "ZUI" then
        anchorTabWords()
        RefreshTabWords()
        initTabWords()
        HideGeneralDockManager()
        debugFrame_TabWords()
    elseif system == "Blizzard" then
        hideBlizzardChatTabStuff()
    end
end)

---<<========================================================================== zui.commitRegistry Function Registration
zui.loginTrigger(function()
    local system = zui.settings.tabSystem
    if system == "ZUI" then
        table.insert(zui.commitRegistry, anchorTabWords)
        table.insert(zui.commitRegistry, RefreshTabWords)
    end
end)