local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local InventoryRemotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Inventory")

local ProfileData = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProfileData"))
local EventInfoService = require(ReplicatedStorage:WaitForChild("SharedServices"):WaitForChild("EventInfoService"))
local ItemPopupService = require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("ItemPopupService"))
local UpdateDataClient = ReplicatedStorage:FindFirstChild("UpdateDataClient")

EventInfoService:WaitForInitializedAsync()

local mainEvent = EventInfoService:GetMainEvent()
if not mainEvent or not mainEvent.EventStartInfo or not mainEvent.EventStartInfo.Quests then
    warn("ManualRewardsUnlocker: main event quests not found")
    return
end

local eventTitle = mainEvent.Title
local questDefinitions = mainEvent.EventStartInfo.Quests
local eventProfile = ProfileData[eventTitle]

if not eventProfile then
    warn("ManualRewardsUnlocker: missing profile for", eventTitle)
    return
end

eventProfile.Quests = eventProfile.Quests or {}
eventProfile.LocalQuestClaims = eventProfile.LocalQuestClaims or {}

local stackableCategories = {
    Weapons = true,
    Pets = true,
    Materials = true
}

local function fireInventoryChanged(category, itemId, amount)
    local bindable = InventoryRemotes:FindFirstChild("InventoryDataChanged")

    if bindable and bindable.Fire then
        bindable:Fire(category, itemId, amount)
    end

    if UpdateDataClient and UpdateDataClient.Fire then
        UpdateDataClient:Fire(false, ProfileData)
    end
end

local function ensureQuestState(questId)
    eventProfile.Quests[questId] = eventProfile.Quests[questId] or { Progress = 0 }
    eventProfile.Quests[questId].Progress = eventProfile.Quests[questId].Progress or 0
    return eventProfile.Quests[questId]
end

local function ensureClaimState(questId)
    eventProfile.LocalQuestClaims[questId] = eventProfile.LocalQuestClaims[questId] or {}
    return eventProfile.LocalQuestClaims[questId]
end

local function getQuestMilestones(questId)
    local questInfo = questDefinitions[questId]
    local milestones = {}

    for _, stage in ipairs((questInfo and questInfo.Quests) or {}) do
        table.insert(milestones, stage.ChallengeAmount or 0)
    end

    table.sort(milestones)
    return milestones
end

