-- MM2 Xmas Hub AutoFarm
-- Меню стилизовано под скриншот

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XmasHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 460)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(119, 194, 225)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 28)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(176, 241, 239)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 201, 228))
}
MainGradient.Rotation = 90
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.7
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 118)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(255, 213, 149)
Header.BorderSizePixel = 0
Header.Active = true
Header.Selectable = true
Header.Parent = MainFrame

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 248, 180)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 223, 123)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 191, 90))
}
HeaderGradient.Rotation = 90
HeaderGradient.Parent = Header

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 24)
HeaderCorner.Parent = Header

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateDrag(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Header.InputBegan:Connect(function(input)
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

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -24, 0, 40)
TitleLabel.Position = UDim2.new(0, 18, 0, 18)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SUMMER Auotfarm"
TitleLabel.TextColor3 = Color3.fromRGB(34, 64, 92)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local SubLabel = Instance.new("TextLabel")
SubLabel.Name = "SubLabel"
SubLabel.Size = UDim2.new(1, -24, 0, 22)
SubLabel.Position = UDim2.new(0, 18, 0, 62)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "☀️ SUMMER EDITION ☀️"
SubLabel.TextColor3 = Color3.fromRGB(60, 114, 124)
SubLabel.Font = Enum.Font.GothamSemibold
SubLabel.TextSize = 16
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = Header

local function createRow(iconEmoji, text, posY)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -28, 0, 58)
	row.Position = UDim2.new(0, 14, 0, posY)
	row.BackgroundColor3 = Color3.fromRGB(255, 247, 229)
	row.BorderSizePixel = 0
	row.Active = true
	row.Selectable = true
	row.Parent = MainFrame

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 18)
	rowCorner.Parent = row

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 38, 0, 38)
	icon.Position = UDim2.new(0, 16, 0, 10)
	icon.BackgroundColor3 = Color3.fromRGB(92, 204, 170)
	icon.BorderSizePixel = 0
	icon.Text = iconEmoji
	icon.TextSize = 24
	icon.TextColor3 = Color3.fromRGB(255, 255, 255)
	icon.Font = Enum.Font.GothamBold
	icon.Parent = row

	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(1, 0)
	iconCorner.Parent = icon

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -110, 0, 38)
	label.Position = UDim2.new(0, 70, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(33, 92, 103)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local statusDot = Instance.new("Frame")
	statusDot.Name = "StatusDot"
	statusDot.Size = UDim2.new(0, 16, 0, 16)
	statusDot.Position = UDim2.new(1, -24, 0, 21)
	statusDot.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
	statusDot.BorderSizePixel = 0
	statusDot.Parent = row

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = statusDot

	return row, statusDot
end

local autoFarmRow, autoFarmDot = createRow("🏖️", "AUTO FARM", 138)
local antiAfkRow, antiAfkDot = createRow("🍉", "ANTI-AFK", 210)

local speedRatio = 31

autoFarmRow.Name = "AutoFarmRow"
autoFarmRow.Active = true

autoFarmRow.Selectable = true

antiAfkRow.Name = "AntiAfkRow"
antiAfkRow.Active = true
antiAfkRow.Selectable = true

local StatsFrame = Instance.new("Frame")
StatsFrame.Name = "StatsFrame"
StatsFrame.Size = UDim2.new(1, -28, 0, 144)
StatsFrame.Position = UDim2.new(0, 14, 0, 364)
StatsFrame.BackgroundColor3 = Color3.fromRGB(69, 171, 214)
StatsFrame.BorderSizePixel = 0
StatsFrame.Parent = MainFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 18)
statsCorner.Parent = StatsFrame

