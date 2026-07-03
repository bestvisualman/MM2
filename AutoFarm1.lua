-- AutoFarm v1 mm2 by meentoz (Summer Edition)

local ScreenGui = Instance.new("ScreenGui")
local player = game:GetService("Players").LocalPlayer
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local SummerButton = Instance.new("TextButton")
SummerButton.Name = "SummerButton"
SummerButton.Size = UDim2.new(0, 60, 0, 60)
SummerButton.Position = UDim2.new(0, 400, 0.1, -85)
SummerButton.BackgroundColor3 = Color3.fromRGB(255, 160, 70)
SummerButton.Text = "☀️"
SummerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SummerButton.Font = Enum.Font.GothamBold
SummerButton.TextSize = 32
SummerButton.AutoButtonColor = false
SummerButton.Parent = ScreenGui

local SummerButtonGradient = Instance.new("UIGradient")
SummerButtonGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 205, 115)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 155, 60))
}
SummerButtonGradient.Rotation = 45
SummerButtonGradient.Parent = SummerButton

local SummerCorner = Instance.new("UICorner")
SummerCorner.CornerRadius = UDim.new(1, 0)
SummerCorner.Parent = SummerButton

local SummerStroke = Instance.new("UIStroke")
SummerStroke.Color = Color3.fromRGB(255, 240, 160)
SummerStroke.Thickness = 3
SummerStroke.Transparency = 0
SummerStroke.LineJoinMode = Enum.LineJoinMode.Round
SummerStroke.Parent = SummerButton

local SummerButtonScale = Instance.new("UIScale")
SummerButtonScale.Scale = 1
SummerButtonScale.Parent = SummerButton

local guiVisible = false
local tweenService = game:GetService("TweenService")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainUI"
MainFrame.Size = UDim2.new(0, 300, 0, 500)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(131, 197, 190) -- Морской
MainFrame.Parent = ScreenGui
MainFrame.BackgroundTransparency = 0.25
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local MainFrameScale = Instance.new("UIScale")
MainFrameScale.Scale = 0.85
MainFrameScale.Parent = MainFrame

local SummerBackground = Instance.new("Frame")
SummerBackground.Name = "SummerBackground"
SummerBackground.Size = UDim2.new(1, 0, 1, 0)
SummerBackground.BackgroundTransparency = 1
SummerBackground.Parent = MainFrame
SummerBackground.ZIndex = 0

local summerItems = {"☀️","🏖️","🌴","🍉","🍦","🍹","🐚","😎","🐠","🌊","🍓","🌺","🩴","🍍"}
local summerItemsCollection = {}

