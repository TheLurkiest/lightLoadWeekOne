-- ZZA_LIGHT_LOAD_MAIN.lua

-- alright i fucked it again; we went to make a light, simple mod and accidentally turned it into a slog again-- here's me committing to a wildly simpler format for how we're gonna do this mod now the right; we start with a blank sheet of paper; we're calling this mod 'lightLoadWeekOne' and it's a mod that simplifies/fixes spawning/de-spawning to make it better and easier on computers-- but here's how we do it different from last time: first-- we start with AN EMPTY lua file 'ZZA_LIGHT_LOAD_MAIN.lua' which is named such so that it loads after all other mods in the 'bandits week one' mod in project zomboid that this mod utilizes/alters and that way i assume we don't need all this extra bullshit with hooks when we wanna modify that mods global functions using wrappers; we just do a SUPER SIMPLE WRAPPER for every single global function that week one created which either spawns or de-spawns zombies and/or NPCs but instead of trying to work WITH those functions and only alter them a LITTLE BIT, THIS TIME WE'RE JUST GONNA INSTANTLY RETURN-- that way we can create our OWN mechanisms for spawning/de-spawning and don't need to worry about conflict or overlap-- but the ONLY thing in our mod when we first open it up in game, as i said-- is going to be that single empty lua file (but with a simple 'ontick' function and 'onPress' function and function that saves our created mod-data table that gets called in those two functions so that our mod-data saves every time we hit the 'escape' key to leave the game and every few minutes as an 'auto-save' mechanism. That should be the only thing that our mod has inside it to start with when we boot up our game. And everything will be something that we create/test in-game within the lua console: that way we might better ensure it's as light and simple structurally as it can possibly be. But I still kinda wanna go over some LOOSE, VAGUE IDEA of how i'm gonna structure some of that before I instantly jump right in with you. 


-- add two global variables:
quickCountNearbyNpcs_R69 = 0

quickCountNearbyZeds_R69 = 0

totZedsOverFlow_R69 = 0

maxNpcs_R69 = 100


-- ((SandboxVars.BanditsWeekOne.StreetsPopMultiplier + SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier) / 2)

-- print(SandboxVars.BanditsWeekOne.StreetsPopMultiplier); print(SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier)

maxZeds_sandbox_knob250 = 250

maxZeds_R69 = maxZeds_sandbox_knob250

npcsCloserThan20dist_R69 = 0

activeSpawningHutKeyId = nil

local savedKeyId = nil



local function fixNakedNpcs()

    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsHere = ModData.getOrCreate("vipsHere")

    local player = getPlayer(0)
    local pl = getPlayer(0)


    local dist = 99

    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Walker", "Entertainer", "Survivor", "Runner", "Inhabitant", "Active", "Babe"})

    local brain; local bandit; local npc_id
    local dist = 99

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local bx, by, bz

    if not result.id then
    else

        -- -- pl:Say("found")
        npc_id = result.id
        babe1 = BanditZombie.GetInstanceById(npc_id)
        bandit = BanditZombie.GetInstanceById(npc_id)
        brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

        bx = BanditZombie.GetInstanceById(npc_id):getX();
        by = BanditZombie.GetInstanceById(npc_id):getY();
        bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());
        
        -- print("brain.fullname is " .. brain.fullname)
        -- print("brain.outfit is " .. tostring(brain.outfit))
        -- print("brain.female is " .. tostring(brain.female))

        if tostring(brain.outfit) == "Generic06" and tostring(brain.female) == "true" then
            -- player:Say("THEY ARE NAKED; GIVE THEM A REAL OUTFIT!!!")


            comboTab1 = {fullname=tostring(brain.fullname), deadNow=false, trust=ZombRand(0, 50), keyId=keyId, outfit=tostring(brain.outfit), id=npc_id, day=tonumber(getGameTime():getDay()), hour=tonumber(getGameTime():getHour()), minute=tonumber(getGameTime():getMinutes()), melee=tostring(brain.weapons.melee), primaryGunName=tostring(brain.weapons.primary.name), secondaryGunName=tostring(brain.weapons.secondary.name), bornX=(brain.bornCoords.x), bornY=(brain.bornCoords.y), bornZ=(brain.bornCoords.z), infection=(brain.infection), health=tonumber(brain.health), female=(brain.female), skinTexture=tostring(brain.skinTexture), hairStyle=tostring(brain.hairStyle), hairColorR=(brain.hairColor.r), hairColorG=(brain.hairColor.g), hairColorB=(brain.hairColor.b), beardColorR=(brain.beardColor.r), beardColorG=(brain.beardColor.g), beardColorB=(brain.beardColor.b), lastDistanceSeen=dist, totMinutesAtLastSeen=(getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))}


            local newOutfit = "Generic0" .. tostring(ZombRand(1, 5))




            local hv = bandit:getHumanVisual()
            -- wipe current outfit visuals
            hv:clear()


            bx = BanditZombie.GetInstanceById(npc_id):getX();
            by = BanditZombie.GetInstanceById(npc_id):getY();
            bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());

            local zombie = BanditZombie.GetInstanceById(npc_id)
            local banditVisuals = zombie:getHumanVisual()



            -- banditVisuals:setHairColor(ImmutableColor.new(0.33334, 0.22221, 0.8355)); 
            banditVisuals:setHairColor(ImmutableColor.new(tonumber(comboTab1.hairColorR), tonumber(comboTab1.hairColorG), tonumber(comboTab1.hairColorB)))
            brain.hairColor.r = comboTab1.hairColorR
            brain.hairColor.g = comboTab1.hairColorG
            brain.hairColor.b = comboTab1.hairColorB

            -- banditVisuals:setBeardColor(ImmutableColor.new(0.33334, 0.32221, 0.81555)); 
            banditVisuals:setBeardColor(ImmutableColor.new(tonumber(comboTab1.beardColorR), tonumber(comboTab1.beardColorG), tonumber(comboTab1.beardColorB)))
            brain.beardColor.r = comboTab1.beardColorR
            brain.beardColor.g = comboTab1.beardColorG
            brain.beardColor.b = comboTab1.beardColorB

            -- Apply bandit visual modifications
            if brain.skinTexture then 

                -- banditVisuals:setSkinTextureName("M_ZedBody01")
                -- banditVisuals:setSkinTextureName("MaleBody05")
                banditVisuals:setSkinTextureName(comboTab1.skinTexture)
                brain.skinTexture = tostring(comboTab1.skinTexture)

            end

            -- player:Say("your beard is " .. tostring(brain.beardStyle))
            -- player:Say("your fullname was " .. tostring(brain.fullname))

            -- banditVisuals:setBeardModel("Long")
            banditVisuals:setBeardModel(tostring(comboTab1.beardStyle))
            brain.beardStyle = tostring(comboTab1.beardStyle)

            -- banditVisuals:setHairModel("M_Yaki_VeryLongParted")
            brain.hairStyle = tostring(comboTab1.hairStyle)
            banditVisuals:setHairModel(comboTab1.hairStyle)

            brain.fullname = tostring(comboTab1.fullname)
            brain.infection = tonumber(comboTab1.infection)

            comboTab1.id = npc_id_of_wiped_guy_in

            -- try a named outfit from the game's outfit list
            -- examples might be stuff like "Police", "Fireman", etc depending on outfit defs

            -- hv:dressInNamedOutfit("Police", hv:getBodyVisuals())

            
            -- hv:dressInNamedOutfit("Police", hv:getBodyVisuals())


            hv:dressInNamedOutfit(newOutfit, hv:getBodyVisuals())

            -- comboTab1.fullname
            bandit:resetModel()


            if vipsHere[npc_id] ~= nil then
                vipsHere[npc_id].outfit = newOutfit
            end

        end
    end


end

local function npcChecker()

    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsHere = ModData.getOrCreate("vipsHere")

    local player = getPlayer(0)
    local pl = getPlayer(0)


    local dist = 99

    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Walker", "Entertainer", "Survivor", "Runner", "Inhabitant", "Active", "Babe"})

    local brain; local bandit; local npc_id
    local dist = 99

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local bx, by, bz

    if not result.id then
    else

    end

    local keyId


    local bx, by
    local tx, ty

    local x1, x2, y1, y2

    

    for k, v in pairs(hutsCsv) do
        -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

        keyId = tonumber(k)

        bx = v.x; by = v.y

        tx = v.x2; ty = v.y2


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

    end

    -- if hutsCsv
    -- hutsCsv

    for k, v in pairs(vipsHere) do

        npc_id = k
        bandit = BanditZombie.GetInstanceById(npc_id)

        if BanditZombie.GetInstanceById(npc_id) == nil then

            -- 
            
            -- v.totMinutesAtLastSeen = (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))

            keyId = v.keyId


            if v.lastDistanceSeen < 21 and math.abs(v.totMinutesAtLastSeen - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 5 then

                if hutsCsv[keyId] ~= nil then
                    if hutsCsv[keyId].npcsLeft > 0 then
                        hutsCsv[keyId].npcsLeft = hutsCsv[keyId].npcsLeft - 1
                    else
                        if hutsCsv[savedKeyId] ~= nil then
                            if hutsCsv[keyId].npcsLeft > 0 then
                                hutsCsv[keyId].npcsLeft = hutsCsv[keyId].npcsLeft - 1
                            else

                                for k, v in pairs(hutsCsv) do
                                    if v.npcsLeft > 0 then
                                        keyId = k
                                        break
                                    end
                                end

                                hutsCsv[keyId].npcsLeft = hutsCsv[keyId].npcsLeft - 1

                            end
                        end
                    end
                end


                local tx, ty;
                local bx, by

                local x1, y1
                local x2, y2

                local totNpcsInRegion = 0

                for k, v in pairs(hutsCsv) do
                    if v.npcsLeft > 0 then
                        keyId = k

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

                        local avgVar1 = math.ceil(((x2 - x1) + (y2 - y1)) / 2)

                        -- print("debug: avgVar1 is " .. tostring(avgVar1))

                        -- BanditUtils.DistTo(px, py, x1, y1) < 35 or BanditUtils.DistTo(px, py, x2, y2) < 35 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 35

                        -- BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100


                        if px > x1 and px < x2 and py > y1 and py < y2 then
                            -- maxNpcs_R69 = maxNpcs_R69 + addNum
                            totNpcsInRegion = totNpcsInRegion + v.npcsLeft
                        else
                            if BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100 then
                                -- maxNpcs_R69 = maxNpcs_R69 + addNum
                                totNpcsInRegion = totNpcsInRegion + v.npcsLeft
                            end
                        end


                    end
                end

                if totNpcsInRegion < maxNpcs_R69 then

                    pl:Say("[" .. tostring(vipsHere[npc_id].fullname) .. " was killed (SURVIVORS REMAINING IN THIS ZONE: " .. tostring(totNpcsInRegion) .. ")]")

                end

            else

                vipsHere[npc_id] = nil

            end

        else

            brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

            bx = BanditZombie.GetInstanceById(npc_id):getX();
            by = BanditZombie.GetInstanceById(npc_id):getY();
            bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());


            dist = BanditUtils.DistTo(px, py, bx, by)

            if BanditZombie.GetInstanceById(npc_id) ~= nil then

                v.totMinutesAtLastSeen = (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))

                v.lastDistanceSeen = dist

            end

        end



    end


end


--         fixSpawnedToMatch("ALWAYS SHOW")

