local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PetData = require(ReplicatedStorage.Modules.PetData)
local PlayerDataManager = require(script.Parent.PlayerDataManager)

local TICK_SECONDS = 1

local IncomeService = {}

function IncomeService.GetIncomePerSecond(player: Player): number
	local data = PlayerDataManager.Get(player)
	if not data then
		return 0
	end

	local income = 0
	for _, speciesId in data.Pets do
		local species = PetData.Species[speciesId]
		if species then
			income += species.baseValue
		end
	end

	return income
end

function IncomeService.Init()
	task.spawn(function()
		while true do
			task.wait(TICK_SECONDS)

			for _, player in Players:GetPlayers() do
				local income = IncomeService.GetIncomePerSecond(player)
				if income > 0 then
					PlayerDataManager.AddCoins(player, income)
				end
			end
		end
	end)
end

return IncomeService