-- Функция создания летнего предмета
local function createSummerItem()
	local item = Instance.new("TextLabel")
	item.Name = "SummerItem"
	item.Size = UDim2.new(0, 22, 0, 22)
	
	item.Position = UDim2.new(
		math.random() * 0.9,
		0,
		0,
		0
	)
	
	item.Text = summerItems[math.random(1, #summerItems)]
	-- Летние сочные цвета для разнообразия
	local colors = {
		Color3.fromRGB(255, 179, 71), -- Оранжевый
		Color3.fromRGB(255, 234, 153), -- Желтый
		Color3.fromRGB(143, 201, 171), -- Морской
		Color3.fromRGB(176, 224, 230), -- Лазурный
		Color3.fromRGB(255, 160, 122), -- Персиковый
		Color3.fromRGB(255, 255, 204), -- Светло-желтый
	}
	item.TextColor3 = colors[math.random(1, #colors)]
	item.TextTransparency = math.random(10, 40) / 100
	item.Font = Enum.Font.Gotham
	item.TextSize = math.random(16, 30)
	item.BackgroundTransparency = 1
	item.Parent = SummerBackground
	item.ZIndex = 0
	
	local speed = math.random(25, 55) / 100
	local rotationSpeed = math.random(-120, 120) / 10
	
	coroutine.wrap(function()
		while item.Parent do
			local currentY = item.Position.Y.Scale
			item.Position = UDim2.new(
				item.Position.X.Scale,
				item.Position.X.Offset,
				currentY + 0.009 * speed,
				item.Position.Y.Offset
			)
			
			item.Rotation = item.Rotation + rotationSpeed
			
			if currentY > 0.9 then
				item:Destroy()
				for i, v in ipairs(summerItemsCollection) do
					if v == item then
						table.remove(summerItemsCollection, i)
						break
					end
				end
				createSummerItem()
				break
			end
			
			wait(0.03)
		end
	end)()

	table.insert(summerItemsCollection, item)
	return item
end

for i = 1, 12 do
	createSummerItem()
	wait(0.1)
end

coroutine.wrap(function()
	while SummerBackground.Parent do
		wait(2)
		if #summerItemsCollection < 18 then
			createSummerItem()
		end
	end
end)()

local summerButtonPosition = SummerButton.Position
local Title

local function openGUI()
	guiVisible = true
	
	MainFrame.Position = summerButtonPosition
	MainFrame.Rotation = -12
	MainFrame.BackgroundTransparency = 1
	Title.TextTransparency = 1
	MainFrame.Visible = true
	
	local openTween = tweenService:Create(
		MainFrame,
		TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0.5, -150, 0.5, -250),
			Rotation = 0,
			BackgroundTransparency = 0.25
		}
	)
	
	local scaleTween = tweenService:Create(
		MainFrame:FindFirstChildOfClass("UIScale"),
		TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Scale = 1}
	)
	
	local titleTween = tweenService:Create(
		Title,
		TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{TextTransparency = 0}
	)
	
	local buttonSpin = tweenService:Create(
		SummerButton,
		TweenInfo.new(0.55, Enum.EasingStyle.Quad),
		{Rotation = 360}
	)
	
	openTween:Play()
	scaleTween:Play()
	titleTween:Play()
	buttonSpin:Play()
	
	print("Summer menu открывается")
end

local function closeGUI()
	guiVisible = false
	
	local closeTween = tweenService:Create(
		MainFrame,
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{
			Rotation = -12,
			BackgroundTransparency = 1
		}
	)
	
	local scaleTween = tweenService:Create(
		MainFrame:FindFirstChildOfClass("UIScale"),
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{Scale = 0.85}
	)
	
	local titleFade = tweenService:Create(
		Title,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{TextTransparency = 1}
	)
	
	local buttonSpin = tweenService:Create(
		SummerButton,
		TweenInfo.new(0.35, Enum.EasingStyle.Quad),
		{Rotation = 0}
	)
	
	closeTween:Play()
	scaleTween:Play()
	titleFade:Play()
	buttonSpin:Play()
	
	print("GUI закрывается...")
	
	task.wait(0.45)
	MainFrame.Visible = false
end

SummerButton.MouseButton1Click:Connect(function()
	print("Лето нажато! Состояние GUI:", guiVisible)
	
	if not guiVisible then
		openGUI()
	else
		closeGUI()
	end
end)

-- Добавляем поддержку касания для кнопки
SummerButton.TouchTap:Connect(function()
    SummerButton.MouseButton1Click:Fire()
end)

SummerButton.MouseEnter:Connect(function()
	tweenService:Create(SummerButtonScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.08}):Play()
end)

SummerButton.MouseLeave:Connect(function()
	tweenService:Create(SummerButtonScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
end)

SummerButton.MouseButton1Down:Connect(function()
	tweenService:Create(SummerButtonScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.92}):Play()
end)

SummerButton.MouseButton1Up:Connect(function()
	tweenService:Create(SummerButtonScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.02}):Play()
	task.delay(0.08, function()
		tweenService:Create(SummerButtonScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
	end)
end)

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 15)

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(255, 215, 0) -- Золотой
UIStroke.Thickness = 4
UIStroke.Transparency = 0
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(172, 233, 227)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 218, 209))
}
MainGradient.Rotation = 90
MainGradient.Parent = MainFrame

Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 0, 50)
Title.Position = UDim2.new(0, 20, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "☀️ Summer AutoFarm MM2 🏖️"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = MainFrame

local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Size = UDim2.new(0, 35, 0, 30)
Version.Position = UDim2.new(1, -40, 0, 45)
Version.BackgroundTransparency = 1
Version.Text = "v1"
Version.TextColor3 = Color3.fromRGB(255, 215, 0)
Version.Font = Enum.Font.GothamBold
Version.TextSize = 16
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.Parent = MainFrame

local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(1, 0, 0, 2)
Divider.Position = UDim2.new(0, 0, 0, 80)
Divider.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local workspace = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer

local autoFarmEnabled = false
local autoResetEnabled = false
local farmSpeed = 20
local farming = false
local bag_full = false
local resetting = false
local start_position = nil

local CoinCollected, RoundStart, RoundEnd
pcall(function()
	CoinCollected = ReplicatedStorage.Remotes.Gameplay.CoinCollected
	RoundStart = ReplicatedStorage.Remotes.Gameplay.RoundStart
	RoundEnd = ReplicatedStorage.Remotes.Gameplay.RoundEndFade
end)

-- Если RemoteEvents не найдены, создаем заглушки
if not CoinCollected then
	warn("⚠️ RemoteEvents не найдены! AutoFarm может не работать.")
end

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
		print("Раунд начался, farming = true")
	end)
