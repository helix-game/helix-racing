Sumo = {}


--Setting Up--

function Sumo.Start(xRace)
    
    print("START SUMO!!!")

    Sumo.SetUp(xRace)

    --spawn vehicles
    local n = 0

    xRace.racers = {}

    for i,p in pairs(xRace.players) do
        n = n+1  ;  local spawn = CONFIG.MapInfo[Server.GetMap()].spawns[n]
        xRace:AddRacer(p,Buggy,spawn.pos, spawn.rot, {model = "helix::SK_Offroad",sound = "nanos-world::A_Vehicle_Engine_05"},CollisionType.Auto)
    end

    Chat.BroadcastMessage("Force other players out of the <blue>safe zone</>.")

end



function Sumo.SetUp(xRace)
    --load map?

    --[[
    local platform = StaticMesh(Vector(0,0,10000),Rotator(0,90,0),"helix::SM_Cylinder")
    platform:SetScale(Vector(100,100,1))
    
    platform:SetMaterial("helix::M_Default_Masked_Lit")
    platform:SetMaterialColorParameter("Tint", Color.FromRGBA(150, 50, 0))
    
    Vector(X = 9067.7311446208, Y = -14428.403978247, Z = 3072.2979609564)
    
    ]]
    local zone = StaticMesh(Vector(9067, -14428, 2500), Rotator(0, 45, 0), "zone::SM_ZoneSphere", 2)
    zone:SetScale(Vector(3,3,3))
    xRace.zone = zone

    table.insert(xRace.entities,platform)
    table.insert(xRace.entities,zone)
    
    xRace.timers = {}

    xRace.timers.fall = Timer.SetInterval(Sumo.FallCheck,5000,xRace)
    xRace.timers.shrink = Timer.SetInterval(Sumo.ShrinkZone,10000,xRace)
    xRace.timers.elim = Timer.SetInterval(Sumo.CheckEliminate,1000,xRace)
end

--




--Get--

function Sumo.GetAlive(xRace)
    
end



function Sumo.GetEliminated(xRace)
    
end

----


--Events--

function Sumo.ShrinkZone(xRace)
    local zone = xRace.zone
    local size = zone:GetScale()
    
    local x = HELIXMath.Clamp(size.X - 0.2,0.3,10)
    local y = HELIXMath.Clamp(size.Y - 0.2,0.3,10)
    local z = HELIXMath.Clamp(size.Z - 0.2,0.3,10)

    zone:SetScale(Vector(x,y,z))

    --Chat.BroadcastMessage("The <blue>safe zone</> is getting smaller!")
end



function Sumo.Eliminate(xRace,player)    
    
    --post process screen
    Events.CallRemote("racing::client:darkScreen",player)
    xRace:EliminatePlayer(player,true)

    
end



function Sumo.FallCheck(xRace)
    
    for i, player in pairs(xRace.racers) do
        local character = player:GetControlledCharacter()

        if character then

            if character:GetLocation().Z < CONFIG.MapInfo[Server.GetMap()].spawns[1].pos.Z - 1200 then

                Sumo.Eliminate(xRace, player)
            end

        end

    end

end



function Sumo.CheckEliminate(xRace)
    
    for i, player in pairs(xRace.racers) do
        local character = player:GetControlledCharacter()

        if character then
            local dist = character:GetLocation():Distance(xRace.zone:GetLocation())
            
            if dist > 950 * xRace.zone:GetScale().X then --5000 then
                print("PLAYER IS ELIMINATED")

                Sumo.Eliminate(xRace, player)
            end

        end
    end
end



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

Package.Export("Sumo",Sumo)