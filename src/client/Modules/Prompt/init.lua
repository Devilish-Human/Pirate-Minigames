local Tween = game:GetService("TweenService")

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local PromptHandler  = {}

-- SERVICES --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- VARIABLES --
local PromptGui = script.PromptGui
local AcceptButton = script.AcceptButton
local DenyButton = script.DenyButton

local Player = Players.LocalPlayer

--[[
local SettingsTbl = {
	Title = "", -- This will be the title of our prompt
	Text = "", -- This will be the body of our prompt
	
	-- V These are optional V --
	
	AcceptButton = { -- This table will allow us to create an AcceptButton
		Text = "", -- This will be the Text of the AcceptButton
		Callback = function() -- This function will run when the player clicks the AcceptButton
			
		end,
	}, 
	DenyButton = { -- This table will allow us to create an DenyButton
		Text = "", -- This will be the Text of the DenyButton
		Callback = function() -- This function will run when the player clicks the DenyButton

		end,
	}, 
}
]]--


function PromptHandler:Create(settingsTbl)	
	assert(settingsTbl.Title, "Prompt Title not found") -- This will cause an error if the Title is not found 
	assert(settingsTbl.Text, "Prompt Text not found") -- This will cause an error if the Body is not found
	
	local Prompt = PromptGui:Clone() -- Clone our GUI so we can use it multiple times
	local PromptFrame = Prompt.PromptBody
	local ButtonHolder = PromptFrame.Buttons
	
	Tween:Create(PromptFrame, TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
	
	PromptFrame.Title.Text = settingsTbl.Title -- This will change the Text for the Title
	PromptFrame.Body.Text = settingsTbl.Text -- This will change the Text for the Body
	
	local AcceptSettings = settingsTbl.AcceptButton
	local DenySettings = settingsTbl.DenyButton
	
	local function CreateButton(BtnType, BtnText, Callback)
		local Button = BtnType:Clone()
		Button.Parent = ButtonHolder
		
		Button.Text = BtnText
		
		Button.MouseButton1Click:Connect(function()
			if Callback then
				Callback()
			end
			local a = Tween:Create(PromptFrame, TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			a:Play()
			a.Completed:Connect(function()
				Prompt:Destroy()
			end)
		end)
	end

	if AcceptSettings then
		assert(AcceptSettings.Text, "Text for AcceptButton not found")
		CreateButton(AcceptButton, AcceptSettings.Text, AcceptSettings.Callback)
	end

	if DenySettings then
		assert(DenySettings.Text, "Text for DenyButton not found")
		CreateButton(DenyButton, DenySettings.Text, DenySettings.Callback)
	end

	if not DenySettings then
		AcceptButton.Size = UDim2.new(1, 0, 1, 0)
	end

	if not AcceptSettings then
		DenyButton.Size = UDim2.new(1, 0, 1, 0)
	end

	Prompt.Parent = Player.PlayerGui
end

return PromptHandler