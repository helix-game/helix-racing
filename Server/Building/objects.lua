Objects = StaticMesh.Inherit("Objects")

--


Checkpoint = Objects.Inherit("Checkpoint")

function Checkpoint:Constructor(xRace,location,rotation,color,scale)
    self.Super:Constructor(location, rotation, "pco-markers::SM_MarkerCylinder",CollisionType.NoCollision)

    self:SetMaterialColorParameter("Color", Color.FromRGBA(130, 217, 200,0.5))
    
    --marker:AttachTo(checkpoints[#checkpoints])
    self:SetScale(Vector(5,5,75))
    --marker:SetRelativeLocation(Vector(0,0,-2500))
    
    
    local trigger = Trigger(location,rotation,Vector(400,400,400),TriggerType.Sphere,false)
    
    trigger:AttachTo(self)

    local n = #xRace.checkpoints+1 -- ??
    
    if n == 1 then
        --self:SetVisibility(true)
    else
        self:SetVisibility(false)
    end

    print(n)
    trigger:Subscribe("BeginOverlap",function (t, entity)
        
        if entity:IsA(Vehicle) then


            local char = entity:GetPassenger(0)
            local player = char:GetPlayer()

            if (player:GetValue("Checkpoints") or 0) < n then 

                print(self,xRace.checkpoints[n])
                Events.CallRemote("racing::server:EnterCheckpoint",player,self,xRace.checkpoints[n+1])
            
                Placement.PlayerCheckpoint(xRace,player)
            
            end

        end

    end)

end




NitroBoost = Objects.Inherit("NitroBoost")

function NitroBoost:Constructor(location,rotation,color,scale)
    self.Super:Constructor(location, rotation, "pco-markers::SM_MarkerArrow",CollisionType.NoCollision)
    self:SetMaterialColorParameter("Color", color or Color.FromRGBA(130, 217, 200,0.5))

    local trigger = Trigger(location,rotation,Vector(400,400,400),TriggerType.Sphere,false)
    
    trigger:AttachTo(self)

    
    trigger:Subscribe("BeginOverlap",function (t, entity)
        
        if entity:IsA(Vehicle) then

            local char = entity:GetPassenger(0)
            local player = char:GetPlayer()

            Events.CallRemote("racing::server:ScreenSFX",player)

        end

    end)

end


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

GravityLoop = Objects.Inherit("GravityLoop")

function GravityLoop:Constructor(location,rotation,color,scale,positions)
    self.Super:Constructor(location, rotation, "pco-markers::SM_MarkerArrow",CollisionType.NoCollision)
    local trigger = Trigger(location, rotation,scale,TriggerType.Box,false,color)

    trigger:Subscribe("BeginOverlap",function (self, entity)
        if entity:IsA(Vehicle) then
            print("meow")
            local n = 2
    
            local char = entity:GetPassenger(0)
            local player = char:GetPlayer()
    
            --local cam = StaticMesh(Vector(41000,-14450,1300),Rotator(),"helix::SM_Cylinder")
            --player:AttachCameraTo(cam,Vector(),0)
            --cam:Destroy()
    
            
            entity:SetGravityEnabled(false)
    
    
            entity:TranslateTo(positions[1][1],0.5)
            entity:RotateTo(positions[1][2],0.5)
    
            Timer.SetInterval(function ()
                if n < #positions then
                    print("moove!")
                    local info = positions[n]
                    entity:TranslateTo(info[1],0.3)
                    entity:RotateTo(info[2],0.3)
                    n = n+1
                else
                    entity:SetGravityEnabled(true)
                    --Timer.ClearInterval(1)
                    Timer.SetTimeout(function ()
                        
                        --player:AttachCameraTo(char,Vector(0,300,0),0)
    
                        --player:ResetCamera()
                        --player:Possess(char)
                        --player:AttachCameraTo(nil)
                    end,300)
                end
            end,301)
        end
    
    end)

end




GravityWall = Objects.Inherit("GravityWall")

function GravityWall:Constructor(location, rotation, color, scale, positions)
    self.Super:Constructor(location, rotation, "pco-markers::SM_MarkerArrow", CollisionType.NoCollision)

    local trigger = Trigger(location, rotation, scale, TriggerType.Box, false, color)


    trigger:Subscribe("BeginOverlap", function(self, entity)
        if entity:IsA(Vehicle) then
            local n = 2

            local char = entity:GetPassenger(0)
            local player = char:GetPlayer()

            --local cam = StaticMesh(Vector(41000,-14450,1300),Rotator(),"helix::SM_Cylinder")
            --player:AttachCameraTo(cam,Vector(),0)
            --cam:Destroy()


            --entity:SetGravityEnabled(false)
            entity:SetCollision(CollisionType.NoCollision)

            entity:TranslateTo(gravity_wall_pos_tab[1][1], 0.3)
            entity:RotateTo(gravity_wall_pos_tab[1][2], 0.3)

            Timer.SetInterval(function()
                if n < #gravity_wall_pos_tab then
                    print("moove!")
                    local info = gravity_wall_pos_tab[n]

                    entity:TranslateTo(info[1], 0.5)
                    entity:RotateTo(info[2], 0.5)
                    n = n + 1
                else
                    --Timer.ClearInterval(1)
                    Timer.SetTimeout(function()
                        entity:SetCollision(CollisionType.IgnoreOnlyPawn)
                        --entity:SetGravityEnabled(true)


                        --player:AttachCameraTo(char,Vector(0,300,0),0)

                        --player:ResetCamera()
                        --player:Possess(char)
                        --player:AttachCameraTo(nil)
                    end, 500)
                end
            end, 501)
        end
    end)
end