local function getQuestMaxProgress(questId)
    local milestones = getQuestMilestones(questId)
    return milestones[#milestones] or 0
end

local function getQuestProgressRatio(questId)
    local questState = ensureQuestState(questId)
    local maxProgress = getQuestMaxProgress(questId)

    if maxProgress <= 0 then
        return 0
    end

    return math.clamp(questState.Progress / maxProgress, 0, 1)
end

local function findNativeQuestFrame(questId)
    for _, instance in ipairs(PlayerGui:GetDescendants()) do
        if instance:IsA("Frame") and instance.Name == questId and instance.Visible then
            local scrollingFrame = instance:FindFirstChild("ScrollingFrame")
            if scrollingFrame and scrollingFrame:FindFirstChild("QuestFrame") then
                return instance
            end
        end
    end

    for _, instance in ipairs(PlayerGui:GetDescendants()) do
        if instance:IsA("Frame") and instance.Name == questId then
            local scrollingFrame = instance:FindFirstChild("ScrollingFrame")
            if scrollingFrame and scrollingFrame:FindFirstChild("QuestFrame") then
                return instance
            end
        end
    end

    return nil
end

local function getVisibleQuestId()
    for questId in pairs(questDefinitions) do
        local nativeFrame = findNativeQuestFrame(questId)
        if nativeFrame and nativeFrame.Visible then
            return questId
        end
    end

    local fallback
    for questId in pairs(questDefinitions) do
        if not fallback then
            fallback = questId
        end
    end

    return fallback
end

local function refreshNativeQuestFrame(questId)
    local nativeFrame = findNativeQuestFrame(questId)
    local questInfo = questDefinitions[questId]

    if not nativeFrame or not questInfo then
        return
    end

    local questState = ensureQuestState(questId)
    local claimState = ensureClaimState(questId)
    local ratio = getQuestProgressRatio(questId)
    local mainFrame = nativeFrame:FindFirstChild("ScrollingFrame")
        and nativeFrame.ScrollingFrame:FindFirstChild("QuestFrame")
        and nativeFrame.ScrollingFrame.QuestFrame:FindFirstChild("Main")

    if not mainFrame then
        return
    end

    local progressRoot = mainFrame:FindFirstChild("Progress")
        and mainFrame.Progress:FindFirstChild("Progress")
        and mainFrame.Progress.Progress:FindFirstChild("Progress")

    if progressRoot then
        local current = progressRoot:FindFirstChild("Current")
        local container = progressRoot:FindFirstChild("Container")

        if current then
            current.Position = UDim2.fromScale(ratio, 0.5)
            local amountLabel = current:FindFirstChild("AmountLabel")
            if amountLabel and amountLabel:IsA("TextLabel") then
                amountLabel.Text = tostring(questState.Progress)
            end
        end

        if container then
            local bar = container:FindFirstChild("Bar")
            local activeColor = bar and bar.BackgroundColor3 or Color3.fromRGB(66, 148, 255)
            local inactiveColor = container.BackgroundColor3

            if bar then
                bar.Size = UDim2.fromScale(ratio, 1)
            end

            for index, stage in ipairs(questInfo.Quests or {}) do
                local reached = questState.Progress >= (stage.ChallengeAmount or 0)
                local checkpoint = container:FindFirstChild("Checkpoint" .. tostring(index))
                local checkpointBackground = container:FindFirstChild("CheckpointBackground" .. tostring(index))

                if checkpoint and checkpoint:IsA("Frame") then
                    checkpoint.BackgroundColor3 = reached and activeColor or inactiveColor
                end

                if checkpointBackground and checkpointBackground:IsA("Frame") then
                    checkpointBackground.BackgroundColor3 = inactiveColor
                    local stroke = checkpointBackground:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Color = inactiveColor
                    end
                end
            end
        end
    end

    local rewardsFrame = mainFrame:FindFirstChild("Rewards")
    if rewardsFrame then
        for index, stage in ipairs(questInfo.Quests or {}) do
            local rewardFrame = rewardsFrame:FindFirstChild("Reward" .. tostring(index))
            if rewardFrame then
                local claimedMarker = rewardFrame:FindFirstChild("Claimed")
                if claimedMarker and claimedMarker:IsA("GuiObject") then
                    claimedMarker.Visible = claimState[index] == true
                end
            end
        end
    end
end

local function refreshAllNativeQuestUi()
    for questId in pairs(questDefinitions) do
        refreshNativeQuestFrame(questId)
    end

    if UpdateDataClient and UpdateDataClient.Fire then
        UpdateDataClient:Fire(false, ProfileData)
    end
end

local function setQuestProgress(questId, progress)
    local questState = ensureQuestState(questId)
    questState.Progress = math.max(progress, 0)
    refreshNativeQuestFrame(questId)
end

local function ensureOwnedTable(category)
    ProfileData[category] = ProfileData[category] or {}
    ProfileData[category].Owned = ProfileData[category].Owned or {}
    return ProfileData[category].Owned
end

local function addReward(itemId, category, amount)
    amount = amount or 1
    local owned = ensureOwnedTable(category)

    if stackableCategories[category] then
        owned[itemId] = (owned[itemId] or 0) + amount
        fireInventoryChanged(category, itemId, owned[itemId])
    else
        for _ = 1, amount do
            table.insert(owned, itemId)
        end

        fireInventoryChanged(category, itemId, amount)
    end

    ItemPopupService:AddNewItem(itemId, category, amount)
end

local function claimReward(questId, rewardIndex)
    local questInfo = questDefinitions[questId]
    local questState = ensureQuestState(questId)
    local claimState = ensureClaimState(questId)
    local stage = questInfo and questInfo.Quests and questInfo.Quests[rewardIndex]

    if not stage then
        return false, "Reward not found"
    end

    if claimState[rewardIndex] == true then
        return false, "Reward already claimed"
    end

    if questState.Progress < (stage.ChallengeAmount or 0) then
        return false, "Unlock this reward first"
    end

    claimState[rewardIndex] = true
    addReward(stage.RewardID, stage.RewardType, stage.RewardAmount or 1)
    refreshNativeQuestFrame(questId)
    return true, "Claimed " .. tostring(stage.RewardID)
end

local function claimUnlockedRewards(questId)
    local questInfo = questDefinitions[questId]

    if not questInfo or not questInfo.Quests then
        return 0, {}
    end

    local claimedCount = 0
    local claimedRewards = {}

    for rewardIndex, stage in ipairs(questInfo.Quests) do
        local ok = claimReward(questId, rewardIndex)
        if ok then
            claimedCount += 1
            table.insert(claimedRewards, tostring(stage.RewardID))
        end
    end

    return claimedCount, claimedRewards
end

local function unlockNextMilestone(questId)
    local questState = ensureQuestState(questId)
    local milestones = getQuestMilestones(questId)

    for _, milestone in ipairs(milestones) do
        if milestone > questState.Progress then
            setQuestProgress(questId, milestone)
            return milestone, false
        end
    end

    return questState.Progress, true
end

local function unlockPreviousMilestone(questId)
    local questState = ensureQuestState(questId)
    local milestones = getQuestMilestones(questId)
    local previous = 0

    for _, milestone in ipairs(milestones) do
        if milestone >= questState.Progress then
            break
        end
        previous = milestone
    end

    setQuestProgress(questId, previous)
    return previous
end

local function unlockAllMilestones(questId)
    local maxProgress = getQuestMaxProgress(questId)
    setQuestProgress(questId, maxProgress)
    return maxProgress
end

local function claimAllUnlockedRewards()
    local totalClaimed = 0
    local claimedRewards = {}

    for questId in pairs(questDefinitions) do
        local claimedCount, rewardIds = claimUnlockedRewards(questId)
        totalClaimed += claimedCount

        for _, rewardId in ipairs(rewardIds) do
            table.insert(claimedRewards, rewardId)
        end
    end

    refreshAllNativeQuestUi()

    return totalClaimed, claimedRewards
end

local function getQuestSummary()
    local totalTracks = 0
    local completedTracks = 0
    local claimableRewards = 0
    local claimedRewards = 0

    for questId, questInfo in pairs(questDefinitions) do
        totalTracks += 1

        local questState = ensureQuestState(questId)
        local claimState = ensureClaimState(questId)
        local maxProgress = getQuestMaxProgress(questId)

        if maxProgress > 0 and questState.Progress >= maxProgress then
            completedTracks += 1
        end

        for rewardIndex, stage in ipairs(questInfo.Quests or {}) do
            if claimState[rewardIndex] == true then
                claimedRewards += 1
            elseif questState.Progress >= (stage.ChallengeAmount or 0) then
                claimableRewards += 1
            end
        end
    end

    return totalTracks, completedTracks, claimableRewards, claimedRewards
end

local existing = PlayerGui:FindFirstChild("ManualRewardsUnlockerGui")
if existing then
    existing:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ManualRewardsUnlockerGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.AnchorPoint = Vector2.new(1, 1)
frame.Position = UDim2.new(1, -18, 1, -18)
frame.Size = UDim2.new(0, 248, 0, 176)
frame.BackgroundColor3 = Color3.fromRGB(18, 23, 30)
frame.BorderSizePixel = 0
frame.ZIndex = 50
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(67, 84, 105)
frameStroke.Thickness = 1
frameStroke.Parent = frame

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 35, 46)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 19, 26))
})
frameGradient.Rotation = 90
frameGradient.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = frame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 8)
list.Parent = frame

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(32, 40, 52)
header.BackgroundTransparency = 0.1
header.BorderSizePixel = 0
header.ZIndex = 51
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = Color3.fromRGB(82, 106, 135)
headerStroke.Transparency = 0.4
headerStroke.Parent = header

