-- ZZA_LIGHT_LOAD_MAIN.lua

-- alright i fucked it again; we went to make a light, simple mod and accidentally turned it into a slog again-- here's me committing to a wildly simpler format for how we're gonna do this mod now the right; we start with a blank sheet of paper; we're calling this mod 'lightLoadWeekOne' and it's a mod that simplifies/fixes spawning/de-spawning to make it better and easier on computers-- but here's how we do it different from last time: first-- we start with AN EMPTY lua file 'ZZA_LIGHT_LOAD_MAIN.lua' which is named such so that it loads after all other mods in the 'bandits week one' mod in project zomboid that this mod utilizes/alters and that way i assume we don't need all this extra bullshit with hooks when we wanna modify that mods global functions using wrappers; we just do a SUPER SIMPLE WRAPPER for every single global function that week one created which either spawns or de-spawns zombies and/or NPCs but instead of trying to work WITH those functions and only alter them a LITTLE BIT, THIS TIME WE'RE JUST GONNA INSTANTLY RETURN-- that way we can create our OWN mechanisms for spawning/de-spawning and don't need to worry about conflict or overlap-- but the ONLY thing in our mod when we first open it up in game, as i said-- is going to be that single empty lua file (but with a simple 'ontick' function and 'onPress' function and function that saves our created mod-data table that gets called in those two functions so that our mod-data saves every time we hit the 'escape' key to leave the game and every few minutes as an 'auto-save' mechanism. That should be the only thing that our mod has inside it to start with when we boot up our game. And everything will be something that we create/test in-game within the lua console: that way we might better ensure it's as light and simple structurally as it can possibly be. But I still kinda wanna go over some LOOSE, VAGUE IDEA of how i'm gonna structure some of that before I instantly jump right in with you. 


-- add two global variables:
quickCountNearbyNpcs_R69 = 0

quickCountNearbyZeds_R69 = 0

totZedsOverFlow_R69 = 0

maxNpcs_R69 = 100
maxZeds_R69 = 350

npcsCloserThan20dist_R69 = 0

activeSpawningHutKeyId = nil

local savedKeyId = nil




local function pauseThenGlobalSave12()

    local player = getPlayer(0)
    local pl = getPlayer(0)

    if not player then 
        do return end
    end

    pl:Say("[SAVING NPC MOD DATA...]")

    print("SAVING GAME NOW...")

    local sc = UIManager.getSpeedControls()
    -- if not sc then return nil end
    local prev = sc:getCurrentGameSpeed()
    -- sc:SetCurrentGameSpeed(0) -- pause

    local hutsCsv = ModData.getOrCreate("hutsCsv")

    -- local vipsHere = ModData.getOrCreate("vipsHere")

    ModData.transmit("hutsCsv")


end




local function dripSpawnZs4Huts(keyId_in)

    -- Phase 2D — Zombie Drip Spawn: Make dripSpawnZs4Huts() slowly add those hut zombies back later, because the poof step only works if it also leads into a believable delayed return.

    local keyId = keyId_in

    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())







    local numberOfZombies = ZombRand(1, 10)

    local rand1 = ZombRand(16, 34)
    local rand2 = ZombRand(16, 34)


    -- hutsCsv

    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsCsv = ModData.getOrCreate("vipsCsv")






    ------------------------------------------------------ 🍪🍪
    -- NO DOUBLE-DIPPING OR SPAWNING WHILE DE-SPAWNING:

    for k, v in pairs(hutsCsv) do
        -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

        keyId = tonumber(k)

        if math.abs(tonumber(v.totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 3 then
            do return end
        end

    end




    if activeSpawningHutKeyId == nil then
        if hutsCsv[keyId] ~= nil then
    
            if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 3 and math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 63 then
                activeSpawningHutKeyId = keyId
            end
            
        end
        
    end

    if activeSpawningHutKeyId == nil then
        do return end
    else


        if math.abs((hutsCsv[activeSpawningHutKeyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 63 then
            activeSpawningHutKeyId = nil
            do return end
        end
    end

    if activeSpawningHutKeyId ~= keyId then
        do return end
    end




    ---------------------------------- NO DOUBLE-DIPPING 🍪

 

    -- 34 and 34 diff -> 48 dist -> this should be MAX total so if (math.abs(rand1) + math.abs(rand2)) is ever MORE than 68 (34+34) then we reset it by doing: rand1 = ZombRand(14, 34); rand2 = ZombRand(14, 34);

    -- print(BanditUtils.DistTo(px, py, px + 34, py + 34)) 


    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsCsv = ModData.getOrCreate("vipsCsv")

    local zedsHere = ModData.getOrCreate("zedsHere")

    local rand3 = ZombRand(1, 100)

    if not hutsCsv[keyId] then
        do return end
    end

    if hutsCsv[keyId].totZombiesLeft < 1 then
        do return end
    else

        if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 3 then
            do return end
        else
            if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 60 or math.abs(hutsCsv[keyId].dayLastSeen - getGameTime():getDay()) >= 2 then

                if math.abs(hutsCsv[keyId].dayLastSeen - getGameTime():getDay()) >= 2 then

                    if rand3 > 50 then

                        if (4 + rand3) % 4 == 0 then

                            if hutsCsv[keyId].totZombiesLeft > 0 then
                                hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft + ZombRand(1, 10)
                            end

                        else

                            hutsCsv[keyId].totZombiesLeft = math.floor(hutsCsv[keyId].totZombiesLeft / 2)

                        end

                        -- buildingDef = 

                        if hutsCsv[keyId].isAlarmed == true or rand3 >= 90 then

                            hutsCsv[keyId].totMinutesAtFirstSeen = math.abs((getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) - 4

                            hutsCsv[keyId].totMinutesWhenLastSeen=math.abs((getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24)))

                            -- or we just do this and have a slow drip of MANY zombies spawn in for a while again (in ADDITION to the starting clump of just the one big clump at once) if some alarm has been going off in here for a long time slowly 


                        end

                    end

                    numberOfZombies = ZombRand(7, 14)

                    if getGameTime():getDay() > 20 then
                        numberOfZombies = ZombRand(7, 20)
                    else
                        if getGameTime():getDay() >= 14 then
                            numberOfZombies = ZombRand(7, (getGameTime():getDay()))
                        end
                    end

                    if hutsCsv[keyId].totZombiesLeft < numberOfZombies then

                        numberOfZombies = hutsCsv[keyId].totZombiesLeft

                        if numberOfZombies < 1 then
                            numberOfZombies = 1
                        end
                    end

                    local bonusZeds = math.abs(hutsCsv[keyId].dayLastSeen - getGameTime():getDay())

                    if bonusZeds > 20 then
                        bonusZeds = 20
                    end

                    if bonusZeds > 2 then
                        numberOfZombies = numberOfZombies + ZombRand(1, bonusZeds)
                    end

                    hutsCsv[keyId].dayLastSeen = getGameTime():getDay()

                    -- SINGLE large-ish burst/clump spawns nearby

                    if hutsCsv[keyId].isAlarmed == true then

                        -- if building alarm was going up for DAYS then they're already gonna be clustered up RIGHT NEARBY:

                        rand1 = ZombRand(14, 21)
                        rand2 = ZombRand(14, 21)
                    else
                        rand1 = ZombRand(21, 49)
                        rand2 = ZombRand(21, 49)
                    end

                    if ZombRand(1, 100) > 50 then

                        -- ...or THIS triggers and no zombie clump spawns in at this point:

                        do return end

                    end

                    if ZombRand(1, 10) >= 5 then
                        rand1 = rand1 * (-1)
                    else
                        rand2 = rand2 * (-1)
                    end

                end

            end
        end

    end







    



    local maleOutfits = { "Chef", "Redneck", "Hunter", "Camper", "MallSecurity", "Cook_Generic", "BWOFormal", "Young", "John", "Priest", "Dean", "Thug", "Party", "OfficeWorker", "Classy", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "Farmer", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Gas2Go", "GigaMart_Employee", "Pharmacist", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal", "SportsFan", "Varsity", "StreetSports", "Waiter_Spiffo", "Spiffo" }

    local femaleOutfits = { "OfficeWorkerSkirt", "Cook_Generic", "Party", "DressShort", "BWORainGeneric02", "BWORainGeneric01", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "BWOYoung", "BWOCow", "BWOLeather", "", "DressNormal", "DressShort", "Classy", "Young", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Gas2Go", "GigaMart_Employee", "Pharmacist", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal", "SportsFan", "Varsity", "StreetSports", "Bandit", "Waiter_Classy", "Waiter_Spiffo", "Waiter_Diner", "Waiter_Restaurant", "Spiffo", "Farmer" }


    if getGameTime():getDay() >= 16 then
               

        maleOutfits = {"PoliceState", "PoliceRiot", "AmbulanceDriver", "Pharmacist", "Nurse", "Doctor", "Bandit", "ZSPoliceSpecialOps", "PoliceState", "PoliceRiot", "BWOYoung", "Police", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Chef", "Redneck", "Hunter", "Camper", "MallSecurity", "Cook_Generic", "BWOFormal", "Young", "John", "Priest", "Dean", "Thug", "Party", "OfficeWorker", "Classy", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "Farmer", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Gas2Go", "Bandit", "Pharmacist", "SportsFan", "Varsity", "StreetSports", "Waiter_Spiffo", "Spiffo", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Chef", "Redneck", "Hunter", "Camper", "Bandit", "Cook_Generic", "BWOFormal", "Young", "John", "Priest", "Dean", "Thug", "Party", "OfficeWorker", "Classy", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "Farmer", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Bandit", "GigaMart_Employee", "Pharmacist", "SportsFan", "Varsity", "StreetSports", "Waiter_Spiffo", "Spiffo", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal", "Security"}
        
        femaleOutfits = {"Pharmacist", "Nurse", "Doctor", "Bandit", "Police", "Generic01",  "Generic02", "Generic03", "Generic04", "Generic05", "BWOYoung", "BWOCow", "BWOLeather", "SportsFan", "Varsity", "StreetSports", "Bandit", "Waiter_Classy", "Waiter_Spiffo", "Waiter_Diner", "Waiter_Restaurant", "Spiffo", "OfficeWorkerSkirt", "Cook_Generic", "Party", "DressShort", "BWORainGeneric02", "BWORainGeneric01", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "BWOYoung", "BWOCow", "BWOLeather", "Joan", "DressNormal", "DressShort", "Classy", "Young", "Biker", "Punk", "Rocker", "Fireman", "Bandit", "Gas2Go", "Bandit", "Pharmacist", "SportsFan", "Varsity", "StreetSports", "Bandit", "Waiter_Classy", "Waiter_Spiffo", "Waiter_Diner", "Waiter_Restaurant", "Spiffo", "OfficeWorkerSkirt", "Cook_Generic", "Party", "DressShort", "BWORainGeneric02", "BWORainGeneric01", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "BWOYoung", "BWOCow", "BWOLeather", "Joan", "DressNormal", "DressShort", "Classy", "Young", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Bandit", "GigaMart_Employee", "Pharmacist", "Farmer", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal" }
        
    end


    if ZombRand(1, 100) > 50 then

        if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 10 or math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) >= 50 then
            numberOfZombies = math.ceil(numberOfZombies / 4)
        else

            if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 15 or math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) >= 45 then
                numberOfZombies = math.ceil(numberOfZombies / 3)
            else

                if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 20 or math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) >= 40 then
                    numberOfZombies = math.ceil(numberOfZombies / 2)
                end

            end

        end

    end



    if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 5 or math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) >= 55 then

        numberOfZombies = math.ceil(numberOfZombies / 4)

        if numberOfZombies > 3 then
            numberOfZombies = ZombRand(1, 3)
        end

    end



    local unisexOutfitsMiniTab = {"Generic01", "Generic02", "Generic03", "Generic04", "Generic05"}

    local text = tostring(unisexOutfitsMiniTab[ZombRand(1, (#unisexOutfitsMiniTab))])

    local femaleChanceHere = 50

    if ZombRand(1, 100) > 80 then
        numberOfZombies = 1
        
        if ZombRand(1, 100) > 50 then

            femaleChanceHere = 0
            text = tostring(maleOutfits[ZombRand(1, (#maleOutfits))])

        else
            femaleChanceHere = 100
            text = tostring(femaleOutfits[ZombRand(1, (#femaleOutfits))])

        end
    end

    if ZombRand(1, 1000) > 500 then
        rand2 = (-1) * (rand2)
    end
    if ZombRand(1, 1000) > 500 then
        rand1 = (-1) * (rand1)
    end
    
    -- 34 and 34 diff -> 48 dist -> this should be MAX total so if (math.abs(rand1) + math.abs(rand2)) is ever MORE than 68 (34+34) then we reset it by doing: rand1 = ZombRand(14, 34); rand2 = ZombRand(14, 34);

    -- print(BanditUtils.DistTo(px, py, px + 34, py + 34)) 

    if (math.abs(rand1) + math.abs(rand2)) > 68 then
        rand1 = ZombRand(21, 34)
        rand2 = ZombRand(21, 34)
    end

    local count = getNumActivePlayers()
    local pl = getPlayer(0)

    if count > 1 then
        -- print("more than one player")
        -- pl:Say("more than one player")

        -- we wanna spawn them a little further away probably if there's more than one player present (for split-screen co-op so we don't spawn right on top of another player)

        for i = (count - 1), (count) do

            local px = getPlayer(i):getX()
            local py = getPlayer(i):getY()
            local pz = math.floor(getPlayer(i):getZ())

            -- make sure to not mess up immersion of anyone else when doing local split-screen co-op by spawning zeds RIGHT IN FRONT OF THEM:

            if BanditUtils.DistTo(px, py, (px + rand1), (py + rand2)) < 10 and pz == 0 then
                numberOfZombies = 0
                do return end
            else
                if BanditUtils.DistTo(px, py, (px + rand1), (py + rand2)) < 20 and tostring(LosUtil.lineClear(getCell(), px, py, pz, px + rand1, py + rand2, pz, false)) == "Clear" then
                    numberOfZombies = 0
                    do return end
                end
            end

        end

        if (math.abs(rand1) + math.abs(34)) < 68 then
            rand2 = 34
        else
            if (math.abs(34) + math.abs(rand2)) < 68 then
                rand1 = 34
            end
        end

    else
        -- print("there's only ONE player")
        -- pl:Say("there's only ONE player")
    end

    
    local px = getPlayer(0):getX()
    local py = getPlayer(0):getY()
    local pz = math.floor(getPlayer(0):getZ())


    if tostring(LosUtil.lineClear(getCell(), px, py, pz, px + rand1, py + rand2, pz, false)) ~= "Clear" then

        -- print("NO CLEAR VIEW TO ZED SPAWN LOCATION: OK TO SPAWN!")
        -- pl:Say("NO CLEAR VIEW TO ZED SPAWN LOCATION: OK TO SPAWN!")

        addZombiesInOutfit(px + rand1, py + rand2, 0, numberOfZombies, text, femaleChanceHere)

        hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft - numberOfZombies

    else
        -- print("EMPTY SPAWN LOCATION CAN BE SEEN! ABORT! DONT SPAWN ZEDS HERE!")
        -- pl:Say("EMPTY SPAWN LOCATION CAN BE SEEN! ABORT! DONT SPAWN ZEDS HERE!")
    end


    if hutsCsv[keyId].totZombiesLeft < 0 then
        hutsCsv[keyId].totZombiesLeft = 0
    end


end




-- maybe my big starting issue is that i keep focusing on the wrong shit: i think that the fundamental problem our mod is supposed to try to overcome is completed simply be eliminating the existing global function that de-spawn/spawn through use of a wrapper and replacing them with super-simple shit that gets rid of the problems:

-- 1. currently the spawn/de-spawn distance for NPCs is WAY too far (to that point where we're straining our computer from NPCs that are too far to see or interact with, pointlessly); so ours is just set up so that instead of the 45-70 distance the game uses by default to spawn, 
    -- 1a. we create a function that spawns NPCs into closer locations that are 9-35 distance away
    -- 1b. and another function that DE-spawns them when they're more than 40 distance away any time total NPC's spawned > 100: this function will INCLUDE ALL OTHER TYPES OF NPCS OTHER THAN CIVILIANS IN ITS COUNTING (which the current bandits week one mod DOESN'T, which is why the number snowballs far outside the max in the existing bandits week one mod-- one of the main things we're trying to fix through this new mod) -- but it WON'T de-spawn the other types of NPCs other than civilians; it'll JUST de-spawn the CIVILIAN npcs that WE spawned in (so we don't mess up an special event NPCs like paramedics that the game spawns in) ...and then keep doing that until our spawned number is <= 100 
-- 2. in terms of de-spawning zombies i think that the only thing that really needs to be fixed in this: when we first step into a building that we've never entered before (and the game IMMEDIATELY spawns in a million zombies RIGHT NEAR US inside said building) we should mitigate this by implementing the following:
    -- 2a. every tick we check the ID's of every zombie spawned in and add it to 'zedsHere' mod-data table






local function allButSpawn()

    -- maxNpcs_R69


    -- if quickCountNearbyZeds_R69 > 250 or (quickCountNearbyZeds_R69 + quickCountNearbyNpcs_R69) > 300 then



    -- ADJUST: population nominals
    BWOPopControl.ZombieMax = 0
    BWOPopControl.StreetsNominal = 41
    BWOPopControl.InhabitantsNominal = 100
    BWOPopControl.SurvivorsNominal = 0

    if BWOScheduler.WorldAge == 83 then -- occasional zombies
        BWOPopControl.ZombieMax = 1
    elseif BWOScheduler.WorldAge == 86 then -- occasional zombies
        BWOPopControl.ZombieMax = 1
    elseif BWOScheduler.WorldAge >= 91 and BWOScheduler.WorldAge < 94 then -- occasional zombies
        BWOPopControl.ZombieMax = 2
    elseif BWOScheduler.WorldAge >= 105 and BWOScheduler.WorldAge < 108 then -- occasional zombies
        BWOPopControl.ZombieMax = 3
    elseif BWOScheduler.WorldAge >= 114 and BWOScheduler.WorldAge < 117 then -- occasional zombies
        BWOPopControl.ZombieMax = 3
    elseif BWOScheduler.WorldAge >= 120 and BWOScheduler.WorldAge < 128 then -- occasional zombies
        BWOPopControl.ZombieMax = 8
    elseif BWOScheduler.WorldAge == 128  then -- outbreak
        BWOPopControl.ZombieMax = 70
        BWOPopControl.StreetsNominal = 45
        BWOPopControl.InhabitantsNominal = 50
    elseif BWOScheduler.WorldAge == 129 then 
        BWOPopControl.ZombieMax = 70
        BWOPopControl.StreetsNominal = 50
        BWOPopControl.InhabitantsNominal = 40
        BWOPopControl.SurvivorsNominal = 2
    elseif BWOScheduler.WorldAge == 130 then
        BWOPopControl.ZombieMax = 70
        BWOPopControl.StreetsNominal = 55
        BWOPopControl.InhabitantsNominal = 30
        BWOPopControl.SurvivorsNominal = 3
    elseif BWOScheduler.WorldAge == 131 then
        BWOPopControl.ZombieMax = 70
        BWOPopControl.StreetsNominal = 60
        BWOPopControl.InhabitantsNominal = 15
        BWOPopControl.SurvivorsNominal = 5
    elseif BWOScheduler.WorldAge == 132 then
        BWOPopControl.ZombieMax = 70
        BWOPopControl.StreetsNominal = 55
        BWOPopControl.InhabitantsNominal = 15
        BWOPopControl.SurvivorsNominal = 8
    elseif BWOScheduler.WorldAge >= 133 and BWOScheduler.WorldAge < 170 then
        BWOPopControl.ZombieMax = 1000
        BWOPopControl.InhabitantsNominal = 4
        BWOPopControl.StreetsNominal = 1
        BWOPopControl.SurvivorsNominal = 6
    elseif BWOScheduler.WorldAge >= 169 then
        -- BWOPopControl.ZombieMax = 1000
        -- BWOPopControl.SurvivorsNominal = 0
        -- BWOPopControl.InhabitantsNominal = 0
        -- BWOPopControl.StreetsNominal = 0
        BWOPopControl.InhabitantsNominal = 2
        BWOPopControl.StreetsNominal = 0
        BWOPopControl.SurvivorsNominal = 3
    end

    maxNpcs_R69 = (BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal + BWOPopControl.SurvivorsNominal)

    if maxNpcs_R69 > 80 then
        maxNpcs_R69 = 80
    end

    -- BWOScheduler.WorldAge == 132 

    if BWOScheduler.WorldAge <= 132 then
        maxZeds_R69 = BWOPopControl.ZombieMax
    else
        maxZeds_R69 = 250
    end


    local zedsHere = ModData.getOrCreate("zedsHere")

    -- ...and then when we enter a new building for the first time we do this:

    local player = getPlayer(0)
    
    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local building = player:getBuilding()

    local buildingDef
    local keyId

    local square

    local hutsCsv = ModData.getOrCreate("hutsCsv")


    local bx, by
    local tx, ty

    local dist


    local addNum = 5

    if getGameTime():getDay() >= 15 then
        addNum = 3

        if getGameTime():getDay() >= 18 then
            addNum = 1
        end
    end

    if maxNpcs_R69 <= 90 then
    
        for k, v in pairs(hutsCsv) do
            -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

            keyId = tonumber(k)

            bx = v.x; by = v.y

            tx = v.x2; ty = v.y2

            local x1, x2, y1, y2

            if v.x < v.x2 then
                x1 = v.x
                x2 = v.x2
            else
                x1 = v.x2
                x2 = v.x
            end

            
            if v.y < v.y2 then
                y1 = v.y
                y2 = v.y2
            else
                y1 = v.y2
                y2 = v.y
            end

            if px > x1 and px < x2 and py > y1 and py < y2 then
                maxNpcs_R69 = maxNpcs_R69 + addNum
            else
                if BanditUtils.DistTo(px, py, bx, by) < 25 or BanditUtils.DistTo(px, py, bx, by) < 25 then
                    maxNpcs_R69 = maxNpcs_R69 + addNum
                end
            end


        end

    end


    if maxNpcs_R69 > 100 then
        maxNpcs_R69 = 100
    end
    


    if building then

        buildingDef = building:getDef()
        keyId = buildingDef:getKeyId()


        local x = buildingDef:getX()
        local y = buildingDef:getY()
        local x2 = buildingDef:getX2()
        local y2 = buildingDef:getY2()

        local occupantsMax = math.ceil((math.abs(x2 - x) * math.abs(y2 - y)) / 20)

        -- math.abs((zedsHere[npc_id].totMinutesAtFirstSeen) - )
        -- 

        if not hutsCsv[keyId] then
            hutsCsv[keyId] = {occupantsMax=occupantsMax, totZombiesLeft=0, totMinutesAtFirstSeen=(getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24)), x=x, y=y, x2=x2, y2=y2, dayLastSeen=getGameTime():getDay()}

            savedKeyId = keyId

        else


        end

    end



    local cell = getCell()
    local zombieList = cell:getZombieList()
    local args
    local zombie

    local bx, by, bz
    local dist; local npc_id; local bandit; local brain

    local buildingDef

    local keyId

    local square

    local zombieObj

    local task

    quickCountNearbyNpcs_R69 = 0

    quickCountNearbyZeds_R69 = 0


    for i = 0, zombieList:size() - 1 do

        zombie = zombieList:get(i)

        if zombie then
            if zombie:isAlive() then

                if zombie:getVariableBoolean("Bandit") then

                    npc_id = zombie.id

                    if BanditZombie.GetInstanceById(npc_id) ~= nil then

                        brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

                        if brain.program.name ~= "Bandit" then
                            quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 + 1
                        end

                    end

                else
                    quickCountNearbyZeds_R69 = quickCountNearbyZeds_R69 + 1
                end
            end
        end
    end



    npcsCloserThan20dist_R69 = 0

    for i = 0, zombieList:size() - 1 do

        zombie = zombieList:get(i)
        bx = zombie:getX()
        by = zombie:getY()

        bz = math.floor(zombie:getZ())

        dist = BanditUtils.DistTo(px, py, bx, by)

        square = getCell():getGridSquare(bx, by, bz);

        if zombie then
            if zombie:isAlive() then

                if zombie:getVariableBoolean("Bandit") then

                    if quickCountNearbyNpcs_R69 >= maxNpcs_R69 then

                        if dist < 25 then
                            npcsCloserThan20dist_R69 = npcsCloserThan20dist_R69 + 1
                        end

                        if dist > 30 then
                            
                            npc_id = zombie.id

                            if BanditZombie.GetInstanceById(npc_id) ~= nil then

                                brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))
                            
                                if brain.program.name == "Inhabitant" or brain.program.name == "Walker" or brain.program.name == "Active" or brain.program.name == "Runner" or brain.program.name == "Survivor" or brain.program.name == "Gardener" or brain.program.name == "Janitor" or brain.program.name == "Vandal" or brain.program.name == "Postal" or brain.program.name == "Entertainer" or brain.program.name == "Babe" or brain.program.name == "Thief" or brain.program.name == "Medic" or brain.program.name == "Fireman" or brain.program.name == "Police" then

                                    if brain.program.name == "Entertainer" then

                                        -----------

                                        args = {x=bx, y=by, z=bz, otype="preacher"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx+1, y=by+1, z=bz, otype="preacher"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx-1, y=by+1, z=bz, otype="preacher"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx+1, y=by-1, z=bz, otype="preacher"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx-1, y=by-1, z=bz, otype="preacher"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        -----------

                                        args = {x=bx, y=by, z=bz, otype="entertainer"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx+1, y=by+1, z=bz, otype="entertainer"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx-1, y=by+1, z=bz, otype="entertainer"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx+1, y=by-1, z=bz, otype="entertainer"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        args = {x=bx-1, y=by-1, z=bz, otype="entertainer"}
                                        sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                                        -----------                                        

                                    end

                                    if brain.program.name ~= "Medic" and brain.program.name ~= "Fireman" and brain.program.name ~= "Police" and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                                        if brain.hostile == false then
    
                                            zombieObj = BanditZombie.GetInstanceById(zombie.id)

                                            zombieObj:removeFromSquare()
                                            zombieObj:removeFromWorld()

                                            args = { id = zombie.id } -- ✅ don’t leak globals
                                            sendClientCommand(player, "Commands", "BanditRemove", args)

                                            quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 - 1

                                        else
                                            -- they should chill out anyway if they're THAT far away

                                            if brain.program.name ~= "Thief" and brain.program.name ~= "Looter" then
                                                brain.hostile = false
                                            else
                                                brain.program.name = "Active"
                                                brain.program.stage = "Escape"
                                            end

                                        end
                                        

                                    else


                                        if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then

                                            task = Bandit.GetTask(bandit)

                                            if tostring(task["action"]) == "Time" then

                                                if tostring(task["anim"]) == "ShiftWeight" or tostring(task["anim"]) == "PullAtCollar" or tostring(task["anim"]) == "ChewNails" or tostring(task["anim"]) == "Smoke" or tostring(task["anim"]) == "Sneeze" or tostring(task["anim"]) == "WipeBrow" or tostring(task["anim"]) == "WipeHead" or tostring(task["anim"]) == "Talk1" or tostring(task["anim"]) == "Talk2" or tostring(task["anim"]) == "Talk3" or tostring(task["anim"]) == "Talk4"  or tostring(task["anim"]) == "Talk5" then
                                                    
                                                    -- if they're not doing anything they can leave

                                                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
    

                                                        zombieObj = BanditZombie.GetInstanceById(zombie.id)

                                                        zombieObj:removeFromSquare()
                                                        zombieObj:removeFromWorld()

                                                        args = { id = zombie.id } -- ✅ don’t leak globals
                                                        sendClientCommand(player, "Commands", "BanditRemove", args)

                                                        quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 - 1


                                                    end
                                                    


                                                end


                                            end
                                        end
                                    end


                                end

                            end

                        end

                    end

                else

                    npc_id = zombie.id

                    if zedsHere[npc_id] == nil then

                        -- 

                        if square ~= nil then

                            if square:getBuilding() == nil then
                                zedsHere[npc_id] = {x=bx, y=by, z=bz}

                            else

                                building = square:getBuilding()

                                buildingDef = building:getDef()

                                keyId = buildingDef:getKeyId()


                                if hutsCsv[keyId] ~= nil then

                                    if math.abs(hutsCsv[keyId].totMinutesAtFirstSeen - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 3 and dist < 30 then

                                        zombieObj = BanditZombie.GetInstanceById(zombie.id)

                                        zombieObj:removeFromSquare()
                                        zombieObj:removeFromWorld()

                                        args = { id = zombie.id } -- ✅ don’t leak globals
                                        sendClientCommand(player, "Commands", "BanditRemove", args)

                                        hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft + 1

                                        quickCountNearbyZeds_R69 = quickCountNearbyZeds_R69 - 1

                                    else
                                        zedsHere[npc_id] = {x=bx, y=by, z=bz}
                                        
                                    end

                                    -- totMinutesAtFirstSeen=(getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))



                                else
                                    -- if they path through a building we haven't entered yet that's fine too:
                                    zedsHere[npc_id] = {x=bx, y=by, z=bz}


                                end
                            end
    
                        end
                        

                    else
                        -- if quickCountNearbyZeds_R69 > 250 or (quickCountNearbyZeds_R69 + quickCountNearbyNpcs_R69) > 300 then
                        if quickCountNearbyZeds_R69 > 250 or (quickCountNearbyZeds_R69 + quickCountNearbyNpcs_R69) > 300 then

                            if dist > 30 then

                                if square ~= nil then

                                    if square:getBuilding() == nil then

                                        building = square:getBuilding()

                                        buildingDef = building:getDef()

                                        keyId = buildingDef:getKeyId()


                                    end
                                end

                                if keyId == nil then
                                    keyId = savedKeyId
                                end

                                zombieObj = BanditZombie.GetInstanceById(zombie.id)

                                zombieObj:removeFromSquare()
                                zombieObj:removeFromWorld()

                                args = { id = zombie.id } -- ✅ don’t leak globals
                                sendClientCommand(player, "Commands", "BanditRemove", args)

                                if keyId == nil then
                                    totZedsOverFlow_R69 = totZedsOverFlow_R69 + 1
                                else
                                    
                                    if hutsCsv[keyId] ~= nil then
                                        hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft + 1
                                    end
                                end

                                quickCountNearbyZeds_R69 = quickCountNearbyZeds_R69 - 1
                            end

                        end

                    end

                end
            end
        end
    end


end




local function slapDashSpawner()

	local zedsHere = ModData.getOrCreate("zedsHere")


    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    local tab1 = {}


    local modNum = 1
    local modNumB = 1

    if ZombRand(1, 100) > 50 then
        
        modNum = -1
    end

    if ZombRand(1, 1000) > 500 then
        
        modNumB = -1
    end

    local rand1 = ZombRand(5, 12) * (modNum)
    local rand1b = ZombRand(5, 12) * (modNumB)

    local rand2 = ZombRand(7, 14) * (modNum)
    local rand2b = ZombRand(7, 14) * (modNumB)

    local rand3 = ZombRand(9, 18) * (modNum)
    local rand3b = ZombRand(9, 18) * (modNumB)

    local rand4 = ZombRand(12, 21) * (modNum)
    local rand4b = ZombRand(12, 21) * (modNumB)

    local rand5 = ZombRand(14, 25) * (modNum)
    local rand5b = ZombRand(14, 25) * (modNumB)


    if npcsCloserThan20dist_R69 >= 10 then

        rand1 = ZombRand(12, 25) * (modNum)
        rand1b = ZombRand(15, 25) * (modNumB)

        rand2 = ZombRand(17, 25) * (modNum)
        rand2b = ZombRand(18, 25) * (modNumB)

    end



    table.insert(tab1, {x=(px+rand1),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand1b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand2),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py+rand2b),z=(pz)})

    table.insert(tab1, {x=(px+rand3),y=(py+0),z=(0)})
    table.insert(tab1, {x=(px-rand3b),y=(py+0),z=(0)})

    table.insert(tab1, {x=(px+0),y=(py+rand4),z=(0)})
    table.insert(tab1, {x=(px+0),y=(py-rand4b),z=(0)})

    table.insert(tab1, {x=(px+0),y=(py+rand5),z=(0)})
    table.insert(tab1, {x=(px+0),y=(py-rand5b),z=(0)})

    local square
    local building

    local event = {}

    local bx, by, bz

    local walkX, walkY, walkZ

    maxNpcs_R69 = BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal + BWOPopControl.SurvivorsNominal

    if maxNpcs_R69 > 100 then
        maxNpcs_R69 = 100
    end

    local numHutsFound = 0


    if quickCountNearbyNpcs_R69 < maxNpcs_R69 and npcsCloserThan20dist_R69 < 16 then

        for i = 1, (#tab1) do

            bx = tab1[i].x; by = tab1[i].y; bz = tab1[i].z

            square = getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z);

            if square ~= nil then

                -- and 

                local footstepMatHere = tostring(getCell():getGridSquare(bx, by, bz):getObjects():get(0):getSprite():getProperties():Val("FootstepMaterial"))

                if square:getBuilding() then
                    
                else

                    if footstepMatHere == "Gravel" or footstepMatHere == "Sand" then
                        walkX = bx; walkY = by; walkZ = bz
                    end

                end
        
                if square:getBuilding() then

                    numHutsFound = numHutsFound + 1

                    pl:Say("Debug:  THIS spot can spawn NPCs!")

                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                        pl:Say("Debug:  THIS spot can spawn NPCs... AND is not immersion breaking visually to pop in there!")
                        
                        building = square:getBuilding()
                        break
                    end

                else
                    pl:Say("Debug:  no building here boss")

                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                        -- if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                    end
                end
            end
        end

        if numHutsFound <= 1 then
            walkX = nil; walkY = nil; walkZ = nil
        end

        local buildingDef; local keyId; 
        local occupantsCnt; local occupantsMax

        local spawnRoom

        if building ~= nil and square ~= nil then

            -- local room = rooms:get(i)

            local room = square:getRoom(); 
            local roomName

            if room == nil then 
            else 

                spawnRoom = room

                roomName = room:getName(); 

                local def = room:getRoomDef()
                
                if def then

                    building = room:getBuilding()
                    buildingDef = building:getDef()

                    keyId = buildingDef:getKeyId()

                    occupantsCnt = BWORooms.GetRoomCurrPop(room)
                    occupantsMax = BWORooms.GetRoomMaxPop(room)


                    local comboStr1 = tostring(keyId) .. tostring(roomName)


                    if occupantsCnt < occupantsMax then

                        pl:Say("Debug:  debug: preparing to spawn...")

                        local spawnRoomDef = spawnRoom:getRoomDef()

                        if spawnRoomDef then

                            local spawnSquare = spawnRoomDef:getFreeSquare()

                            pl:Say("Debug:  debug: preparing to spawn... pt 2")
                            
                            if spawnSquare and not spawnSquare:getZombie() and not spawnSquare:isOutside() and spawnSquare:isFree(false) and BanditCompatibility.HaveRoofFull(spawnSquare) and not BWOSquareLoader.IsInExclusion(spawnSquare:getX(), spawnSquare:getY()) then

                                pl:Say("Debug:  debug: preparing to spawn... pt 3")

                                local chanceOfOutside = 30

                                -- if getGameTime():getDay() < 15

                                if BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal < 15 then
                                    chanceOfOutside = 70
                                end

                                if ZombRand(1, 100) < chanceOfOutside and walkX ~= nil then

                                    pl:Say("Debug: spawning OUTSIDE INSTEAD!")
    
                                    event.x = walkX
                                    event.y = walkY
                                    event.z = walkZ

                                else
    
                                    event.x = spawnSquare:getX()
                                    event.y = spawnSquare:getY()
                                    event.z = spawnSquare:getZ()

                                end
                                
                                local dist = BanditUtils.DistTo(px, py, event.x, event.y)

                                if dist >= 7 and dist < 45 then

                                    pl:Say("Debug:  debug: preparing to spawn... pt 4")

                                    event.bandits = {}

                                    event.hostile = false
                                    event.occured = false
                                    event.program = {}
                                
                                    if BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal < 12 and ZombRand(1, 100) > 30 then
                                        
                                        event.program.name = "Survivor"
                                        event.program.stage = "Main"

                                    else
                                        
                                        event.program.name = "Inhabitant"
                                        event.program.stage = "Main"

                                    end
                                    


                                    
                                    local bandit = BanditCreator.MakeFromRoom(spawnRoom)
                                    if bandit then

                                        pl:Say("Debug:  debug: preparing to spawn... pt 5 ...ok?")

                                        table.insert(event.bandits, bandit)

                                        pl:Say("Debug:  debug: preparing to spawn... pt 5b")


                                        sendClientCommand(player, 'Commands', 'SpawnGroup', event)

                                        pl:Say("Debug:  debug:paring to spawn... pt 5c")


                                        -- break
                                    end
                                end
                            end
                        end

                    end


                end
            end
        end
    end






    -------------------------------------------------------- ❓❓❓❓❓❓❓❓❓❓


    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    local tab1 = {}



    local rand1 = ZombRand(5, 12) * (modNum)
    local rand1b = ZombRand(5, 12) * (modNumB)

    local rand2 = ZombRand(7, 14) * (modNum)
    local rand2b = ZombRand(7, 14) * (modNumB)

    local rand3 = ZombRand(9, 18) * (modNum)
    local rand3b = ZombRand(9, 18) * (modNumB)

    local rand4 = ZombRand(12, 21) * (modNum)
    local rand4b = ZombRand(12, 21) * (modNumB)

    local rand5 = ZombRand(14, 25) * (modNum)
    local rand5b = ZombRand(14, 25) * (modNumB)


    table.insert(tab1, {x=(px+rand1),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand1b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand2),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py+rand2b),z=(pz)})

    table.insert(tab1, {x=(px+rand3),y=(py+0),z=(0)})
    table.insert(tab1, {x=(px-rand3b),y=(py+0),z=(0)})

    table.insert(tab1, {x=(px+0),y=(py+rand4),z=(0)})
    table.insert(tab1, {x=(px+0),y=(py-rand4b),z=(0)})

    table.insert(tab1, {x=(px+0),y=(py+rand5),z=(0)})
    table.insert(tab1, {x=(px+0),y=(py-rand5b),z=(0)})

    local square
    local building

    local event = {}

    local bx, by, bz

    local walkX, walkY, walkZ


    maxNpcs_R69 = BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal + BWOPopControl.SurvivorsNominal

    if maxNpcs_R69 > 100 then
        maxNpcs_R69 = 100
    end

    local numHutsFound = 0

    if quickCountNearbyNpcs_R69 < maxNpcs_R69 then

        for i = 1, (#tab1) do

            bx = tab1[i].x; by = tab1[i].y; bz = tab1[i].z

            square = getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z);

            if square ~= nil then

                -- and 

                local footstepMatHere = tostring(getCell():getGridSquare(bx, by, bz):getObjects():get(0):getSprite():getProperties():Val("FootstepMaterial"))

                if square:getBuilding() then
                    
                else

                    if footstepMatHere == "Gravel" or footstepMatHere == "Sand" then
                        walkX = bx; walkY = by; walkZ = bz
                    end

                end
        
                if square:getBuilding() then

                    numHutsFound = numHutsFound + 1

                    pl:Say("Debug:  THIS spot can spawn NPCs!")

                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                        pl:Say("Debug:  THIS spot can spawn NPCs... AND is not immersion breaking visually to pop in there!")
                        
                        building = square:getBuilding()
                        break
                    end

                else
                    pl:Say("Debug:  no building here boss")

                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                        -- if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                    end
                end
            end
        end

        if numHutsFound <= 1 then
            walkX = nil; walkY = nil; walkZ = nil
        end

        local buildingDef; local keyId; 
        local occupantsCnt; local occupantsMax

        local spawnRoom

        if building ~= nil and square ~= nil then

            -- local room = rooms:get(i)

            local room = square:getRoom(); 
            local roomName

            if room == nil then 
            else 

                spawnRoom = room

                roomName = room:getName(); 

                local def = room:getRoomDef()
                
                if def then

                    building = room:getBuilding()
                    buildingDef = building:getDef()

                    keyId = buildingDef:getKeyId()

                    occupantsCnt = BWORooms.GetRoomCurrPop(room)
                    occupantsMax = BWORooms.GetRoomMaxPop(room)


                    local comboStr1 = tostring(keyId) .. tostring(roomName)


                    if occupantsCnt < occupantsMax then

                        pl:Say("Debug:  debug: preparing to spawn...")

                        local spawnRoomDef = spawnRoom:getRoomDef()

                        if spawnRoomDef then

                            local spawnSquare = spawnRoomDef:getFreeSquare()

                            pl:Say("Debug:  debug: preparing to spawn... pt 2")
                            
                            if spawnSquare and not spawnSquare:getZombie() and not spawnSquare:isOutside() and spawnSquare:isFree(false) and BanditCompatibility.HaveRoofFull(spawnSquare) and not BWOSquareLoader.IsInExclusion(spawnSquare:getX(), spawnSquare:getY()) then

                                pl:Say("Debug:  debug: preparing to spawn... pt 3")

                                local chanceOfOutside = 30

                                -- if getGameTime():getDay() < 15

                                if BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal < 15 then
                                    chanceOfOutside = 70
                                end

                                if ZombRand(1, 100) < chanceOfOutside and walkX ~= nil then

                                    pl:Say("Debug: spawning OUTSIDE INSTEAD!")
    
                                    event.x = walkX
                                    event.y = walkY
                                    event.z = walkZ

                                else
    
                                    event.x = spawnSquare:getX()
                                    event.y = spawnSquare:getY()
                                    event.z = spawnSquare:getZ()

                                end
                                
                                local dist = BanditUtils.DistTo(px, py, event.x, event.y)

                                if dist >= 7 and dist < 45 then

                                    pl:Say("Debug:  debug: preparing to spawn... pt 4")

                                    event.bandits = {}

                                    event.hostile = false
                                    event.occured = false
                                    event.program = {}
                                
                                    if BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal < 12 and ZombRand(1, 100) > 30 then
                                        
                                        event.program.name = "Survivor"
                                        event.program.stage = "Main"

                                    else
                                        
                                        event.program.name = "Inhabitant"
                                        event.program.stage = "Main"

                                    end
                                    


                                    
                                    local bandit = BanditCreator.MakeFromRoom(spawnRoom)
                                    if bandit then

                                        pl:Say("Debug:  debug: preparing to spawn... pt 5 ...ok?")

                                        table.insert(event.bandits, bandit)

                                        pl:Say("Debug:  debug: preparing to spawn... pt 5b")


                                        sendClientCommand(player, 'Commands', 'SpawnGroup', event)

                                        pl:Say("Debug:  debug:paring to spawn... pt 5c")


                                        -- break
                                    end
                                end
                            end
                        end

                    end


                end
            end
        end
    end




end




local onTickZZB = function(numTicksInZZB)

    if numTicksInZZB % 2 == 0 or numTicksInZZB % 2 ~= 0 then
        allButSpawn()
    end

    if numTicksInZZB % 77 == 0 then
        slapDashSpawner()
    end

    if numTicksInZZB % 9500 == 0 then
        pauseThenGlobalSave12()
    end


end
Events.OnTick.Add(onTickZZB)



local function onPress(key)

    local player = getPlayer(0)
    local pl = getPlayer(0)

    if not player then
        do return end
    end


    local rand1 = 1

    if key == getCore():getKey("PLACEHOLDER_Keyboard_KEY_ESCAPE") then
        pauseThenGlobalSave12()
    end

end

Events.OnKeyPressed.Add(onPress)




