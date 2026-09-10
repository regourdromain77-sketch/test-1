local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")

local DEFAULT_DATA = {
	Coins = 0,
	Pets = {}, -- array of species ids, e.g. { "Bronto", "Sphinx" }
}

local PlayerDataManager = {}
local sessionData: { [Player]: typeof(DEFAULT_DATA) } = {}

local function loadData(player: Player): typeof(DEFAULT_DATA)
	local key = "Player_" .. player.UserId
	local ok, result = pcall(function()
		return PlayerDataStore:GetAsync(key)
	end)

	if ok and result then
		return result
	end

	if not ok then
		warn(("PlayerDataManager: failed to load data for %s: %s"):format(player.Name, result))
	end

	return table.clone(DEFAULT_DATA)
end

local function saveData(player: Player)
	local data = sessionData[player]
	if not data then
		return
	end

	local key = "Player_" .. player.UserId
	local ok, err = pcall(function()
		PlayerDataStore:SetAsync(key, data)
	end)

	if not ok then
		warn(("PlayerDataManager: failed to save data for %s: %s"):format(player.Name, err))
	end
end

local function buildLeaderstats(player: Player, data: typeof(DEFAULT_DATA))
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = data.Coins
	coins.Parent = leaderstats

	leaderstats.Parent = player
end

function PlayerDataManager.Get(player: Player): typeof(DEFAULT_DATA)?
	return sessionData[player]
end

function PlayerDataManager.AddPet(player: Player, speciesId: string)
	local data = sessionData[player]
	if not data then
		return
	end

	table.insert(data.Pets, speciesId)
end

function PlayerDataManager.AddCoins(player: Player, amount: number)
	local data = sessionData[player]
	if not data then
		return
	end

	data.Coins += amount

	local leaderstats = player:FindFirstChild("leaderstats")
	local coinsValue = leaderstats and leaderstats:FindFirstChild("Coins")
	if coinsValue then
		coinsValue.Value = data.Coins
	end
end

function PlayerDataManager.Init()
	Players.PlayerAdded:Connect(function(player)
		local data = loadData(player)
		sessionData[player] = data
		buildLeaderstats(player, data)
	end)

	Players.PlayerRemoving:Connect(function(player)
		saveData(player)
		sessionData[player] = nil
	end)

	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			saveData(player)
		end
	end)
end

return PlayerDataManager
