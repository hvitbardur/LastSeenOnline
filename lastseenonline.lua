local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
LastSeenOnlineList = {}

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then
    	print("LastSeenOnline loaded. For more info type /lso help")
        -- Our saved variables, if they exist, have been loaded at this point.
    end
end)

local function LastOnline(clubId)
	-- local player = UnitName("player")
	memberIds = CommunitiesUtil.GetMemberIdsSortedByName(clubId);
	allMemberList = CommunitiesUtil.GetMemberInfo(clubId, memberIds);
	LastSeenOnlineList[clubId] = {}

	for index, data in ipairs(allMemberList) do -- go through the complete member list
		if (allMemberList[index].presence==1 and allMemberList[index].isSelf==false) then -- presence 1:online, 3:offline
			LastSeenOnlineList[clubId][allMemberList[index].name] = time()
		end
	end
end

local function CheckAllCommunities()
	clubs = C_Club.GetSubscribedClubs()
	for index, data in ipairs(clubs) do
		if (tonumber(clubs[index].clubType)==1) then -- The value is 1 if the club is a community, 2 if it's a guild
			club = clubs[index].clubId
			LastOnline(club)
		end
	end
end

SLASH_LASTSEENONLINE1 = "/lso"
SlashCmdList["LASTSEENONLINE"] = function(msg)
	local club
	local clubs = {}

	if (msg == "") then
		CheckAllCommunities()
	elseif (msg == "help") then
		print("This addon looks in your communities and makes timestamps for online players. Methods to evaluate the timestamps will be added later. The addon runs automatically when you log in, log off, reload the interface with /reload or manually if you type /lso in the chat.")
	end
end
