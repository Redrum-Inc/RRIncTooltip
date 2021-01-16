RRIncTooltip_MessagePrefix = ""

local SELL_PRICE_TEXT = format("%s:", SELL_PRICE)
local f = CreateFrame("Frame")

local function GetClassFromGuildRoster(targetName)
	local numTotalMembers = select(1, GetNumGuildMembers())
	for i=1, numTotalMembers, 1 do
		local name, rankName, rankIndex, level, classDisplayName, _, publicNote, _, _, status, class, _, _, _, _, _, GUID = GetGuildRosterInfo(i);
		name = name:gsub("-ZandalarTribe","")
		if name == targetName then
			return classDisplayName
		end
	end
	return ""
end

local function GetClassColorInRGB(class)
	local r, g, b = 0,0,0

	if string.lower(class) == "druid" then
		r,g,b=1.00,0.49,0.04
	end

	if string.lower(class) == "hunter" then
		r,g,b=0.67,0.83,0.45
	end

	if string.lower(class) == "mage" then
		r,g,b=0.25,0.78,0.92
	end

	if string.lower(class) == "paladin" then
		r,g,b=0.96,0.55,0.73
	end

	if string.lower(class) == "priest" then
		r,g,b=1.00,1.00,1.00
	end

	if string.lower(class) == "rogue" then
		r,g,b=1.00,0.96,0.41
	end

	if string.lower(class) == "shaman" then
		r,g,b=0.00,0.44,0.87
	end

	if string.lower(class) == "warlock" then
		r,g,b=0.53,0.53,0.93
	end

	if string.lower(class) == "warrior" then
		r,g,b=0.78,0.61,0.43
	end



	return r, g, b
end

local function SetGameToolTipPrice(tt)
	local container = GetMouseFocus()	
	local itemLink = select(2, tt:GetItem())
	if itemLink then
		itemName = select(1, GetItemInfo(itemLink))

		if RRIncData_Loot[itemName] ~= nil then
			if next(RRIncData_Loot[itemName]) == nil then
				return 
			end
			
			tt:AddDoubleLine(" ","")
			tt:AddDoubleLine("RRIncLoot:",#RRIncData_Loot[itemName].." listed", 1,1,1,1,1,1)

			for i=1, #RRIncData_Loot[itemName] do
				local r = 0 g = 0 b = 0
				local r2 = 0 g2 = 0 b2 = 0
				local class = GetClassFromGuildRoster(RRIncData_Loot[itemName][i].name)

				-- print(class)
				if class == nil or class == "" then
					r=0.4 g=0.4 b=0.4
				else
					r, g, b = GetClassColorInRGB(class)
				end

				tt:AddDoubleLine(RRIncData_Loot[itemName][i].name, RRIncData_Loot[itemName][i].ranking, r,g,b,r,g,b)
			end
			-- tt:AddDoubleLine(lootranking)		
		else 
			--nothing?
		end 

	end
end

GameTooltip:HookScript("OnTooltipSetItem", SetGameToolTipPrice)
ItemRefTooltip:HookScript("OnTooltipSetItem", SetGameToolTipPrice)
f:RegisterEvent("MODIFIER_STATE_CHANGED")
f:SetScript("OnEvent", f.OnEvent)

local function EventEnterWorld(self, event, isLogin, isReload)
	-- Set default values. (This might need rework? Not sure how saved variables work in this regard.)
	-- RRIncData_LootTimestamp = RRIncData_LootTimestamp or "0000-00-00 00:00:00"

	local addonName = GetAddOnMetadata("RRIncTooltip", "Title")	
	RRIncTooltip_MessagePrefix = addonName..":"
	local version = GetAddOnMetadata("RRIncTooltip", "Version")

	if isLogin then
		C_Timer.After(1, function() print(addonName.." v"..version.." loaded.") end)
	end
	
end

local FrameEnterWorld = CreateFrame("Frame")
FrameEnterWorld:RegisterEvent("PLAYER_ENTERING_WORLD")
FrameEnterWorld:SetScript("OnEvent", EventEnterWorld)