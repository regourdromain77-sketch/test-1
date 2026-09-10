local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PetHatched = ReplicatedStorage.Remotes.PetHatched
local GetInventory = ReplicatedStorage.Remotes.GetInventory

local RARITY_COLORS = {
	Common = Color3.fromRGB(190, 190, 190),
	Rare = Color3.fromRGB(90, 160, 255),
	Epic = Color3.fromRGB(190, 90, 255),
	Legendary = Color3.fromRGB(255, 190, 60),
}

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

local petsButton = Instance.new("TextButton")
petsButton.Name = "PetsButton"
petsButton.AnchorPoint = Vector2.new(1, 0)
petsButton.Position = UDim2.new(1, -16, 0, 60)
petsButton.Size = UDim2.new(0, 200, 0, 32)
petsButton.BackgroundTransparency = 0.3
petsButton.BackgroundColor3 = Color3.new(0, 0, 0)
petsButton.TextColor3 = Color3.new(1, 1, 1)
petsButton.Font = Enum.Font.GothamBold
petsButton.TextSize = 16
petsButton.Text = "Mes pets"
petsButton.Parent = screenGui

local inventoryFrame = Instance.new("Frame")
inventoryFrame.Name = "InventoryFrame"
inventoryFrame.AnchorPoint = Vector2.new(1, 0)
inventoryFrame.Position = UDim2.new(1, -16, 0, 100)
inventoryFrame.Size = UDim2.new(0, 260, 0, 320)
inventoryFrame.BackgroundTransparency = 0.15
inventoryFrame.BackgroundColor3 = Color3.new(0, 0, 0)
inventoryFrame.Visible = false
inventoryFrame.Parent = screenGui

local incomeLabel = Instance.new("TextLabel")
incomeLabel.Name = "IncomeLabel"
incomeLabel.Size = UDim2.new(1, -16, 0, 28)
incomeLabel.Position = UDim2.new(0, 8, 0, 8)
incomeLabel.BackgroundTransparency = 1
incomeLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
incomeLabel.Font = Enum.Font.GothamBold
incomeLabel.TextSize = 16
incomeLabel.TextXAlignment = Enum.TextXAlignment.Left
incomeLabel.Text = "Revenu : 0/s"
incomeLabel.Parent = inventoryFrame

local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "List"
listFrame.Position = UDim2.new(0, 8, 0, 40)
listFrame.Size = UDim2.new(1, -16, 1, -48)
listFrame.BackgroundTransparency = 1
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listFrame.ScrollBarThickness = 6
listFrame.Parent = inventoryFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = listFrame

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

local function refreshInventory()
	local ok, result = pcall(function()
		return GetInventory:InvokeServer()
	end)

	if not ok then
		warn("UI: failed to fetch inventory: " .. tostring(result))
		return
	end

	incomeLabel.Text = ("Revenu : %d/s"):format(result.incomePerSecond)

	for _, child in listFrame:GetChildren() do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	for i, entry in result.pets do
		local row = Instance.new("TextLabel")
		row.Name = entry.id
		row.LayoutOrder = i
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundTransparency = 1
		row.TextColor3 = RARITY_COLORS[entry.rarity] or Color3.new(1, 1, 1)
		row.Font = Enum.Font.Gotham
		row.TextSize = 14
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.Text = ("%s x%d"):format(entry.displayName, entry.count)
		row.Parent = listFrame
	end
end

petsButton.MouseButton1Click:Connect(function()
	inventoryFrame.Visible = not inventoryFrame.Visible
	if inventoryFrame.Visible then
		refreshInventory()
	end
end)

bindCoinsLabel()
PetHatched.OnClientEvent:Connect(function(species)
	showHatchNotice(species)
	if inventoryFrame.Visible then
		refreshInventory()
	end
end)
