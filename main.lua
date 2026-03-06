-- Blox Fruits Orca UI Hub - Keyless - Fix UI Black Issue
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orca/master/library.lua"))()

local Window = Orca:NewWindow("Blox Fruits Hub - Orca Edition", "Keyless 2026")

local FarmTab = Orca:NewTab("Farm")
FarmTab:NewToggle("Auto Farm Level", function(state)
    _G.AutoFarm = state
    -- Add farm loop here (copy from previous script)
end)

-- Add more toggles/buttons similarly for Quest, Boss, Fruit Sniper...
-- Fruit Sniper example
local FruitTab = Orca:NewTab("Fruit")
FruitTab:NewToggle("Fruit Sniper (TP + Notify)", function(state)
    _G.FruitSniper = state
    -- Your fruit loop here
end)

print("Orca UI Loaded - No black screen!")
