-- By Peak#7550
-- Design yoinked from uc

local players = game:GetService("Players")
local inputs = game:GetService("UserInputService")
local anim = game:GetService("TweenService")
local http = game:GetService("HttpService")
local core = game:GetService("CoreGui")
local run = game:GetService("RunService")

local library = {menus = {}}
local env = getfenv()

local player = players.LocalPlayer
local mouse = player:GetMouse()

function library:create(class, properties)
	local instance = Instance.new(class)
	
	if(properties) then
		for propertie, value in next, properties do
			instance[propertie] = value
		end
	end
	
	return instance
end

function library:animate(instance, property, value, ...)
	local tween = anim:Create(instance, TweenInfo.new(unpack({...})), {[property] = value})
	
	tween:Play()
	
	return tween
end

function library.new(text, subtext, size)
	local menu = {categories = {}, flags = {}, first = true}
	
	local base = library:create("ScreenGui", {
		Parent = run:IsStudio() and player.PlayerGui or core
	})
	
	local back = library:create("ImageLabel", {
		Parent = base,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0.252475232, 0, 0.181818187, 0),
		Size = size or UDim2.new(0, 600, 0, 420),
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(25, 25, 31),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.080
	})
	
	local side = library:create("ImageLabel", {
		Parent = back,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Size = UDim2.new(0, 150, 1, 0),
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(20, 18, 24),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.080
	})
	
	local corner_hider = library:create("Frame", {
		Parent = side,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(20, 18, 24),
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, 6, 1, 0)
	})
	
	local side_contrast = library:create("Frame", {
		Parent = corner_hider,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(34, 34, 42),
		BorderSizePixel = 0,
		Position = UDim2.new(1, 1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0)
	})
	
	local text1 = library:create("TextLabel", {
		Parent = side,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0.5, 0, 0, 30),
		Size = UDim2.new(1, 0, 0, 20),
		Font = Enum.Font.Gotham,
		Text = text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 16.000
	})
	
	local text2 = library:create("TextLabel", {
		Parent = side,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0.5, 0, 0, 50),
		Size = UDim2.new(1, 0, 0, 20),
		Font = Enum.Font.Gotham,
		Text = subtext,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14.000,
		TextTransparency = 0.400
	})
	
	local buttons = library:create("Frame", {
		Parent = side,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0.5, 0, 0, 86),
		Size = UDim2.new(1, -28, 1, -100)
	})
	
	local layout = library:create("UIListLayout", {
		Parent = buttons,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8)
	})
	

	local dragging = false
local dragStartPos = nil
local offset = nil

-- The title bar is 'text1' in your code, so we'll use that for dragging.
local titleBar = text1

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
        offset = base.Position - UDim2.new(0, dragStartPos.X, 0, dragStartPos.Y)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local newPosition = UDim2.new(0, input.Position.X, 0, input.Position.Y) + offset
        base.Position = newPosition
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)


	function menu:AddCategory(name, icon_id)
		local category = {sections = {}}
		
		local category_button = library:create("TextButton", {
			Parent = buttons,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			BorderSizePixel = 0,
			LayoutOrder = #menu.categories,
			Size = UDim2.new(1, 0, 0, 32),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14.000,
			TextXAlignment = Enum.TextXAlignment.Left
		})
		
		local button_back = library:create("ImageLabel", {
			Parent = category_button,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Selectable = true,
			Size = UDim2.new(1, 0, 1, 0),
			Image = "rbxassetid://3570695787",
			ImageColor3 = Color3.fromRGB(34, 34, 42),
			ImageTransparency = self.first and 0 or 1,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(100, 100, 100, 100),
			SliceScale = 0.060
		})
		
		local inner_button = library:create("ImageLabel", {
			Parent = button_back,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -2, 1, -2),
			Image = "rbxassetid://3570695787",
			ImageColor3 = Color3.fromRGB(25, 25, 31),
			ImageTransparency = self.first and 0 or 1,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(100, 100, 100, 100),
			SliceScale = 0.060
		})
		
		local button_icon = library:create("ImageLabel", {
			Parent = category_button,
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 4, 0.5, 0),
			Size = UDim2.new(0, 24, 1, -8),
			Image = "rbxassetid://3570695787",
			ImageColor3 = self.first and Color3.fromRGB(238, 48, 76) or Color3.fromRGB(26, 25, 31),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(100, 100, 100, 100),
			SliceScale = 0.060
		})
		
		local button_icon_img = library:create("ImageLabel", {
			Parent = button_icon,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -8, 1, -8),
			Image = "http://www.roblox.com/asset/?id=" .. icon_id,
			ScaleType = Enum.ScaleType.Slice,
			SliceScale = 100.000
		})
		
		local button_text = library:create("TextLabel", {
			Parent = category_button,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 40, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.Gotham,
			Text = name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14.000,
			TextTransparency = self.first and 0 or 0.400,
			TextXAlignment = Enum.TextXAlignment.Left
		})
		
		if(self.first) then
			self.first = false
		end
		
		category_button.MouseButton1Click:Connect(function()
			category:Show()
		end)
		
		function category:Show()
			if(button_text.TextTransparency == 0) then
				return
			end
			
			for _, button in next, buttons:GetChildren() do
				local text
				local back
				local icon
				
				for _, child in next, button:GetChildren() do
					if(child:IsA("TextLabel")) then
						text = child
					elseif(child:IsA("ImageLabel")) then
						if(child.AnchorPoint.X == 0.5) then
							back = child
						else
							icon = child
						end
					end
				end
				
				if(text) then
					library:animate(text, "TextTransparency", text ~= button_text and 0.4 or 0, 0.1)
				end
				
				if(back) then
					local trans = back ~= button_back and 1 or 0
					
					library:animate(back, "ImageTransparency", trans, 0.3)
					library:animate(back:GetChildren()[1], "ImageTransparency", trans, 0.3)
				end
				
				if(icon) then
					local color = icon ~= button_icon and Color3.fromRGB(26, 25, 31) or Color3.fromRGB(238, 48, 76)
					
					library:animate(icon, "ImageColor3", color, 0.2)
				end
			end
		end
		
		function category:AddSection(name)
			local section = {objects = {}}
			
			function section:AddButton()
				local object = {}
				
				
				table.insert(section.objects, object)
				return object
			end
			
			table.insert(category.sections, section)
			return section
		end
		
		table.insert(self.categories, category)
		return category
	end
	
	table.insert(library.menus, menu)
	return menu
end

return library
