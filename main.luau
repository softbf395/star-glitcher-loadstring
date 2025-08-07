warn("STAR GLITCHER NS LOADSTRING V0.1 BUGFIX 3") -- version ( 0.1.3 )!
warn("----------------------------------------------------------")
warn("THIS IS A REMAKE of Star Glitcher. you will need edit access to the game you use this in.") --saying this is a remake
warn("----------------------------------------------------------")
warn("UPDATE:") --update log.
warn("----------------------------------------------------------")
warn("FIXED THE BUG WHERE INITIALIZATION BUGS.")
warn("----------------------------------------------------------")
local owner = owner or game.Players.Aedaniss7 -- owner placeholder just in case.
local HTTPEnabled = pcall(function() game:GetService("HttpService"):GetAsync("https://httpbin.org/get") end) --self-explanetory
if game:GetService("RunService"):IsStudio() or HTTPEnabled == false then NLS = require(13482937602)() end --http enabled? if yes then dont run require for NLS and use NS's built in version

local mode = "MAYHEM" --mode
local side = "Spectrum" -- side

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local rm = Instance.new("RemoteEvent", ReplicatedStorage)
rm.Name = "SGInput"
local rm2 = Instance.new("RemoteEvent", ReplicatedStorage)
rm2.Name = "SGSay"

local function say(text)
    rm2:FireAllClients(text, owner.Name, mode)
end

local chatClientCode = [[
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TextChatService = game:GetService("TextChatService")
    ReplicatedStorage.SGSay.OnClientEvent:Connect(function(text, sender, mode)
        TextChatService:FindFirstChild("TextChannels").RBXSystem:DisplaySystemMessage("["..mode.."] "..sender..": "..text) -- fixed <-
    end)
warn("Chat Client Code initialized.")
]]

local inputClientCode = [[
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input, isTyping)
        if isTyping then return end
        ReplicatedStorage.SGInput:FireServer("Key", {input.KeyCode})
    end)
warn("Controls code initialized.")
]]


local function setupPlayer(player)
    -- Inject the chat handler for ALL players into their PlayerGui.
    NLS(chatClientCode, player.PlayerGui)

    -- Inject the input handler ONLY for the owner.
    if player == owner then
        NLS(inputClientCode, player:WaitForChild("Backpack"))
    end
end

-- Inject the code for players already in the game
for _, p in ipairs(Players:GetPlayers()) do
    setupPlayer(p)
end

Players.PlayerAdded:Connect(setupPlayer)
local title=Instance.new("TextLabel")
local sguiTitle=Instance.new("BillboardGui", owner.Character.Head)
sguiTitle.Size=UDim2.new(3,0,1.5,0)
sguiTitle.StudsOffsetWorldSpace=Vector3.new(0,3,0) --fix, again
title.Parent=sguiTitle
title.BackgroundTransparency=1
title.Size=UDim2.new(1,0,1,0)
title.TextScaled=true
title.TextColor3=Color3.fromRGB(255,0,0)
title.Font="Arcade"
title.Text=mode
-- Connect the server-side RemoteEvent handler
rm.OnServerEvent:Connect(function(plr, input, params)
    -- Check for the correct player
    if plr.Name ~= owner.Name then
        warn("Unauthorized attempt to control Star Glitcher by "..plr.Name)
        return
    end

    if input == "Key" then
        local key = params[1]
        if key == Enum.KeyCode.Q then
            if mode == "MAYHEM" then
                mode = "SUBLIMINAL"
                side = "SUBLIMINAL"
title.TextColor3=Color3.fromRGB(255,255,255)
title.Text="SUBLIMINAL"
            else
title.TextColor3=Color3.fromRGB(255,0,0)
title.Text="MAYHEM"
                mode = "MAYHEM"
                side = "Spectrum"
                    say("THIS CANT BE HAPPENING.")
            end
        end
        if key == Enum.KeyCode.M then
            if mode == "MAYHEM" then
                mode = "VIOLENCE"
                say("I AM REALLY DONE WITH YOU...")
                task.wait(1)
                    mode="MAYHEM"
                say("nvm, its unfinished.")
            end
        end
        if key==Enum.KeyCode.Z then
            if mode=="MAYHEM" then
                    say("SHATTER!")
                    say("unfinished")
            end
        end
      warn(mode)
    end
end)
