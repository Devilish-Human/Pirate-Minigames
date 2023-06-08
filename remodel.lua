local game = remodel.readPlaceFile("assetplace.rbxlx")

remodel.createDirAll("src/assets/ServerStorage")

local lobby = game.Workspace.Lobby

local Assets = game.ServerStorage.Assets


for _, asset in ipairs(Assets:GetChildren()) do
    remodel.writeModelFile ("src/assets/ServerStorage/" .. asset.Name .. ".rbxm", asset)
end

remodel.writeModelFile("src/assets/Workspace/" .. lobby.Name .. ".rbxm", lobby)