local function fixSpawnedToMatch(display_mode_in)


    local player = getPlayer(0)

    local vipsHere = ModData.getOrCreate("vipsHere")

    
    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    for k, v in pairs(vipsHere) do
        -- hutsCsv[k] = nil
        -- -- -- print("Key:", k, "Value of v.occupantsMax: ", v.occupantsMax)
        -- -- print("Key:", k, "Value of v.fullname: ", v.fullname)

    end


    local hutsCsv = ModData.getOrCreate("hutsCsv")

    local livingNumber_OG = 0

    local tx, ty;
    local bx, by

    local x1, y1
    local x2, y2

    local totNpcsInRegion = 0

    local totHutsNearby = 0

    -- totHutsNearby

    for k, v in pairs(hutsCsv) do
        if v.npcsLeft > 0 then
            keyId = k

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

            local avgVar1 = math.ceil(((x2 - x1) + (y2 - y1)) / 2)
            
            if px > x1 and px < x2 and py > y1 and py < y2 then
                -- maxNpcs_R69 = maxNpcs_R69 + addNum
                totNpcsInRegion = totNpcsInRegion + v.npcsLeft
            else
                if BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100 then
                    -- maxNpcs_R69 = maxNpcs_R69 + addNum
                    totNpcsInRegion = totNpcsInRegion + v.npcsLeft



                    totHutsNearby = totHutsNearby + 1

                    livingNumber_OG = livingNumber_OG + v.livingNumber_OG

                end
            end

        end
    end

    -- BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100 then

    -- BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100 then



    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsHere = ModData.getOrCreate("vipsHere")

    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    local dist = 99

    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Walker", "Survivor", "Runner", "Inhabitant", "Active"})

    local brain; local bandit; local npc_id
    local dist = 99

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local bx, by, bz

    local args

    local zombieObj

    local vipsHere = ModData.getOrCreate("vipsHere")

    local cell = getCell()
    local zombieList = cell:getZombieList()

    local totalb = 0 -- all civs
    local totalz = 0 -- all zeds
    
    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local comboTab1

    local stillNpcsAliveNearby = false

    local zombie 

    local prg

    local npcBuffer = 0
    -- npcBuffer = 15


    -- quickCountNearbyNpcs_R69

    -- pl:Say("[totNpcsInRegion is " .. tostring(totNpcsInRegion))

    -- pl:Say("[CIVILIANS NEARBY: " .. tostring(quickCountNearbyNpcs_R69) .. " (OUT OF " .. tostring(totNpcsInRegion) .. " TOTAL SURVIVING RESIDENTS OF THIS REGION)]")

    -- pl:Say("[REMAINING RESIDENTS STILL SURVIVING IN THIS REGION: " .. tostring(totNpcsInRegion) .. "]")


    if quickCountNearbyNpcs_R69 > 7 + totNpcsInRegion then
        
        
        for i = 0, zombieList:size() - 1 do

            zombie = zombieList:get(i)
            
            if zombie then
                if zombie:isAlive() then


                    bx = zombie:getX()
                    by = zombie:getY()

                    bz = math.floor(zombie:getZ())

                    dist = BanditUtils.DistTo(px, py, bx, by)

                    --     local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Walker", "Survivor", "Runner", "Inhabitant", "Active"})



                    if zombie:getVariableBoolean("Bandit") then
                        brain = BanditBrain.Get(zombie)
                        prg = brain.program.name

                        if pz ~= bz then
                            
                            dist = dist + ( (math.abs(pz - bz)) * 10)

                        end

                        npc_id = brain.id
                        bandit = BanditZombie.GetInstanceById(npc_id)

                        if prg == "Walker" or prg == "Active" or prg == "Survivor" or prg == "Runner" or prg == "Inhabitant" then

                            pl:Say("found a possible npc to de-spawn...")

                            npc_id = result.id
                            babe1 = BanditZombie.GetInstanceById(npc_id)
                            bandit = BanditZombie.GetInstanceById(npc_id)
                            brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

                            bx = BanditZombie.GetInstanceById(npc_id):getX();
                            by = BanditZombie.GetInstanceById(npc_id):getY();
                            bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());

                            dist = BanditUtils.DistTo (px, py, bx, by)

                            if bz ~= pz then
                                dist = dist + 7
                            end

                            if vipsHere[npc_id] ~= nil then
                                vipsHere[npc_id] = nil
                            end

                            local babe3 = bandit
                            
                            if dist > 25 then
                                
                                if tostring(player:CanSee(babe3)) == "false" or tostring(getPlayer(getPlayer():getPlayerNum()):isFacingLocation(babe3:getX(), babe3:getY(), 0.3)) == "false" or tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" or dist > 21 then

                                    zombieObj = BanditZombie.GetInstanceById(npc_id)

                                    zombieObj:removeFromSquare()
                                    zombieObj:removeFromWorld()

                                    args = { id = npc_id } -- ✅ don’t leak globals
                                    sendClientCommand(player, "Commands", "BanditRemove", args)

                                    quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 - 1

                                    pl:Say("DE-SPAWNED NPC SINCE WE WERE OVER-FLOWING!")

                                    break

                                end
                            
                            end
                                

                            
                        end

                    end

                end

            end

        end

    end



    -- pl:Say("[REMAINING RESIDENTS STILL SURVIVING IN THIS REGION: " .. tostring(totNpcsInRegion) .. "]")


    -- if quickCountNearbyNpcs_R69 <= totNpcsInRegion then
    --     pl:Say("[CIVILIANS NEARBY: " .. tostring(quickCountNearbyNpcs_R69) .. " (OUT OF " .. tostring(totNpcsInRegion) .. " TOTAL SURVIVING RESIDENTS OF THIS REGION)]")
    -- else
    

    --     pl:Say("[CIVILIANS NEARBY: " .. tostring(quickCountNearbyNpcs_R69) .. " (OUT OF " .. tostring(totNpcsInRegion) .. " TOTAL SURVIVING RESIDENTS OF THIS REGION)]")

    -- end







    local nonResidents = 0

    if quickCountNearbyNpcs_R69 - totNpcsInRegion > 0 then
        nonResidents = quickCountNearbyNpcs_R69 - totNpcsInRegion
    end





    -- fixSpawnedToMatch("SHOW IF WORTH SHOWING")

    if livingNumber_OG > 100 then
        livingNumber_OG = 100
    end

    if totNpcsInRegion > 100 then
        totNpcsInRegion = 100
    end

    if tostring(display_mode_in) == "ALWAYS SHOW" then
        pl:Say("[ CURRENT ZONE HAS " .. tostring(totNpcsInRegion) .. " of " .. tostring(livingNumber_OG) .. " SURVIVING RESIDENTS REMAINING (" .. tostring(totNpcsInRegion) .. " HERE NOW + " .. tostring(nonResidents) .. " NON-RESIDENTS) ]")

    else


        if tostring(display_mode_in) == "SHOW IF WORTH SHOWING" then


            -- MOSTLY WONT SHOW
            if ZombRand(1, 100) > 75 then

                if livingNumber_OG > 50 then
                    pl:Say("[ CURRENT ZONE HAS " .. tostring(totNpcsInRegion) .. " of " .. tostring(livingNumber_OG) .. " SURVIVING RESIDENTS REMAINING (" .. tostring(totNpcsInRegion) .. " HERE NOW + " .. tostring(nonResidents) .. " NON-RESIDENTS) ]")
                end
                
            else

                if totNpcsInRegion > 0 and totHutsNearby > 3 then
                
                    if totNpcsInRegion < (livingNumber_OG - 10) or totNpcsInRegion > 25 then
                        pl:Say("[ CURRENT ZONE HAS " .. tostring(totNpcsInRegion) .. " of " .. tostring(livingNumber_OG) .. " SURVIVING RESIDENTS REMAINING (" .. tostring(totNpcsInRegion) .. " HERE NOW + " .. tostring(nonResidents) .. " NON-RESIDENTS) ]")
                    end


                else
                    if totNpcsInRegion > 0 and totHutsNearby >= 1 and totNpcsInRegion < livingNumber_OG then

                        pl:Say("[ CURRENT ZONE HAS " .. tostring(totNpcsInRegion) .. " of " .. tostring(livingNumber_OG) .. " SURVIVING RESIDENTS REMAINING (" .. tostring(totNpcsInRegion) .. " HERE NOW + " .. tostring(nonResidents) .. " NON-RESIDENTS) ]")

                    end
                end

            end


        else

            if tostring(display_mode_in) == "MOSTLY WONT SHOW" and ZombRand(1, 1000) > 700 then

                if livingNumber_OG >= 80 and totNpcsInRegion < livingNumber_OG - 10 then

                    pl:Say("[ CURRENT ZONE HAS " .. tostring(totNpcsInRegion) .. " of " .. tostring(livingNumber_OG) .. " SURVIVING RESIDENTS REMAINING (" .. tostring(totNpcsInRegion) .. " HERE NOW + " .. tostring(nonResidents) .. " NON-RESIDENTS) ]")

                else

                    if livingNumber_OG >= 100 and totNpcsInRegion < livingNumber_OG - 5 then
                        pl:Say("[ CURRENT ZONE HAS " .. tostring(totNpcsInRegion) .. " of " .. tostring(livingNumber_OG) .. " SURVIVING RESIDENTS REMAINING (" .. tostring(totNpcsInRegion) .. " HERE NOW + " .. tostring(nonResidents) .. " NON-RESIDENTS) ]")
                    end

                end


            end

        end




    end

    

    if quickCountNearbyNpcs_R69 > totNpcsInRegion and totNpcsInRegion > 5 then

        -- pl:Say("[ " .. tostring(quickCountNearbyNpcs_R69 - (quickCountNearbyNpcs_R69 - totNpcsInRegion)) .. " OUT OF " .. tostring(totNpcsInRegion) .. " OF THE TOTAL SURVIVING KNOWN RESIDENTS OF THIS AREA ARE CURRENTLY PRESENT NEARBY (AS WELL AS " .. tostring(quickCountNearbyNpcs_R69 - totNpcsInRegion) .. " NON-RESIDENTS FROM ELSE-WHERE)]")

        -- pl:Say("[ " .. tostring(quickCountNearbyNpcs_R69 - (quickCountNearbyNpcs_R69 - totNpcsInRegion)) .. " OF THE ORIGINAL " .. tostring(livingNumber_OG) .. " RESIDENTS OF THIS AREA ARE STILL ALIVE. " .. tostring(totNpcsInRegion) .. " ARE HERE NOW AS WELL AS " .. tostring(quickCountNearbyNpcs_R69 - totNpcsInRegion) .. " NON-RESIDENTS FROM ELSEWHERE)]")


    else

        -- pl:Say("[ " .. tostring(quickCountNearbyNpcs_R69) .. " OUT OF " .. tostring(totNpcsInRegion) .. " OF THE TOTAL SURVIVING KNOWN RESIDENTS OF THIS AREA ARE CURRENTLY PRESENT NEARBY ]")

        -- pl:Say("[ " .. tostring(quickCountNearbyNpcs_R69) .. " OUT OF " .. tostring(totNpcsInRegion) .. " OF THE TOTAL SURVIVING KNOWN RESIDENTS OF THIS AREA ARE CURRENTLY PRESENT NEARBY (" .. tostring(totNpcsInRegion) .. " OF " .. tostring(livingNumber_OG) .. " REMAINING) ]")


    end



end


local function npcHandler()

    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsHere = ModData.getOrCreate("vipsHere")


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

    local cell = getCell()
    local zombieList = cell:getZombieList()

    local totalb = 0 -- all civs
    local totalz = 0 -- all zeds
    
    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local comboTab1

    local stillNpcsAliveNearby = false

    for i = 0, zombieList:size() - 1 do

        local zombie = zombieList:get(i)
        
        if zombie then
            if zombie:isAlive() then


                local bx = zombie:getX()
                local by = zombie:getY()

                local bz = math.floor(zombie:getZ())

                local dist = BanditUtils.DistTo(px, py, bx, by)

                if zombie:getVariableBoolean("Bandit") then
                    local brain = BanditBrain.Get(zombie)
                    local prg = brain.program.name

                    if pz ~= bz then
                        
                        dist = dist + ( (math.abs(pz - bz)) * 10)

                    end

                    npc_id = brain.id
                    bandit = BanditZombie.GetInstanceById(npc_id)

                    if brain.program.name ~= "Bandit" then

                        if dist > 25 and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                        
                        end

                        -- vipsHere[npc_id] 

                        if BanditZombie.GetInstanceById(npc_id) ~= nil then


                            brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))



                            local bx, by
                            local tx, ty

                            local keyIdForNpc = nil

                            for k, v in pairs(hutsCsv) do
                                -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

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
                                    keyIdForNpc = keyId
                                else
                                    if BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100 then

                                        if v.npcsLeft > 0 then
                                            keyId = tonumber(k)

                                            keyIdForNpc = keyId

                                            break


                                        end



                                        

                                    end
                                end


                            end

                            keyId=keyIdForNpc

                            if keyId == nil then
                                -- hutsCsv[keyId]
                                if hutsCsv[savedKeyId] ~= nil then
                        
                                    if hutsCsv[savedKeyId].npcsLeft > 0 then
                                        keyId = savedKeyId
                                    end
                                end
                    
                            end

                            if keyId == nil then

                                for k, v in pairs(hutsCsv) do
                                    -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

                                    if v.npcsLeft > 0 then
                                        keyId = tonumber(k)

                                        stillNpcsAliveNearby = true
                                    else
                                        if stillNpcsAliveNearby == true then

                                        else
                                            stillNpcsAliveNearby = false
                                        end
                                    end

                                end

                            end

                            if hutsCsv[keyId] == nil then

                                for k, v in pairs(hutsCsv) do
                                    -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

                                    if v.npcsLeft > 0 then
                                        keyId = tonumber(k)

                                        stillNpcsAliveNearby = true
                                    else
                                        if stillNpcsAliveNearby == true then

                                        else
                                            stillNpcsAliveNearby = false
                                        end
                                    end
                                end

                            end

                            if keyId == nil then

                            else

                                if hutsCsv[keyId] == nil then


                                else
                                
                                    comboTab1 = {fullname=tostring(brain.fullname), deadNow=false, trust=ZombRand(0, 50), keyId=keyId, outfit=tostring(brain.outfit), id=npc_id, day=tonumber(getGameTime():getDay()), hour=tonumber(getGameTime():getHour()), minute=tonumber(getGameTime():getMinutes()), melee=tostring(brain.weapons.melee), primaryGunName=tostring(brain.weapons.primary.name), secondaryGunName=tostring(brain.weapons.secondary.name), bornX=(brain.bornCoords.x), bornY=(brain.bornCoords.y), bornZ=(brain.bornCoords.z), infection=(brain.infection), health=tonumber(brain.health), female=(brain.female), skinTexture=tostring(brain.skinTexture), hairStyle=tostring(brain.hairStyle), hairColorR=(brain.hairColor.r), hairColorG=(brain.hairColor.g), hairColorB=(brain.hairColor.b), beardColorR=(brain.beardColor.r), beardColorG=(brain.beardColor.g), beardColorB=(brain.beardColor.b), lastDistanceSeen=dist, totMinutesAtLastSeen=(getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))}

                                    vipsHere[npc_id] = comboTab1

                                end
                                

                            end

                            if stillNpcsAliveNearby == false then

                                    comboTab1 = {fullname=tostring(brain.fullname), deadNow=false, trust=ZombRand(0, 50), keyId=keyId, outfit=tostring(brain.outfit), id=npc_id, day=tonumber(getGameTime():getDay()), hour=tonumber(getGameTime():getHour()), minute=tonumber(getGameTime():getMinutes()), melee=tostring(brain.weapons.melee), primaryGunName=tostring(brain.weapons.primary.name), secondaryGunName=tostring(brain.weapons.secondary.name), bornX=(brain.bornCoords.x), bornY=(brain.bornCoords.y), bornZ=(brain.bornCoords.z), infection=(brain.infection), health=tonumber(brain.health), female=(brain.female), skinTexture=tostring(brain.skinTexture), hairStyle=tostring(brain.hairStyle), hairColorR=(brain.hairColor.r), hairColorG=(brain.hairColor.g), hairColorB=(brain.hairColor.b), beardColorR=(brain.beardColor.r), beardColorG=(brain.beardColor.g), beardColorB=(brain.beardColor.b), lastDistanceSeen=dist, totMinutesAtLastSeen=(getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))}

                                    if vipsHere[npc_id] == nil then

                                        if brain.program.name == "Inhabitant" or brain.program.name == "Walker" or brain.program.name == "Active" or brain.program.name == "Runner" or brain.program.name == "Survivor" then

                                            if BanditUtils.DistTo(px, py, (bx), (by)) > 10 and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                                                
                                                local zombieObj = BanditZombie.GetInstanceById(npc_id)

                                                zombieObj:removeFromSquare()
                                                zombieObj:removeFromWorld()

                                                local args = { id = npc_id } -- ✅ don’t leak globals
                                                sendClientCommand(player, "Commands", "BanditRemove", args)

                                                quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 - 1

                                                local vipsHere = ModData.getOrCreate("vipsHere")

                                                if vipsHere[npc_id] ~= nil then
                                                    vipsHere[npc_id] = nil
                                                    -- vipsHere[npc_id] = nil
                                                end


                                            end


                                        end


                                    end

                            end


                            -- vipsHere[brain.id]


                        end


                    end

                end
            end
        end


    end

