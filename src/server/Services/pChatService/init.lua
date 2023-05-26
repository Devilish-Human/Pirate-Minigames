local Knit = require(game:GetService("ReplicatedStorage").Knit)

local pChatService = Knit.CreateService {
    Name = "pChatService";
    Client = {};
}

local Players = game:GetService("Players")

local SSS = game:GetService("ServerScriptService")
local CSR = SSS:WaitForChild("ChatServiceRunner")
local RChatService = require(CSR:WaitForChild("ChatService"))

local ChatData = require(script.ChatTags)

local DataService

function pChatService:KnitStart()
    --[[ local Players = game:GetService("Players")

    local SSS = game:GetService ("ServerScriptService")
    local CSR = SSS:FindFirstChild ("ChatServiceRunner")
    local RChatService = require(CSR:WaitForChild ("ChatService"))

    local ChatData = require(script.ChatTags) ]]
    RChatService.SpeakerAdded:Connect(function(playerName)
        local speaker = RChatService:GetSpeaker (playerName)
        local player = game:GetService("Players"):FindFirstChild(playerName)
    
        if (ChatData.GroupTags[player:GetRankInGroup(1043574)]) then
            speaker:SetExtraData("Tags", {ChatData.GroupTags[player:GetRankInGroup(1043574)]})
            speaker:SetExtraData("ChatColor", ChatData.GroupColors[player:GetRankInGroup(1043574)])
        elseif (ChatData.UserTags[player.UserId]) then
            speaker:SetExtraData("Tags", {ChatData.UserTags[player.UserId]})
            speaker:SetExtraData("ChatColor", ChatData.UserColor[player.UserId])
        end
    end)
end

function pChatService:GetRXChat ()
    return RChatService
end

function pChatService:KnitInit()
    DataService = Knit.Services.DataService
end


return pChatService