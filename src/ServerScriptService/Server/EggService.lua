local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local PetData = require(ReplicatedStorage.Modules.PetData)
local PlayerDataManager = require(script.Parent.PlayerDataManager)

local PetHatched = ReplicatedStorage.Remotes.PetHatched

local HATCH_COOLDOWN_SECONDS = 1
local lastHatchAt: { [Player]: number } = {}

local EggService = {}

-- Placeholder egg so the loop is testable immediately; swap this part for a
-- Sloyd-generated model in Studio once art is ready, keeping the same name
-- and ProximityPrompt so this script doesn't need to change.
local function spawnPlaceholderEgg()
	local part = Instance.new("Part")
	part.Name = "Egg"
	part.Anchored = true
	part.Size = Vector3.new(4, 4, 4)
	part.Position = Vector3.new(0, 2, 0)
	part.BrickColor = BrickColor.new("Bright yellow")
	part.Shape = Enum.PartType.Ball

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Hatch"
	prompt.ObjectText = "Egg"
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 10
	prompt.Parent = part

	part.Parent = Workspace

	prompt.Triggered:Connect(function(player)
		EggService.Hatch(player)
	end)
end

function EggService.Hatch(player: Player)
	local now = os.clock()
	if now - (lastHatchAt[player] or 0) < HATCH_COOLDOWN_SECONDS then
		return
	end
	lastHatchAt[player] = now

	if not PlayerDataManager.Get(player) then
		return
	end

	local species = PetData.rollRandomSpecies()
	PlayerDataManager.AddPet(player, species.id)

	PetHatched:FireClient(player, species)
end

function EggService.Init()
	spawnPlaceholderEgg()
end

return EggService