end

if RoundEnd then
	RoundEnd.OnClientEvent:Connect(function()
		farming = false
		print("Раунд окончен, farming = false")
	end)
end

if CoinCollected then
	CoinCollected.OnClientEvent:Connect(function(_, current, max)
		if current == max and not resetting and autoResetEnabled then
			print("Сумка заполнена! Запускаем Reset...")
			resetting = true
			bag_full = true
			local hrp = getHRP()
			if start_position then
				local tween = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = start_position})
				tween:Play()
				tween.Completed:Wait()
			end
			wait(0.5)
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.Health = 0
			end
			player.CharacterAdded:Wait()
			wait(1.5)
			resetting = false
			bag_full = false
			print("Reset завершен")
		end
	end)
end

if RoundStart then
	RoundStart.OnClientEvent:Connect(function()
		if player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				start_position = hrp.CFrame
				print("Стартовая позиция сохранена")
			end
		end
	end)
end

local autoFarmCoroutine = nil
local function startAutoFarm()
	if autoFarmCoroutine then 
		autoFarmCoroutine = nil
	end
	
	print("🚀 AutoFarm ВКЛЮЧЕН! Скорость: " .. farmSpeed)
	autoFarmEnabled = true
	
	autoFarmCoroutine = coroutine.wrap(function()
		while autoFarmEnabled do
			if farming and not bag_full then
				local coin, dist = get_nearest_coin()
				if coin and player.Character then
					local hrp = player.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						if dist > 150 then
							hrp.CFrame = coin.CFrame
						else
							local tween = TweenService:Create(hrp, TweenInfo.new(dist / farmSpeed, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
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
		print("AutoFarm OFF")
	end)
	
	autoFarmCoroutine()
end

local function stopAutoFarm()
	autoFarmEnabled = false
	autoFarmCoroutine = nil
	print("AutoFarm ВЫКЛЮЧЕН")
end

local function createModernToggle(name, text, position, defaultValue)
	-- Контейнер
	local ToggleContainer = Instance.new("Frame")
	ToggleContainer.Name = name .. "Toggle"
	ToggleContainer.Size = UDim2.new(1, -40, 0, 40)
	ToggleContainer.Position = position
	ToggleContainer.BackgroundTransparency = 1
	ToggleContainer.Active = true
	ToggleContainer.Parent = MainFrame
	
	local Background = Instance.new("Frame")
	Background.Name = "Background"
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.BackgroundColor3 = Color3.fromRGB(167, 235, 221)
	Background.BackgroundTransparency = 0.4
	Background.Active = true
	Background.Parent = ToggleContainer
	
	local BackgroundCorner = Instance.new("UICorner")
	BackgroundCorner.CornerRadius = UDim.new(0, 8)
	BackgroundCorner.Parent = Background
	
	local BackgroundStroke = Instance.new("UIStroke")
	BackgroundStroke.Color = Color3.fromRGB(255, 215, 0)
	BackgroundStroke.Thickness = 1
	BackgroundStroke.Parent = Background
	
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "Text"
	TextLabel.Size = UDim2.new(0.7, 0, 1, 0)
	TextLabel.Position = UDim2.new(0, 15, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = text
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.Gotham
	TextLabel.TextSize = 21
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Active = true
	TextLabel.Parent = ToggleContainer
	
	local ToggleSwitch = Instance.new("Frame")
	ToggleSwitch.Name = "Switch"
	ToggleSwitch.Size = UDim2.new(0, 60, 0, 30)
	ToggleSwitch.Position = UDim2.new(1, -30, 1, -20)
	ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
	ToggleSwitch.BackgroundColor3 = defaultValue and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(124, 124, 124)
	ToggleSwitch.Active = true
	ToggleSwitch.Parent = ToggleContainer
	
	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(0, 15)
	SwitchCorner.Parent = ToggleSwitch
	
	local SwitchStroke = Instance.new("UIStroke")
	SwitchStroke.Color = Color3.fromRGB(255, 240, 200)
	SwitchStroke.Thickness = 1
	SwitchStroke.Transparency = 0.3
	SwitchStroke.Parent = ToggleSwitch
	
	local ToggleSlider = Instance.new("Frame")
	ToggleSlider.Name = "Slider"
	ToggleSlider.Size = UDim2.new(0, 26, 0, 26)
	ToggleSlider.Position = defaultValue and UDim2.new(1, -28, 1, -10) or UDim2.new(1, 2, 1, -10)
	ToggleSlider.AnchorPoint = Vector2.new(0, 0)
	ToggleSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ToggleSlider.Parent = ToggleSwitch
	
	local SliderCorner = Instance.new("UICorner")
	SliderCorner.CornerRadius = UDim.new(1, 0)
	SliderCorner.Parent = ToggleSlider
	
	local isEnabled = defaultValue
	
	local function toggleState()
		isEnabled = not isEnabled
		
		game:GetService("TweenService"):Create(
			ToggleSwitch,
			TweenInfo.new(0.2),
			{BackgroundColor3 = isEnabled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(124, 124, 124)}
		):Play()
		
		game:GetService("TweenService"):Create(
			ToggleSlider,
			TweenInfo.new(0.2),
			{Position = isEnabled and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)}
		):Play()
		
		print(text .. ": " .. (isEnabled and "ВКЛЮЧЕНО" or "ВЫКЛЮЧЕНО"))
		return isEnabled
	end
	
	
	if not defaultValue then
		ToggleSwitch.BackgroundColor3 = Color3.fromRGB(124, 124, 124)
		ToggleSlider.Position = UDim2.new(0, 2, 0.5, -13)
	else
		ToggleSwitch.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		ToggleSlider.Position = UDim2.new(1, -28, 0.5, -13)
	end
	
	-- СОЗДАЕМ ПРОЗРАЧНУЮ КНОПКУ ПОВЕРХ ВСЕГО (ФИКС ДЛЯ ТЕЛЕФОНА)
	local Hitbox = Instance.new("TextButton")
	Hitbox.Name = "Hitbox"
	Hitbox.Size = UDim2.new(1, 0, 1, 0)
	Hitbox.BackgroundTransparency = 1
	Hitbox.Text = ""
	Hitbox.Parent = ToggleContainer
	Hitbox.ZIndex = 10
	Hitbox.AutoButtonColor = false
	
	-- Обработка нажатия (для мыши)
	Hitbox.MouseButton1Click:Connect(function()
		local newState = toggleState()
		
		if name == "FarmCoins" then
			if newState then
				startAutoFarm()
			else
				stopAutoFarm()
			end
		elseif name == "Reset" then
			autoResetEnabled = newState
			print("Auto Reset: " .. (autoResetEnabled and "ON" or "OFF"))
		elseif name == "AntiAfk" then
			if newState then
				local VirtualUser = game:GetService("VirtualUser")
				player.Idled:Connect(function()
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
				end)
				print("Anti-AFK ON")
			else
				print("Anti-AFK OFF")
			end
		end
	end)
	
	-- Для телефона
	Hitbox.TouchTap:Connect(function()
		Hitbox.MouseButton1Click:Fire()
	end)
	
	-- Эффекты наведения
	ToggleContainer.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(
			Background,
			TweenInfo.new(0.2),
			{BackgroundTransparency = 0.2}
		):Play()
	end)
	
	ToggleContainer.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(
			Background,
			TweenInfo.new(0.2),
			{BackgroundTransparency = 0.4}
		):Play()
	end)
	
	return {Container = ToggleContainer, toggleFunction = toggleState, isEnabled = function() return isEnabled end}
