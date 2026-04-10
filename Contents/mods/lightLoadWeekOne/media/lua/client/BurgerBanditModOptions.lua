-- BurgerBanditModOptions.lua
-- These are the default options.
local OPTIONS = {}

local key_gata_PLACEHOLDER_Keyboard_KEY_ESCAPE = { key = Keyboard.KEY_ESCAPE, name = "PLACEHOLDER_Keyboard_KEY_ESCAPE",}
local key_gata_PLACEHOLDER_Keyboard_KEY_8 = { key = Keyboard.KEY_8, name = "PLACEHOLDER_Keyboard_KEY_8",}
local key_gata_PLACEHOLDER_Keyboard_KEY_9 = { key = Keyboard.KEY_9, name = "PLACEHOLDER_Keyboard_KEY_9",}
local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD8 = { key = Keyboard.KEY_NUMPAD8, name = "PLACEHOLDER_Keyboard_KEY_NUMPAD8",}
local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD9 = { key = Keyboard.KEY_NUMPAD9, name = "PLACEHOLDER_Keyboard_KEY_NUMPAD9",}


-- Connecting the options to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then

    ModOptions:getInstance(OPTIONS, "LighterLoad", "LighterLoad")

    local category = "[LighterLoad]"

    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_8)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_9)
    
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD8)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD9)

    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_ESCAPE)

end

local function InitModOptions()
end

-- Check actual options at game loading.
Events.OnGameStart.Add(InitModOptions)
  

