local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local rs = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")
local events =  rs:WaitForChild("Events")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local towerToSpawn = nil
local gui = script.Parent
local canPlace = false
local towers = rs:WaitForChild("Towers")
local rotation = 0

task.wait(1)
local function mouseRaycast(blacklist)
	
	local mousePos = uis:GetMouseLocation()
	local mouseRay = cam:ViewportPointToRay(mousePos.X, mousePos.Y)
	local raycastParams = RaycastParams.new()
	
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = blacklist

	local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)
	
	return raycastResult
end





local function removePHTower(name)
	if towerToSpawn then
		towerToSpawn:Destroy()
		towerToSpawn = nil
		rotation = 0
	end
end

local function addPHTower(name)
	local towerExists = towers:FindFirstChild(name)
	if towerExists then
		removePHTower()
		towerToSpawn = towerExists:Clone()
		towerToSpawn.Parent = workspace.Towers
		

		for i, object in ipairs(towerToSpawn:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CollisionGroup = "Towers"
				object.Material = Enum.Material.ForceField
			end
		end
	end
end


local function colorPHTower(color)
	for i, object in ipairs(towerToSpawn:GetDescendants()) do
		if object:IsA("BasePart") then
			object.Color = color
		end
	end
end

gui.Spawn.Activated:Connect(function()
	addPHTower("Scout")
end)




uis.InputBegan:Connect(function(input, processed)
	if processed then return end
	if towerToSpawn then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if canPlace then
				spawnTowerEvent:FireServer(towerToSpawn.Name, towerToSpawn.PrimaryPart.CFrame)
				removePHTower()
			end
		elseif input.KeyCode == Enum.KeyCode.R then
			rotation += 90
		end
	end
end)


run.RenderStepped:Connect(function()
	if towerToSpawn then
		local result = mouseRaycast({towerToSpawn})

		if result and result.Instance then
			if result.Instance.Parent.Name == "TowerArea" then
				canPlace = true
				colorPHTower(Color3.new(0,1,0))
			else
				canPlace = false
				colorPHTower(Color3.new(1,0,0))
			end
			local x = result.Position.X
			local y = result.Position.Y + (towerToSpawn.PrimaryPart.Size.Y / 2) + 3.5
			local z = result.Position.Z
			local cframe = CFrame.new(x,y,z) * CFrame.Angles(0, math.rad(rotation), 0)

			towerToSpawn:SetPrimaryPartCFrame(cframe)
		end
	end
end)