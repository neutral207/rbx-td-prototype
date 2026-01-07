local function animateMob(object)
	local humanoid = object:WaitForChild("Humanoid")
	local animationsFolder = object:WaitForChild("Animations")
	
	
	if humanoid and animationsFolder then
		local walk = animationsFolder:WaitForChild("Walk")
		if walk then
			local walkAnimator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
			local walkTrack = walkAnimator:LoadAnimation(walk)
			walkTrack:Play()
		end
	else
		warn("Humanoid or Animations folder not found in mob")
	end
	
end



workspace.MapEnemies.ChildAdded:Connect(animateMob)
