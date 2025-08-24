local ADDON_NAME = ...
local DEBUG = false
local function D(...) if DEBUG then print("|cff66ccff[FastReload]|r", ...) end end

local BUTTON_NAME = "GameMenuButtonFastReload"
local BUTTON_LABEL = RELOAD_UI or "Reload UI"

local function CreateReloadButton()
    if _G[BUTTON_NAME] then return _G[BUTTON_NAME] end
    if not GameMenuFrame then return nil end

    local btn = CreateFrame("Button", BUTTON_NAME, GameMenuFrame, "GameMenuButtonTemplate")
    btn:SetText(BUTTON_LABEL)
    btn:SetScript("OnClick", function()
        D("Reload triggered via button")
        ReloadUI()
    end)
    return btn
end

local function PositionReloadButton()
    local btn = _G[BUTTON_NAME] or CreateReloadButton()
    if not btn then return end

    btn:ClearAllPoints()

    if GameMenuButtonContinue then
        btn:SetPoint("BOTTOM", GameMenuButtonContinue, "TOP", 0, 1)
        btn:SetSize(GameMenuButtonContinue:GetSize())
    elseif GameMenuFrame.BottomButtons then
        -- Neuere Menüs haben Container für Bottom Buttons
        btn:SetPoint("BOTTOM", GameMenuFrame.BottomButtons, "TOP", 0, 4)
    else
        btn:SetPoint("BOTTOM", GameMenuFrame, "BOTTOM", 0, 14)
    end

    btn:Show()
end

local function InsertReloadButton()
    D("InsertReloadButton called")
    PositionReloadButton()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        if GameMenuFrame then
            hooksecurefunc(GameMenuFrame, "Show", function()
                C_Timer.After(0, InsertReloadButton)
            end)
        end
    end
end)

-- Slash Command
SLASH_FASTRELOAD1 = "/freload"
SlashCmdList["FASTRELOAD"] = function(msg)
    msg = (msg or ""):lower()
    if msg == "debug" then
        DEBUG = not DEBUG
        print("|cff66ccff[FastReload]|r Debug:", DEBUG and "ON" or "OFF")
    else
        D("Reload triggered via slash command")
        ReloadUI()
    end
end
