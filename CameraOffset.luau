local player = game.Players.LocalPlayer

while not player:HasAppearanceLoaded() do task.wait(0.5) end -- does this work the way i think it does?

local character = player.Character or player.CharacterAdded:Wait()

local head = character:WaitForChild("Head")
local torso = character:WaitForChild("Torso")
local rightarm = character:WaitForChild("Right Arm")
local leftarm = character:WaitForChild("Left Arm")
local rightleg = character:WaitForChild("Right Leg")
local leftleg = character:WaitForChild("Left Leg")

local firstperson = player.CameraMode == Enum.CameraMode.LockFirstPerson

local humanoid:Humanoid = character:WaitForChild("Humanoid")

character.ChildAdded:Connect(function(child)
	if child:IsA("Model") then
		local middle = child:WaitForChild("Middle")
		if middle then
			local pos0 = middle.Position
			local pos1 = (pos0-head.Position).magnitude
			local pos2 = (pos0-torso.Position).magnitude
			local pos3 = (pos0-rightarm.Position).magnitude
			local pos4 = (pos0-leftarm.Position).magnitude
			local pos5 = (pos0-rightleg.Position).magnitude
			local pos6 = (pos0-leftleg.Position).magnitude
			local closest = math.min(pos1,pos2,pos3,pos4,pos5,pos6)
			local ishead = closest == pos1
			if ishead then
				middle:SetAttribute("check",false)
				return
			else
				middle:SetAttribute("check",true)
			end

			for i,v in pairs(child:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("Decal") then
					v:SetAttribute("trans",v.Transparency)
				end
			end
		end
	end
end)

local offset = humanoid.CameraOffset

game:GetService("RunService").RenderStepped:Connect(function(deltaTime) 	
	if firstperson then
		for i,v in pairs(character:GetChildren()) do
			if v:IsA("Accessory") and v.Handle.AccessoryWeld.Part1.Name ~= "Head" then
				v.Handle.LocalTransparencyModifier = 0
			elseif v:IsA("BasePart") and v.Name ~= "Head" and v.Name ~= "HumanoidRootPart" and not (character:FindFirstChildWhichIsA("Tool") and string.find(v.Name,"Arm")) then
				v.LocalTransparencyModifier = 0
			elseif v:IsA("Model") and v:FindFirstChild("Middle") then
				if v.Middle:GetAttribute("check") == true then
					for i,v in pairs(v:GetDescendants()) do
						if v:IsA("BasePart") or v:IsA("Decal") then
							v.LocalTransparencyModifier = v:GetAttribute("trans")
						end
					end
				end
			end
		end
		if humanoid.CameraOffset.Z > -1 then
			humanoid.CameraOffset = Vector3.new(humanoid.CameraOffset.X,humanoid.CameraOffset.Y,humanoid.CameraOffset.Z + (-1 - humanoid.CameraOffset.Z) * 0.25)
		end
	else
		if humanoid.CameraOffset.Z ~= offset.Z then
			humanoid.CameraOffset = Vector3.new(humanoid.CameraOffset.X,humanoid.CameraOffset.Y,humanoid.CameraOffset.Z + (offset.Z - humanoid.CameraOffset.Z ) * 0.25)
		end
	end
end)

head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
	local ltm = head.LocalTransparencyModifier
	if ltm ~= 0 then
		firstperson = true
	elseif ltm == 0 then
		firstperson = false
	end
end)
