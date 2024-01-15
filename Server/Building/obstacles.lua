Obstacles = StaticMesh.Inherit("Obstacles")

--


--MOVING--
Hammer = Obstacles.Inherit("Hammer")

function Hammer:Constructor(location,rotation,color,speed)
    --self.Super:Constructor(location, rotation, "helix::SM_Cube")


    local hammer_arm = self.Super:Constructor(location, rotation, "nanos-world::SM_Cylinder")
		hammer_arm:SetScale(Vector(1, 1, 14))
	
	local hammer_head = StaticMesh(location, rotation, "nanos-world::SM_Cube")
		hammer_head:SetScale(Vector(2.5, 5, 2.5))
		hammer_head:AttachTo(hammer_arm)

		hammer_head:SetRelativeLocation(Vector(0,0,40))
		local darker = 20
		local c = Vector(color.R,color.G,color.B) - Vector(darker/255,darker/255,darker/255)
		local darker_col = Color(c.X,c.Y,c.Z)

		--print(darker_col,color)
		hammer_arm:SetMaterialColorParameter("Tint",darker_col)
		hammer_head:SetMaterialColorParameter("Tint",color)

		local min = hammer_arm:GetRotation() - Rotator(0,0,270)
		local max = hammer_arm:GetRotation() + Rotator(0,0,270)
		hammer_arm:SetRotation(min)
		local swing = "min"

		local timer = (speed-0.5)*1000

		local rotator_timer = Timer.SetInterval(function(param1, param2) --needs to swing back and forth like pendulum
			--print("swing to "..swing)
			local rot
			if swing == "min" then 
				rot = max
				swing = "max"
			else
				rot = min
				swing = "min"
			end
			--print(rot)
			hammer_arm:RotateTo(rot, speed, 0)
			

		end, timer)

    
end


Windmill = Obstacles.Inherit("Windmill")

function Windmill:Constructor(location,rotation,color,speed)
    local rotator_mesh1 = self.Super:Constructor(location, rotation, "nanos-world::SM_Cylinder")
	rotator_mesh1:SetScale(Vector(0.5, 1, 15))

    local rotator_mesh2 = StaticMesh(location, rotation + Rotator(0,0,90), "nanos-world::SM_Cylinder")
	rotator_mesh2:SetScale(Vector(0.5, 1, 15))


	rotator_mesh2:SetMaterialColorParameter("Tint",color)
	rotator_mesh1:SetMaterialColorParameter("Tint",color)
    
    local timer = (speed-0.5)*1000

	local rotator_timer = Timer.SetInterval(function()
	
		local rot = rotator_mesh1:GetRotation() + Rotator(0,0,90)
			rotator_mesh1:RotateTo(rot, speed, 0)

		
		local rot2 = rotator_mesh2:GetRotation() + Rotator(0,0,90)
			rotator_mesh2:RotateTo(rot2, speed, 0)

			
		
		
	
	end, timer)


rotator_mesh1:SetNetworkAuthority(nil)
rotator_mesh2:SetNetworkAuthority(nil)

end


--STATIONARY--
Spike = Obstacles.Inherit("Spike")

function Spike:Constructor(location,rotation,color,scale)
    local spike = self.Super:Constructor(location, rotation, "helix::SM_TriPyramid")
	spike:SetScale(scale)
end

