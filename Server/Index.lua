Racing_World = {}
Racing_World.__index = Racing_World
Races = {}

Default_Settings = {

    max_racers = 2,
    max_rounds = 1,
    round_time = 300

}



--Gamemodes
Package.Require("Server/Gamemodes/Sumo/sumo.lua")
Package.Require("Server/Gamemodes/Face2Face/face2face.lua")
Package.Require("Server/Gamemodes/TrackRace/trackrace.lua")

--Systems--
Package.Require("Server/Vehicles/Index.lua")
Package.Require("Server/NameTags/nametags.lua")
Package.Require("Server/Placement/placement.lua")
Package.Require("Server/Building/objects.lua")
Package.Require("Server/Matchmaking/mm.lua")
Package.Require("Server/.CONFIG/config.lua")


--MAPS--

MAP_INFO = {

    ["racing-world:RacingMap"] = {gamemode = "trackrace"},
    ["racing-world:SumoMap"] = {gamemode = "sumo"},
    ["racing-world:FaceToFaceMap"] = {gamemode = "face2face"},

    --add your maps



}


--[[
if map_name == "racing-world::RacingMap" then

        gamemode = "trackrace"

    elseif map_name == "racing-world::SumoMap" then

        gamemode = "sumo"

    elseif map_name == "racing-world::FaceToFaceMap" then

        gamemode = "face2face"

    end
Racing worlds is a standalone world that others can use as a template for creating and modifying their own game(mode)s


3 Gamemodes

Sumo - There's a big platform and loads of cars, the platform safezone will shrink and more players will fight for their survival

Face-To-Face - Players start at different positions and tend to overlap, so players will be tempted to push others off

Standard Race - 3 laps, checkpoints, standard

let lobbyPlayers = [
    {
        name: "Bradcoxy",
        ready: true,
        joined: true,
    },
    {
        name: "Dobby",
        ready: false,
        joined: false,
    },
];

]]

function Racing_World.FormatLobby(players)
    local lobby = {}

    for i,v in pairs(players) do
        table.insert(lobby,{name = v:GetName(),ready = false, joined = true})
    end

    return lobby
end

function Racing_World.New(gamemode, max_racers, players, max_rounds, round_time, teams)
    local xRace = setmetatable(Racing_World, {})

    xRace.gameID = math.random(1, 5000)
    xRace.gamemode = gamemode
    
    xRace.max_racers = max_racers
    xRace.respawn_times = {}
    xRace.lobby = { players = Racing_World.FormatLobby(players), timer = false }
    
    xRace.round = 0
    xRace.max_rounds = max_rounds
    xRace.round_time = round_time

    
    xRace.entities = {}
    
    --Server.SetMaxPlayers(max_racers) ?? should we basically "lock" the server so no one else can join now


    --lobby--

    xRace.lobby.timer = Timer.SetInterval(CheckLobby, 5000, xRace)
    --

    table.insert(Races, xRace)


    

    return xRace
end

---


function Racing_World:ReturnInfo()
    return self.players
end



function Racing_World:GetPlayers() --all players, dead or alive
    return self.players
end


function Racing_World:GetRacers() --all alive racers
    return self.racers
end



function Racing_World:GetPlayerFromLobby(player)

    for i, v in pairs(self.lobby.players) do
       
        if v.name == player:GetName() then
            return i
            --self.lobby.players[i].ready = true
        end

    end

end



function Racing_World:GetRaceFromPlayer(player)

    for n, race in pairs(Races) do
       
       for i,p in pairs(race.racers) do

            if p:GetAccountID() == player:GetAccountID() then
            
                return race

            end

        end

    end

end



function Racing_World:BroadcastRacers(event_name,...) --all alive racers


    for i,plr in pairs(self.racers) do
        Events.CallRemote(event_name,plr,...)
    end
end

---rounds


function Racing_World:Start()


    Timer.ClearInterval(self.lobby.timer)

    
    print(self.gamemode)
    self.players = Player.GetAll() or self.lobby.ready_players
    self.racers = Player.GetAll() or self.lobby.ready_players

    self.lobby = nil --remove lobby
    
    self.roundstarted = Server.GetTime()
    self.completed_racers = {}

    self:BroadcastRacers("racing-worlds::server:RemoveLobby")

    self:NewRound()
