-- Made by wer888

local CoreGui = game:GetService("CoreGui")

local toolbar = plugin:CreateToolbar("Sound Roll-Off Visualizer")
local button = toolbar:CreateButton("Display Sound Roll-Offs", "Displays audio roll-off distances as spheres.", "rbxassetid://9224953365")
local volumetricButton = toolbar:CreateButton("Enable Volumetric Roll-Offs", "Displays audio roll-off distances based on the beta volumetric audio feature. These are approximate and may be wrong near the edges.", "rbxassetid://9225032190")

local on = false
local volumetricSounds = false

local function turnOn()
	
	on = true

	local folder = Instance.new("Folder")
	folder.Name = "RollOffVisualizer"
	folder.Parent = CoreGui

	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Sound") and (v.Parent:IsA("BasePart") or v.Parent:IsA("Attachment")) then
			
			local col = BrickColor.random().Color
			local max, min
			
			if volumetricSounds and v.Parent:IsA("Part") then

				if v.Parent.Shape == Enum.PartType.Block or v.Parent.Shape == Enum.PartType.Cylinder then
					max = Instance.new("BoxHandleAdornment")
					max.Size = v.Parent.Size + (Vector3.one * v.RollOffMaxDistance * 2) -- an approximation of surface, not exact
				else
					max = Instance.new("SphereHandleAdornment")
					max.Radius = v.RollOffMaxDistance + (v.Parent.Size.X / 2) -- roll off + sphere radius
				end

			else
				max = Instance.new("SphereHandleAdornment")
				max.Radius = v.RollOffMaxDistance
			end

			max.Adornee = v.Parent
			max.Color3 = col
			max.Transparency = 0.75
			max.Parent = folder
			
			if volumetricSounds and v.Parent:IsA("Part") then

				if v.Parent.Shape == Enum.PartType.Block or v.Parent.Shape == Enum.PartType.Cylinder then
					min = Instance.new("BoxHandleAdornment")
					min.Size = v.Parent.Size + (Vector3.one * v.RollOffMinDistance * 2) -- an approximation of surface, not exact
				else
					min = Instance.new("SphereHandleAdornment")
					min.Radius = v.RollOffMinDistance + (v.Parent.Size.X / 2) -- roll off + sphere radius
				end

			else
				min = Instance.new("SphereHandleAdornment")
				min.Radius = v.RollOffMinDistance
			end

			min.Adornee = v.Parent
			min.Color3 = col
			min.Transparency = 0.75
			min.Parent = folder

		end
	end

end

local function turnOff()
	
	on = false
	
	local folder = CoreGui:FindFirstChild("RollOffVisualizer")
	if folder then
		folder.Parent = nil -- allows changehistoryservice to undo a destroy
	end
	
end

local function update()
	if on then
		turnOff()
	else
		turnOn()
	end
end
button.Click:Connect(update)

volumetricButton.Click:Connect(function()

	if volumetricSounds then
		volumetricSounds = false
		turnOff()
	else
		volumetricSounds = true
		turnOff()
		turnOn()
	end

end)