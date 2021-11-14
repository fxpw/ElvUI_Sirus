local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB


-- local addon = E:GetModule("ElvUI_Sirus")

--Lua functions
local _G = _G
local tonumber, pairs, ipairs, error, unpack, select, tostring = tonumber, pairs, ipairs, error, unpack, select, tostring
local assert, type, print = assert, type, print
local twipe, tinsert, tremove, next = table.wipe, tinsert, tremove, next
local format, find, match, strrep, strlen, sub, gsub, strjoin = string.format, string.find, string.match, strrep, strlen, string.sub, string.gsub, strjoin
--WoW API / Variables
local CreateFrame = CreateFrame
-- local GetAddOnInfo = GetAddOnInfo
-- local GetCVar = GetCVar
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
-- local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local IsInInstance = IsInInstance
local SendAddonMessage = SendAddonMessage
-- local UnitGUID = UnitGUID
-- local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
-- local RAID_CLASS_COLORS = RAID_CLASS_COLORS



local myname = UnitName("player")
local versionsirus = GetAddOnMetadata("ElvUI_Sirus", "Version")



do
    local SendMessageWaitingsirus
    local SendRecieveGroupSizesirus = 0
    function SendMessage_sirus()
        if GetNumRaidMembers() > 1 then
            local _, instanceType = IsInInstance()
            if instanceType == "pvp" then
                SendAddonMessage("ELVUIS_VERSIONCHK", versionsirus, "BATTLEGROUND")
            else
                SendAddonMessage("ELVUIS_VERSIONCHK", versionsirus, "RAID")
            end
        elseif GetNumPartyMembers() > 0 then
            SendAddonMessage("ELVUIS_VERSIONCHK", versionsirus, "PARTY")
        elseif IsInGuild() then
            SendAddonMessage("ELVUIS_VERSIONCHK", versionsirus, "GUILD")
        end
        SendMessageWaitingsirus = nil
    end
    print("|cff1784d1E|r|cffe5e3e3lvUI|r |cff1784d1S|r|cffe5e3e3irus|r версии "..versionsirus.." загружен. ")
    local function SendRecieve_sirus(_, event, prefix, message, _, sender)
        if event == "CHAT_MSG_ADDON" then
            if prefix ~= "ELVUIS_VERSIONCHK" then return end
            if not sender or sender == myname then return end

            local ver = tonumber(versionsirus)
            message = tonumber(message)

          
            if message and (message > ver) then               
                E:Print("|cff1784d1E|r|cffe5e3e3lvUI|r |cff1784d1S|r|cffe5e3e3irus|r не обновлен. Вы можете загрузить последнюю версию из https://github.com/fxpw/ElvUI_Sirus")
            end
        end
   

        if event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" then
            local numRaid = GetNumRaidMembers()
            local num = numRaid > 0 and numRaid or (GetNumPartyMembers() + 1)
            if num ~= SendRecieveGroupSizesirus then
                if num > 1 and num > SendRecieveGroupSizesirus then
                    if not SendMessageWaitingsirus then
                        SendMessageWaitingsirus = E:Delay(10, SendMessage_sirus)
                    end
                end
                SendRecieveGroupSizesirus = num
            end
        elseif event == "PLAYER_ENTERING_WORLD" then
            if not SendMessageWaitingsirus then
                SendMessageWaitingsirus = E:Delay(10, SendMessage_sirus)
            end
        end
    end
           
    local f = CreateFrame("Frame")
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:RegisterEvent("RAID_ROSTER_UPDATE")
    f:RegisterEvent("PARTY_MEMBERS_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", SendRecieve_sirus)
end