local accent = Instance.new("Frame")
accent.Size = UDim2.new(0, 4, 1, -10)
accent.Position = UDim2.new(0, 6, 0, 5)
accent.BackgroundColor3 = Color3.fromRGB(92, 171, 255)
accent.BorderSizePixel = 0
accent.ZIndex = 52
accent.Parent = header

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(1, 0)
accentCorner.Parent = accent

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -18, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "BattlePass Panel"
title.ZIndex = 52
title.Parent = header

local summary = Instance.new("TextLabel")
summary.Name = "Summary"
summary.Size = UDim2.new(1, 0, 0, 46)
summary.BackgroundTransparency = 1
summary.Font = Enum.Font.Gotham
summary.TextSize = 12
summary.TextWrapped = true
summary.TextXAlignment = Enum.TextXAlignment.Left
summary.TextYAlignment = Enum.TextYAlignment.Top
summary.TextColor3 = Color3.fromRGB(194, 203, 214)
summary.Text = ""
summary.ZIndex = 51
summary.Parent = frame

local function makeButton(text, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 32)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.AutoButtonColor = false
    button.ZIndex = 51
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.84
    stroke.Parent = button

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color:Lerp(Color3.new(1, 1, 1), 0.14)),
        ColorSequenceKeypoint.new(1, color:Lerp(Color3.new(0, 0, 0), 0.12))
    })
    gradient.Rotation = 90
    gradient.Parent = button

    local baseColor = color
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = baseColor:Lerp(Color3.new(1, 1, 1), 0.08)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = baseColor
    end)

    return button
