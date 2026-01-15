local player = game:GetService("Players")
local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local rs = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")

local cash = player.LocalPlayer.leaderstats:WaitForChild("Cash")
local events =  rs:WaitForChild("Events")
local functions =  rs:WaitForChild("Functions")
local requestTower = functions:WaitForChild("RequestTower")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local towerToSpawn = nil
local gui = script.Parent
local canPlace = false
local towers = rs:WaitForChild("Towers")
local rotation = 0
local placedTowers = 0
local maxTowers = 15

local function updateCash()
	gui.Cash.Text = "$ " .. cash.Value
end
updateCash()
cash.Changed:Connect(updateCash)


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

gui.Towers.Title.Text = "Towers (" .. placedTowers .. "/" .. maxTowers .. ")"

for i, tower in pairs(towers:GetChildren()) do
	local button = gui.Towers.Template:Clone()
	button.Name = tower.Name
	local config = tower.Configuration
	button.Image = config.Image.Texture
	button.Visible = true
	button.LayoutOrder = config.Price.Value
	button.Price.Text = "$" .. config.Price.Value
	button.Parent = gui.Towers
	
	button.Activated:Connect(function()
		local allowedToSpawn = requestTower:InvokeServer(tower.Name)
		if allowedToSpawn then
			addPHTower(tower.Name)
		end
		
	end)
end



uis.InputBegan:Connect(function(input, processed)
	if processed then return end
	if towerToSpawn then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if canPlace then
				spawnTowerEvent:FireServer(towerToSpawn.Name, towerToSpawn.PrimaryPart.CFrame)
				placedTowers += 1
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
