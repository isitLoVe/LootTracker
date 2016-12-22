function LootTracker_OnLoad()

	DEFAULT_CHAT_FRAME:AddMessage(string.format("LootTracker version %s by %s", GetAddOnMetadata("LootTracker", "Version"), GetAddOnMetadata("LootTracker", "Author")));
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("CHAT_MSG_ADDON");   
    this:RegisterEvent("CHAT_MSG_LOOT")
    
	SlashCmdList["LootTracker"] = LootTracker_SlashCommand;
	SLASH_LootTracker1 = "/loottracker";
	SLASH_LootTracker2 = "/lt";
	
	local MSG_PREFIX = "LootTracker"
	
	
	lootpattern_looter = "^([^%s]+) receive loot" 
	lootpattern_loot = "%[(.+)]"
 	you = "You"
	
	LootTracker_color_common = "cffffffff"
	LootTracker_color_uncommon = "cff1eff00"
	LootTracker_color_rare = "cff0070dd"
	LootTracker_color_epic = "cffa335ee"
	LootTracker_color_legendary = "cffff8000"

	LootTracker_enabled = true
end

function LootTracker_OnEvent()
	if event == "CHAT_MSG_LOOT" and arg1 and LootTracker_enabled == true then
		timestamp = date("%y-%m-%d %H:%M:%S")
		
		if not LootTrackerDB then
			LootTrackerDB = {}
		end
		
		--check rarity
		
		

		--extract the person who looted
		local _, _, looter = string.find(arg1, lootpattern_looter)
		if looter then
			if looter == you then
				looter = UnitName("player")
			end
		end
		
		--extract the loot
		local _, _, loot = string.find(arg1, lootpattern_loot)
		
		--add loot to DB
		DEFAULT_CHAT_FRAME:AddMessage(timestamp .. " " .. looter .. " --> " .. loot)
		if getn(LootTrackerDB) == 0 then
			LootTrackerDB[1] = timestamp .. " " .. looter .. " --> " .. loot
		else
			LootTrackerDB[getn(LootTrackerDB)+1] = timestamp .. " " .. looter .. " --> " .. loot
		end
	end
end

function LootTracker_SlashCommand( msg )

	if msg == "help" then
		DEFAULT_CHAT_FRAME:AddMessage("no help available yet")
	elseif msg == "toggle" then
		if LootTracker_enabled == true then
			LootTracker_enabled = false
			DEFAULT_CHAT_FRAME:AddMessage("LootTracker disabled")
		elseif LootTracker_enabled == false then
			LootTracker_enabled = true
			DEFAULT_CHAT_FRAME:AddMessage("LootTracker enabled")
		end
	elseif msg == "enable" then
		LootTracker_enabled = true
		DEFAULT_CHAT_FRAME:AddMessage("LootTracker enabled")
	elseif msg == "disable" then
		LootTracker_enabled = false
		DEFAULT_CHAT_FRAME:AddMessage("LootTracker disabled")
	elseif msg == "epic" then		
		if LootTracker_epic == true then
			LootTracker_epic = false
			DEFAULT_CHAT_FRAME:AddMessage("LootTracker will NOT track Epic items")
		elseif LootTracker_enabled == false then
			LootTracker_epic = true
			DEFAULT_CHAT_FRAME:AddMessage("LootTracker is now tracking Epic items")
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("no help available yet")
	end

end

