local player = game.Players.LocalPlayer

while not player:HasAppearanceLoaded() do task.wait(0.5) end

local character = player.Character or player.CharacterAdded:Wait()

local lockfirstperson = player.CameraMode == Enum.CameraMode.LockFirstPerson

local transval = lockfirstperson and 0 or 1

local newbody = Instance.new("Model")
newbody.Name = character.Name .. "FPA"
newbody.Parent = workspace

local function absolutefindchild(parent,child)
	local child2 = false
	while not child2 do
		child2 = parent:FindFirstChild(child)
		if not child2 then
			task.wait(0.5)
		end
	end
	return child2
end

local leftarm = absolutefindchild(character,"Left Arm")
local rightarm = absolutefindchild(character,"Right Arm")
local leftleg = absolutefindchild(character,"Left Leg")
local rightleg = absolutefindchild(character,"Right Leg")
local torso = absolutefindchild(character,"Torso")

local newleftarm = Instance.new("Part")
newleftarm.Name = "Left Arm"
newleftarm.Size = Vector3.new(1,2,1)
newleftarm.CanCollide = false
newleftarm.Parent = newbody
newleftarm.Anchored = true
newleftarm.CanTouch = false
newleftarm.CastShadow = lockfirstperson
newleftarm.Transparency = transval
newleftarm.AudioCanCollide = false
newleftarm.EnableFluidForces = false
newleftarm.CanQuery = false
newleftarm.Color = leftarm.Color

local newrightarm = Instance.new("Part")
newrightarm.Name = "Right Arm"
newrightarm.Size = Vector3.new(1,2,1)
newrightarm.CanCollide = false
newrightarm.Parent = newbody
newrightarm.Anchored = true
newrightarm.CanTouch = false
newrightarm.CastShadow = lockfirstperson
newrightarm.Transparency = transval
newrightarm.AudioCanCollide = false
newrightarm.EnableFluidForces = false
newrightarm.CanQuery = false
newrightarm.Color = rightarm.Color

local newleftleg = Instance.new("Part")
newleftleg.Name = "Left Leg"
newleftleg.Size = Vector3.new(1,2,1)
newleftleg.CanCollide = false
newleftleg.Parent = newbody
newleftleg.Anchored = true
newleftleg.CanTouch = false
newleftleg.CastShadow = lockfirstperson
newleftleg.Transparency = transval
newleftleg.AudioCanCollide = false
newleftleg.EnableFluidForces = false
newleftleg.CanQuery = false
newleftleg.Color = leftleg.Color

local newrightleg = Instance.new("Part")
newrightleg.Name = "Right Leg"
newrightleg.Size = Vector3.new(1,2,1)
newrightleg.CanCollide = false
newrightleg.Parent = newbody
newrightleg.Anchored = true
newrightleg.CanTouch = false
newrightleg.CastShadow = lockfirstperson
newrightleg.Transparency = transval
newrightleg.AudioCanCollide = false
newrightleg.EnableFluidForces = false
newrightleg.CanQuery = false
newrightleg.Color = rightleg.Color

local newtorso = Instance.new("Part")
newtorso.Name = "Torso"
newtorso.Size = Vector3.new(2,2,1)
newtorso.CanCollide = false
newtorso.Parent = newbody
newtorso.Anchored = true
newtorso.CanTouch = false
newtorso.CastShadow = lockfirstperson
newtorso.Transparency = transval
newtorso.AudioCanCollide = false
newtorso.EnableFluidForces = false
newtorso.CanQuery = false
newtorso.Color = torso.Color

local humanoid = absolutefindchild(character,"Humanoid")

humanoid:Clone().Parent = newbody

humanoid.Died:Connect(function()
	newbody:Destroy()
end)

leftarm:GetPropertyChangedSignal("Color"):Connect(function()
	newleftarm.Color = leftarm.Color
end)

rightarm:GetPropertyChangedSignal("Color"):Connect(function()
	newrightarm.Color = rightarm.Color
end)

leftleg:GetPropertyChangedSignal("Color"):Connect(function()
	newleftleg.Color = leftleg.Color
end)

rightleg:GetPropertyChangedSignal("Color"):Connect(function()
	newrightleg.Color = rightleg.Color
end)

torso:GetPropertyChangedSignal("Color"):Connect(function()
	newtorso.Color = torso.Color
end)

local chead = character.Head

