local game = remodel.readPlaceFile("assetplace.rbxlx")

remodel.createDirAll("src/assets/ServerStorage")
remodel.createDirAll("src/assets/StarterGui")

local lobby = game.Workspace.Lobby

local Assets = game.ServerStorage.Assets
local GUIs = game.StarterGui

for _, asset in ipairs(Assets:GetChildren()) do
    remodel.writeModelFile ("src/assets/ServerStorage/" .. asset.Name .. ".rbxm", asset)
end

for _, ui in ipairs(GUIs:GetChildren()) do
    remodel.writeModelFile ("src/assets/StarterGui/" .. ui.Name .. ".rbxmx", ui)
end

remodel.writeModelFile("src/assets/Workspace/" .. lobby.Name .. ".rbxm", lobby)