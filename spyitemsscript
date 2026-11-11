-- ISpySomeonesItems - TSS Script NoneUserHub (Section Headings in List)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Format numbers into abbreviations with full value in parentheses
local function formatNumber(val)
	if type(val) ~= "number" then return tostring(val) end
	
	local function commaValue(n)
		local left, num, right = string.match(tostring(n), '^([^%d]*%d+)(%d*)(.-)$')
		return left .. num:reverse():gsub('(%d%d%d)','%1,'):reverse() .. right
	end

	local fullFormatted = commaValue(val)
	local suffixes = {"", "K", "M", "B", "T", "Qd", "Qn"}
	local i = 1
	local absVal = math.abs(val)
	
	while absVal >= 1000 and i < #suffixes do
		absVal = absVal / 1000
		i = i + 1
	end
	
	if i == 1 then
		return fullFormatted
	else
		local shortVal = string.format("%.3f", absVal)
		shortVal = shortVal:gsub("%.0+$", ""):gsub("(%..-)0+$", "%1")
		local sign = val < 0 and "-" or ""
		return string.format("%s%s%s\n(%s)", sign, shortVal, suffixes[i], fullFormatted)
	end
end

-- Structured List with Main Sections, Sub Sections, and Items
local ListStructure = {
	{
		type = "MainSection",
		title = "-- Players"
	},
	{
		type = "Section",
		title = "- Stats"
	},
	{ type = "Item", name = "Level" },
	{ type = "Item", name = "Stage" },
	{ type = "Item", name = "Win" },
	{ type = "Item", name = "Diamond" },

	{
		type = "MainSection",
		title = "-- Rares"
	},
	{
		type = "Section",
		title = "- Normal Items"
	},
	{ type = "Item", name = "Basic" },
	{ type = "Item", name = "Mega" },
	{ type = "Item", name = "Ultra" },
	{ type = "Item", name = "Secret" },
	{ type = "Item", name = "Godly" },

	{
		type = "Section",
		title = "- Rare Items"
	},
	{ type = "Item", name = "Gold" },
	{ type = "Item", name = "Crystal" },
	{ type = "Item", name = "Chrome" },
	{ type = "Item", name = "Platinum" },
	{ type = "Item", name = "Prisma" },
	{ type = "Item", name = "HyperRed" },
	{ type = "Item", name = "HyperWhite" },
	{ type = "Item", name = "HyperGreen" },
	{ type = "Item", name = "Amethyst" },
	{ type = "Item", name = "Celestial" },
	{ type = "Item", name = "Azurite" },

	{
		type = "Section",
		title = "- Limited Items"
	},
	{ type = "Item", name = "Divine" },
	{ type = "Item", name = "Frost" },
	{ type = "Item", name = "Dirt" },
	{ type = "Item", name = "Void" },
	{ type = "Item", name = "Winter2024" },
	{ type = "Item", name = "Winter2025" },
	{ type = "Item", name = "Halloween2025" },
}

-- UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ISpySomeonesItemsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 270, 0, 420)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 8)
MainUICorner.Parent = MainFrame

local MainUIStroke = Instance.new("UIStroke")
MainUIStroke.Color = Color3.fromRGB(60, 60, 80)
MainUIStroke.Thickness = 1
MainUIStroke.Parent = MainFrame

-- Title Bar (Draggable Area)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 8)
TitleBarCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 8)
TitleFix.Position = UDim2.new(0, 0, 1, -8)
TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ISpySomeonesItems - TSS Script NoneUserHub"
TitleText.TextColor3 = Color3.fromRGB(220, 220, 240)
TitleText.TextSize = 11
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -28, 0, 4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinimizeBtn

-- Body Frame
local BodyFrame = Instance.new("Frame")
BodyFrame.Name = "BodyFrame"
BodyFrame.Size = UDim2.new(1, 0, 1, -32)
BodyFrame.Position = UDim2.new(0, 0, 0, 32)
BodyFrame.BackgroundTransparency = 1
BodyFrame.Parent = MainFrame

-- User Search Box
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -16, 0, 28)
SearchBox.Position = UDim2.new(0, 8, 0, 8)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "Enter Username / DisplayName..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 150)
SearchBox.Text = ""
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.SourceSans
SearchBox.Parent = BodyFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 5)
BoxCorner.Parent = SearchBox

-- Spy Button
local SpyBtn = Instance.new("TextButton")
SpyBtn.Size = UDim2.new(1, -16, 0, 28)
SpyBtn.Position = UDim2.new(0, 8, 0, 42)
SpyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SpyBtn.Text = "Spy Player Searched"
SpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpyBtn.TextSize = 12
SpyBtn.Font = Enum.Font.SourceSansBold
SpyBtn.Parent = BodyFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 5)
BtnCorner.Parent = SpyBtn

