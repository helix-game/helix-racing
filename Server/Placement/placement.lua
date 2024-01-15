Placement = {}



function Placement.Update(xRace) --set to a timer!
    
    if not xRace.places then
        xRace.places = {}
    end 
    
    if #xRace.completed_racers == #xRace.racers then
        xRace:EndRound()
    end

    local racers = xRace.racers

    print("COMPLETED RACERS!",#xRace.completed_racers)

    local places =  {}

    

    local sort_tab = {} 

    --table.sort

    print("RACERS!:",HELIXTable.Dump(racers))
    for i,player in pairs(racers) do --get their progress
        if player:GetControlledCharacter() then 
            local progress = Placement.GetProgress(xRace,player)
            table.insert(sort_tab,{plr = player, prog = progress})
        end
    end

    table.sort(sort_tab, function (k1, k2) return k1.prog > k2.prog end )

    print("SORT!:",HELIXTable.Dump(sort_tab))

    --print("hmm...",#sort_tab,#places,#sort_tab + #places)

    for i,v in pairs(xRace.completed_racers) do
        table.insert(places,v)
    end

    for i,v in pairs(sort_tab) do
        table.insert(places,v)
    end

    xRace.places = places

    print(#xRace.places)
    --print(HELIXTable.Dump(xRace.places))

    NameTags.Update(xRace)

end



function Placement.GetPlace(xRace,player)
    for i,v in pairs(xRace.places) do
        if v.plr:GetAccountID() == player:GetAccountID() then
            return i
        end
    end
end

--[[

how to get and how to calculate progress

player enters checkpoint

function playercheckpoint runs
    set value?


]]

function Placement.PlayerCheckpoint(xRace,player)
    local checkpoints = player:GetValue("Checkpoints") or 0 --maybe do it on the car?
    local laps = player:GetValue("Laps") or 0 --maybe do it on the car?
    
    player:SetValue("Checkpoints",checkpoints+1)

    if player:GetValue("Checkpoints") == xRace.checkpoints then

        Events.CallRemote("racing::server:ReloadCheckpoints",player,xRace.checkpoints)

        player:SetValue("Laps",laps+1)

        --print(player:GetValue("Laps"), xRace.laps)

        if player:GetValue("Laps") == xRace.laps then
            --complete race ?
        end
        
        
    end


    --local complete_prog = #xRace.checkpoints * xRace.laps 

end



function Placement.GetProgress(xRace,player)
    
    if player:GetControlledCharacter() then
    local checkpoints = player:GetValue("Checkpoints") or 0 --maybe do it on the car?
    local laps = player:GetValue("Laps") or 0 --maybe do it on the car?

    --get progress between next checkpoint

    local current_checkpoint_pos, next_checkpoint

    --print(checkpoints)
    if xRace.checkpoints[checkpoints+1] and checkpoints > 1 then
         current_checkpoint_pos, next_checkpoint = xRace.checkpoints[checkpoints]:GetLocation() , xRace.checkpoints[checkpoints+1]:GetLocation()
    
    elseif xRace.checkpoints[checkpoints+1] then 
         current_checkpoint_pos, next_checkpoint = Vector(39369,5433,2314) , xRace.checkpoints[checkpoints+1]:GetLocation()

    else --completed race
        
        --if player:GetControlledCharacter() then
           
            xRace:CompletedRace(player) --COMPLETE RACE!

        --end
        
    end

    local checkpoint_distance = current_checkpoint_pos:Distance(next_checkpoint)
    local player_distance = next_checkpoint:Distance(player:GetControlledCharacter():GetVehicle():GetLocation())

    --[[
    print("PREV CHECKPOINT DISTANCE TO NEXT CHECKPOINT:",checkpoint_distance)
    print("PLAYER DISTANCE TO NEXT CHECKPOINT:",player_distance)
    ]]

    local checkpoint_prog  = HELIXMath.Clamp((checkpoint_distance-player_distance)/checkpoint_distance,0,1) --significantly more calculations to this
    local total_checkpoints_prog =  checkpoints
    local lap_prog = laps

    --print(checkpoint_prog,total_checkpoints_prog,lap_prog)

    local completion_prog = #xRace.checkpoints + xRace.laps

    local progress = math.floor((checkpoint_prog + total_checkpoints_prog + lap_prog)*100)/100 / completion_prog 

    Events.CallRemote("racing-world::server:UpdateProgress",player,(math.floor(progress*100)/100)*100)

    return math.floor(progress*100)/100
end
end