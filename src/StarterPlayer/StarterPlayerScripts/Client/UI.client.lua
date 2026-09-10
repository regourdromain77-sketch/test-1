local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PetHatched = ReplicatedStorage.Remotes.PetHatched

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Name = "CoinsLabel"
coinsLabel.AnchorPoint = Vector2.new(1, 0)
coinsLabel.Position = UDim2.new(1, -16, 0, 16)
coinsLabel.Size = UDim2.new(0, 200, 0, 36)
coinsLabel.BackgroundTransparency = 0.3
coinsLabel.BackgroundColor3 = Color3.new(0, 0, 0)
coinsLabel.TextColor3 = Color3.new(1, 1, 1)
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.TextSize = 20
coinsLabel.Text = "Coins: 0"
coinsLabel.Parent = screenGui

local function bindCoinsLabel()
	local leaderstats = player:WaitForChild("leaderstats")
	local coins = leaderstats:WaitForChild("Coins")

	local function refresh()
		coinsLabel.Text = ("Coins: %d"):format(coins.Value)
	end

	coins:GetPropertyChangedSignal("Value"):Connect(refresh)
	refresh()
end

local function showHatchNotice(species)
	local notice = coinsLabel:Clone()
	notice.Name = "HatchNotice"
	notice.AnchorPoint = Vector2.new(0.5, 0)
	notice.Position = UDim2.new(0.5, 0, 0, 16)
	notice.BackgroundColor3 = Color3.new(0.1, 0.6, 0.1)
	notice.Text = ("Nouveau pet : %s (%s)"):format(species.displayName, species.rarity)
	notice.Parent = screenGui

	task.delay(2.5, function()
		notice:Destroy()
	end)
end

bindCoinsLabel()
PetHatched.OnClientEvent:Connect(showHatchNotice)