end



local function simpWalkerSpawner(x_in, y_in, z_in)

    local event = {}
    local player = getPlayer(0)
    local pl = getPlayer(0)



    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    if tonumber(x_in) == nil then

    else
        px = x_in
        py = y_in
        pz = z_in
    end

    local bandit

    local footstepMatHere = tostring(getCell():getGridSquare(px, py, pz):getObjects():get(0):getSprite():getProperties():Val("FootstepMaterial"))


    local randChanceOfWalker = 0

    if z_in == 0 then

        if tostring(footstepMatHere) == "Gravel" then
            randChanceOfWalker = 100
        else
            if tostring(footstepMatHere) == "Concrete" or tostring(footstepMatHere) == "Ceramic" then
                randChanceOfWalker = 75
            else

                randChanceOfWalker = 30
                
            end
            
        end


    end
    -- print("footstepMatHere is " .. tostring(footstepMatHere))

    -- if tostring(footstepMatHere) == "Gravel" or tostring(footstepMatHere) == "Sand" or tostring(footstepMatHere) == "Concrete" or tostring(footstepMatHere) == "Ceramic"

    event.x = x_in
    event.y = y_in
    event.z = z_in
    event.hostile = false
    event.occured = false
    event.program = {}
    event.bandits = {}


    pl:Say("simpWalkerSpawner CALLED!")

    if randChanceOfWalker > ZombRand(-100, 50) then

        pl:Say("simpWalkerSpawner CALLED!")

        if getGameTime():getDay() < 13 then

            event.program.name = "Walker"
            event.program.stage = "Main"

        else
            if getGameTime():getDay() <= 14 then

                if ZombRand(1, 100) > 80 then

                    event.program.name = "Walker"
                    event.program.stage = "Main"

                else

                    event.program.name = "Survivor"
                    event.program.stage = "Main"

                end

            else


                if ZombRand(1, 100) > 50 then

                    event.program.name = "Walker"
                    event.program.stage = "Main"
                    
                else

                    event.program.name = "Survivor"
                    event.program.stage = "Main"

                end


            end

        end


        config = {}
        config.clanId = 0


        if getGameTime():getDay() < 13 then

            if ZombRand(1, 100) > 90 then

                config.hasRifleChance = 0
                config.hasPistolChance = 100
                config.rifleMagCount = 0
                config.pistolMagCount = ZombRand(2, 5)

            else

                config.hasRifleChance = 0
                config.hasPistolChance = 0
                config.rifleMagCount = 0
                config.pistolMagCount = 0

            end

        else

            if getGameTime():getDay() <= 14 then

                if ZombRand(1, 100) > 50 then


                    if ZombRand(1, 100) > 75 then

                        config.hasRifleChance = 0
                        config.rifleMagCount = 0

                    else
                        config.hasRifleChance = 100
                        config.rifleMagCount = ZombRand(3, 8)
                    end

                    config.hasPistolChance = 100
                    config.pistolMagCount = ZombRand(2, 9)

                else

                    config.hasRifleChance = 0
                    config.hasPistolChance = 0
                    config.rifleMagCount = 0
                    config.pistolMagCount = 0

                end

            else

            end
        end


        bandit = BanditCreator.MakeFromWave(config)

        local eyesAdded = 0

        if ZombRand(1, 100) > 50 then
            eyesAdded = (-0.1) * (ZombRand(1, 5))
        else
            eyesAdded = (0.1) * (ZombRand(1, 5))
        end

        bandit.accuracyBoost = 1.0 + eyesAdded

        if getGameTime():getDay() >= 16 then

            if ZombRand(1, 100) > 50 then
                bandit.accuracyBoost = 1.4 + eyesAdded
            end

        end




        if ZombRand(1, 100) > 50 then
            eyesAdded = (-0.1) * (ZombRand(1, 10))
        else
            eyesAdded = (0.1) * (ZombRand(1, 10))
        end



        BanditClan.Civilians.health = 2.0 + eyesAdded



        bandit.weapons.melee = "Base.BareHands"

        local text2Tab = {
            "Base.SpearCrafted",
            "Base.SpearBreadKnife",
            "Base.SpearButterKnife",
            "Base.SpearFork",
            "Base.SpearHandFork",
            "Base.SpearHuntingKnife",
            "Base.SpearIcePick",
            "Base.SpearKnife",
            "Base.SpearLetterOpener",
            "Base.SpearMachete",
            "Base.SpearScalpel",
            "Base.SpearScissors",
            "Base.SpearScrewdriver",
            "Base.SpearSpoon",
            "Base.WoodenLance",
            "Base.Katana",
            "Base.Machete",
            "Base.ChairLeg",
            "Base.ClubHammer",
            "Base.Hammer",
            "Base.LeadPipe",
            "Base.MetalBar",
            "Base.MetalPipe",
            "Base.PickAxeHandle",
            "Base.PipeWrench",
            "Base.PickAxeHandleSpiked",
            "Base.TableLeg",
            "Base.Wrench",
            "Base.BaseballBat",
            "Base.CanoePadel",
            "Base.CanoePadelX2",
            "Base.Crowbar",
            "Base.Golfclub",
            "Base.HockeyStick",
            "Base.IceHockeyStick",
            "Base.Shovel",
            "Base.Shovel2",
            "Base.Sledgehammer",
            "Base.Sledgehammer2",
            "Base.BaseballBatNails",
            "Base.PlankNail",
            "Base.Axe",
            "Base.HandAxe",
            "Base.PickAxe",
            "Base.WoodAxe",
        }


        local text

        if getGameTime():getDay() < 10 then
            bandit.weapons.melee = "Base.BareHands"


            if ZombRand(1, 100) > 80 then


                text2Tab = {
                        "Base.ChairLeg",
                        "Base.ClubHammer",
                        "Base.Hammer",
                        "Base.Wrench",
                        "Base.BaseballBat",
                        "Base.CanoePadel",
                        "Base.Crowbar",
                        "Base.Golfclub",
                        "Base.HockeyStick",
                        "Base.IceHockeyStick",
                        "Base.Shovel",
                        "Base.Shovel2",
                        "Base.Axe",
                }

                text = text2Tab[ZombRand(1, (#text2Tab))]

                bandit.weapons.melee = text

            end


        else

            if getGameTime():getDay() < 14 then


                if ZombRand(1, 100) > 50 then
        
                    text2Tab = {
                            "Base.ChairLeg",
                            "Base.ClubHammer",
                            "Base.Hammer",
                            "Base.LeadPipe",
                            "Base.MetalBar",
                            "Base.MetalPipe",
                            "Base.PickAxeHandle",
                            "Base.PipeWrench",
                            "Base.TableLeg",
                            "Base.Wrench",
                            "Base.BaseballBat",
                            "Base.CanoePadel",
                            "Base.CanoePadelX2",
                            "Base.Crowbar",
                            "Base.Golfclub",
                            "Base.HockeyStick",
                            "Base.IceHockeyStick",
                            "Base.Shovel",
                            "Base.Shovel2",
                            "Base.Axe",
                    }
                end
                

                text = text2Tab[ZombRand(1, (#text2Tab))]

                bandit.weapons.melee = text


            else

                if ZombRand(1, 100) > 70 then

                    text2Tab = {
                            "Base.Katana",
                            "Base.Machete",
                            "Base.ClubHammer",
                            "Base.Hammer",
                            "Base.LeadPipe",
                            "Base.MetalBar",
                            "Base.MetalPipe",
                            "Base.PickAxeHandle",
                            "Base.PipeWrench",
                            "Base.PickAxeHandleSpiked",
                            "Base.Wrench",
                            "Base.BaseballBat",
                            "Base.Crowbar",
                            "Base.Sledgehammer",
                            "Base.Sledgehammer2",
                            "Base.BaseballBatNails",
                            "Base.PlankNail",
                            "Base.Axe",
                            "Base.HandAxe",
                            "Base.PickAxe",
                            "Base.WoodAxe",
                    }

                else

                    text2Tab = {
                            "Base.SpearCrafted",
                            "Base.SpearBreadKnife",
                            "Base.SpearButterKnife",
                            "Base.SpearFork",
                            "Base.SpearHandFork",
                            "Base.SpearHuntingKnife",
                            "Base.SpearIcePick",
                            "Base.SpearKnife",
                            "Base.SpearLetterOpener",
                            "Base.SpearMachete",
                            "Base.SpearScalpel",
                            "Base.SpearScissors",
                            "Base.SpearScrewdriver",
                            "Base.SpearSpoon",
                            "Base.WoodenLance",
                            "Base.Katana",
                            "Base.Machete",
                            "Base.ChairLeg",
                            "Base.ClubHammer",
                            "Base.Hammer",
                            "Base.LeadPipe",
                            "Base.MetalBar",
                            "Base.MetalPipe",
                            "Base.PickAxeHandle",
                            "Base.PipeWrench",
                            "Base.PickAxeHandleSpiked",
                            "Base.TableLeg",
                            "Base.Wrench",
                            "Base.BaseballBat",
                            "Base.CanoePadel",
                            "Base.CanoePadelX2",
                            "Base.Crowbar",
                            "Base.Golfclub",
                            "Base.HockeyStick",
                            "Base.IceHockeyStick",
                            "Base.Shovel",
                            "Base.Shovel2",
                            "Base.Sledgehammer",
                            "Base.Sledgehammer2",
                            "Base.BaseballBatNails",
                            "Base.PlankNail",
                            "Base.Axe",
                            "Base.HandAxe",
                            "Base.PickAxe",
                            "Base.WoodAxe",
                            "Base.IcePick",
                            "Base.HuntingKnife"
                        }
                end


                text = text2Tab[ZombRand(1, (#text2Tab))]

                bandit.weapons.melee = text




            end




        end



        bandit.femaleChance = 50

        table.insert(event.bandits, bandit)
        sendClientCommand(player, 'Commands', 'SpawnGroup', event)



    end



end



local function fixMusicManClusterFuck()

    local task
    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Entertainer"})

    local brain; local bandit; local npc_id
    local dist = 99


    local babe1

    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local bx, by, bz


    local cell = getCell()
    local zombieList = cell:getZombieList()


    local distToEntertainer = 999

    local npcNearbyNodding = false


    if not result.id then
    else
        -- -- pl:Say("found")
        npc_id = result.id
        babe1 = BanditZombie.GetInstanceById(npc_id)
        bandit = BanditZombie.GetInstanceById(npc_id)
        brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

        bx = BanditZombie.GetInstanceById(npc_id):getX();
        by = BanditZombie.GetInstanceById(npc_id):getY();
        bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());
        
        
        distToEntertainer = BanditUtils.DistTo(px, py, bx, by)

    
        -- distToEntertainer
        
        if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then
            task = Bandit.GetTask(bandit)

            
            if task ~= nil then
                for k, v in pairs(task) do
                    -- -- print(tostring(k) .. ": " .. tostring(v))
                end
            end



        end

    end


    local distToClapper = 500
    
    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Walker", "Inhabitant"})

    if not result.id then
    else
        -- -- pl:Say("found")
        npc_id = result.id
        babe1 = BanditZombie.GetInstanceById(npc_id)
        bandit = BanditZombie.GetInstanceById(npc_id)
        brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

        bx = BanditZombie.GetInstanceById(npc_id):getX();
        by = BanditZombie.GetInstanceById(npc_id):getY();
        bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());
        
        
        distToClapper = BanditUtils.DistTo(px, py, bx, by)

    
        -- distToEntertainer
        
        if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then
            task = Bandit.GetTask(bandit)

            
            if task ~= nil then
                for k, v in pairs(task) do
                    -- -- print(tostring(k) .. ": " .. tostring(v))
                end
            end



            task = Bandit.GetTask(bandit)

            if tostring(task["anim"]) == "Yes" or tostring(task["anim"]) == "Clap" then
                npcNearbyNodding = true
            end


        end

    end

    -- distToEntertainer




    if distToEntertainer > 30 and math.abs(distToClapper - distToEntertainer) > 20 and npcNearbyNodding == true then
        

        
        for i = 0, zombieList:size() - 1 do
            
            local zombie = zombieList:get(i)
            local bx = zombie:getX()
            local by = zombie:getY()

            local bz = math.floor(zombie:getZ())

            local dist = BanditUtils.DistTo(px, py, bx, by)
            if zombie:getVariableBoolean("Bandit") then
                local brain = BanditBrain.Get(zombie)
                local prg = brain.program.name
                npc_id = brain.id

                bandit = BanditZombie.GetInstanceById(npc_id)
                brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

                bx = BanditZombie.GetInstanceById(npc_id):getX();
                by = BanditZombie.GetInstanceById(npc_id):getY();
                bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());

            
                if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then

                    task = Bandit.GetTask(bandit)


                    -- -- print(tostring(task))

                    -- -- print(" -------------------------- ")

                    -- -- print("brain.tasks[1].anim is " .. tostring(brain.tasks[1].anim))

                    -- tostring(bandit.tasks[1].anim)

                    

                    if task ~= nil then
                        for k, v in pairs(task) do
                            -- print(tostring(k) .. ": " .. tostring(v))
                        end
                    end

                end

                if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then




                    task = Bandit.GetTask(bandit)


                    if tostring(task["anim"]) == "Yes" or tostring(task["anim"]) == "Clap" then

                        for i = -14, 14 do

                            for j = -14, 14 do

                            args = {x=bx, y=by, z=bz, otype="preacher"}
                            sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                            args = {x=bx+i, y=by+j, z=bz, otype="preacher"}
                            sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                            -----------

                            args = {x=bx, y=by, z=bz, otype="entertainer"}
                            sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                            args = {x=bx+i, y=by+j, z=bz, otype="entertainer"}
                            sendClientCommand(player, 'Commands', 'ObjectRemove', args)

                            -- -- pl:Say("remove NODDING!!!")

                            -----------                
                            ---
                        
                            end                 

                        end



                    end


                    if tostring(task["action"]) == "TimeEvent" then




                    end
                end
            



            end

        end
    end














 

end

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
    sc:SetCurrentGameSpeed(0) -- pause

    local hutsCsv = ModData.getOrCreate("hutsCsv")

    -- local vipsHere = ModData.getOrCreate("vipsHere")

    ModData.transmit("hutsCsv")


end






local function makeFixedDespawn(removePrg)

    return function(cnt)
        
        cnt = 0

        if type(cnt) ~= "number" then cnt = tonumber(cnt) or 0 end
        if cnt <= 0 then return end

    end

end


local function capSpawn(originalSpawn, cap)
    return function(cnt, ...)

        cnt = 0

        if type(cnt) ~= "number" then cnt = tonumber(cnt) or 0 end
        if cnt <= 0 then return end


        if type(cnt) ~= "number" then return originalSpawn(cnt, ...) end


        return originalSpawn(cnt, ...)

    end
end

local function patchOnce()
    if not BWOPopControl then return end
    if BWOPopControl.__R69_DespawnFix then return end
    BWOPopControl.__R69_DespawnFix = true

    -- despawn fixes (yours)

    BWOPopControl.InhabitantsDespawn = makeFixedDespawn({"Inhabitant", "Looter", "Bandit", "RiotPolice", "Patrol"})

    BWOPopControl.StreetsDespawn = makeFixedDespawn({"Walker", "Runner", "Postal", "Entertainer", "Janitor", "Medic", "Gardener", "Vandal", "Police", "ArmyGuard", "Fireman", "Active"})

    BWOPopControl.SurvivorsDespawn = makeFixedDespawn({"Survivor", "Looter", "Thief"})

    -- ✅ spawn throttles (NEW)
    BWOPopControl.InhabitantsSpawn = capSpawn(BWOPopControl.InhabitantsSpawn, 7) -- 👈🟢 pick your cap
    BWOPopControl.StreetsSpawn     = capSpawn(BWOPopControl.StreetsSpawn, 5)
    BWOPopControl.SurvivorsSpawn   = capSpawn(BWOPopControl.SurvivorsSpawn, 3)


end
-- Call once after everything is loaded.
Events.OnGameStart.Add(patchOnce)

local function dripSpawnZs4Huts(x_in2, y_in2, z_in2, tick_in2, footMat_in2)

    -- dripSpawnZs4Huts

    local hutsCsv = ModData.getOrCreate("hutsCsv")

    local square


    local building = nil

    local buildingDef

    local keyId


    if tonumber(x_in2) ~= nil then
        square = getCell():getGridSquare(x_in2, y_in2, z_in2)

        if square ~= nil then

            building = square:getBuilding()

            if building then
            
                buildingDef = building:getDef()

                keyId = buildingDef:getKeyId()

            else


            end

            
        end


    end

    if building == nil then
        do return end
    end

    -- Phase 2D — Zombie Drip Spawn: Make dripSpawnZs4Huts() slowly add those hut zombies back later, because the poof step only works if it also leads into a believable delayed return.

    local keyId

    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    local numberOfZombies = ZombRand(1, 10)

    -- hutsCsv

    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsCsv = ModData.getOrCreate("vipsCsv")


    local building; local square


    local buildingDef






    for i = (getNumActivePlayers() - 1), (getNumActivePlayers()) do

        local px2 = getPlayer(i):getX()
        local py2 = getPlayer(i):getY()
        local pz2 = math.floor(getPlayer(i):getZ())

        -- make sure to not mess up immersion of anyone else when doing local split-screen co-op by spawning zeds RIGHT IN FRONT OF THEM:

        if BanditUtils.DistTo(px, py, (x_in2), (y_in2)) < 21 and pz == z_in2 then
            numberOfZombies = 0
            do return end
        else
            if BanditUtils.DistTo(px, py, (x_in2), (y_in2)) < 15 and tostring(LosUtil.lineClear(getCell(), px, py, pz, x_in2, y_in2, z_in2, false)) == "Clear" then
                numberOfZombies = 0
                do return end
            end
        end

    end







    local hutsCsv = ModData.getOrCreate("hutsCsv")


    if activeSpawningHutKeyId == nil then

        for k, v in pairs(hutsCsv) do
            -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)
            keyId = k

            if hutsCsv[keyId] ~= nil then

                if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 3 then
                    do return end
                end
        
                if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 3 and math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 60 then
                    activeSpawningHutKeyId = keyId
                end
                
            end
        end

    end



    if activeSpawningHutKeyId == nil then

        for k, v in pairs(hutsCsv) do
            -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)
            keyId = k

            if hutsCsv[keyId] ~= nil then
        
                if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 3 then
                    activeSpawningHutKeyId = keyId
                end
                
            end
        end

    end


    -- 
    ------------------------------------------------------ 🍪🍪
    -- NO DOUBLE-DIPPING OR SPAWNING WHILE DE-SPAWNING:

    for k, v in pairs(hutsCsv) do
        -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

        keyId = tonumber(k)

        if math.abs(tonumber(v.totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 3 then
            do return end
        end

    end


    if activeSpawningHutKeyId == nil then
        do return end
    end

    if hutsCsv[activeSpawningHutKeyId] == nil then
        do return end
    end

    if BanditUtils.DistTo(px, py, hutsCsv[activeSpawningHutKeyId].px, hutsCsv[activeSpawningHutKeyId].py) < 100 or BanditUtils.DistTo(px, py, ((hutsCsv[activeSpawningHutKeyId].x + hutsCsv[activeSpawningHutKeyId].x2)/2) , ((hutsCsv[activeSpawningHutKeyId].y + hutsCsv[activeSpawningHutKeyId].y2)/2)) < 100 then


        -- hutsCsv[activeSpawningHutKeyId].px, hutsCsv[activeSpawningHutKeyId].py
        square = getCell():getGridSquare(hutsCsv[activeSpawningHutKeyId].px, hutsCsv[activeSpawningHutKeyId].py, hutsCsv[activeSpawningHutKeyId].pz);

        if square then

            building = square:getBuilding()

            if building then

                building = square:getBuilding()

                buildingDef = building:getDef()

                hutsCsv[activeSpawningHutKeyId].isAlarmed = buildingDef:isAlarmed()

                keyId = buildingDef:getKeyId()

            end

        end

    end


    if tostring(hutsCsv[activeSpawningHutKeyId].isAlarmed) == "false" then

        for k, v in pairs(hutsCsv) do
            -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

            if math.abs((v.totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 3 then

                if BanditUtils.DistTo(px, py, v.px, v.py) < 45 then

                    square = getCell():getGridSquare(v.px, v.py, v.pz);

                    if square then
                        if building then

                            building = square:getBuilding()

                            buildingDef = building:getDef()

                            hutsCsv[k].isAlarmed = buildingDef:isAlarmed()

                            keyId = buildingDef:getKeyId()





                            if BanditUtils.DistTo(px, py, hutsCsv[k].px, hutsCsv[k].py) < 100 or BanditUtils.DistTo(px, py, ((hutsCsv[k].x + hutsCsv[k].x2)/2) , ((hutsCsv[k].y + hutsCsv[k].y2)/2)) < 100 then


                                if tostring(hutsCsv[activeSpawningHutKeyId].isAlarmed) == "false" and tostring(hutsCsv[k].isAlarmed) == "true" and hutsCsv[k].totZombiesLeft > 1 then
                                    activeSpawningHutKeyId = k
                                    break
                                end


                            end






                        end

                    end

                end


            end

        end
    end




    keyId = activeSpawningHutKeyId


    -- tick_in2

    -- hutsCsv[keyId].isAlarmed
    -- if tick_in2 % 180 == 0 then
    -- if numTicksInZZB % 30 == 0 then


    -- if footstepMatHere == "Gravel" or footstepMatHere == "Sand" or footstepMatHere == "Concrete" or footstepMatHere == "Ceramic" or footstepMatHere == "Grass" then

    local tickMultiplierNeeded = 1

    local zedClumpSizeMultiplier = 1



    if tostring(footMat_in2) == "Gravel" or tostring(footMat_in2) == "Concrete" or tostring(footMat_in2) == "Ceramic" then

        if quickCountNearbyZeds_R69 < (maxZeds_sandbox_knob250 - 50) then
            tickMultiplierNeeded = 3

        else
            if quickCountNearbyZeds_R69 < (maxZeds_sandbox_knob250 - 0) then
                tickMultiplierNeeded = 4
            else
                tickMultiplierNeeded = 6

                -- hutsCsv[keyId].isAlarmed
            end

        end

        zedClumpSizeMultiplier = 1

        -- rapid mini spawns
    else
        
        if tostring(footMat_in2) == "nil" then
            -- BIG DENSE CLUMPS... but MODERATELY SLOW


            zedClumpSizeMultiplier = 7

            tickMultiplierNeeded = 12


        else

            if tostring(footMat_in2) == "Sand" then
                -- rapid mini spawns... but a little less rapid than the other

                zedClumpSizeMultiplier = 1

                tickMultiplierNeeded = 12

            else
    
                if tostring(footMat_in2) == "Grass" then
                    -- SINGLE-zombie spawns.... also very slow
                    zedClumpSizeMultiplier = 1
                    
                    tickMultiplierNeeded = 25

                else

                    zedClumpSizeMultiplier = 1

                    tickMultiplierNeeded = 27

                    -- SINGLE-zombie spawns.... also very slow

                end
            end
            

        end


    end

    keyId = activeSpawningHutKeyId
    

    if hutsCsv[keyId].isAlarmed == true then
        
        tickMultiplierNeeded = math.ceil(tickMultiplierNeeded / 2)

    end


    if tick_in2 % (180 * tickMultiplierNeeded) == 0 then
        -- zedClumpSizeMultiplier
        -- numberOfZombies
        numberOfZombies = ZombRand(zedClumpSizeMultiplier, 10 + zedClumpSizeMultiplier)

        if zedClumpSizeMultiplier == 1 then
            
            numberOfZombies = 1 + ZombRand(0, 1)
            
            if ZombRand(1, 100) > 50 then
                numberOfZombies = numberOfZombies + ZombRand(0, 1)
            end

        end

    else

        do return end
        
    end


    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsCsv = ModData.getOrCreate("vipsCsv")

    local zedsHere = ModData.getOrCreate("zedsHere")

    if not hutsCsv[keyId] then
        do return end
    end

    if hutsCsv[keyId].totZombiesLeft < 1 then
        do return end
    else


    end







    



    local maleOutfits = { "Chef", "Redneck", "Hunter", "Camper", "MallSecurity", "Cook_Generic", "BWOFormal", "Young", "John", "Priest", "Dean", "Thug", "Party", "OfficeWorker", "Classy", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "Farmer", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Gas2Go", "GigaMart_Employee", "Pharmacist", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal", "SportsFan", "Varsity", "StreetSports", "Waiter_Spiffo", "Spiffo" }

    local femaleOutfits = { "OfficeWorkerSkirt", "Cook_Generic", "Party", "DressShort", "BWORainGeneric02", "BWORainGeneric01", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "BWOYoung", "BWOCow", "BWOLeather", "", "DressNormal", "DressShort", "Classy", "Young", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Gas2Go", "GigaMart_Employee", "Pharmacist", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal", "SportsFan", "Varsity", "StreetSports", "Bandit", "Waiter_Classy", "Waiter_Spiffo", "Waiter_Diner", "Waiter_Restaurant", "Spiffo", "Farmer" }


    if getGameTime():getDay() >= 16 then
               

        maleOutfits = {"PoliceState", "HazardSuit", "HazardSuit", "HazardSuit", "PoliceRiot", "AmbulanceDriver", "Pharmacist", "Nurse", "Doctor", "Bandit", "ZSPoliceSpecialOps", "PoliceState", "PoliceRiot", "BWOYoung", "Police", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Chef", "Redneck", "Hunter", "Camper", "MallSecurity", "Cook_Generic", "BWOFormal", "Young", "John", "Priest", "Dean", "Thug", "Party", "OfficeWorker", "Classy", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "Farmer", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Gas2Go", "Bandit", "Pharmacist", "SportsFan", "Varsity", "StreetSports", "Waiter_Spiffo", "Spiffo", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Chef", "Redneck", "Hunter", "Camper", "Bandit", "Cook_Generic", "BWOFormal", "Young", "John", "Priest", "Dean", "Thug", "Party", "OfficeWorker", "Classy", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "Farmer", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Bandit", "GigaMart_Employee", "Pharmacist", "SportsFan", "Varsity", "StreetSports", "Waiter_Spiffo", "Spiffo", "Young", "BWOYoung", "BWOCow", "BWOLeather", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal", "Security"}
        
        femaleOutfits = {"Pharmacist", "Nurse", "Doctor", "Bandit", "Police", "Generic01",  "Generic02", "Generic03", "Generic04", "Generic05", "BWOYoung", "BWOCow", "BWOLeather", "SportsFan", "Varsity", "StreetSports", "Bandit", "Waiter_Classy", "Waiter_Spiffo", "Waiter_Diner", "Waiter_Restaurant", "Spiffo", "OfficeWorkerSkirt", "Cook_Generic", "Party", "DressShort", "BWORainGeneric02", "BWORainGeneric01", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "BWOYoung", "BWOCow", "BWOLeather", "Joan", "DressNormal", "DressShort", "Classy", "Young", "Biker", "Punk", "Rocker", "Fireman", "Bandit", "Gas2Go", "Bandit", "Pharmacist", "SportsFan", "Varsity", "StreetSports", "Bandit", "Waiter_Classy", "Waiter_Spiffo", "Waiter_Diner", "Waiter_Restaurant", "Spiffo", "OfficeWorkerSkirt", "Cook_Generic", "Party", "DressShort", "BWORainGeneric02", "BWORainGeneric01", "Generic01", "Generic02", "Generic03", "Generic04", "Generic05", "Student", "Teacher", "BWOYoung", "BWOCow", "BWOLeather", "Joan", "DressNormal", "DressShort", "Classy", "Young", "Biker", "Punk", "Rocker", "Fireman", "Fossoil", "Bandit", "GigaMart_Employee", "Pharmacist", "Farmer", "ShellSuit_Black", "ShellSuit_Black", "ShellSuit_Blue", "ShellSuit_Green", "ShellSuit_Pink", "ShellSuit_Teal" }
        
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


    local count = getNumActivePlayers()
    local pl = getPlayer(0)

    if count > 1 then
        -- print("more than one player")
        -- -- pl:Say("more than one player")

        -- we wanna spawn them a little further away probably if there's more than one player present (for split-screen co-op so we don't spawn right on top of another player)

        for i = (count - 1), (count) do

            local px = getPlayer(i):getX()
            local py = getPlayer(i):getY()
            local pz = math.floor(getPlayer(i):getZ())

            -- make sure to not mess up immersion of anyone else when doing local split-screen co-op by spawning zeds RIGHT IN FRONT OF THEM:

            if BanditUtils.DistTo(px, py, (x_in2), (y_in2)) < 21 and pz == z_in2 then
                numberOfZombies = 0
                do return end
            else
                if BanditUtils.DistTo(px, py, (x_in2), (y_in2)) < 15 and tostring(LosUtil.lineClear(getCell(), px, py, pz, (x_in2), (y_in2), (z_in2), false)) == "Clear" then
                    numberOfZombies = 0
                    do return end
                end
            end

        end
    end

    
    local px = getPlayer(0):getX()
    local py = getPlayer(0):getY()
    local pz = math.floor(getPlayer(0):getZ())



    if tostring(LosUtil.lineClear(getCell(), px, py, pz, (x_in2), (y_in2), (z_in2), false)) ~= "Clear" then

        addZombiesInOutfit(x_in2, y_in2, z_in2, numberOfZombies, text, femaleChanceHere)

        hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft - numberOfZombies

    else
        -- print("EMPTY SPAWN LOCATION CAN BE SEEN! ABORT! DONT SPAWN ZEDS HERE!")
        -- -- pl:Say("EMPTY SPAWN LOCATION CAN BE SEEN! ABORT! DONT SPAWN ZEDS HERE!")
    end


    if hutsCsv[keyId].totZombiesLeft < 0 then
        hutsCsv[keyId].totZombiesLeft = 0
    end


end





local function allButSpawn()

    -- maxNpcs_R69


    -- if quickCountNearbyZeds_R69 > maxZeds_sandbox_knob250 or (quickCountNearbyZeds_R69 + quickCountNearbyNpcs_R69) > 300 then

    local vipsHere = ModData.getOrCreate("vipsHere")


    -- if 



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



        BWOPopControl.InhabitantsNominal = 14 - (BWOScheduler.WorldAge - 133)
        BWOPopControl.StreetsNominal = 11 - (BWOScheduler.WorldAge - 133)
        BWOPopControl.SurvivorsNominal = 16 - (BWOScheduler.WorldAge - 133)

        if BWOPopControl.StreetsNominal < 0 then

            BWOPopControl.InhabitantsNominal = 0
            BWOPopControl.StreetsNominal = 0
            BWOPopControl.SurvivorsNominal = 1

        end



    elseif BWOScheduler.WorldAge >= 169 then
        BWOPopControl.ZombieMax = 1000
        BWOPopControl.SurvivorsNominal = 0
        BWOPopControl.InhabitantsNominal = 0
        BWOPopControl.StreetsNominal = 0

    end

    maxNpcs_R69 = (BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal + BWOPopControl.SurvivorsNominal)


    if BWOScheduler.WorldAge <= 132 then
        maxNpcs_R69 = 15
    end


    -- BWOScheduler.WorldAge == 132 

    if BWOScheduler.WorldAge <= 132 then
        maxZeds_R69 = BWOPopControl.ZombieMax
    else
        maxZeds_R69 = maxZeds_sandbox_knob250
    end


    local zedsHere = ModData.getOrCreate("zedsHere")

    -- ...and then when we enter a new building for the first time we do this:

    local player = getPlayer(0)
    local pl = getPlayer(0)

    
    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local building = player:getBuilding()

    local buildingDef
    local keyId

    local square

    local hutsCsv = ModData.getOrCreate("hutsCsv")

    -- for k, v in pairs(hutsCsv) do
    --     -- hutsCsv[k] = nil
    --     -- -- print("Key:", k, "Value of v.occupantsMax: ", v.occupantsMax)
    --     -- -- print("Key:", k, "Value of v.px: ", v.px)
    --     -- -- print("Key:", k, "Value of v.py: ", v.py)
    -- end

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

    -- print("maxNpcs_R69 is " .. tostring(maxNpcs_R69))

    if maxNpcs_R69 <= 90 then
    
        for k, v in pairs(hutsCsv) do
            -- -- print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)

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

            local avgVar1 = math.ceil(((x2 - x1) + (y2 - y1)) / 2)

            -- -- print("debug: avgVar1 is " .. tostring(avgVar1))

            -- if avgVar1 >= 30 then
            --     addNum = addNum * 4
            --     -- -- pl:Say("debug: avgVar1 is " .. tostring(avgVar1) .. " and addNum is " .. tostring(addNum))
            -- end



            -- local addNum = 5

            -- if getGameTime():getDay() >= 15 then
            --     addNum = 3

            --     if getGameTime():getDay() >= 18 then
            --         addNum = 1
            --     end
            -- end

            -- local avgVar1 = math.ceil(((x2 - x1) + (y2 - y1)) / 2)

            -- -- print("debug: avgVar1 is " .. tostring(avgVar1))

            -- if avgVar1 >= 30 then
            --     addNum = addNum * 4
            --     -- -- pl:Say("debug: avgVar1 is " .. tostring(avgVar1) .. " and addNum is " .. tostring(addNum))

            -- else
            --     if avgVar1 > 23 then
            --         addNum = addNum * 2
            --     else

            --         if avgVar1 > 16 then
            --             addNum = addNum
            --         else
            --             addNum = math.ceil(addNum * (1/2))
            --         end
            --     end
            -- end

            if px > x1 and px < x2 and py > y1 and py < y2 then
                -- maxNpcs_R69 = maxNpcs_R69 + addNum
                maxNpcs_R69 = maxNpcs_R69 + v.npcsLeft
            else
                if BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100 then
                    -- maxNpcs_R69 = maxNpcs_R69 + addNum
                    maxNpcs_R69 = maxNpcs_R69 + v.npcsLeft
                else

                end
            end

        end

    end


    if maxNpcs_R69 > math.ceil(100 * ((SandboxVars.BanditsWeekOne.StreetsPopMultiplier + SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier) / 2)) then
        maxNpcs_R69 = math.ceil(100 * ((SandboxVars.BanditsWeekOne.StreetsPopMultiplier + SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier) / 2))
    end

    if maxNpcs_R69 > 100 then
        maxNpcs_R69 = 100
    end
    


    if building then

        buildingDef = building:getDef()
        keyId = buildingDef:getKeyId()


        local x1 = buildingDef:getX()
        local y1 = buildingDef:getY()
        local x2 = buildingDef:getX2()
        local y2 = buildingDef:getY2()

        local occupantsMax = math.ceil((math.abs(x2 - x1) * math.abs(y2 - y1)) / 20)

        -- math.abs((zedsHere[npc_id].totMinutesAtFirstSeen) - )
        -- 

        local livingNumber_OG = 0




        local npcsLeft = 8

        -- if getGameTime():getDay() >= 15 then
        --     -- npcsLeft = 3
        --     npcsLeft = 5

        --     if getGameTime():getDay() >= 18 then
        --         npcsLeft = 5
        --         -- npcsLeft = 1
        --     end
        -- end

        local avgVar1 = math.ceil(((x2 - x1) + (y2 - y1)) / 2)

        -- print("debug: avgVar1 is " .. tostring(avgVar1))



        if avgVar1 >= 40 then
            npcsLeft = npcsLeft * 5
            -- -- pl:Say("debug: avgVar1 is " .. tostring(avgVar1) .. " and npcsLeft is " .. tostring(npcsLeft))

        else

            if avgVar1 >= 30 then
                npcsLeft = npcsLeft * 4
                -- -- pl:Say("debug: avgVar1 is " .. tostring(avgVar1) .. " and npcsLeft is " .. tostring(npcsLeft))

            else
                if avgVar1 > 23 then
                    npcsLeft = npcsLeft * 2
                else

                    if avgVar1 > 16 then
                        npcsLeft = npcsLeft
                    else
                        npcsLeft = math.ceil(npcsLeft * (1/2))
                    end
                end
            end

        end



        if not hutsCsv[keyId] then
            hutsCsv[keyId] = {
                occupantsMax=occupantsMax, 
                totZombiesLeft=0, 
                totMinutesAtFirstSeen=(getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24)), 
                x=x1, 
                y=y1, 
                x2=x2,
                y2=y2, 
                dayLastSeen=getGameTime():getDay(),
                isAlarmed=buildingDef:isAlarmed(),
                px=px,
                py=py,
                pz=pz,
                npcs={},
                npcsLeft=npcsLeft,
                livingNumber_OG=npcsLeft
            }

            savedKeyId = keyId


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

    local cell = getCell()
    local zombieList = cell:getZombieList()

    local totalb = 0 -- all civs
    local totalz = 0 -- all zeds
    
    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    for i = 0, zombieList:size() - 1 do
        local zombie = zombieList:get(i)
        local zx = zombie:getX()
        local zy = zombie:getY()
        local dist = BanditUtils.DistTo(px, py, zx, zy)
        if zombie:getVariableBoolean("Bandit") then
            local brain = BanditBrain.Get(zombie)
            local prg = brain.program.name

            -- -- print("bandit??? -> program name is: " .. tostring(prg))

            quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 + 1

        else
            -- print("no???")
            quickCountNearbyZeds_R69 = quickCountNearbyZeds_R69 + 1
        end
    end



    -- print("quickCountNearbyNpcs_R69 is " .. tostring(quickCountNearbyNpcs_R69))
    -- print("quickCountNearbyZeds_R69 is " .. tostring(quickCountNearbyZeds_R69))




    -- -- pl:Say("maxNpcs_R69 is " .. tostring(maxNpcs_R69))
    -- -- pl:Say("maxZeds_R69 is " .. tostring(maxZeds_R69))









    local bx, by, bz
    local vipsHere = ModData.getOrCreate("vipsHere")




    for i = 0, zombieList:size() - 1 do


        -- print(" ------>>>> print THIS if this is running!!")
        

        zombie = zombieList:get(i)



        

        vipsHere = ModData.getOrCreate("vipsHere")


        if zombie then
            
            if zombie:isAlive() then

                bx = zombie:getX()
                by = zombie:getY()

                bz = math.floor(zombie:getZ())

                dist = BanditUtils.DistTo(px, py, bx, by)


                if zombie:getVariableBoolean("Bandit") then


                    local brain = BanditBrain.Get(zombie)
                    local prg = brain.program.name

                    if pz ~= bz then
                        
                        dist = dist + ( (math.abs(pz - bz)) * 10)

                    end

                    npc_id = brain.id
                    bandit = BanditZombie.GetInstanceById(npc_id)

                    if quickCountNearbyNpcs_R69 > maxNpcs_R69 and brain.program.name ~= "Bandit" then

                        if dist > 25 and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                            
                            if BanditZombie.GetInstanceById(npc_id) ~= nil then

                                -- print("bandit??? -> program name is: " .. tostring(prg))


                                -- brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))
                            
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


                                        local notBusyNow = false

                                        if brain.hostile == false then

                                            

                                            if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then

                                                task = Bandit.GetTask(bandit)

                                                if tostring(task["action"]) == "Time" then

                                                    if tostring(task["anim"]) == "ShiftWeight" or tostring(task["anim"]) == "PullAtCollar" or tostring(task["anim"]) == "ChewNails" or tostring(task["anim"]) == "Smoke" or tostring(task["anim"]) == "Sneeze" or tostring(task["anim"]) == "WipeBrow" or tostring(task["anim"]) == "WipeHead" or tostring(task["anim"]) == "Talk1" or tostring(task["anim"]) == "Talk2" or tostring(task["anim"]) == "Talk3" or tostring(task["anim"]) == "Talk4"  or tostring(task["anim"]) == "Talk5" then

                                                        notBusyNow = true
                                                        
                                                        -- if they're not doing anything they can leave


                                                    end

                                                end
                                            else
                                                notBusyNow = true
                                            end


                                                if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" and notBusyNow == true then
                                                    zombieObj = BanditZombie.GetInstanceById(brain.id)

                                                    zombieObj:removeFromSquare()
                                                    zombieObj:removeFromWorld()

                                                    args = { id = brain.id } -- ✅ don’t leak globals
                                                    sendClientCommand(player, "Commands", "BanditRemove", args)

                                                    quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 - 1

                                                    -- vipsHere

                                                    local vipsHere = ModData.getOrCreate("vipsHere")

                                                    if vipsHere[brain.id] ~= nil then
                                                        vipsHere[brain.id] = nil
                                                        -- vipsHere[npc_id] = nil
                                                    end

                                                end


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

                                        if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then


                                            zombieObj = BanditZombie.GetInstanceById(brain.id)

                                            zombieObj:removeFromSquare()
                                            zombieObj:removeFromWorld()

                                            args = { id = brain.id } -- ✅ don’t leak globals
                                            sendClientCommand(player, "Commands", "BanditRemove", args)

                                            quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 - 1


                                            local vipsHere = ModData.getOrCreate("vipsHere")

                                            if vipsHere[brain.id] ~= nil then
                                                vipsHere[brain.id] = nil
                                                -- vipsHere[npc_id] = nil
                                            end


                                        end

                                    end


                                end

                            end

                        end

                    end

                    -- quickCountNearbyNpcs_R69 = quickCountNearbyNpcs_R69 + 1

                else
                    -- print("no???")
                    -- quickCountNearbyZeds_R69 = quickCountNearbyZeds_R69 + 1

                    if quickCountNearbyZeds_R69 > maxZeds_R69 then

                        npc_id = BanditUtils.GetCharacterID(zombie)


                        -- -- pl:Say("....BanditUtils.GetCharacterID(zombie) is " .. tostring(BanditUtils.GetCharacterID(zombie)))
                        -- npc_id = zombie.id

                        

                        if zedsHere[npc_id] == nil then

                            -- 

                            if square ~= nil then

                                if square:getBuilding() == nil then
                                    zedsHere[npc_id] = {x=bx, y=by, z=bz}

                                else

                                    building = square:getBuilding()

                                    buildingDef = building:getDef()

                                    keyId = buildingDef:getKeyId()


                                    if hutsCsv[keyId] ~= nil and zombie then

                                        -- if zombie:isAlive() then

                                        if zombie:isAlive() then

                                            if math.abs(hutsCsv[keyId].totMinutesAtFirstSeen - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 3 and dist < 30 then


                                                local zombieObj = BanditZombie.GetInstanceById(zombie.id)

                                                if zombie.id ~= nil then
                                                    if zombie.id ~= 0 then

                                                        if (4 + tonumber(zombie.id)) % 4 == 0 then

                                                            if math.abs(hutsCsv[keyId].totMinutesAtFirstSeen - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 1 and dist > 3 then
                            
                                                                zombieObj:removeFromSquare()
                                                                zombieObj:removeFromWorld()

                                                                args = { id = zombie.id } -- ✅ don’t leak globals
                                                                sendClientCommand(player, "Commands", "BanditRemove", args)

                                                                hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft + 1

                                                                quickCountNearbyZeds_R69 = quickCountNearbyZeds_R69 - 1

                                                            else
                                                                -- leave 1/4 of the nearby zombos in place so long as they're not TOO close
                                                            end

                                                        end
                    
                                                        zombieObj:removeFromSquare()
                                                        zombieObj:removeFromWorld()

                                                        args = { id = zombie.id } -- ✅ don’t leak globals
                                                        sendClientCommand(player, "Commands", "BanditRemove", args)

                                                        hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft + 1

                                                        quickCountNearbyZeds_R69 = quickCountNearbyZeds_R69 - 1

                                                    end
                                                end
                                                

                                            else
                                                zedsHere[npc_id] = {x=bx, y=by, z=bz}
                                                
                                            end
                                        end

                                        -- totMinutesAtFirstSeen=(getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))



                                    else
                                        -- if they path through a building we haven't entered yet that's fine too:
                                        zedsHere[npc_id] = {x=bx, y=by, z=bz}


                                    end
                                end

                            end
                            

                                local bool3 = false

                                if 1 + 1 == 2 then

                                    -- if getGameTime():getDay() < 13


                                    if getGameTime():getDay() >= 13 then

                                        if quickCountNearbyZeds_R69 > maxZeds_sandbox_knob250 or (quickCountNearbyZeds_R69 + quickCountNearbyNpcs_R69) > 320 or quickCountNearbyZeds_R69 > maxZeds_R69 then
                                            bool3 = true
                                        end

                                    else
                                        bool3 = true

                                    end

                                    -- quickCountNearbyZeds_R69
                                    if zombie then

                                        if zombie:isAlive() then


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



                                            npc_id = BanditUtils.GetCharacterID(zombie)


                                            -- -- pl:Say("...wtf??? zombie.id is " .. tostring(zombie.id))

                                            -- -- pl:Say("...wtf??? npc_id from BanditUtils.GetCharacterID(zombie) is " .. tostring(npc_id))

                                            -- maxZeds_R69

                                            local bool4 = false

                                            if dist > 25 and quickCountNearbyZeds_R69 > (100 + maxZeds_sandbox_knob250) then

                                                if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                                                    bool4 = true

                                                    if getNumActivePlayers() > 1 then
                                                        
                                                        for i = (getNumActivePlayers() - 1), (getNumActivePlayers()) do

                                                            local px2 = getPlayer(i):getX()
                                                            local py2 = getPlayer(i):getY()
                                                            local pz2 = math.floor(getPlayer(i):getZ())

                                                            if tostring(LosUtil.lineClear(getCell(), px2, py2, pz2, bx, by, bz, false)) == "Clear" or BanditUtils.DistTo(px2, py2, bx, by) + ( (math.abs(pz2 - bz)) * 10) < 15 then
                                                                bool4 = false
                                                            end

                                                        end

                                                    end


                                                end
                                            end

                                            if dist > 30 then

                                                if quickCountNearbyZeds_R69 > maxZeds_sandbox_knob250 then
                                                    bool4 = true
                                                end

                                            else

                                                if quickCountNearbyZeds_R69 > maxZeds_R69 - 25 then

                                                    if dist > 40 then

                                                        if hutsCsv[keyId].totZombiesLeft >= 35 then
                                                            bool4 = true
                                                        end

                                                    end

                                                else

                                                    if quickCountNearbyZeds_R69 > maxZeds_R69 - 45 then

                                                        if dist > 45 then

                                                            if hutsCsv[keyId].totZombiesLeft >= 55 then
                                                                bool4 = true
                                                            end

                                                        end

                                                    else


                                                        if quickCountNearbyZeds_R69 > maxZeds_R69 - 55 then

                                                            if dist > 55 then

                                                                if hutsCsv[keyId].totZombiesLeft >= 70 then
                                                                    bool4 = true
                                                                end

                                                            end

                                                        end


                                                    end

                                                end

                                            end


                                            -- quickCountNearbyZeds_R69 > maxZeds_sandbox_knob250 or (quickCountNearbyZeds_R69 + quickCountNearbyNpcs_R69) > (maxZeds_sandbox_knob250 + 50) or quickCountNearbyZeds_R69 > maxZeds_R69

                                            if bool4 == true then
            
                                                if zombie.id ~= nil then
                                                    if zombie.id ~= 0 then

                                                        if quickCountNearbyZeds_R69 > maxZeds_sandbox_knob250 then

                                                        end

                                                        if dist > 30 then
                        
                                                            zombieObj = BanditZombie.GetInstanceById(npc_id)

                                                            zombieObj:removeFromSquare()
                                                            zombieObj:removeFromWorld()

                                                            args = { id = npc_id } -- ✅ don’t leak globals
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

                        
                    end

                end

            end
        end


    end





end

-- allButSpawn()
















local function preDripper(tick_in)

	local zedsHere = ModData.getOrCreate("zedsHere")


    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())


    local tab1 = {}


    local keyId

    local hutsCsv = ModData.getOrCreate("hutsCsv")

    local nearbyAlarmActive = false



    if activeSpawningHutKeyId ~= nil then

        for k, v in pairs(hutsCsv) do
            if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 3 then
                do return end
            else

                -- -- print("Key:", k, "Value of v.maxzomboSlots: ", v.maxzomboSlots)
                keyId = k
                activeSpawningHutKeyId = k

            end
        end

    end

    if activeSpawningHutKeyId ~= nil then

        for k, v in pairs(hutsCsv) do
            -- -- print("Key:", k, "Value of v.maxzomboSlots: ", v.maxzomboSlots)
            keyId = k

            if hutsCsv[keyId] ~= nil then
        
                -- hutsCsv[activeSpawningHutKeyId].isAlarmed
                -- hutsCsv[keyId].isAlarmed

                if BanditUtils.DistTo(px, py, hutsCsv[activeSpawningHutKeyId].px, hutsCsv[activeSpawningHutKeyId].py) < 100 or BanditUtils.DistTo(px, py, ((hutsCsv[activeSpawningHutKeyId].x + hutsCsv[activeSpawningHutKeyId].x2)/2) , ((hutsCsv[activeSpawningHutKeyId].y + hutsCsv[activeSpawningHutKeyId].y2)/2)) < 100 then


                    if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 3 then

                        do return end

                    else

                        if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 3 and math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < (60 * 4) then

                            activeSpawningHutKeyId = keyId
                            
                            if hutsCsv[activeSpawningHutKeyId].isAlarmed == true then
                                nearbyAlarmActive = true
                                break
                            end
                        end

                    end

                end

                
            end
        end

    end

    -- if BanditUtils.DistTo(px, py, hutsCsv[activeSpawningHutKeyId].px, hutsCsv[activeSpawningHutKeyId].py) < 100 or BanditUtils.DistTo(px, py, ((hutsCsv[activeSpawningHutKeyId].x + hutsCsv[activeSpawningHutKeyId].x2)/2) , ((hutsCsv[activeSpawningHutKeyId].y + hutsCsv[activeSpawningHutKeyId].y2)/2)) < 100 then

    -- if BanditUtils.DistTo(px, py, hutsCsv[activeSpawningHutKeyId].px, hutsCsv[activeSpawningHutKeyId].py) < 100 or BanditUtils.DistTo(px, py, ((hutsCsv[activeSpawningHutKeyId].x + hutsCsv[activeSpawningHutKeyId].x2)/2) , ((hutsCsv[activeSpawningHutKeyId].y + hutsCsv[activeSpawningHutKeyId].y2)/2)) < 100 then


    if activeSpawningHutKeyId ~= nil then

        for k, v in pairs(hutsCsv) do
            -- -- print("Key:", k, "Value of v.maxzomboSlots: ", v.maxzomboSlots)
            keyId = k

            if hutsCsv[keyId] ~= nil then

                if BanditUtils.DistTo(px, py, hutsCsv[activeSpawningHutKeyId].px, hutsCsv[activeSpawningHutKeyId].py) < 100 or BanditUtils.DistTo(px, py, ((hutsCsv[activeSpawningHutKeyId].x + hutsCsv[activeSpawningHutKeyId].x2)/2) , ((hutsCsv[activeSpawningHutKeyId].y + hutsCsv[activeSpawningHutKeyId].y2)/2)) < 100 then
    

                    if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < 3 then
                        do return end
                    end
            
                    if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 3 then
                        activeSpawningHutKeyId = keyId
                    end

                    if hutsCsv[activeSpawningHutKeyId].isAlarmed == true then

                        if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) > 3 and math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) < (60 * 4) then

                            nearbyAlarmActive = true
                            
                            break
                        end

                    end
                
                end
                    

            end
        end
    end



    if activeSpawningHutKeyId == nil then
        do return end
    end


    local distMultiplier = 1.8
    
    distMultiplier = 1.0

    if hutsCsv[activeSpawningHutKeyId].isAlarmed == true then
        nearbyAlarmActive = true
        distMultiplier = 0.8
    else
        nearbyAlarmActive = false
        distMultiplier = 1.8
    end
    

    local modNum = 1
    local modNumB = 1

    if ZombRand(1, 100) > 50 then
        
        modNum = -1
    end

    if ZombRand(1, 1000) > 500 then
        
        modNumB = -1
    end

    -- so for alarmed buildings we need minimum of 11, 11 numbers… and honestly we should max out around 18, 18 as our range 

    -- ...and non-alarmed buildings should spawn in zeds from minimum 14, 14 and max of 34, 34 I think 



    local rand1 = ZombRand(10, 18) * (modNum)
    local rand1b = ZombRand(10, 18) * (modNumB)

    local rand2 = ZombRand(10, 18) * (modNum)
    local rand2b = ZombRand(10, 18) * (modNumB)

    local rand3 = ZombRand(10, 18) * (modNum)
    local rand3b = ZombRand(10, 18) * (modNumB)

    local rand4 = ZombRand(10, 18) * (modNum)
    local rand4b = ZombRand(10, 18) * (modNumB)

    local rand5 = ZombRand(21, 27) * (modNum)
    local rand5b = ZombRand(21, 27) * (modNumB)


    
    if nearbyAlarmActive == true then

        rand1 = ZombRand(10, 18) * (modNum)
        rand1b = ZombRand(10, 18) * (modNumB)

        rand2 = ZombRand(10, 18) * (modNum)
        rand2b = ZombRand(10, 18) * (modNumB)

        rand3 = ZombRand(10, 18) * (modNum)
        rand3b = ZombRand(10, 18) * (modNumB)

        rand4 = ZombRand(10, 18) * (modNum)
        rand4b = ZombRand(10, 18) * (modNumB)

        rand5 = ZombRand(10, 18) * (modNum)
        rand5b = ZombRand(10, 18) * (modNumB)


    else

        rand1 = ZombRand(14, 34) * (modNum)
        rand1b = ZombRand(14, 34) * (modNumB)

        rand2 = ZombRand(14, 34) * (modNum)
        rand2b = ZombRand(14, 34) * (modNumB)

        rand3 = ZombRand(14, 34) * (modNum)
        rand3b = ZombRand(14, 34) * (modNumB)

        rand4 = ZombRand(14, 34) * (modNum)
        rand4b = ZombRand(14, 34) * (modNumB)

        rand5 = ZombRand(14, 34) * (modNum)
        rand5b = ZombRand(14, 34) * (modNumB)


    end




    

    if player:isOutside() and pz == 0 then

        table.insert(tab1, {x=(px+math.ceil(rand1/2)),y=(py+math.ceil(rand1/2)),z=(pz)})
        table.insert(tab1, {x=(px-math.ceil(rand1b/2)),y=(py+math.ceil(rand1b/2)),z=(pz)})

        table.insert(tab1, {x=(px+math.ceil(rand2/2)),y=(py+0),z=(pz)})
        table.insert(tab1, {x=(px-math.ceil(rand2b/2)),y=(py+0),z=(pz)})
        
    end


    
    table.insert(tab1, {x=(px+rand1),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand1b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand2),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py+rand2b),z=(pz)})

    table.insert(tab1, {x=(px+rand3),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand3b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand4),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py-rand4b),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand5),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py-rand5b),z=(pz)})



    if ZombRand(1, 100) > 50 then
        
        for i = 1, (#tab1) do
            if getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1) ~= nil then
                if getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getBuilding() ~= nil then
                    if getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom() ~= nil then
                        if BWORooms.GetRoomMaxPop(getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom()) < math.ceil((BWORooms.GetRoomCurrPop(getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom())) / 3) and BWORooms.GetRoomMaxPop(getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom()) > 0 then

                            if ZombRand(1, 100) > 70 then

                                tab1[i].z = tab1[i].z + 1

                            end
                            
                            -- BWORooms.GetRoomMaxPop(room)

                            -- BWORooms.GetRoomCurrPop
                            -- 
                        end
                    end
                end
            end
        end


    end


    local square
    local building

    local event = {}

    local bx, by, bz

    local walkX, walkY, walkZ


    local numHutsFound = 0


    --     BWOPopControl.InhabitantsNominal = 2
    -- BWOPopControl.StreetsNominal = 0
    -- BWOPopControl.SurvivorsNominal = 3


    local footstepMatHere = nil


    if quickCountNearbyZeds_R69 < maxZeds_R69 then

        for i = 1, (#tab1) do

            bx = tab1[i].x; by = tab1[i].y; bz = tab1[i].z

            square = getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z);

            -- square:getBuilding()

            -- room:getName()

            -- getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z)
            if square ~= nil then

                -- and 

                footstepMatHere = tostring(getCell():getGridSquare(bx, by, bz):getObjects():get(0):getSprite():getProperties():Val("FootstepMaterial"))

                if square:getBuilding() then
                    
                else

                    if tostring(footstepMatHere) == "Gravel" or tostring(footstepMatHere) == "Sand" or tostring(footstepMatHere) == "Concrete" or tostring(footstepMatHere) == "Ceramic" or tostring(footstepMatHere) == "Grass" then

                        if getCell():getGridSquare(bx, by, bz):isOutside() == true then
                            walkX = bx; walkY = by; walkZ = bz
                        end

                    end

                end
    
                if square:getBuilding() then

                    numHutsFound = numHutsFound + 1

                    -- pl:Say("Debug:  THIS spot can spawn zombos!")

                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                        -- pl:Say("Debug:  THIS spot can spawn zombos... AND is not immersion breaking visually to pop in there!")
                        
                        building = square:getBuilding()
                        break
                    end

                end
            end
        end

        if numHutsFound <= 1 then
            walkX = nil; walkY = nil; walkZ = nil
        end

        local buildingDef; local keyId; 

        local spawnRoom


        -- spawnSquare:getZ()

        local boolRandomOrSideStreet = false

        local chanceOfSpawningSideStreet = 100


        if walkX == nil then

            chanceOfSpawningSideStreet = 0
            
        else
            -- tostring(footstepMatHere) == 

            if tostring(footstepMatHere) == "Gravel" or tostring(footstepMatHere) == "Concrete" or tostring(footstepMatHere) == "Ceramic" and player:isOutside() and walkZ == 0 then
                chanceOfSpawningSideStreet = 100

            else
                if tostring(footstepMatHere) == "nil" and player:isOutside() and walkZ == 0 then

                    chanceOfSpawningSideStreet = 80

                else

                    chanceOfSpawningSideStreet = 50

                end
            end

        end

        local notSideStreetChance = 1

        if ZombRand(1, 1000) > 750 then
            notSideStreetChance = notSideStreetChance + ZombRand(1, 70)
        end



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

                    local comboStr1 = tostring(keyId) .. tostring(roomName)


                    if 1 + 1 == 2 then

                        -- pl:Say("Debug:  debug: preparing to spawn...")

                        local spawnRoomDef = spawnRoom:getRoomDef()

                        if spawnRoomDef then

                            local spawnSquare = spawnRoomDef:getFreeSquare()

                            -- pl:Say("Debug:  debug: preparing to spawn... pt 2")
                            
                            if spawnSquare and not spawnSquare:getZombie() then

                                -- pl:Say("Debug:  debug: preparing to spawn... pt 3")

                                local chanceOfOutside = 70

                                -- if getGameTime():getDay() < 15

                                if BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal < 15 then
                                    chanceOfOutside = 80
                                end

                                if 1 + 1 == 2 then

                                -- notSideStreetChance

                                -- chanceOfSpawningSideStreet


                                    local keyId2

                                    if notSideStreetChance > chanceOfSpawningSideStreet or walkX == nil then

                                        dist = BanditUtils.DistTo(spawnSquare:getX(), spawnSquare:getY(), spawnSquare:getZ())

                                        dist = dist + ( (math.abs(pz - spawnSquare:getZ())) * 10)
   
                                        if dist > 21 then

                                            -- building = player:getBuilding() 
                                            
                                            dripSpawnZs4Huts(spawnSquare:getX(), spawnSquare:getY(), spawnSquare:getZ(), tick_in, footstepMatHere)


                                        else

                                            if tostring(LosUtil.lineClear(getCell(), px, py, pz, spawnSquare:getX(), spawnSquare:getY(), spawnSquare:getZ(), false)) ~= "Clear" and dist > 15 then

                                                dripSpawnZs4Huts(spawnSquare:getX(), spawnSquare:getY(), spawnSquare:getZ(), tick_in, footstepMatHere)

                                            end

                                        end

                                        local keyId2 = nil
                                        if player:getBuilding() then

                                            building = room:getBuilding()
                                            buildingDef = building:getDef()

                                            keyId = buildingDef:getKeyId()

                                        end


                                    else




                                        dist = BanditUtils.DistTo(walkX, walkY, walkZ)
    
                                        dist = dist + ( (math.abs(pz - walkZ)) * 10)
                                        
                                        if dist > 21 then

                                            -- building = player:getBuilding() 
                                            
                                            dripSpawnZs4Huts(walkX, walkY, walkZ, tick_in, footstepMatHere)


                                        else

                                            if tostring(LosUtil.lineClear(getCell(), px, py, pz, walkX, walkY, walkZ, false)) ~= "Clear" and dist > 15 then
                                                dripSpawnZs4Huts(walkX, walkY, walkZ, tick_in, footstepMatHere)
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
    end






    -------------------------------------------------------- ❓❓❓❓❓❓❓❓❓❓




