CONFIG = {


    Settings = {


        Testing =         
        {
            max_racers = 2,
            max_rounds = 1,
            round_time = 300
        },

        
        Default = 
        {
            max_racers = 8,
            max_rounds = 3,
            round_time = 300
        },


        --premade gamemodes-- 

        trackrace = 
        {
            max_racers = 8,
            max_rounds = 1,
            round_time = 900
        },


        sumo = 
        {
            max_racers = 8,
            max_rounds = 3,
            round_time = 300
        },


        face2face = 
        {
            max_racers = 8,
            max_rounds = 3,
            round_time = 300
        },


        -- add your own gamemode!

    },

    MapInfo = {

    ["racing-world::RacingMap"] = 
    
    {    
        gamemode = "trackrace",
        
        spawns = 
        {

            {pos = Vector(39220,5259,2140) , rot = Rotator(0,-30,0)},
            {pos = Vector(39508,5757,2140) , rot = Rotator(0,-30,0)},
            
            {pos = Vector(39812,4914,2140) , rot = Rotator(0,-30,0)},
            {pos = Vector(40099,5417,2140) , rot = Rotator(0,-30,0)},

            {pos = Vector(40397,4571,2140) , rot = Rotator(0,-30,0)},
            {pos = Vector(40687,5078,2140) , rot = Rotator(0,-30,0)},

            {pos = Vector(40926,4259,2140) , rot = Rotator(0,-30,0)},
            {pos = Vector(41220,4771,2140) , rot = Rotator(0,-30,0)}

        },

        checkpoints = 
        {
            Vector(46331,-2628,1728),
            --[[
            Vector(41739,-26473,-45),
            Vector(34445,-29563,3790),
            Vector(35769,-20383,6736),
            Vector(48600,-39951,4655), 
            Vector(51188,-55603,3235), 
            Vector(47510,-59369,3235)
            ]]
        },

        laps = 1,
        max_racers = 2 or 8,
        max_rounds = 1,
        round_time = 300,

    },
    


    ["racing-world::SumoMap"] = {    
        gamemode = "sumo",
        
        spawns = 
        {

            {pos = Vector(6554, -14331, 2411) , rot = Rotator(0,0,0)},
            {pos = Vector(11128, -14331, 2411) , rot = Rotator(0,180,0)},
            {pos = Vector(8782, -14331, 2411) , rot = Rotator(0,-90,0)},
            {pos = Vector(8870, -14331, 2411) , rot = Rotator(0,90,0)},
            {pos = Vector(10436, -14331, 2411) , rot = Rotator(0,145,0)},
            {pos = Vector(7293, -14331, 2411) , rot = Rotator(0,-45,0)},
            {pos = Vector(7181, -14331, 2411) , rot = Rotator(0,45,0)},
            {pos = Vector(10444, -14331, 2411) , rot = Rotator(0,-145,0)},

        },

        laps = 1,
        max_racers = 8,
        max_rounds = 1,
        round_time = 300,
    },
    ["racing-world::FaceToFaceMap"] = {gamemode = "face2face"},

    },


}


Package.Export("CONFIG",CONFIG)