local function createStatLine(iconText, titleText, valueText, posY)
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -12, 0, 28)
	line.Position = UDim2.new(0, 6, 0, posY)
	line.BackgroundTransparency = 1
	line.ClipsDescendants = true
	line.Parent = StatsFrame

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 20, 0, 20)
	icon.Position = UDim2.new(0, 0, 0, 4)
	icon.BackgroundTransparency = 1
	icon.Text = iconText
	icon.TextColor3 = Color3.fromRGB(255, 220, 120)
	icon.Font = Enum.Font.GothamBold
	icon.TextSize = 16
	icon.Parent = line

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.33, 0, 1, 0)
	title.Position = UDim2.new(0, 28, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.TextColor3 = Color3.fromRGB(245, 245, 245)
	title.Font = Enum.Font.Gotham
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Parent = line

	local value = Instance.new("TextLabel")
	value.Name = "Value"
	value.Size = UDim2.new(0.56, 0, 1, 0)
	value.Position = UDim2.new(1, -8, 0, 0)
	value.AnchorPoint = Vector2.new(1, 0)
	value.BackgroundTransparency = 1
	value.Text = valueText
	value.TextColor3 = Color3.fromRGB(255, 255, 255)
	value.Font = Enum.Font.GothamBold
	value.TextSize = 14
	value.TextXAlignment = Enum.TextXAlignment.Right
	value.TextTruncate = Enum.TextTruncate.AtEnd
	value.Parent = line

	return value
end

local coinsPerHourLabel = createStatLine("💰", "Coins/Hour:", "0", 14)
local timeLabel = createStatLine("⏱️", "Time:", "00:00:00", 44)
local collectedLabel = createStatLine("🎁", "Collected:", "0", 74)

local autoFarmEnabled = false
local antiAfkEnabled = false
local farming = false
local coinsCollected = 0
local startTime = tick()
local autoFarmCoroutine = nil

local function resetAfterFullBag()
	coinsCollected = 0
	collectedLabel.Text = "0"
	startTime = tick()
end

local CoinCollected, RoundStart, RoundEnd
pcall(function()
	CoinCollected = ReplicatedStorage.Remotes.Gameplay.CoinCollected
	RoundStart = ReplicatedStorage.Remotes.Gameplay.RoundStart
	RoundEnd = ReplicatedStorage.Remotes.Gameplay.RoundEndFade
end)

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
	local char = getCharacter()
	return char:WaitForChild("HumanoidRootPart")
end

local function get_nearest_coin()
	local hrp = getHRP()
	if not hrp then return nil, math.huge end

	local closest, dist = nil, math.huge
	for _, m in pairs(workspace:GetChildren()) do
		if m:FindFirstChild("CoinContainer") then
			for _, coin in pairs(m.CoinContainer:GetChildren()) do
				if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
					local d = (hrp.Position - coin.Position).Magnitude
					if d < dist then
						closest, dist = coin, d
					end
				end
			end
		end
	end

	return closest, dist
end

if RoundStart then
	RoundStart.OnClientEvent:Connect(function()
		farming = true
		print("Раунд начался")
	end)
end

if RoundEnd then
	RoundEnd.OnClientEvent:Connect(function()
		farming = false
		print("Раунд окончен")
	end)
end

if CoinCollected then
	CoinCollected.OnClientEvent:Connect(function(_, current, max)
		if autoFarmEnabled and farming then
			coinsCollected = coinsCollected + 1
			collectedLabel.Text = tostring(coinsCollected)
		end
		if current and max and current >= max then
			print("Full bag detected, resetting stats")
			resetAfterFullBag()
		end
	end)
end

local function updateStats()
	local elapsed = math.max(0, tick() - startTime)
	local hours = math.floor(elapsed / 3600)
	local minutes = math.floor((elapsed % 3600) / 60)
	local seconds = math.floor(elapsed % 60)
	local perHour = 0
	if elapsed > 0 then
		perHour = math.floor(coinsCollected / elapsed * 3600)
	end
	coinsPerHourLabel.Text = tostring(perHour)
	timeLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

coroutine.wrap(function()
	while true do
		updateStats()
		wait(1)
	end
end)()

local function setStatus(dot, enabled)
	dot.BackgroundColor3 = enabled and Color3.fromRGB(80, 200, 100) or Color3.fromRGB(198, 198, 198)
end

local function stopAutoFarm()
	autoFarmEnabled = false
	if autoFarmCoroutine then
		autoFarmCoroutine = nil
	end
	setStatus(autoFarmDot, false)
	print("AutoFarm OFF")
end

local function startAutoFarm()
	if autoFarmCoroutine then
		autoFarmCoroutine = nil
	end
	coinsCollected = 0
	collectedLabel.Text = "0"
	startTime = tick()
	autoFarmEnabled = true
	setStatus(autoFarmDot, true)

	autoFarmCoroutine = coroutine.wrap(function()
		while autoFarmEnabled do
			if farming then
				local coin, dist = get_nearest_coin()
				if coin and player.Character then
					local hrp = player.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						if dist > 150 then
							hrp.CFrame = coin.CFrame
						else
							local tween = TweenService:Create(hrp, TweenInfo.new(dist / speedRatio, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
							tween:Play()
							repeat
								wait()
							until not coin:FindFirstChild("TouchInterest") or not farming or not autoFarmEnabled or not hrp.Parent
							tween:Cancel()
						end
					end
				end
			end
			wait(0.2)
		end
	end)

	autoFarmCoroutine()
	print("AutoFarm ON")
end

local function setAntiAfk(enabled)
	antiAfkEnabled = enabled
	setStatus(antiAfkDot, enabled)
	if enabled then
		player.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
		print("AntiAFK ON")
	else
		print("AntiAFK OFF")
	end
end

local function bindRow(frame, callback)
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			callback()
		end
	end)
end

bindRow(autoFarmRow, function()
	autoFarmEnabled = not autoFarmEnabled
	if autoFarmEnabled then
		startAutoFarm()
	else
		stopAutoFarm()
	end
end)

bindRow(antiAfkRow, function()
	setAntiAfk(not antiAfkEnabled)
end)

setStatus(autoFarmDot, false)
setStatus(antiAfkDot, false)

-- Первичный стиль плавного появления
MainFrame.BackgroundTransparency = 1
Header.BackgroundTransparency = 1
StatsFrame.BackgroundTransparency = 1
for _, child in ipairs(MainFrame:GetChildren()) do
	if child:IsA("TextLabel") then
		child.TextTransparency = 1
	end
end

local appear = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
appear:Play()
for _, child in ipairs(MainFrame:GetChildren()) do
	if child:IsA("TextLabel") then
		TweenService:Create(child, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	end
end
