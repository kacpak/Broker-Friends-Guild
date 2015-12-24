local db
local playerName, playerRealm = UnitName("player"), GetRealmName()

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:GetDataObjectByName("Friends") or ldb:NewDataObject("Friends", {
	type = "data source", icon = [[Interface\Icons\Inv_cask_04]], text = "0/0",
	OnClick = function(self, button)
		if button == "RightButton" then
			ToggleGuildFrame()
			if ( IsInGuild() ) then
				GuildFrameTab2:Click()
			end
		else
			ToggleFriendsFrame(1)
		end
	end,
})

local function UpdateText()
	friendsOn, guildOn = 0, 0
	for i = 1, GetNumFriends() do
		local name, lvl, class, area, online, status, note = GetFriendInfo(i)
		if ( online ) then
			friendsOn = friendsOn + 1
		end
	end
	
	for j = 1, BNGetNumFriends() do
		local BNid, BNname, battleTag, _, toonname, toonid, client, online, lastonline, isafk, isdnd, broadcast, note = BNGetFriendInfo(j)
		if ( online ) then
			friendsOn = friendsOn + 1
		end
	end
	
	if ( IsInGuild() ) then		
		for i = 0, select(1, GetNumGuildMembers()) do
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR = GetGuildRosterInfo(i)
			if ( online ) then
				guildOn = guildOn + 1
			end
		end
	
		dataobj.text = string.format("|cffffffffFriends: |cffffcc00%d |cffc0c0c0/ |cffffffffGuild: |cffffcc00%d", friendsOn, guildOn)
	else
		dataobj.text = string.format("|cffffffffFriends: |cffffcc00%d |cffc0c0c0/ |cffffffffNo Guild", friendsOn)
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
f:RegisterEvent("ADDON_LOADED")
f.ADDON_LOADED = UpdateText
f:RegisterEvent("PLAYER_LOGIN")
f.PLAYER_LOGIN = UpdateText
f:RegisterEvent("FRIENDLIST_UPDATE")
f.FRIENDLIST_UPDATE = UpdateText
f:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
f.BN_FRIEND_ACCOUNT_ONLINE = UpdateText
f:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
f.BN_FRIEND_ACCOUNT_OFFLINE = UpdateText
f:RegisterEvent("GUILD_ROSTER_UPDATE")
f.GUILD_ROSTER_UPDATE = UpdateText
f:RegisterEvent("PLAYER_GUILD_UPDATE")
f.PLAYER_GUILD_UPDATE = UpdateText
