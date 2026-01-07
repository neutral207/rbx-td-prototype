local serverStorage = game:GetService("ServerStorage")
local phys = game:GetService("PhysicsService")
local RepStorage = game:GetService("ReplicatedStorage")
local events =  RepStorage:WaitForChild("Events")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local tower = {}

local function findNearestEnemy(newTower)
	local maxDistance = 75
	local nearestTarget = nil

	for i, target in ipairs(workspace.MapEnemies:GetChildren()) do
		local targetPos = target:WaitForChild("HumanoidRootPart")
		local distance = (targetPos.Position - newTower.HumanoidRootPart.Position).Magnitude
		--print (target.Name, distance)

		if distance < maxDistance then
			--print(target.Name, "is the nearest enemy")
			nearestTarget = target
			maxDistance = distance
		end
	end
	return nearestTarget
end

function tower.Attack(newTower)
	local target = findNearestEnemy(newTower)
	if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
		local targetCFrame = CFrame.lookAt(newTower.HumanoidRootPart.Position, target.HumanoidRootPart.Position)
		newTower.HumanoidRootPart.BodyGyro.CFrame = targetCFrame
		target.Humanoid:TakeDamage(25)
	end

	task.wait(1)
	tower.Attack(newTower)
end


function tower.Spawn(player, name, cframe)
	local towerExists = RepStorage.Towers:FindFirstChild(name)
	
	if towerExists then
		local newTower = towerExists:Clone()
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
			
		coroutine.wrap(tower.Attack)(newTower)
		
	else
		warn("Requested Tower does not exist")
	end
end

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)
return tower
