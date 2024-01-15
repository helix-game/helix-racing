Racing_World = {}

hud = {

    start_menu = false,
    end_menu = false,
    main_hud = false,
    speedometer = false,
    main_menu = false
}

time = 500

hud.main_hud = nil





last_pos = false
function Calculate_MPH()

    if Client.GetLocalPlayer():GetControlledCharacter() then 
    local char = Client.GetLocalPlayer():GetControlledCharacter()

    if char then
        local car = char:GetVehicle()
        --print(car:GetRPM())
        if car:GetRPM() ~= 0 then
            local current_pos = char:GetLocation()

            --print(last_pos,car:GetVelocity())
            if last_pos and car:GetVelocity():IsZero() == false then
                --print("this!")

                local distance = current_pos:Distance(last_pos)
                local speed = distance / (time) * 10
                local mph = HELIXMath.Round((speed * 2.23694)) -- convert "speed" to actual mph - estimation is not perfect

                local tab = {
                    action = "show",
                    isMetric = false, --false,
                    speed = mph,
                    rpm = car:GetRPM(),
                    gear = car:GetGear()
                }
                --print(car:GetRPM())
                if car:GetRPM() > 1200 and speed <= 250 then
                    hud.main_hud:CallEvent("SetDashboard", car:GetRPM(),mph,car:GetGear())
                end
                --speedometer = hud.speedometer
                --speedometer:CallEvent("Speedometer", tab)
                --Events.CallRemote("speedFOV",mph,car:GetRPM()/60)
                --end
            end

            last_pos = current_pos
        end
    end
end
end
local mph_timer = Timer.SetInterval(Calculate_MPH, time)



Events.SubscribeRemote("racing::client:darkScreen",function ()
    PostProcess.SetGlobalSaturation(Color(0,0,0))    
end)



Events.SubscribeRemote("racing::client:normalScreen",function ()
    PostProcess.SetGlobalSaturation(Color(1,1,1))    
end)


Events.SubscribeRemote("racing::server:EnterCheckpoint",function (checkpoint,next_checkpoint)
    print(checkpoint,next_checkpoint)
    
    checkpoint:SetVisibility(false)
    next_checkpoint:SetVisibility(true)
    for i,v in pairs(next_checkpoint:GetAttachedEntities()) do
        v:SetVisibility(false)
    end

    
    --play sound
    local sound = Sound(Vector(), Package:GetName().."/Client/sounds/CHECKPOINT.ogg", true,true)
end)


Events.SubscribeRemote("racing::server:ReloadCheckpoints",function (checkpoints)

    for i,checkpoint in pairs(checkpoints) do
    
        if i > 1 then 
            checkpoint:SetVisibility(false)
        else
            checkpoint:SetVisibility(true)
            for i,v in pairs(checkpoint:GetAttachedEntities()) do
                v:SetVisibility(false)
            end
        end 
          
    end

end)

function HideCheckpoint()
    
end

function ShowCheckpoint(checkpoint)
    
    checkpoint:SetVisibility(true)
    
    for i, v in pairs(checkpoint:GetAttachedEntities()) do
        v:SetVisibility(false)
    end
    
end

--UIS

local GameID = ""

function Racing_World.MainMenu() -- BEFORE MATCHMAKING!
    local main_menu = WebUI(
        "lobby",
        "file://UI/lobby-stunt_races/index.html" or "file://UI/menu/index.html",
        WebUIVisibility.Visible
   ) 

   hud.main_menu = main_menu
   Input.SetMouseEnabled(true)

   local name,lvl,prog = Client.GetLocalPlayer():GetName(),1,0
   main_menu:CallEvent("SetupUI",name,lvl,prog)

   main_menu:Subscribe("play",function(gamemode)
        print(gamemode)

        Events.CallRemote("racing-worlds::client:playerJoins",gamemode)

        hud.main_menu:Destroy()
   end)



   main_menu:Subscribe("BeginMM",function(gamemode)
        print(gamemode)

        Events.CallRemote("racing-worlds::client:playerJoins",gamemode)

        --hud.main_menu:Destroy()
    end)

end
Events.SubscribeRemote("racing-worlds::server:playerJoins",Racing_World.MainMenu)



function Racing_World.CompletedRace(scoreboard,i)
    
    --make the ui
   
    if not hud.end_menu then
        local scoreboardUI = WebUI(
            "lobby",
            "file://Client/UI/scoreboard-stunt_races/index.html",
            WebUIVisibility.Visible
        )

        hud.end_menu = scoreboardUI
        Input.SetMouseEnabled(true)
    end

    scoreboard[i].you = true
    
    hud.end_menu:CallEvent("UpdateScoreboard",scoreboard)

    hud.main_hud:Destroy()
    hud.main_hud = nil

end
Events.SubscribeRemote("racing-worlds::server:CompletedRace",Racing_World.CompletedRace)



function Racing_World.SetupUI(gameID,lobby)

    GameID = gameID
    local start_menu = WebUI(
        "lobby",
        "file://UI/lobby/index.html",
        WebUIVisibility.Visible
   ) 

   hud.start_menu = start_menu

   Input.SetMouseEnabled(true)

   print(HELIXTable.Dump(lobby))
   hud.start_menu:CallEvent("update_Menu",lobby)
    