end

local lvlUpButton = makeButton("Lvl Up", Color3.fromRGB(57, 126, 226))
local getAllRewardButton = makeButton("Get all reward", Color3.fromRGB(53, 166, 116))

local dragging = false
local dragInput
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function trackDragInput(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end

local function bindDraggable(guiObject)
    guiObject.Active = true
    guiObject.InputBegan:Connect(beginDrag)
    guiObject.InputChanged:Connect(trackDragInput)
end

bindDraggable(frame)
bindDraggable(header)
bindDraggable(title)
bindDraggable(summary)
bindDraggable(lvlUpButton)
bindDraggable(getAllRewardButton)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

local function getTargetQuestId()
    return getVisibleQuestId()
end

local function refresh()
    local totalTracks, completedTracks, claimableRewards, claimedRewards = getQuestSummary()

    summary.Text = string.format(
        "Tracks: %d/%d  Claimable: %d\nClaimed: %d",
        completedTracks,
        totalTracks,
        claimableRewards,
        claimedRewards
    )

    refreshAllNativeQuestUi()
end

lvlUpButton.Activated:Connect(function()
    local questId = getTargetQuestId()
    if not questId then
        warn("ManualRewardsUnlocker: track not found, open battlepass first")
        refresh()
        return
    end

    local milestone, finished = unlockNextMilestone(questId)
    if finished then
        warn("ManualRewardsUnlocker: track is already maxed")
    else
        warn("ManualRewardsUnlocker: leveled up to " .. tostring(milestone))
    end

    refresh()
end)

getAllRewardButton.Activated:Connect(function()
    local totalClaimed, claimedRewards = claimAllUnlockedRewards()

    if totalClaimed > 0 then
        warn("ManualRewardsUnlocker: collected unlocked rewards - " .. table.concat(claimedRewards, ", "))
    else
        warn("ManualRewardsUnlocker: no unlocked rewards to collect")
    end

    refresh()
end)

refresh()