-- Target Display Info Label
local TargetInfoLabel = Instance.new("TextLabel")
TargetInfoLabel.Size = UDim2.new(1, -16, 0, 18)
TargetInfoLabel.Position = UDim2.new(0, 8, 0, 74)
TargetInfoLabel.BackgroundTransparency = 1
TargetInfoLabel.Text = "No player selected"
TargetInfoLabel.TextColor3 = Color3.fromRGB(0, 220, 130)
TargetInfoLabel.TextSize = 11
TargetInfoLabel.Font = Enum.Font.SourceSansBold
TargetInfoLabel.Parent = BodyFrame

-- Item Search Bar (Filter Items List)
local ItemSearchBox = Instance.new("TextBox")
ItemSearchBox.Size = UDim2.new(1, -16, 0, 24)
ItemSearchBox.Position = UDim2.new(0, 8, 0, 96)
ItemSearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ItemSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemSearchBox.PlaceholderText = "Search Item in List..."
ItemSearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
ItemSearchBox.Text = ""
ItemSearchBox.TextSize = 11
ItemSearchBox.Font = Enum.Font.SourceSans
ItemSearchBox.Parent = BodyFrame

local ItemBoxCorner = Instance.new("UICorner")
ItemBoxCorner.CornerRadius = UDim.new(0, 4)
ItemBoxCorner.Parent = ItemSearchBox

-- Scroll Frame Status
local StatusScroll = Instance.new("ScrollingFrame")
StatusScroll.Size = UDim2.new(1, -16, 1, -132)
StatusScroll.Position = UDim2.new(0, 8, 0, 124)
StatusScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
StatusScroll.BorderSizePixel = 0
StatusScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
StatusScroll.ScrollBarThickness = 3
StatusScroll.Parent = BodyFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 5)
ScrollCorner.Parent = StatusScroll

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = StatusScroll

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	StatusScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 8)
end)

----------------------------------------------------
-- INDEPENDENT DRAG LOGIC (TitleBar Only)
----------------------------------------------------
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TitleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

