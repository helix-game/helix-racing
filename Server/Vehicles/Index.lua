Vehicles = {}

RaceCar = Vehicle.Inherit("RaceCar")

function RaceCar:Constructor(pos, rot, vehicle, col_type,engine,wheels,misc)
    self.Super:Constructor(pos, rot, vehicle.model, col_type, true, false, true, vehicle.sound)

    self:SetEngineSetup(3500, 8000, 1700)
	self:SetTransmissionSetup(3.08, 5500, 2200)

	-- Configure it's Steering Wheel and Headlights location

	self:SetSteeringWheelSetup(Vector(0, 27, 120), 24)
	self:SetHeadlightsSetup(Vector(270, 0, 70))

	self:SetAerodynamicsSetup(2500,0.3,180,140,1,Vector(0,0,25))
	self:SetCameraOffset(Vector(0,0,80))
	-- Configures each Wheel


	--WHEELS WILL BE HIGHER RADIUS , NORMALLY WE DO 18, RN IT WILL BE
	self:SetWheel(0, "Wheel_Front_Left", 24, 20, 45, Vector(), true, true, false, false, false, 2500, 4000, 1000, 1, 3,
		20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
        self:SetWheel(1, "Wheel_Front_Right", 24, 20, 45, Vector(), true, true, false, false, false, 2500, 4000, 1000, 1,
		3, 20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
        self:SetWheel(2, "Wheel_Rear_Left", 24, 20, 0, Vector(), false, true, true, false, false, 2500, 4000, 1000, 1, 4,
		20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
        self:SetWheel(3, "Wheel_Rear_Right", 24, 20, 0, Vector(), false, true, true, false, false, 2500, 4000, 1000, 1, 4,
		20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)

	-- Adds 6 Doors/Seats
	self:SetDoor(0, Vector(50, -75, 105), Vector(-25, -35, 60), Rotator(0, 0, 10), 70, -150)
    -- Make it ready (so clients only create Physics once and not for each function call above)
    self:RecreatePhysics()
end

--local car = RaceCar(Vector(500,500,100),Rotator(),{model = "helix::SK_SportsCar",sound = "nanos-world::A_Vehicle_Engine_05"},CollisionType.Auto)

PickUp = Vehicle.Inherit("PickUp")

function PickUp:Constructor(pos, rot, vehicle, col_type,engine,wheels,misc)
    self.Super:Constructor(pos, rot, vehicle.model, col_type, true, false, true, vehicle.sound)

    self:SetEngineSetup(1300, 8000, 1700)
	self:SetTransmissionSetup(3.08, 5500, 2200)

	-- Configure it's Steering Wheel and Headlights location

	self:SetSteeringWheelSetup(Vector(0, 27, 120), 24)
	self:SetHeadlightsSetup(Vector(270, 0, 70))

	self:SetAerodynamicsSetup(2500,0.3,180,140,1,Vector(0,0,25))
	self:SetCameraOffset(Vector(0,0,80))
	-- Configures each Wheel


	--WHEELS WILL BE HIGHER RADIUS , NORMALLY WE DO 18, RN IT WILL BE
	self:SetWheel(0, "Wheel_Front_Left", 24, 20, 45, Vector(), true, true, false, false, false, 2500, 4000, 1000, 1, 3,
		20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
        self:SetWheel(1, "Wheel_Front_Right", 24, 20, 45, Vector(), true, true, false, false, false, 2500, 4000, 1000, 1,
		3, 20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
        self:SetWheel(2, "Wheel_Rear_Left", 24, 20, 0, Vector(), false, true, true, false, false, 2500, 4000, 1000, 1, 4,
		20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)
        self:SetWheel(3, "Wheel_Rear_Right", 24, 20, 0, Vector(), false, true, true, false, false, 2500, 4000, 1000, 1, 4,
		20, 20, 250, 50, 10, 10, 0, 0.5, 0.5)

	-- Adds 6 Doors/Seats
	self:SetDoor(0, Vector(50, -75, 105), Vector(-25, -35, 60), Rotator(0, 0, 10), 70, -150)
    -- Make it ready (so clients only create Physics once and not for each function call above)
    self:RecreatePhysics()
end


Buggy = Vehicle.Inherit("Buggy")

function Buggy:Constructor(pos, rot, vehicle, col_type,engine,wheels,misc)
    self.Super:Constructor(pos, rot, vehicle.model, col_type, true, false, true, vehicle.sound)

    self:AddStaticMeshAttached("body", "helix::SM_Offroad_Body")
	self:AddStaticMeshAttached("wheel_BR", "helix::SM_Offroad_Tire", "VisWheel_BR", Vector(), Rotator(0, 180, 0))
	self:AddStaticMeshAttached("wheel_FR", "helix::SM_Offroad_Tire", "VisWheel_FR", Vector(), Rotator(0, 180, 0))
	self:AddStaticMeshAttached("wheel_FL", "helix::SM_Offroad_Tire", "VisWheel_FL")
	self:AddStaticMeshAttached("wheel_BL", "helix::SM_Offroad_Tire", "VisWheel_BL")

	self:SetEngineSetup(600, 5000)
	self:SetAerodynamicsSetup(1700, 0.1, 180, 160, 0.1)
	self:SetSteeringWheelSetup(Vector(0, 30, 130), 15)

	self:SetWheel(0, "PhysWheel_FL", 45, 15, 50, Vector(), true, true, false, false, false, 3000, 6000, 750, 1, 4, 20, 20, 100, 100, 20, 20, 0, 0.5, 1)
	self:SetWheel(1, "PhysWheel_FR", 45, 15, 50, Vector(), true, true, false, false, false, 3000, 6000, 750, 1, 4, 20, 20, 100, 100, 20, 20, 0, 0.5, 1)
	self:SetWheel(2, "PhysWheel_BL", 45, 15,  0, Vector(), true, true, true,  false, false, 3000, 6000, 750, 1, 4, 20, 20, 100, 100, 20, 20, 0, 0.5, 1)
	self:SetWheel(3, "PhysWheel_BR", 45, 15,  0, Vector(), true, true, true,  false, false, 3000, 6000, 750, 1, 4, 20, 20, 100, 100, 20, 20, 0, 0.5, 1)

	self:SetDoor(0, Vector(0, -80, 100), Vector(12, -30, 90), Rotator(0, 0,   0), 75, -150)

	self:RecreatePhysics()


end

Package.Export("Vehicles", Vehicles)