end
Events.SubscribeRemote("racing-worlds::server:playerMatchmaked",Racing_World.SetupUI)


function Racing_World.ReadyRequest()
    print("READY UP!")
    Events.CallRemote("racing-worlds::client:ReadyRequest",GameID)
end
WebUI.Subscribe("click",Racing_World.ReadyRequest)


function Racing_World.UpdateRacers(racers)
    print("update racers!")
    print(HELIXTable.Dump(racers))
    hud.start_menu:CallEvent("update_Menu",racers)
end
Events.SubscribeRemote("racing-worlds::server:updateRacers",Racing_World.UpdateRacers)


--start game
function Racing_World.RemoveLobby()
    hud.start_menu:Destroy()
    hud.start_menu = false

    local main_hud = WebUI(
        "Speedometer",
        "file://UI/game-stunt_races/index.html" or "file://UI/main_hud/index.html",
        WidgetVisibility.Visible
   ) 

   hud.main_hud = main_hud

   Input.SetMouseEnabled(false)

end
Events.SubscribeRemote("racing-worlds::server:RemoveLobby",Racing_World.RemoveLobby)

--HUD

Input.Register("Respawn","R","Respawn the racer")

Input.Bind("Respawn",InputEvent.Released,function ()
    print("respawn!")
    Events.CallRemote("racing-worlds::client:Respawn")
end)

--MENU




--NAMETAGS
nametag_list = {}
name_tag_ui = {}

NameTag = {}

function NameTag.New(tag_info,car)
    
    print(car)

    local name = tag_info.name
    local pos = tag_info.pos
    local id = tag_info.id

    local nametag_UI = WebUI(
    "NameTag",
    "file://UI/NAMETAGS/index.html",
    WidgetVisibility.Hidden)
    --print(id,"MEOW!!!")
    name_tag_ui[id] = nametag_UI
   
    nametag_UI:CallEvent("load_NameTag",{name = tag_info.name, pos = tag_info.pos})
    local nametag = Billboard(
    Vector(0,0,0), -- location
    "helix::M_Default_Masked_Unlit", -- material
    Vector2D(55, 100), -- size
    false)
    nametag:SetVisibility(true)
    nametag:SetMaterialFromWebUI(nametag_UI)
    nametag:AttachTo(car,AttachmentRule.SnapToTarget,"",0)
    nametag:SetRelativeLocation(Vector(0,0,250))

    print(nametag:GetLocation())
    
    nametag_list[id] = nametag
end
Events.SubscribeRemote("racing-world::server:NewNametag",NameTag.New)



function loadNameTags(plr_tag)

        local car = plr_tag.car
        local name = plr_tag.name
        local pos = plr_tag.pos
        local id = plr_tag.id

        local nametag = WebUI(
        "NameTag",
        "file://UI/NAMETAGS/index.html",
        WebUIVisibility.Hidden)
        --print(id,"MEOW!!!")
        name_tag_ui[id] = nametag
       
        nametag:CallEvent("load_NameTag",{name = plr_tag.name,plr_tag.pos})

        local my_billboard = Billboard(
        Vector(0,0,0), -- location
        "helix::M_Default_Masked_Unlit", -- material
        Vector2D(55, 100), -- size
        false)
        my_billboard:SetVisibility(true)
        my_billboard:SetMaterialFromWebUI(nametag)
        my_billboard:AttachTo(car)
        my_billboard:SetRelativeLocation(Vector(0,0,250))
        
        nametag_list[id] = my_billboard
        --print(#nametag_list,#name_tag_ui)
end
Events.SubscribeRemote("loadNameTags",loadNameTags)



function updateNameTags(plrs,total_racers)
    --print("CHANGE")

    for id,tag in pairs(plrs) do 
        --print(id,tag)
        --print(#name_tag_ui)
        --print(id)
       -- print(nametag_list[id]:IsVisible())
        --if not nametag_list[id]:IsVisible() then
          --  print("VISIBLE!")
            --nametag_list[id]:SetVisibility(true)
        --end
        --print(tostring(tag.pos))

        success, e = pcall(function()
            name_tag_ui[id]:CallEvent("TEST")
        end)
        if success then 
        name_tag_ui[id]:CallEvent("updateNameTag",tostring(tag.pos))
        hud.main_hud:CallEvent("SetPosition",tostring(tag.pos),total_racers)

        end
    end
end
Events.SubscribeRemote("updateNameTags",updateNameTags)



function UpdateProgress(progress)
    if hud.main_hud then 
        hud.main_hud:CallEvent("SetProgress",progress)
    end
end
Events.SubscribeRemote("racing-world::server:UpdateProgress",UpdateProgress)



function StartCountdown()
    if hud.main_hud then 
        hud.main_hud:CallEvent("StartCountdown")
    end
end
Events.SubscribeRemote("racing-world::server:StartCountdown",StartCountdown)



function StartTimer()
    if hud.main_hud then 
        hud.main_hud:CallEvent("StartTimer")
    end
end
Events.SubscribeRemote("racing-world::server:StartTimer",StartTimer)