end





local function slapDashSpawner()


    local player = getPlayer(0)

    local vipsHere = ModData.getOrCreate("vipsHere")


    
    local player = getPlayer(0)
    local pl = getPlayer(0)

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local homeCoords = BWOBuildings.GetEventBuildingCoords("home")
    local dist = BanditUtils.DistTo(px, py, homeCoords.x, homeCoords.y)

    if dist < 15 then
        do return end
    end

    if dist < 20 and player:isOutside() == false then
        do return end
    end

    if getGameTime():getDay() == 8 and getGameTime():getHour() < 9 then

        if dist < 30 and player:isOutside() == false then

            do return end

        else
            if getGameTime():getMinutes() < 15 then
                do return end
            end
        end

    end




    for k, v in pairs(vipsHere) do
        -- hutsCsv[k] = nil
        -- -- print("Key:", k, "Value of v.occupantsMax: ", v.occupantsMax)
        -- print("Key:", k, "Value of v.fullname: ", v.fullname)

    end


    local hutsCsv = ModData.getOrCreate("hutsCsv")


    local tx, ty;
    local bx, by

    local x1, y1
    local x2, y2

    local totNpcsInRegion = 0

    for k, v in pairs(hutsCsv) do
        if v.npcsLeft > 0 then
            keyId = k

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

            local avgVar1 = math.ceil(((x2 - x1) + (y2 - y1)) / 2)
            
            if px > x1 and px < x2 and py > y1 and py < y2 then
                -- maxNpcs_R69 = maxNpcs_R69 + addNum
                totNpcsInRegion = totNpcsInRegion + v.npcsLeft
            else
                if BanditUtils.DistTo(px, py, x1, y1) < 100 or BanditUtils.DistTo(px, py, x2, y2) < 100 or BanditUtils.DistTo(px, py, (x2 + x1)/2, (y2 + y1)/2) < 100 then
                    -- maxNpcs_R69 = maxNpcs_R69 + addNum
                    totNpcsInRegion = totNpcsInRegion + v.npcsLeft

                end
            end

        end
    end


    if quickCountNearbyNpcs_R69 >= totNpcsInRegion then
        
        do return end

        -- pl:Say("totNpcsInRegion is " .. tostring(totNpcsInRegion))
        
    end



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




    local rand3 = ZombRand(14, 21) * (modNum)
    local rand3b = ZombRand(14, 21) * (modNumB)

    local rand4 = ZombRand(17, 25) * (modNum)
    local rand4b = ZombRand(17, 25) * (modNumB)



    local rand1 = ZombRand(5, 12) * (modNum)
    local rand1b = ZombRand(5, 12) * (modNumB)

    local rand2 = ZombRand(7, 14) * (modNum)
    local rand2b = ZombRand(7, 14) * (modNumB)



    if pz == 0 then
        
        rand1 = ZombRand(12, 17) * (modNum)
        rand1b = ZombRand(12, 17) * (modNumB)

        rand2 = ZombRand(14, 19) * (modNum)
        rand2b = ZombRand(14, 19) * (modNumB)
        
    end



    local rand5 = ZombRand(21, 27) * (modNum)
    local rand5b = ZombRand(21, 27) * (modNumB)


    if npcsCloserThan20dist_R69 >= 10 then

        rand1 = ZombRand(12, 25) * (modNum)
        rand1b = ZombRand(15, 25) * (modNumB)

        rand2 = ZombRand(17, 25) * (modNum)
        rand2b = ZombRand(18, 25) * (modNumB)

    end

    if player:isOutside() and pz == 0 then

        table.insert(tab1, {x=(px+math.ceil(rand1/2)),y=(py+math.ceil(rand1/2)),z=(pz)})
        table.insert(tab1, {x=(px-math.ceil(rand1b/2)),y=(py+math.ceil(rand1b/2)),z=(pz)})

        table.insert(tab1, {x=(px+math.ceil(rand2/2)),y=(py+0),z=(pz)})
        table.insert(tab1, {x=(px-math.ceil(rand2b/2)),y=(py+0),z=(pz)})
        
    end


    
    table.insert(tab1, {x=(px+rand1),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand1b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand2),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py+rand2b),z=(pz)})

    table.insert(tab1, {x=(px+rand3),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand3b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand4),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py-rand4b),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand5),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py-rand5b),z=(pz)})



    if ZombRand(1, 100) > 50 then
        
        for i = 1, (#tab1) do
            if getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1) ~= nil then
                if getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getBuilding() ~= nil then
                    if getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom() ~= nil then
                        if BWORooms.GetRoomMaxPop(getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom()) < math.ceil((BWORooms.GetRoomCurrPop(getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom())) / 3) and BWORooms.GetRoomMaxPop(getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z + 1):getRoom()) > 0 then

                            if ZombRand(1, 100) > 70 then

                                tab1[i].z = tab1[i].z + 1

                            end
                            
                            -- BWORooms.GetRoomMaxPop(room)

                            -- BWORooms.GetRoomCurrPop
                            -- 
                        end
                    end
                end
            end
        end


    end


    local square
    local building

    local event = {}

    local bx, by, bz

    local walkX, walkY, walkZ

    -- maxNpcs_R69 = BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal + BWOPopControl.SurvivorsNominal

    -- if maxNpcs_R69 > math.ceil(100 * ((SandboxVars.BanditsWeekOne.StreetsPopMultiplier + SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier) / 2)) then
    --     maxNpcs_R69 = math.ceil(100 * ((SandboxVars.BanditsWeekOne.StreetsPopMultiplier + SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier) / 2))
    -- end

    local numHutsFound = 0


    --     BWOPopControl.InhabitantsNominal = 2
    -- BWOPopControl.StreetsNominal = 0
    -- BWOPopControl.SurvivorsNominal = 3



    if BWOScheduler.WorldAge <= 132 then
        maxNpcs_R69 = maxNpcs_R69 - 15
    else
        if BWOScheduler.WorldAge > 132 then

            -- maxNpcs_R69 = 0

            maxNpcs_R69 = maxNpcs_R69 - (BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal + BWOPopControl.SurvivorsNominal)

        end

    end

    -- if maxNpcs_R69


    if quickCountNearbyNpcs_R69 < maxNpcs_R69 and npcsCloserThan20dist_R69 < 16 then

        for i = 1, (#tab1) do

            bx = tab1[i].x; by = tab1[i].y; bz = tab1[i].z

            square = getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z);

            -- square:getBuilding()

            -- room:getName()

            -- getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z)
            if square ~= nil then

                -- and 

                local footstepMatHere = tostring(getCell():getGridSquare(bx, by, bz):getObjects():get(0):getSprite():getProperties():Val("FootstepMaterial"))

                if square:getBuilding() then
                    
                else

                    if footstepMatHere == "Gravel" or footstepMatHere == "Sand" or footstepMatHere == "Concrete" or footstepMatHere == "Ceramic" or footstepMatHere == "Grass" then

                        if getCell():getGridSquare(bx, by, bz):isOutside() == true then
                            walkX = bx; walkY = by; walkZ = bz
                        end




                        -- isOutside()
                    end

                end
        
                if square:getBuilding() then

                    numHutsFound = numHutsFound + 1

                    -- pl:Say("Debug:  THIS spot can spawn NPCs!")

                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                        -- pl:Say("Debug:  THIS spot can spawn NPCs... AND is not immersion breaking visually to pop in there!")
                        
                        building = square:getBuilding()
                        break
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

                        -- pl:Say("Debug:  debug: preparing to spawn...")

                        local spawnRoomDef = spawnRoom:getRoomDef()

                        if spawnRoomDef then

                            local spawnSquare = spawnRoomDef:getFreeSquare()

                            -- pl:Say("Debug:  debug: preparing to spawn... pt 2")
                            
                            if spawnSquare and not spawnSquare:getZombie() and not spawnSquare:isOutside() and spawnSquare:isFree(false) and BanditCompatibility.HaveRoofFull(spawnSquare) and not BWOSquareLoader.IsInExclusion(spawnSquare:getX(), spawnSquare:getY()) then

                                -- pl:Say("Debug:  debug: preparing to spawn... pt 3")

                                local chanceOfOutside = 70

                                -- if getGameTime():getDay() < 15

                                if BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal < 15 then
                                    chanceOfOutside = 80
                                end

                                if ZombRand(1, 100) < chanceOfOutside and walkX ~= nil then

                                    -- pl:Say("Debug: spawning OUTSIDE INSTEAD!")
    
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

                                    -- pl:Say("Debug:  debug: preparing to spawn... pt 4")

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

                                        -- pl:Say("Debug:  debug: preparing to spawn... pt 5 ...ok?")

                                        table.insert(event.bandits, bandit)

                                        -- pl:Say("Debug:  debug: preparing to spawn... pt 5b")


                                        sendClientCommand(player, 'Commands', 'SpawnGroup', event)

                                        -- pl:Say("Debug:  debug:paring to spawn... pt 5c")


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



    local rand3 = ZombRand(14, 21) * (modNum)
    local rand3b = ZombRand(14, 21) * (modNumB)

    local rand4 = ZombRand(17, 25) * (modNum)
    local rand4b = ZombRand(17, 25) * (modNumB)

    local rand1 = ZombRand(5, 12) * (modNum)
    local rand1b = ZombRand(5, 12) * (modNumB)

    local rand2 = ZombRand(7, 14) * (modNum)
    local rand2b = ZombRand(7, 14) * (modNumB)


    if pz == 0 then
        
        rand1 = ZombRand(12, 17) * (modNum)
        rand1b = ZombRand(12, 17) * (modNumB)

        rand2 = ZombRand(14, 19) * (modNum)
        rand2b = ZombRand(14, 19) * (modNumB)
        
    end


    local rand5 = ZombRand(21, 27) * (modNum)
    local rand5b = ZombRand(21, 27) * (modNumB)


    if npcsCloserThan20dist_R69 >= 10 then

        rand1 = ZombRand(12, 25) * (modNum)
        rand1b = ZombRand(15, 25) * (modNumB)

        rand2 = ZombRand(17, 25) * (modNum)
        rand2b = ZombRand(18, 25) * (modNumB)

    end

    
    if player:isOutside() and pz == 0 then

        table.insert(tab1, {x=(px+math.ceil(rand1/2)),y=(py+math.ceil(rand1/2)),z=(pz)})
        table.insert(tab1, {x=(px-math.ceil(rand1b/2)),y=(py+math.ceil(rand1b/2)),z=(pz)})

        table.insert(tab1, {x=(px+math.ceil(rand2/2)),y=(py+0),z=(pz)})
        table.insert(tab1, {x=(px-math.ceil(rand2b/2)),y=(py+0),z=(pz)})
        
    end


    table.insert(tab1, {x=(px+rand1),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand1b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand2),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py+rand2b),z=(pz)})

    table.insert(tab1, {x=(px+rand3),y=(py+0),z=(pz)})
    table.insert(tab1, {x=(px-rand3b),y=(py+0),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand4),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py-rand4b),z=(pz)})

    table.insert(tab1, {x=(px+0),y=(py+rand5),z=(pz)})
    table.insert(tab1, {x=(px+0),y=(py-rand5b),z=(pz)})

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

    local footstepMatHere = "bullshit"

    if quickCountNearbyNpcs_R69 < maxNpcs_R69 then

        for i = 1, (#tab1) do

            bx = tab1[i].x; by = tab1[i].y; bz = tab1[i].z

            square = getCell():getGridSquare(tab1[i].x, tab1[i].y, tab1[i].z);

            if square ~= nil then

                -- and 

                if getCell():getGridSquare(bx, by, bz):getObjects():get(0) ~= nil then
    
                    footstepMatHere = tostring(getCell():getGridSquare(bx, by, bz):getObjects():get(0):getSprite():getProperties():Val("FootstepMaterial"))
                end
                

                if square:getBuilding() then
                    
                else

                    if footstepMatHere == "Gravel" or footstepMatHere == "Sand" or footstepMatHere == "Concrete" or footstepMatHere == "Ceramic" or footstepMatHere == "Grass" then

                        if getCell():getGridSquare(bx, by, bz):isOutside() == true then
                            walkX = bx; walkY = by; walkZ = bz
                        end

                    end

                end
        
                if square:getBuilding() then

                    numHutsFound = numHutsFound + 1

                    -- pl:Say("Debug:  THIS spot can spawn NPCs!")

                    if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                        -- pl:Say("Debug:  THIS spot can spawn NPCs... AND is not immersion breaking visually to pop in there!")
                        
                        building = square:getBuilding()
                        break
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

        -- walkX

        local boolWalkerChance = 0

        if getGameTime():getDay() < 13 then
            boolWalkerChance = 10
        else
            if getGameTime():getDay() == 13 then
                boolWalkerChance = 70
            else
                if getGameTime():getDay() == 14 then
                    boolWalkerChance = 90
                else
                    if getGameTime():getDay() > 14 then
                        boolWalkerChance = 100
                    end

                end

            end

        end


        if boolWalkerChance >= 100 and walkX == nil then
            do return end
        end

        if ZombRand(1, 25) + ZombRand(1, 25) + ZombRand(1, 30) > boolWalkerChance then

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

                            -- pl:Say("Debug:  debug: preparing to spawn...")

                            local spawnRoomDef = spawnRoom:getRoomDef()

                            if spawnRoomDef then

                                local spawnSquare = spawnRoomDef:getFreeSquare()

                                -- pl:Say("Debug:  debug: preparing to spawn... pt 2")
                                
                                if spawnSquare and not spawnSquare:getZombie() and not spawnSquare:isOutside() and spawnSquare:isFree(false) and BanditCompatibility.HaveRoofFull(spawnSquare) and not BWOSquareLoader.IsInExclusion(spawnSquare:getX(), spawnSquare:getY()) then

                                    -- pl:Say("Debug:  debug: preparing to spawn... pt 3")

                                    local chanceOfOutside = 70

                                    -- if getGameTime():getDay() < 15

                                    if BWOPopControl.InhabitantsNominal + BWOPopControl.StreetsNominal < 15 then
                                        chanceOfOutside = 80
                                    end

                                    if ZombRand(1, 100) < chanceOfOutside and walkX ~= nil then

                                        -- pl:Say("Debug: spawning OUTSIDE INSTEAD!")
        
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

                                        -- pl:Say("Debug:  debug: preparing to spawn... pt 4")

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

                                            -- pl:Say("Debug:  debug: preparing to spawn... pt 5 ...ok?")

                                            table.insert(event.bandits, bandit)

                                            -- pl:Say("Debug:  debug: preparing to spawn... pt 5b")


                                            sendClientCommand(player, 'Commands', 'SpawnGroup', event)

                                            -- pl:Say("Debug:  debug:paring to spawn... pt 5c")


                                            -- break
                                        end
                                    end
                                end
                            end

                        end


                    end
                end
            end

        
        
        else
            -- if ZombRand(1,)
            simpWalkerSpawner(walkX, walkY, walkZ)
        end
    


    end




end




local onTickZZB = function(numTicksInZZB)

    local player = getPlayer(0)

    if not player then
        do return end
    end

    if numTicksInZZB % 2 == 0 or numTicksInZZB % 2 ~= 0 then
        allButSpawn()

        npcChecker()
    end

    if numTicksInZZB % 360 == 0 then


        if numTicksInZZB % 7200 == 0 then
            fixSpawnedToMatch("SHOW IF WORTH SHOWING")
        else
            fixSpawnedToMatch("MOSTLY WONT SHOW")
        end


    end

    -- 

    if numTicksInZZB % 177 == 0 then
        npcHandler()
    end

    if numTicksInZZB % 12 == 0 then
        fixNakedNpcs()
    end
    -- 


    if numTicksInZZB % 30 == 0 then
        -- dripSpawnZs4Huts()
        preDripper(tonumber(numTicksInZZB))
    end

    -- dripSpawnZs4Huts


    -- if  10, it's 2 therefore,  120 
    local slapNum = math.floor(quickCountNearbyNpcs_R69 / 5)

    slapNum = (slapNum * 90)

    if slapNum == 0 then
        slapNum = 77
    end

    --    npcs|ticks
        -- 5	90
        -- 10	180
        -- 15	270
        -- 20	360


    local dist = 99

    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Walker", "Entertainer", "Survivor", "Runner", "Inhabitant", "Active", "Babe"})

    local brain; local bandit; local npc_id
    local dist = 99

    local px = player:getX()
    local py = player:getY()
    local pz = math.floor(player:getZ())

    local bx, by, bz

    if not result.id then
    else
        npc_id = result.id
        bandit = BanditZombie.GetInstanceById(npc_id)
        brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))

        bx = BanditZombie.GetInstanceById(npc_id):getX();
        by = BanditZombie.GetInstanceById(npc_id):getY();
        bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());


        dist = BanditUtils.DistTo(px, py, bx, by)

    end


    if quickCountNearbyNpcs_R69 >= 10 then

        if dist > 20 or bz ~= pz then
        end
    end

    if slapNum > 50 then
        slapNum = 50
    end




    if maxNpcs_R69 > quickCountNearbyNpcs_R69 + 25 then
        slapNum = 18
    end
    
    if numTicksInZZB % slapNum == 0 then
        slapDashSpawner()
    end

    if numTicksInZZB % 9500 == 0 then
        pauseThenGlobalSave12()
    end



    local task

    local npcNearbyNodding = false
    
    result = BanditUtils.GetClosestBanditLocationProgram(player, {"Inhabitant", "Walker"})



    if not result.id then
    else
        npc_id = result.id
        bandit = BanditZombie.GetInstanceById(npc_id)
        brain = BanditBrain.Get(BanditZombie.GetInstanceById(npc_id))


        if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then
            task = Bandit.GetTask(bandit)

            
            if task ~= nil then
                for k, v in pairs(task) do
                    -- -- print(tostring(k) .. ": " .. tostring(v))
                end
            end




            bx = BanditZombie.GetInstanceById(npc_id):getX();
            by = BanditZombie.GetInstanceById(npc_id):getY();
            bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());


            dist = BanditUtils.DistTo(px, py, bx, by)




            task = Bandit.GetTask(bandit)

            if tostring(task["anim"]) == "Yes" or tostring(task["anim"]) == "Clap" then

                if dist < 8 and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) == "Clear" then
                    npcNearbyNodding = true
                end
            end

        end
        



    end



    if numTicksInZZB % 350 == 0 then

        if npcNearbyNodding == true then
            fixMusicManClusterFuck()
        end
        
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
        fixSpawnedToMatch("ALWAYS SHOW")
    end



    if key == getCore():getKey("PLACEHOLDER_Keyboard_KEY_ESCAPE") then
    end

    -- 
end

Events.OnKeyPressed.Add(onPress)