end


local toggleList = {
	{"FarmCoins", "🏖️ AutoFarm", UDim2.new(0, 20, 0, 100), false},
	{"Reset", "🌊 Reset FullBag", UDim2.new(0, 20, 0, 160), false},
	{"AntiAfk", "😎 AntiAfk", UDim2.new(0, 20, 0, 220), false},
}


local toggles = {}


for i, toggleData in ipairs(toggleList) do
	local name, text, position, defaultValue = toggleData[1], toggleData[2], toggleData[3], toggleData[4]
	local toggle = createModernToggle(name, text, position, defaultValue)
	toggles[name] = toggle
end


local SpeedContainer = Instance.new("Frame")
SpeedContainer.Name = "SpeedToggle"
SpeedContainer.Size = UDim2.new(1, -40, 0, 40)
SpeedContainer.Position = UDim2.new(0, 20, 0, 280)
SpeedContainer.BackgroundTransparency = 1
SpeedContainer.Active = true
SpeedContainer.Parent = MainFrame


local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(167, 235, 221)
Background.BackgroundTransparency = 0.4
Background.Active = true
Background.Parent = SpeedContainer

local BackgroundCorner = Instance.new("UICorner")
BackgroundCorner.CornerRadius = UDim.new(0, 8)
BackgroundCorner.Parent = Background

