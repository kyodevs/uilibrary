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

-- Function to create the UI
function library:create(class, properties)
    local instance = Instance.new(class)

    if properties then
        for property, value in next, properties do
            instance[property] = value
        end
    end

    return instance
end

-- Function to create animations
function library:animate(instance, property, value, ...)
    local tween = anim:Create(instance, TweenInfo.new(unpack({...})), {[property] = value})

    tween:Play()

    return tween
end

local existingBase = core:FindFirstChild("YourUINameHere")

-- Check if the UI already exists and destroy it
if existingBase then
    existingBase:Destroy()
end

function library.new(text, subtext, size)
    local menu = {categories = {}, flags = {}, first = true}

    local base = library:create("ScreenGui", {
        Parent = run:IsStudio() and player.PlayerGui or core,
        Name = "YourUINameHere" -- Give your UI a unique name to easily find it
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

    -- Rest of your code for creating the UI
    -- ...

    table.insert(library.menus, menu)
    return menu
end

-- Drag functionality for the UI
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

return library
