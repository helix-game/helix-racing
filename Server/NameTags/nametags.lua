NameTags = {}
NameTags.__index = {}

NameTagStorage = {}

--nametags


function NameTags.AddTag(player,car,xRace)

	local pos = "" --Placement.GetPosition(player) or "" -- thisi s for NAMETAGS
	
	print(car)
			local plr_tab =
			{
				name = player:GetAccountName(),
				pos = tostring(pos),
				id = player:GetAccountID(),
				car = car
			}
	
			--plr_tabs[p:GetAccountID()] = plr_tab
	
	--	xRace:BroadcastRacers("racing-world::server:NewNametag",{plr_tab,car})
			Events.BroadcastRemote("racing-world::server:NewNametag",plr_tab,car)

end


function NameTags.LoadTags()
	local plr_tabs = {}
		for i,p in pairs(Player.GetPairs()) do
		
			local pos = 0 --placement_system.getPlrPlace(p)
	
			local plr_tab =
			{
				name = p:GetAccountName(),
				pos = pos,
			}
	
			plr_tabs[p:GetAccountID()] = plr_tab
		end
	
		Events.BroadcastRemote("loadNameTags",plr_tabs)
	
	end
	
	
	
	function NameTags.Update(xRace)
		local plr_tabs = {}
	
		for i,p in pairs(xRace:GetRacers()) do
		
		local pos = Placement.GetPlace(xRace,p)
    
	
		local plr_tab =
		{name = p:GetAccountName(),
		 pos = pos}
	
		plr_tabs[p:GetAccountID()] = plr_tab
		end
		Events.BroadcastRemote("updateNameTags",plr_tabs,#xRace:GetRacers())
	 
	end
