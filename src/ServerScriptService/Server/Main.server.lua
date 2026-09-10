local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataManager = require(script.Parent.PlayerDataManager)
local EggService = require(script.Parent.EggService)
local IncomeService = require(script.Parent.IncomeService)

PlayerDataManager.Init()
EggService.Init()
IncomeService.Init()

ReplicatedStorage.Remotes:WaitForChild("GetInventory").OnServerInvoke = function(player)
	return {
		pets = PlayerDataManager.GetInventorySummary(player),
		incomePerSecond = IncomeService.GetIncomePerSecond(player),
	}
end