----------------------------------------------------
-- MINIMIZE LOGIC
----------------------------------------------------
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		BodyFrame.Visible = false
		MainFrame:TweenSize(UDim2.new(0, 270, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
		MinimizeBtn.Text = "+"
	else
		MainFrame:TweenSize(UDim2.new(0, 270, 0, 420), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true, function()
			BodyFrame.Visible = true
		end)
		MinimizeBtn.Text = "-"
	end
end)

----------------------------------------------------
-- SPY & STATS LOGIC
----------------------------------------------------
local function FindPlayer(query)
	query = query:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower():sub(1, #query) == query or p.DisplayName:lower():sub(1, #query) == query then
			return p
		end
	end
	return nil
end

local function ClearStatus()
	for _, child in pairs(StatusScroll:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end

local function CreateMainSectionRow(title, order)
	local Row = Instance.new("Frame")
	Row.Name = "Header_" .. title
	Row.Size = UDim2.new(1, -8, 0, 24)
	Row.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	Row.LayoutOrder = order
	Row.Parent = StatusScroll

	local RowCorner = Instance.new("UICorner")
	RowCorner.CornerRadius = UDim.new(0, 4)
	RowCorner.Parent = Row

	local TitleLbl = Instance.new("TextLabel")
	TitleLbl.Size = UDim2.new(1, -12, 1, 0)
	TitleLbl.Position = UDim2.new(0, 6, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = title
	TitleLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
	TitleLbl.TextSize = 12
	TitleLbl.Font = Enum.Font.SourceSansBold
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	TitleLbl.Parent = Row
end

local function CreateSubSectionRow(title, order)
	local Row = Instance.new("Frame")
	Row.Name = "Header_" .. title
	Row.Size = UDim2.new(1, -8, 0, 20)
	Row.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
	Row.LayoutOrder = order
	Row.Parent = StatusScroll

	local RowCorner = Instance.new("UICorner")
	RowCorner.CornerRadius = UDim.new(0, 4)
	RowCorner.Parent = Row

	local TitleLbl = Instance.new("TextLabel")
	TitleLbl.Size = UDim2.new(1, -12, 1, 0)
	TitleLbl.Position = UDim2.new(0, 10, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = title
	TitleLbl.TextColor3 = Color3.fromRGB(180, 180, 210)
	TitleLbl.TextSize = 11
	TitleLbl.Font = Enum.Font.SourceSansBold
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	TitleLbl.Parent = Row
end

local function CreateItemRow(name, rawValue, order)
	local Row = Instance.new("Frame")
	Row.Name = name
	Row.Size = UDim2.new(1, -8, 0, 32)
	Row.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	Row.LayoutOrder = order
	Row.Parent = StatusScroll

	local RowCorner = Instance.new("UICorner")
	RowCorner.CornerRadius = UDim.new(0, 4)
	RowCorner.Parent = Row

	local ItemName = Instance.new("TextLabel")
	ItemName.Size = UDim2.new(0.45, -4, 1, 0)
	ItemName.Position = UDim2.new(0, 12, 0, 0)
	ItemName.BackgroundTransparency = 1
	ItemName.Text = tostring(name)
	ItemName.TextColor3 = Color3.fromRGB(210, 210, 220)
	ItemName.TextSize = 11
	ItemName.Font = Enum.Font.SourceSans
	ItemName.TextXAlignment = Enum.TextXAlignment.Left
	ItemName.Parent = Row

	local displayValue = formatNumber(rawValue)

	local ItemValue = Instance.new("TextLabel")
	ItemValue.Size = UDim2.new(0.55, -6, 1, 0)
	ItemValue.Position = UDim2.new(0.45, 0, 0, 0)
	ItemValue.BackgroundTransparency = 1
	ItemValue.Text = tostring(displayValue)
	ItemValue.TextColor3 = Color3.fromRGB(255, 215, 0)
	ItemValue.TextSize = 11
	ItemValue.Font = Enum.Font.SourceSansBold
	ItemValue.TextXAlignment = Enum.TextXAlignment.Right
	ItemValue.TextWrapped = true
	ItemValue.Parent = Row
end

-- Filter items & sections in scroll view via Item Search Bar
ItemSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filterText = ItemSearchBox.Text:lower()
	
	for _, row in pairs(StatusScroll:GetChildren()) do
		if row:IsA("Frame") then
			if filterText == "" then
				row.Visible = true
			else
				if row.Name:sub(1, 7) == "Header_" then
					row.Visible = true
				else
					row.Visible = row.Name:lower():find(filterText, 1, true) ~= nil
				end
			end
		end
	end
end)

-- Function to search for value of a specific item in player stats
local function GetValueFromStats(player, itemName)
	local statsFolder = player:FindFirstChild("Stats") or player:FindFirstChild("leaderstats")
	if not statsFolder then return nil end
	
	local directObj = statsFolder:FindFirstChild(itemName)
	if directObj and (directObj:IsA("ValueBase") or pcall(function() return directObj.Value end)) then
		return directObj.Value
	end
	
	local basicObj = statsFolder:FindFirstChild("Basic")
	if basicObj then
		if basicObj.Name == itemName and (basicObj:IsA("ValueBase") or pcall(function() return basicObj.Value end)) then
			return basicObj.Value
		end
		local innerObj = basicObj:FindFirstChild(itemName)
		if innerObj and (innerObj:IsA("ValueBase") or pcall(function() return innerObj.Value end)) then
			return innerObj.Value
		end
	end
	
	return nil
end

SpyBtn.MouseButton1Click:Connect(function()
	ClearStatus()
	
	local searchText = SearchBox.Text
	if searchText == "" then
		TargetInfoLabel.Text = "Please enter a name!"
		TargetInfoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	local targetPlayer = FindPlayer(searchText)
	if not targetPlayer then
		TargetInfoLabel.Text = "Player not found!"
		TargetInfoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	TargetInfoLabel.Text = string.format("%s (@%s)", targetPlayer.DisplayName, targetPlayer.Name)
	TargetInfoLabel.TextColor3 = Color3.fromRGB(0, 220, 130)
	
	-- Build List according to ListStructure order
	for orderIndex, element in ipairs(ListStructure) do
		if element.type == "MainSection" then
			CreateMainSectionRow(element.title, orderIndex)
		elseif element.type == "Section" then
			CreateSubSectionRow(element.title, orderIndex)
		elseif element.type == "Item" then
			local val = GetValueFromStats(targetPlayer, element.name)
			CreateItemRow(element.name, val or 0, orderIndex)
		end
	end
	
	-- Apply current search filter if active
	local filterText = ItemSearchBox.Text:lower()
	if filterText ~= "" then
		for _, row in pairs(StatusScroll:GetChildren()) do
			if row:IsA("Frame") then
				if row.Name:sub(1, 7) == "Header_" then
					row.Visible = true
				else
					row.Visible = row.Name:lower():find(filterText, 1, true) ~= nil
				end
			end
		end
	end
end)
