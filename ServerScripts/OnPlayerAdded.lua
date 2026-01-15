local player = game:GetService("Players")
local phys = game:GetService("PhysicsService")	
	
player.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = 500
	cash.Parent = leaderstats
	
	local placedTowers = Instance.new("IntValue")
	placedTowers.Name = "PlacedTowers"
	placedTowers.Value = 0
	placedTowers.Parent = player
	
	player.CharacterAdded:Connect(function(character)
		for i, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CollisionGroup = "Player"
			end
		end
	end)

end)
