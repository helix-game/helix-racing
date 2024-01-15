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


function MM.PlayerAdded(player,gamemode)
    
    Matchmaking.JoinMatchmaking(Worlds[gamemode], player, Default_Settings.max_racers, function (success, match_id, current_players, min_players)

    if success then 

        print(Worlds[gamemode])

        if Lobbies[match_id] then
            print("add player to lobby!")

            table.insert(Lobbies[match_id].players,player)

        else

            print("new lobby",match_id)

            Lobbies[match_id] = {players = {player},gamemode = gamemode, min_players = min_players}

        end

    end    

    end)

end

function MM.CheckLobbies()

    print(HELIXTable.Dump(Lobbies))

    --if #Lobbies > 0 then --and something somehting race started alreadyh
        --print("Check Lobbies!")

        for match_id, lobby_data in pairs(Lobbies) do
            print(#lobby_data.players.."/"..lobby_data.min_players)

            Matchmaking.CheckMatchmakingStatus(match_id,
                
            function(success, match_id, current_players, min_players, match_status, ip_address)
                
                print(current_players.."/"..min_players)
                
                if success  then
                        
                    for i, p in pairs(lobby_data.players) do
                        p:Connect(ip_address)
                    end

                    Lobbies[match_id] = nil

                    end

                end)

        end
    --end

end

Timer.SetInterval(MM.CheckLobbies, 10000)

Package.Export("MM",MM)


--[[ OLD SYSTEM

function MM.NewMatchmaking(gamemode,player,hosting) -- replace old one when ready
    

    function MM.SetUP(success, match_id, current_players,min_players)
        
        if success then
            Worlds[gamemode].matches[match_id] = { players = current_players, config = { min_players = min_players, level_range = {min = 0, max = 100} } }
        end

    end

    function MM.Join(success, match_id, current_players,min_players)
        
        if success then
            Worlds[gamemode].matches[match_id] = { players = current_players, config = { min_players = min_players, level_range = {min = 0, max = 100} } }
        end

    end



    if #Worlds[gamemode].matches < 1 or hosting then 
        Matchmaking.CreateMatchmaking(gamemode, player, Default_Settings.max_racers, MM.SetUP)
    else
        Matchmaking.JoinMatchmaking(gamemode,player,Default_Settings.max_racers,MM.Join)
    end

end



--- @param game string? Choose a random or gamemode for the user if requested 
function MM.PickGameMode(game)
    
    local gamemodes = {sumo = Sumo, trackrace = TrackRace}
    local gamemodes_array = {Sumo,TrackRace}

    if game then 

    return gamemodes[game]
    
    else

        return gamemodes_array[math.random(1,#gamemodes)]

    end
end



function MM.Matchmaking(player,gamemode_request)

    local xRace

    if #Races == 0 then
        --new game

        local gamemode = MM.PickGameMode(gamemode_request)

        xRace = Racing_World.New(gamemode, Default_Settings.max_racers, { player },Default_Settings.max_rounds,Default_Settings.round_time)
    else
        local n = math.random(1, #Races) --better matchmaking
        xRace = Races[n]
    end

    return xRace
end



function MM.PlayerJoins(player)
    
    Events.CallRemote("racing-worlds::server:playerJoins",player)
    
    --SQUARE SQUARE
    local xRace = Racing_World.Matchmaking(player)

    Events.CallRemote("racing-worlds::server:playerMatchmaked",player,xRace.gameID,xRace.lobby.players)
    xRace:AddPlayer(player)
    ]
    --xRace:PlayerReady(player) -- keep this until has a ui
    
end
Player.Subscribe("Ready", Racing_World.PlayerJoins)



function MM.PlayerStarts(player,gamemode) --this is temporary stuff
    
    local xRace = MM.Matchmaking(player,gamemode)

    print("meow!")
    Events.CallRemote("racing-worlds::server:playerMatchmaked",player,xRace.gameID,xRace.lobby.players)
    xRace:AddPlayer(player)

end
Events.SubscribeRemote("racing-worlds::client:playerJoins",Racing_World.PlayerStarts)




--SQUARE SQUARE
local platform = StaticMesh(Vector(0,0,5000),Rotator(0,90,0),"helix::SM_Cylinder")
platform:SetScale(Vector(100,100,1))

local zone = StaticMesh(Vector(0, 0, 5000), Rotator(0, 45, 0), "zone::SM_ZoneSphere", 2)
zone:SetScale(Vector(5.5,5.5,5.5))
]]


