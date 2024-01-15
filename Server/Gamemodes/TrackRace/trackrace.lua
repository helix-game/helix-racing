TrackRace = {}




--Setting Up--

function TrackRace.Start(xRace)
    
    print("START!!!")

    TrackRace.SetUp(xRace)

    --spawn vehicles
    local n = 0

    xRace.racers = {}

    for i,p in pairs(xRace.players) do
        n = n+1  ;  local spawn = CONFIG.MapInfo[Server.GetMap()].spawns[n]
        xRace:AddRacer(p,RaceCar,spawn.pos, spawn.rot, {model = "helix::SK_SportsCar",sound = "nanos-world::A_Vehicle_Engine_05"},CollisionType.StaticOnly)
    end    
    

    Chat.BroadcastMessage("Complete the race by going through all the <blue>checkpoints</>.")

end



function TrackRace.SetUp(xRace)

    --anti gravity boost Vector(X = 45259.250449656, Y = -16200.783690246, Z = 539.69507995747)	 
    local gravity_loop_pos_tab = {

        {Vector(45150,-16350,1500),Rotator(90,-90,0)},
        {Vector(45050,-16200,2100),Rotator(115,-90,0)},
        {Vector(44950,-15650,2750),Rotator(140,-90,0)},
        {Vector(44850,-15000,3100),Rotator(165,-90,0)},
        {Vector(44750,-14200,3100),Rotator(190,-90,0)},
        {Vector(44650,-13400,2800),Rotator(-145,-90,0)},
        {Vector(44550,-12750,2000),Rotator(-120,-90,0)},
        {Vector(44450,-12600,1100),Rotator(-90,-90,0)},
        {Vector(44300,-12850,300),Rotator(-60,-90,0)},
    
    }

    
    local loop = GravityLoop(Vector(45265,-16270,200),Rotator(5,0,0),Color(),Vector(600,300,300),gravity_loop_pos_tab)

    local gravity_wall_pos_tab = {

        {Vector(55300,-50500,3437),Rotator(15,-70,-60)},
        {Vector(55250,-51500,3437),Rotator(15,-95,-60)},
        {Vector(54900,-52500,3600),Rotator(15,-120,-60)},
        {Vector(54200,-53300,3800),Rotator(15,-130,-50)},
       
        {Vector(51800,-54800,3300),Rotator(-5,-135,0)},
        {Vector(51800,-54800,3300),Rotator(-5,-135,0)},
    
    }

    local wall = GravityWall(Vector(54731,-50331,3437),Rotator(0,5,0),Color(),Vector(600,300,300),gravity_wall_pos_tab)
    
    xRace.timers = {}
    --checkpoints

    xRace.checkpoints = {}
    print(Server.GetMap())
    print(HELIXTable.Dump(CONFIG.MapInfo[Server.GetMap()]))
    xRace.laps = CONFIG.MapInfo[Server.GetMap()].laps


    for i,pos in pairs(CONFIG.MapInfo[Server.GetMap()].checkpoints) do
        local checkpoint = Checkpoint(xRace,pos,Rotator(0,0,0))  
        table.insert(xRace.checkpoints,checkpoint)      
    end

    xRace.timers.placementupdate = Timer.SetInterval(function () --add to timer list
        Placement.Update(xRace)
    end,1000)

    -- speed boosts too
   
end

--


--GET--

----


--Events--




--ROUNDS--

--[[

function Sumo.NewRound(xRace)
    xRace:NewRound()
end

]]


--[[
function Sumo.EndRound(xRace)
    local winner = xRace.players[1]

    --Chat.BroadcastMessage(winner:GetName()..' WINS!')
    xRace:EndRound()
    
end
]]
----

Package.Export("TrackRace",TrackRace)