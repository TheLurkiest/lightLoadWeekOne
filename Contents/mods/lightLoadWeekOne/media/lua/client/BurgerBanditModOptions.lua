-- BurgerBanditModOptions.lua
-- These are the default options.
local OPTIONS = {}

-- <-------------------- put the ACTUAL lines in HERE, not at the end for local key_gata_PLACEHOLDER_Keyboard_getCore():getKey("PLACEHOLDER_Keyboard_KEY_B") = { key = Keyboard.getCore():getKey("PLACEHOLDER_Keyboard_KEY_B"), name = "PLACEHOLDER_Keyboard_getCore():getKey("PLACEHOLDER_Keyboard_KEY_B")",} ...........and the rest! FirstLines.lua goes here!

local key_gata_PLACEHOLDER_Keyboard_KEY_ESCAPE = { key = Keyboard.KEY_ESCAPE, name = "PLACEHOLDER_Keyboard_KEY_ESCAPE",}

-- Connecting the options to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then

    -- ModOptions:getInstance(OPTIONS, "Bandits", "Bandits")

    ModOptions:getInstance(OPTIONS, "LighterLoad", "LighterLoad")

    local category = "[LighterLoad]"

    -- <--------------- and put the rest of these in here!!! SecondLines.lua goes here!

    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_ESCAPE)

end

local function InitModOptions()
end

-- Check actual options at game loading.
Events.OnGameStart.Add(InitModOptions)
  

