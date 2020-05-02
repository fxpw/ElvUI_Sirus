local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule("DataTexts")

--Lua functions
local ipairs = ipairs
local join = string.join
local format = string.format
local tinsert = table.insert
local tconcat = table.concat
--WoW API / Variables
local GetArenaRating = GetArenaRating
local GetRatedBattlegroundRankInfo = GetRatedBattlegroundRankInfo
local TogglePVPUIFrame = TogglePVPUIFrame

local displayNumberString = ""
local lastPanel

local brackets = {
	[1] = "Solo",
	[2] = "2x2",
	[3] = "3x3",
	[4] = "RBG",
}

local tbl = {}

local function OnEvent(self)
	lastPanel = self

	table.wipe(tbl)

	local _, _, _, _, currRating = GetRatedBattlegroundRankInfo()
	for i, enabled in ipairs(E.db.datatexts.ArenaRating) do
		if enabled then
			tinsert(tbl, format(displayNumberString, brackets[i], (i == 4 and currRating or GetArenaRating(i)) or 0))
		end
	end

	self.text:SetText(tconcat(tbl, ", "))
end

local function OnClick()
	TogglePVPUIFrame()
end

local function ValueColorUpdate(hex)
	displayNumberString = join("", "%s: ", hex, "%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("ArenaRating", {"PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA"}, OnEvent, nil, OnClick, nil, nil, PVP_YOUR_RATING)