MM = {}

Default_Settings = {

    max_racers = 2,
    max_rounds = 5,
    round_time = 300

}

local Lobbies = {}

--[[
Worlds = {

    Sumo = {name = "sumo-world", matches = {}, tab = Sumo},
    Face2Face = {"face2face-world", matches = {}, tab = Face2Face},
    Track = {"track-world", matches = {}, tab = TrackRace},

}
]]

Worlds = {

    trackrace = "d558009", 
    face2face = "",
    sumo = "x51717b"

}


function MM.PlayerAdded(player, gamemode)
    print("WORDLS1", Worlds[gamemode])
    Matchmaking.LeaveAllMatchmaking(player, function(success)
        if success then
            Matchmaking.JoinMatchmaking(Worlds[gamemode], player, Default_Settings.max_racers/2,
                function(success, match_id, current_players, min_players)
                    if success then
                        print("WORDLS", Worlds[gamemode])

                        if Lobbies[match_id] then
                            print("add player to lobby!")

                            table.insert(Lobbies[match_id].players, player)
                            Events.CallRemote("UpdateLobby", player, match_id)
                        else
                            print("new lobby", match_id)

                            Lobbies[match_id] = { players = { player }, gamemode = gamemode, min_players = min_players }
                            Events.CallRemote("UpdateLobby", player, match_id)

                        end
                    end
                end)
        end
    end)
end

function MM.CheckLobbies()
    --print(HELIXTable.Dump(Lobbies))


    for match_id, lobby_data in pairs(Lobbies) do
        print(#lobby_data.players .. "/" .. lobby_data.min_players)

        Matchmaking.CheckMatchmakingStatus(match_id,
            function(success, match_id, current_players, min_players, match_status, ip_address)
                print(current_players .. "/" .. min_players)
                print(success, match_status)
                if success and match_status == 'running' and ip_address ~= '' then
                    for i, p in pairs(lobby_data.players) do
                        print("Connecting player")
                        p:Connect(ip_address)
                    end

                    Lobbies[match_id] = nil
                end
            end)
    end
    --end
end

Timer.SetInterval(MM.CheckLobbies, 10000)

Package.Export("MM", MM)


Events.SubscribeRemote("LeaveMatchMaking", function (player,playerLobby)
    
    Matchmaking.LeaveAllMatchmaking(player, function(success)
        removePlayerFromLobby(playerLobby,player,Lobbies)
        print("SUCCESS", success)
        
    end)

end)

function removePlayerFromLobby(lobbyID, playerToRemove, lobbies)

    if not lobbies[lobbyID] then
        print("Lobby not found.")
        return false
    end

   
    if not lobbies[lobbyID].players then
        print("Players list not found in the lobby.")
        return false
    end

 
    for index, player in pairs(lobbies[lobbyID].players) do
        if player == playerToRemove then
       
            table.remove(lobbies[lobbyID].players, index)
            print("Player removed from lobby.")
            return true
        end
    end

    print("Player not found in the lobby.")
    return false
end

Package.Export("MM",MM)

