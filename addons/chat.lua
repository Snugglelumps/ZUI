------------------------------------------------------------------------
-- Blizzard Chat + Prat 3.0
------------------------------------------------------------------------


-- Determines whether chat should be anchored
function ShouldAnchorChat()
    return ZUISettings and (ZUISettings.anchorAssignments.left == "Chat" or ZUISettings.anchorAssignments.right == "Chat")
end

-- Returns the anchor (left or right) assigned to Chat
function GetChatAnchorTarget()
    if not ZUISettings then return nil end
    if ZUISettings.anchorAssignments.left == "Chat" then
        return leftAnchor
    elseif ZUISettings.anchorAssignments.right == "Chat" then
        return rightAnchor
    end
end

-- Anchors the chat frame and its edit box to the selected anchor
function AnchorChatToAssignedAnchor()
    local anchor = GetChatAnchorTarget()
    if anchor and ChatFrame1 and ChatFrame1EditBox then
        -- Chat frame
        ChatFrame1:ClearAllPoints()
        ChatFrame1:SetPoint("TOPLEFT", anchor, "TOPLEFT", 2, -2)
        ChatFrame1:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -2, 2)

        -- Edit box (Prat or default height offset)
        local offsetY = IsAddOnLoaded("Prat-3.0") and 2 or 6
        local editBox = ChatFrame1EditBox
        editBox:ClearAllPoints()
        editBox:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, offsetY)
        editBox:SetPoint("BOTTOMRIGHT", anchor, "TOPRIGHT", 0, offsetY)
        editBox:SetHeight(20)
        editBox:SetWidth(anchor:GetWidth())
    elseif ZUISettings.DebugMode then
        print("ZUI Chat: Failed to anchor. Missing anchor or ChatFrame1.")
    end
end

--------Position
--local f = CreateFrame("Frame")
--f:RegisterEvent("PLAYER_LOGIN")
--f:SetScript("OnEvent", function()
--    C_Timer.After(0.1, function()
--        if leftAnchor and ChatFrame1 then
--            -- Position the Chat Frame
--            ChatFrame1:ClearAllPoints()
--            ChatFrame1:SetPoint("TOPLEFT", leftAnchor, "TOPLEFT", 2, -2)
--            ChatFrame1:SetPoint("BOTTOMRIGHT", leftAnchor, "BOTTOMRIGHT", -2, 2)
--        else
--            print("ChatFrame1 or leftAnchor not found")
--        end
--
--        local editBox = ChatFrame1EditBox
--        if editBox and leftAnchor then
--            -- Conditional offset if Prat is loaded
--            local offsetY = IsAddOnLoaded("Prat-3.0") and 2 or 6
--
--            -- Position the Chat Edit Box
--            editBox:ClearAllPoints()
--            editBox:SetPoint("BOTTOMLEFT", leftAnchor, "TOPLEFT", 0, offsetY)
--            editBox:SetPoint("BOTTOMRIGHT", leftAnchor, "TOPRIGHT", 0, offsetY)
--            editBox:SetHeight(20)
--            editBox:SetWidth(leftAnchor:GetWidth())
--        else
--            print("ChatFrame1EditBox or leftAnchor not found")
--        end
--    end)
--end)

local function HideBlizzardChatTabs()
    for i = 1, NUM_CHAT_WINDOWS do
        local tab = _G["ChatFrame"..i.."Tab"]
        if tab then
            tab:SetAlpha(0) -- Hides the tab by setting alpha. Do not hide() tabs, they are needed to generate tabwords
            tab:EnableMouse(false)
            hooksecurefunc(tab, "Show", function(self)
                self:SetAlpha(0)
                self:EnableMouse(false)
            end)
            hooksecurefunc(tab, "SetAlpha", function(self, a)
                if a > 0 then self:SetAlpha(0) end
            end)
        end
    end
end

local function HideChatButtons()
    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame"..i]
        if frame then
            local up = _G[frame:GetName().."ButtonFrameUpButton"]
            local down = _G[frame:GetName().."ButtonFrameDownButton"]
            local bottom = _G[frame:GetName().."ButtonFrameBottomButton"]
            local chatMenu = _G[frame:GetName().."ButtonFrameMinimizeButton"]
            if up then up:Hide() end
            if down then down:Hide() end
            if bottom then bottom:Hide() end
            if chatMenu then chatMenu:Hide() end
        end
    end
end
-- PLAYER_LOGIN: Setup visual tweaks
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    C_Timer.After(0.5, function()
        HideChatButtons()
        HideBlizzardChatTabs()
    end)
end)


------------------------------------------------------------------------------------------------------------------------
--- Init on login
------------------------------------------------------------------------------------------------------------------------
local detailsEventFrame = CreateFrame("Frame")
detailsEventFrame:RegisterEvent("PLAYER_LOGIN")
detailsEventFrame:SetScript("OnEvent", function()
    C_Timer.After(0.1, function()
        AnchorChatToAssignedAnchor()

        -- Hook resize
        local anchor = GetChatAnchorTarget()
        if anchor and not anchor.__details_size_hooked then
            anchor:HookScript("OnSizeChanged", AnchorChatToAssignedAnchor)
            anchor.__details_size_hooked = true
        end
    end)
end)

------------------------------------------------------------------------------------------------------------------------
--- ZUICommitRegistry Function Registration
------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    ZUICommitRegistry = ZUICommitRegistry or {}

    table.insert(ZUICommitRegistry, AnchorChatToAssignedAnchor)
end)