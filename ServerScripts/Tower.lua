local serverStorage = game:GetService("ServerStorage")
local phys = game:GetService("PhysicsService")
local RepStorage = game:GetService("ReplicatedStorage")

local events =  RepStorage:WaitForChild("Events")
local functions =  RepStorage:WaitForChild("Functions")
local requestTower = functions:WaitForChild("RequestTower")
local spawnTowerEvent = events:WaitForChild("SpawnTower")

local tower = {}
local maxTowers = 15

local function findNearestEnemy(newTower, range)
	local nearestTarget = nil

	for i, target in ipairs(workspace.MapEnemies:GetChildren()) do
		local targetPos = target:WaitForChild("HumanoidRootPart")
		local distance = (targetPos.Position - newTower.HumanoidRootPart.Position).Magnitude
		--print (target.Name, distance)

		if distance < range then
			--print(target.Name, "is the nearest enemy")
			nearestTarget = target
			range = distance
		end
	end
	return nearestTarget
end

function tower.Attack(newTower, player)
	local config = newTower.Configuration
	local target = findNearestEnemy(newTower, config.AttackRange.Value)
	if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
		local targetCFrame = CFrame.lookAt(newTower.HumanoidRootPart.Position, target.HumanoidRootPart.Position)
		newTower.HumanoidRootPart.BodyGyro.CFrame = targetCFrame
		target.Humanoid:TakeDamage(config.AttackDamage.Value)
		
		if target.Humanoid.Health <= 0 then
			player.leaderstats.Cash.Value += target.Humanoid.MaxHealth / 2
		end
		task.wait(config.FireRate.Value)
	end
	
	task.wait(0.1)
	tower.Attack(newTower, player)
end


function tower.Spawn(player, name, cframe)
	local allowedToSpawn = tower.CheckSpawn(player, name)
	
	if allowedToSpawn then
		local newTower = RepStorage.Towers[name]:Clone()
		newTower.Parent = workspace.Towers
		newTower.HumanoidRootPart.CFrame = cframe
		newTower.HumanoidRootPart:SetNetworkOwner(nil)
		
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.D = 0
		bodyGyro.CFrame = newTower.HumanoidRootPart.CFrame
		bodyGyro.Parent = newTower.HumanoidRootPart

		for i, object in ipairs(newTower:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CollisionGroup = "Towers"
			end
		end
		
		player.leaderstats.Cash.Value -= newTower.Configuration.Price.Value
		player.PlacedTowers.Value += 1
			
		coroutine.wrap(tower.Attack)(newTower, player)
		
	else
		warn("Requested Tower does not exist")
	end
end

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

function tower.CheckSpawn(player, name)
	local towerExists = RepStorage.Towers:FindFirstChild(name)

	if towerExists then
		if towerExists.Configuration.Price.Value <= player.leaderstats.Cash.Value then
			if player.PlacedTowers.Value < maxTowers then
				return true
			else
				warn("Cannot place more than " .. maxTowers .. " towers!")
			end
		else
			warn("Not enough cash to place this tower!")
		end
	else
		warn("Requested Tower does not exist")
	end
	
end

requestTower.OnServerInvoke = tower.CheckSpawn

return tower