end



function Racing_World:End()
    --remove entire race, send players back to lobby pool  ?
    --send players

    self:Rewards()

    Chat.BroadcastMessage("Race has ended! Will shut down in 1 minute!")
    self = nil

    --do we kick players?

    Timer.SetTimeout(function ()
    
        --[[
        for i,v in pairs(Player:GetPairs()) do
            v:Kick("Game is over!")
        end
        ]]

        --shutdown
        Server.Stop()
        
    end,60000)
    

end

function Racing_World:ClearRace()
    
    for i,v in pairs(self.timers) do
        Timer.ClearInterval(v)
    end

    for i,v in pairs(self.entities) do
        v:Destroy()
        --table.remove(self.entities,i)
    end

    for i,v in pairs(self.racers) do
        self:RemoveRacer(v)
        --table.remove(self.entities,i)

    end

    self.entities = {}
    self.racers = {}
end



function Racing_World:EndRound()

    Chat.BroadcastMessage("ROUND IS NOW OVER!")

    self:ClearRace()

    --self:BroadcastRacers("racing::client:darkScreen")

    Timer.SetTimeout(function()
        print(self.round , self.max_rounds)

        if self.round < self.max_rounds then
            
            self:NewRound()

        else
            self:End()
        end

    end, 10000)

end



function Racing_World:NewRound()
    self.round = self.round + 1

    self.completed_racers = {}

    print(self.gamemode)

    self:BroadcastRacers("racing-world::server:StartCountdown")
    

    Timer.SetTimeout(function()
        self.roundstarted = Server.GetTime()

        self:FreezeRacers(true)

        self:BroadcastRacers("racing-world::server:StartTimer")
        Chat.BroadcastMessage("ROUND HAS BEGUN!")
        --unlock racers?
    end, 5500)

        self.gamemode['Start'](self)
        self:FreezeRacers(false)


        self:BroadcastRacers("racing::client:normalScreen")

        --timeout for round--

        Timer.SetTimeout(function()
            self:EndRound()
        end, self.round_time * 1000)


end

--actions 


function Racing_World:Rewards()

end



function Racing_World:FreezeRacers(freeze_type)

    for i,racers in pairs(self.racers) do
        racers:GetControlledCharacter():GetVehicle():SetGravityEnabled(freeze_type)
    end

end

--[[
function Racing_World:DarkScreen(player) --all alive racers
    Events.CallRemote("racing::client:darkScreen",player)
end
]]



function Racing_World.RespawnRequest(player)

    local char = player:GetControlledCharacter()
    local car = char:GetVehicle()
    local xRace = Racing_World:GetRaceFromPlayer(player)
    

    if car then --check respawn thing
        
        if xRace.respawn_times[player:GetAccountID()] then
            
            if xRace.respawn_times[player:GetAccountID()] <= os.time() then
                xRace:RespawnPlayer(player)
            end

        else
            xRace:RespawnPlayer(player)
        end

    end

end
Events.SubscribeRemote("racing-worlds::client:Respawn",Racing_World.RespawnRequest)



