local _, SnugUI = ...

local function GetAnchorTarget()
    local anchors = SnugUI.settings.anchors
    if not anchors then return nil end

    if (anchors.leftAssignment == "Chat" and SnugUI.frames.leftAnchor) then
        return SnugUI.frames.leftAnchor
    elseif (anchors.rightAssignment == "Chat" and SnugUI.frames.rightAnchor) then
        return SnugUI.frames.rightAnchor
    end
    return nil
end

-- Anchors the chat frame and its edit box to the selected anchor
local function AnchorChatToAssignedAnchor()
    local anchor = GetAnchorTarget()
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
    elseif SnugUI.settings.debug then
        print("SnugUI Chat: Failed to anchor. Missing anchor or ChatFrame1.")
    end
end

local function HideChatButtons()
    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame"..i]
        if frame then
            local up = _G[frame:GetName().."ButtonFrameUpButton"]
            local down = _G[frame:GetName().."ButtonFrameDownButton"]
            local bottom = _G[frame:GetName().."ButtonFrameBottomButton"]
            if up then up:Hide() end
            if down then down:Hide() end
            if bottom then bottom:Hide() end
        end
    end
    FriendsMicroButton:Hide()
    ChatFrameChannelButton:Hide()
    ChatFrameMenuButton:Hide()
end

local function debugFrame_GeneralDockManager()
    if SnugUI.settings.debug then
        local debugBackdrop = CreateFrame("Frame", nil, GeneralDockManager, "BackdropTemplate")
        debugBackdrop:SetAllPoints()
        debugBackdrop:SetFrameStrata("BACKGROUND")
        debugBackdrop:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
        debugBackdrop:SetBackdropColor(1, 0, 0, 0.3)
    end
end

---<===========================================================================================================>---<<AUX
SnugUI.loginTrigger(function()
    -- Initialization
    AnchorChatToAssignedAnchor()
    HideChatButtons()
    debugFrame_GeneralDockManager()

    -- Hook
    local anchor = GetAnchorTarget()
    if anchor and not anchor.care then
        anchor:HookScript("OnSizeChanged", AnchorChatToAssignedAnchor)
        anchor.care = true
    end
    -- Commit Registry
    table.insert(SnugUI.commitRegistry, AnchorChatToAssignedAnchor)
end)