local BackgroundStroke = Instance.new("UIStroke")
BackgroundStroke.Color = Color3.fromRGB(255, 215, 0)
BackgroundStroke.Thickness = 1
BackgroundStroke.Parent = Background


local SpeedTextLabel = Instance.new("TextLabel")
SpeedTextLabel.Name = "Text"
SpeedTextLabel.Size = UDim2.new(0.7, 0, 1, 0)
SpeedTextLabel.Position = UDim2.new(0, 15, 0, 0)
SpeedTextLabel.BackgroundTransparency = 1
SpeedTextLabel.Text = "🌸 Farm Speed: " .. farmSpeed
SpeedTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextLabel.Font = Enum.Font.Gotham
SpeedTextLabel.TextSize = 21
SpeedTextLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedTextLabel.Active = true
SpeedTextLabel.Parent = SpeedContainer


local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Size = UDim2.new(0, 60, 0, 30)
SpeedInput.Position = UDim2.new(1, -15, 0.9, -15)
SpeedInput.AnchorPoint = Vector2.new(1, 0.5)
SpeedInput.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.TextSize = 16
SpeedInput.Text = tostring(farmSpeed)
SpeedInput.PlaceholderText = "Speed"
SpeedInput.Parent = SpeedContainer

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = SpeedInput

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(255, 240, 200)
InputStroke.Thickness = 1
InputStroke.Transparency = 0.3
InputStroke.Parent = SpeedInput


SpeedInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local newSpeed = tonumber(SpeedInput.Text)
		if newSpeed and newSpeed >= 5 and newSpeed <= 100 then
			farmSpeed = newSpeed
			SpeedTextLabel.Text = "🌸 Farm Speed: " .. farmSpeed
			print("Скорость AutoFarm изменена на: " .. farmSpeed)
			
			SpeedInput.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
			wait(0.3)
			SpeedInput.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		else
			SpeedInput.Text = tostring(farmSpeed)
			SpeedInput.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			print("Ошибка! Скорость должна быть от 5 до 100")
			wait(0.3)
			SpeedInput.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		end
	end
end)


SpeedContainer.MouseEnter:Connect(function()
	game:GetService("TweenService"):Create(
		Background,
		TweenInfo.new(0.2),
		{BackgroundTransparency = 0.2}
	):Play()
end)

SpeedContainer.MouseLeave:Connect(function()
	game:GetService("TweenService"):Create(
		Background,
		TweenInfo.new(0.2),
		{BackgroundTransparency = 0.4}
	):Play()
end)


local TimeCounter = Instance.new("TextLabel")
TimeCounter.Name = "TimeCounter"
TimeCounter.Size = UDim2.new(1, -40, 0, 30)
TimeCounter.Position = UDim2.new(0, 20, 1, -35)
TimeCounter.BackgroundColor3 = Color3.fromRGB(216, 191, 216)
TimeCounter.BackgroundTransparency = 0.3
TimeCounter.Text = "Time Farm: 00:00:00"
TimeCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeCounter.Font = Enum.Font.Gotham
TimeCounter.TextSize = 20
TimeCounter.TextXAlignment = Enum.TextXAlignment.Center
TimeCounter.Parent = MainFrame

local TimeCorner = Instance.new("UICorner")
TimeCorner.CornerRadius = UDim.new(0, 8)
TimeCorner.Parent = TimeCounter

local TimeStroke = Instance.new("UIStroke")
TimeStroke.Color = Color3.fromRGB(255, 215, 0)
TimeStroke.Thickness = 2
TimeStroke.Parent = TimeCounter


local startTime = tick()
local function updateTime()
	while TimeCounter.Parent do
		local elapsed = tick() - startTime
		local hours = math.floor(elapsed / 3600)
		local minutes = math.floor((elapsed % 3600) / 60)
		local seconds = math.floor(elapsed % 60)
		
		TimeCounter.Text = string.format("Time Farm: %02d:%02d:%02d", hours, minutes, seconds)
		wait(1)
	end
end


coroutine.wrap(updateTime)()

coroutine.wrap(function()
	while true do
		if autoFarmEnabled and farming then
			print("farming=" .. tostring(farming))
		end
		wait(5)
	end
end)()