function Racing_World:RespawnPlayer(player)
    local checkpoints = player:GetValue("Checkpoints")    

    local pos = self.checkpoints[checkpoints]:GetLocation() or CONFIG.MapInfo[Server.GetMap()].spawns[#CONFIG.MapInfo[Server.GetMap()].spawns] --MapConfig[Server.GetMap()].Checkpoints[checkpoints]

    local char = player:GetControlledCharacter()
    local car = char:GetVehicle()

    self.respawn_times[player:GetAccountID()] = os.time()+15

    print("RESPAWN!!!")

    car:SetGravityEnabled(false)

    print(self.checkpoints[checkpoints]:GetLocation())

    print(car:GetLocation():Distance(pos))

    car:SetCollision(CollisionType["NoCollision"])
    car:TranslateTo(pos+Vector(0,0,250),0.1)
    car:RotateTo(self.checkpoints[checkpoints]:GetRotation(),0.1)

    --rotation too

    Timer.SetTimeout(function ()
        car:SetGravityEnabled(true)
        car:SetCollision(CollisionType["Auto"])
    end,7000)
     
end



function Racing_World:RemovePlayer(player)
    local n
    for i,p in pairs(self:GetPlayers()) do
        if player:GetAccountID() == p:GetAccountID() then
            n = i
            break
        end
    end
    
    self.players[n] = nil
    --table.remove(self.players,n)

end



function Racing_World:EliminatePlayer(player,explode_vehicle)
    local n
    for i,p in pairs(self:GetRacers()) do
        if player:GetAccountID() == p:GetAccountID() then

            Events.CallRemote("racing::client:darkScreen",player)

            Chat.SendMessage(player,"You have been <red>ELIMINATED</>.")

            if explode_vehicle then 
                self:RemoveRacer(player,true)
            end

            table.remove(self.racers,i)

            break
        end
    end

    if #self.racers == 1 then -- win conditions

        Timer.SetTimeout(function ()
            self:EndRound()    
        end,5000)
        
    end
end


function Racing_World:RemoveRacer(player,has_particle)
    local char = player:GetControlledCharacter()

    local success, e = pcall(function (...)
        char:GetVehicle():GetID()  
    end)


    if success then
        local vehicle = char:GetVehicle()
        
        if has_particle then 
            local my_particle = Particle(vehicle:GetLocation(),Rotator(0, 0, 0),"helix::P_Explosion",true,false)
            my_particle:SetScale(Vector(5,5,5))
            my_particle:Activate(false)
        end
        
        vehicle:Destroy()
        char:Destroy()

    end
    
end



function Racing_World:AddRacer(player, VehicleType, pos, rot, vehicleInfo, col)


    local car = VehicleType(pos, rot, vehicleInfo,col)

    local character = Character(Vector(0, 0, 0), Rotator(0, 0, 0), "helix::SK_Quinn")

    local racer = { car = car, char = character }

    NameTags.AddTag(player,car)

    player:Possess(character)
    character:EnterVehicle(car)

    table.insert(self.racers, player)

    return racer
end



function Racing_World:CompletedRace(player)
    player:SetValue("Completed",true)

    local char = player:GetControlledCharacter()
    local vehicle = char:GetVehicle()


    player:UnPossess() --?
   
    --add ui
    local t = Server.GetTime()
    local completed_tab = {plr = player, time = t}

    table.insert(self.completed_racers,completed_tab)
    
    self:RemoveRacer(player)

    --Events.CallRemote("racing-worlds::server:CompletedRace",player,self.completed_racers)
    
    local scoreboard = {}

    Timer.SetTimeout(function ()
       
        for i,v in pairs(self.completed_racers) do
        
            print(HELIXTable.Dump(v))
            local tab = {}
            
            tab.name = v.plr:GetName()
            tab.position = i
            tab.time = (t - self.roundstarted)
            tab.you = false
            --[[
    
            name: "Kravs",
                position: 4,
                time: "00:23.12",
                you: false
    
            ]]
    
            table.insert(scoreboard,tab)
    
            Events.CallRemote("racing-worlds::server:CompletedRace",v.plr,scoreboard,i) 
        end
        --self:BroadcastRacers("racing-worlds::server:CompletedRace",self.completed_racers)

    end,1000)
    

end


--Get--

function Racing_World.GetRaceFromID(gameID)
    for i, race in pairs(Races) do
        if race.gameID == gameID then
            return race
        end
    end
end


function Racing_World.GetLobbyLength(tab)
    
    local n = 0

    for i, v in pairs(tab) do
        n = n + 1
    end

    return n
end

--Lobby--





function CheckLobby(xRace)

    if xRace.lobby then

        local ready_players = 0
        for i,v in pairs(xRace.lobby.players) do
            if v.ready then
                ready_players = ready_players+1
            end
        end 

        if ready_players >= math.ceil(xRace.max_racers/2) or #xRace.lobby.players >= xRace.max_racers then
            xRace:Start()
        end

    end

end



function Racing_World:AddPlayer(player)

    if not Racing_World:GetPlayerFromLobby(player) then
        table.insert(self.lobby.players,{name = player:GetName(), ready = false, joined = true})
    end
    
    --self.lobby.players[id] = player

    Events.BroadcastRemote("racing-worlds::server:updateRacers",self.lobby.players)
end



function Racing_World:PlayerReady(player)
    local n = Racing_World:GetPlayerFromLobby(player)
    
    if n then
       self.lobby.players[n].ready = not self.lobby.players[n].ready
    end

    Events.BroadcastRemote("racing-worlds::server:updateRacers",self.lobby.players)

end



function Racing_World.ReadyRequest(player, gameID)
    local xRace = Racing_World.GetRaceFromID(gameID)

    xRace:PlayerReady(player)
end
Events.SubscribeRemote("racing-worlds::client:ReadyRequest",Racing_World.ReadyRequest)



--- @param game string? Choose a random or gamemode for the user if requested 
function Racing_World.PickGameMode(game)
    
    local gamemodes = {sumo = Sumo, trackrace = TrackRace, face2face = Face2Face}
    local gamemodes_array = {Sumo,TrackRace}

    if game then 

    return gamemodes[game]
    
    else

        return gamemodes_array[math.random(1,#gamemodes)]

    end
end



function Racing_World.Matchmaking(player,gamemode_request)

    
    --[[

    local xRace

    if #Races == 0 then
        --new game

        local gamemode = Racing_World.PickGameMode(gamemode_request)

        xRace = Racing_World.New(gamemode, Default_Settings.max_racers, { player },Default_Settings.max_rounds,Default_Settings.round_time)
    else
        local n = math.random(1, #Races) --better matchmaking
        xRace = Races[n]
    end

    return xRace
    ]]
end

function Racing_World.GetGamemodeFromMap()
 
    local map_name = Server.GetMap()
    local gamemode

    --Server:GetMapConfig()

    if map_name == "racing-world::RacingMap" then

        gamemode = TrackRace or "trackrace"

    elseif map_name == "racing-world::SumoMap" then

        gamemode = Sumo or "sumo"

    elseif map_name == "racing-world::FaceToFaceMap" then

        gamemode = Face2Face or "face2face"

    end

    
    return gamemode 
end

function Racing_World.PlayerJoins(player)
    
    if Server.GetMap() == "default-blank-map" or Server.GetMap() == "nanos-world::BlankMap" then

        Events.CallRemote("racing-worlds::server:playerJoins",player)

    else

        local xRace

        if #Races == 0 then
            local gamemode = Racing_World.GetGamemodeFromMap()

            xRace = Racing_World.New(gamemode, CONFIG.MapInfo[Server.GetMap()].max_racers, { player },CONFIG.MapInfo[Server.GetMap()].max_rounds,CONFIG.MapInfo[Server.GetMap()].round_time)

        else
            local n = math.random(1, #Races) --better matchmaking
            xRace = Races[n]
        end

        Events.CallRemote("racing-worlds::server:playerMatchmaked",player,xRace.gameID,xRace.lobby.players)
        xRace:AddPlayer(player)

    end
    
    --[[
    local xRace = Racing_World.Matchmaking(player)

    Events.CallRemote("racing-worlds::server:playerMatchmaked",player,xRace.gameID,xRace.lobby.players)
    xRace:AddPlayer(player)
    ]]
    --xRace:PlayerReady(player) -- keep this until has a ui
    
end
Player.Subscribe("Ready", Racing_World.PlayerJoins)



function Racing_World.PlayerStarts(player,gamemode) --this is temporary stuff
    

     
    MM.PlayerAdded(player,gamemode)

    --[[ old way!
    local xRace = Racing_World.Matchmaking(player,gamemode)

    Events.CallRemote("racing-worlds::server:playerMatchmaked",player,xRace.gameID,xRace.lobby.players)
    xRace:AddPlayer(player)
    ]]
end
Events.SubscribeRemote("racing-worlds::client:playerJoins",Racing_World.PlayerStarts)




--[[
local platform = StaticMesh(Vector(0,0,5000),Rotator(0,90,0),"helix::SM_Cylinder")
platform:SetScale(Vector(100,100,1))

local zone = StaticMesh(Vector(0, 0, 5000), Rotator(0, 45, 0), "zone::SM_ZoneSphere", 2)
zone:SetScale(Vector(5.5,5.5,5.5))
]]