local function accessorycheck()
	for i,thing in pairs(character:GetChildren()) do
		local success = false
		while not success do
			success = pcall(function()
				local thingname = thing.Name
				if not newbody:FindFirstChild(thingname) then
					if thing:IsA("Accessory") then
						local handle = thing:FindFirstChild("Handle")
						local aweld = handle.AccessoryWeld
						local name = aweld.Part1.Name
						if name ~= "Head" then
							local hsize = handle.Size
							if hsize.X * hsize.Y * hsize.Z < 48 then
								local clone = thing:Clone()
								clone.Name = thingname
								clone.Parent = newbody
								clone.Handle.AccessoryWeld.Part1 = newbody[name]
								clone.Handle.Transparency = transval
								clone.Handle.CastShadow = lockfirstperson
							end
						end
					elseif thing:IsA("Model") and thing:FindFirstChild("Middle") then
						local hsize:Vector3 = thing:GetExtentsSize()
						if hsize.X * hsize.Y * hsize.Z < 48 then
							local middleanch = thing.Middle.Anchored
							local pos0 = thing.Middle.Position
							local pos1 = (pos0-chead.Position).magnitude
							local pos2 = (pos0-torso.Position).magnitude
							local pos3 = (pos0-rightarm.Position).magnitude
							local pos4 = (pos0-leftarm.Position).magnitude
							local pos5 = (pos0-rightleg.Position).magnitude
							local pos6 = (pos0-leftleg.Position).magnitude
							local closest = math.min(pos1,pos2,pos3,pos4,pos5,pos6)
							local targetcf
							if closest == pos1 then
								return
							elseif closest == pos2 then
								targetcf = "Torso"
							elseif closest == pos3 then
								targetcf = "Right Arm"
							elseif closest == pos4 then
								targetcf = "Left Arm"
							elseif closest == pos5 then
								targetcf = "Right Leg"
							elseif closest == pos6 then
								targetcf = "Left Leg"
							end					
							local clone:Model = thing:Clone()
							clone.Parent = newbody
							local middle = clone.Middle
							local newweld = Instance.new("Weld")
							newweld.Part0 = newbody[targetcf]
							newweld.Name = "WELDDDDD"
							newweld.Part1 = middle
							newweld.Parent = middle		
							if not lockfirstperson then
								for i,v in pairs(clone:GetChildren()) do
									local ispart = v:IsA("BasePart")
									if ispart or v:IsA("Decal") then
										v.Transparency = transval
										if ispart then
											v.CastShadow = lockfirstperson

											v.CanTouch = false											
											v.AudioCanCollide = false
											v.EnableFluidForces = false
											v.CanQuery = false
											--]]
										end
									end
								end
							end
						end
					end
				end
			end)
			if not success then
				task.wait(0.5)
			end
		end
	end
end

local toolequipped

character.ChildRemoved:Connect(function(child) 
	if child:IsA("Tool") then
		toolequipped = false
		if lockfirstperson then
			newleftarm.Transparency = leftarm.Transparency
			newleftarm.CastShadow =  leftarm.CastShadow
			newrightarm.Transparency = rightarm.Transparency
			newrightarm.CastShadow = rightarm.CastShadow
		end
	end
	local find = newbody:FindFirstChild(child.Name)
	if find then
		find:Destroy()
	end
end)

local Camera = workspace.CurrentCamera

local function updatecf()	
	--local x,y,z = Camera.CFrame:ToOrientation()

	local rootpartcf = character.HumanoidRootPart.CFrame

	local rootcf = rootpartcf * CFrame.new(0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1)

	newleftarm.CFrame = rootcf * rootpartcf:ToObjectSpace(leftarm.CFrame)
	newrightarm.CFrame = rootcf * rootpartcf:ToObjectSpace(rightarm.CFrame)
	newleftleg.CFrame = rootcf * rootpartcf:ToObjectSpace(leftleg.CFrame)
	newrightleg.CFrame = rootcf * rootpartcf:ToObjectSpace(rightleg.CFrame)
	newtorso.CFrame = rootcf * rootpartcf:ToObjectSpace(torso.CFrame)
end

--Using character.childadded doesnt work consistently for some reason

local HEAVY_TASK_INTERVAL = 0.5

local lastExecutionTime = 0

game:GetService("RunService").RenderStepped:Connect(function(deltaTime) 
	newleftarm.CanCollide = false
	newrightarm.CanCollide = false
	newleftleg.CanCollide = false
	newrightleg.CanCollide = false
	newtorso.CanCollide = false
	--newrootpart.CanCollide = false

	if not lockfirstperson then return end

	updatecf()

	local currentTime = tick()

	if currentTime - lastExecutionTime >= HEAVY_TASK_INTERVAL then
		lastExecutionTime = currentTime
		accessorycheck()
	end
end)

local newpants:Pants = absolutefindchild(character,"Pants"):Clone()
newpants.Parent = newbody

local newshirt:Shirt = absolutefindchild(character,"Shirt"):Clone()
newshirt.Parent = newbody

character.ChildAdded:Connect(function(child) 
	if child:IsA("Shirt") then
		newshirt:Destroy()
		newshirt = child:Clone()
		newshirt.Parent = newbody
	elseif child:IsA("Pants") then
		newpants:Destroy()
		newpants = child:Clone()
		newpants.Parent = newbody
	elseif child:IsA("Tool") then
		toolequipped = true
		newleftarm.Transparency = 1
		newleftarm.CastShadow = false
		newrightarm.Transparency = 1
		newrightarm.CastShadow = false
	end
end)

chead:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
	local LTM = chead.LocalTransparencyModifier
	if LTM ~= 1 then
		lockfirstperson = false
		transval = 1
		for i,v in pairs(newbody:GetDescendants()) do
			local isbasepart:BasePart = v:IsA("BasePart")
			if isbasepart or v:IsA("Decal") then
				v.Transparency = 1
				if isbasepart then
					v.CastShadow = false
				end
			end
		end
	elseif LTM == 1 then
		lockfirstperson = true
		transval = 0
		for i,v in pairs(newbody:GetDescendants()) do
			local isbasepart:BasePart = v:IsA("BasePart")
			if isbasepart or v:IsA("Decal") then
				local find:BasePart|Decal = character:FindFirstChild(v.Name,true)
				if find then
					v.Transparency = find.Transparency
					if isbasepart then
						v.CastShadow = find.CastShadow
					end
					if toolequipped then
						newleftarm.Transparency = 1
						newleftarm.CastShadow = false
						newrightarm.Transparency = 1
						newrightarm.CastShadow = false
					end
				end
			end
		end
	end
end)
