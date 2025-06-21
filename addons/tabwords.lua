-- Create a frame to hold the clickable tab words, positioned to the right of the chat box
local TabWordsFrame = CreateFrame("Frame", "ZacsTabWordsFrame", UIParent, "BackdropTemplate")

local function anchorTabWords()
    if ZUISettings.anchorAssignments.left == "Chat" then
        TabWordsFrame:ClearAllPoints()
        TabWordsFrame:SetPoint("TOPLEFT", ChatFrame1, "TOPRIGHT", 1, 2)
        TabWordsFrame:SetSize(100, 200)
        --btn.text:SetJustifyH("LEFT")
        print ("true!!!")
        end
    if ZUISettings.anchorAssignments.right == "Chat" then
        TabWordsFrame:ClearAllPoints()
        TabWordsFrame:SetPoint("TOPRIGHT", ChatFrame1, "TOPLEFT", 1, 2)
        TabWordsFrame:SetSize(100, 200)
        --btn.text:SetJustifyH("RIGHT")
        print ("true!!!")
        end
end

-- Dev-only: semi-transparent black background for visual debug
TabWordsFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
TabWordsFrame:SetBackdropColor(0, 0, 0, 0) -- change here for alpha

-- Table to store button references for tab words
local tabWordButtons = {}
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
        local btn = tabWordButtons[btnIndex]

        if not btn then
            btn = CreateFrame("Button", nil, TabWordsFrame)
            local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetFont(GameFontNormal:GetFont(), 16)
            btn.text = text
            tabWordButtons[btnIndex] = btn
        end

        -- Anchor and justification based on Chat anchor assignment
        local assignment = ZUISettings.anchorAssignments
        local text = btn.text
        text:ClearAllPoints()

        if assignment.left == "Chat" then
            text:SetPoint("TOPLEFT", btn, "TOPLEFT", -6, 8)
            text:SetPoint("RIGHT", btn, "RIGHT", 0, 0)
            text:SetJustifyH("LEFT")
        elseif assignment.right == "Chat" then
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
    for i = btnIndex, #tabWordButtons do
        tabWordButtons[i]:Hide()
    end
end

local function initTabWords() -- only used to remove some logic from RefreshTabWords(), i was chasing a bug. it lives here now
    for _, btn in ipairs(tabWordButtons) do
        btn:SetSize(180, 20)
        btn:RegisterForClicks("AnyUp")
        btn:SetAlpha(0)
        btn:SetScript("OnMouseUp", function(self, button)
            local chatTab = _G["ChatFrame"..self.tabIndex.."Tab"]
            FCF_Tab_OnClick(chatTab, button)
        end)
        -- Define mouse enter behavior to highlight button
        btn:SetScript("OnEnter", function(self)
            for _, b in ipairs(tabWordButtons) do
                if b:IsShown() then
                    UIFrameFadeIn(b, 0.5, b:GetAlpha(), 1)
                end
            end
            self.text:SetTextColor(1, 1, 1)
        end)
        -- Define mouse leave behavior to fade button
        btn:SetScript("OnLeave", function(self)
            for _, b in ipairs(tabWordButtons) do
                if b:IsShown() then
                    UIFrameFadeOut(b, 3.14, b:GetAlpha(), 0)
                end
            end
            self.text:SetTextColor(1, 0.82, 0)
        end)
    end
        -- Hide any unused buttons
    local btnIndex = 1
    for i = btnIndex, #tabWordButtons do
        tabWordButtons[i]:Hide()
    end
end
------------------------------------------------------------------------------------------------------------------------
--- HOOKS
------------------------------------------------------------------------------------------------------------------------
for _, funcName in ipairs({"FCF_DockUpdate", "FCF_OpenNewWindow", "FCF_Close"}) do
    hooksecurefunc(funcName, RefreshTabWords)
end

------------------------------------------------------------------------------------------------------------------------
--- Init on login
------------------------------------------------------------------------------------------------------------------------
local l = CreateFrame("Frame")
l:RegisterEvent("PLAYER_LOGIN")
l:SetScript("OnEvent", function()
    anchorTabWords()
    RefreshTabWords()
    initTabWords()
end)

------------------------------------------------------------------------------------------------------------------------
--- ZUICommitRegistry Function Registration
------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    ZUICommitRegistry = ZUICommitRegistry or {}

    table.insert(ZUICommitRegistry, anchorTabWords)
    table.insert(ZUICommitRegistry, RefreshTabWords)
end)