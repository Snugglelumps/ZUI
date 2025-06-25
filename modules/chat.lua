------------------------------------------------------------------------
-- Blizzard Chat + Prat 3.0
------------------------------------------------------------------------
function ShouldAnchorChat() -- Determines whether chat should be anchored
    return ZUISettings and (ZUISettings.anchorAssignments.left == "Chat" or ZUISettings.anchorAssignments.right == "Chat")
end

function GetChatAnchorTarget() -- Returns the anchor (left or right) assigned to Chat
    if not ZUISettings then return nil end
    if ZUISettings.anchorAssignments.left == "Chat" then
        return leftAnchor
    elseif ZUISettings.anchorAssignments.right == "Chat" then
        return rightAnchor
    end
end

function AnchorChatToAssignedAnchor() -- Anchors the chat frame and its edit box to the selected anchor
    local anchor = GetChatAnchorTarget()
    if anchor and ChatFrame1 and ChatFrame1EditBox then
        -- Chat frame
        ChatFrame1:ClearAllPoints()
        for i = 1, 9 do
            local frame = _G["ChatFrame"..i]
            if frame then
                frame:SetClampedToScreen(false)
                FCF_SetLocked(frame, true)
            end
        end
        ChatFrame1:SetPoint("TOPLEFT", anchor, "TOPLEFT", 2, -3)
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

local function HideChatButtons()
    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame"..i]
        if frame then
            local up = _G[frame:GetName().."ButtonFrameUpButton"]
            local down = _G[frame:GetName().."ButtonFrameDownButton"]
            local bottom = _G[frame:GetName().."ButtonFrameBottomButton"]
            --local chatMenu = _G[frame:GetName().."ButtonFrameMinimizeButton"]
            if up then up:Hide() end
            if down then down:Hide() end
            if bottom then bottom:Hide() end
            --if chatMenu then chatMenu:Hide() end
            FriendsMicroButton:Hide()
            ChatFrameChannelButton:Hide()
            ChatFrameMenuButton:Hide()
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

local function debugFrame_GeneralDockManager()
    if ZUISettings.DebugMode then
        local debugBackdrop = CreateFrame("Frame", "nil", GeneralDockManager, "BackdropTemplate")
        debugBackdrop:SetAllPoints()
        debugBackdrop:SetFrameStrata("BACKGROUND")
        debugBackdrop:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
        debugBackdrop:SetBackdropColor(1, 0, 0, 0.3)
        else
        print("GeneralDockManager not available or not visible.")
    end
end

------------------------------------------------------------------------------------------------------------------------
--- Init on login
------------------------------------------------------------------------------------------------------------------------
local l = CreateFrame("Frame")
l:RegisterEvent("PLAYER_LOGIN")
l:SetScript("OnEvent", function()
    HideChatButtons()
    --HideGeneralDockManager()
    debugFrame_GeneralDockManager()
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