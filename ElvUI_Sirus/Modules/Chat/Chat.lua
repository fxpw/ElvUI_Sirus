local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CH = E:GetModule("Chat")

local ElvBlue = E:TextureString(E.Media.ChatLogos.ElvBlue, ":13:25")
local Vakh = E:TextureString([[Interface\AddOns\ElvUI_Sirus\Media\ChatLogos\Vakh]], ":16:16")
local Dodzo = E:TextureString([[Interface\AddOns\ElvUI_Sirus\Media\ChatLogos\Dodzo]], ":16:16")
local Apolexis = E:TextureString([[Interface\AddOns\ElvUI_Sirus\Media\ChatLogos\Apolexis]], ":24:58")
local Fxpw = E:TextureString([[Interface\AddOns\ElvUI_Sirus\Media\ChatLogos\Fxpw]], ":24:24")
local specialChatIcons = {
	["Крольчонок-Scourge x2 - 3.3.5a+"] = ElvBlue,
	["Vakh-Scourge x2 - 3.3.5a+"] = Vakh,
	["Язло-Scourge x2 - 3.3.5a+"] = Vakh,
	["Додзё-Scourge x2 - 3.3.5a+"] = Dodzo,
	["Apolexis-Scourge x2 - 3.3.5a+"] = Apolexis,
	["Шутка-Scourge x2 - 3.3.5a+"] = Fxpw,
	["Пьяная-Scourge x2 - 3.3.5a+"] = Fxpw,
	["Лужица-Scourge x2 - 3.3.5a+"] = Fxpw,
	["Лягушечка-Scourge x2 - 3.3.5a+"] = Fxpw,
}

local function GetChatIcon(_, name, realm)
	if not name then return end

	realm = realm ~= "" and realm or E.myrealm
	name = name.."-"..realm

	if specialChatIcons[name] then
		return specialChatIcons[name]
	end
end

CH:AddPluginIcons(GetChatIcon)

hooksecurefunc(CH, "StyleChat", function(_, frame)
	frame.buttonFrame:Kill()
	frame.buttonFrame2:Hide()
	frame.buttonFrame2.Show = E.noop
end)

function ChatUrlHyperlink_OnClick(link, text)
	if IsModifiedClick() then
		HandleModifiedItemClick(text)
		return
	end

	local linkData = C_Split(link, ":")
	if linkData then
		local id, arg1, arg2, arg3 = unpack(linkData, 2)

		if linkData then
			if id and arg1 and arg2 and arg3 then
				C_SendOpcode(CMSG_SIRUS_OPEN_URL, tonumber(id), arg1, arg2, arg3)
			else
				local currentLink = strsub(link, 5)
				if currentLink and currentLink ~= "" then
					CH:SetChatEditBoxMessage(currentLink)
				end
			end
		end
	end
end