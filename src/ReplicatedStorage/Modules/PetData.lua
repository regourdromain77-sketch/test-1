-- Species catalogue: rarity drives both drop weight and display order.
export type Rarity = "Common" | "Rare" | "Epic" | "Legendary"

export type PetSpecies = {
	id: string,
	displayName: string,
	rarity: Rarity,
	weight: number, -- higher = more common
	baseValue: number, -- coins/sec once owned
}

local PetData = {}

PetData.Species = {
	Bronto = {
		id = "Bronto",
		displayName = "Bronto",
		rarity = "Common",
		weight = 100,
		baseValue = 1,
	},
	RainbowBronto = {
		id = "RainbowBronto",
		displayName = "Bronto arc-en-ciel",
		rarity = "Rare",
		weight = 35,
		baseValue = 5,
	},
	Sphinx = {
		id = "Sphinx",
		displayName = "Sphinx royal",
		rarity = "Epic",
		weight = 10,
		baseValue = 20,
	},
	SilverAntelope = {
		id = "SilverAntelope",
		displayName = "Antilope argentée",
		rarity = "Legendary",
		weight = 2,
		baseValue = 60,
	},
} :: { [string]: PetSpecies }

function PetData.rollRandomSpecies(): PetSpecies
	local totalWeight = 0
	for _, species in PetData.Species do
		totalWeight += species.weight
	end

	local roll = math.random() * totalWeight
	local cumulative = 0
	for _, species in PetData.Species do
		cumulative += species.weight
		if roll <= cumulative then
			return species
		end
	end

	error("PetData.rollRandomSpecies: failed to roll a species (check weights)")
end

return PetData
