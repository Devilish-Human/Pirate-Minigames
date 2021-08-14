local Players = game:GetService("Players")

local SSS = script.Parent.Parent
local CSR = SSS:WaitForChild("ChatServiceRunner")
local ChatService = require(CSR:WaitForChild("ChatService"))

local ChatData = require(script.ChatData)


ChatService.SpeakerAdded:Connect(function(playerName)
    local speaker = ChatService:GetSpeaker (playerName)
    local player = game:GetService("Players"):FindFirstChild(playerName)

    if (ChatData.GroupTags[player:GetRankInGroup(1043574)]) then
        speaker:SetExtraData("Tags", {ChatData.GroupTags[player:GetRankInGroup(1043574)]})
        speaker:SetExtraData("ChatColor", ChatData.GroupColors[player:GetRankInGroup(1043574)])
    else
        speaker:SetExtraData("Tags", {ChatData.UserTags[player.UserId]})
        speaker:SetExtraData("ChatColor", ChatData.UserColor[player.UserId])
    end
end)