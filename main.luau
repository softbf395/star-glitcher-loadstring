-- This line handles both scenarios: 'owner' is pre-filled by NS, or it falls back to a specific player for testing.
local owner = owner or game:GetService("Players").Aedaniss7
local HTTPEnabled = pcall(function() game:GetService("HttpService"):GetAsync("https://httpbin.org/get") end)
if game:GetService("RunService"):IsStudio() or HTTPEnabled == false then NLS = require(13482937602)() end --http enabled? if yes then dont run require for NLS and use NS's built in version

-- Server-side variables
local mode = "MAYHEM"
local side = "Spectrum" -- Note: 'side' is not used in this script.

-- Get services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create RemoteEvents in ReplicatedStorage
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
        TextChatService:FindFirstChild("TextChannels").RBXSystem:ShowSystemMessage("["..mode.."] "..sender..": "..text)
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

-- Function to handle code injection for players
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

-- Inject the code for new players who join the game
Players.PlayerAdded:Connect(setupPlayer)

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
                say("Mode changed to SUBLIMINAL.")
            else
                mode = "MAYHEM"
                side = "Spectrum"
                say("Mode changed to MAYHEM.")
            end
        end
        if key == Enum.KeyCode.M then
            if mode == "MAYHEM" then
                mode = "VIOLENCE"
                say("I AM REALLY DONE WITH YOU...")
                task.wait(1)
                say("nvm, its unfinished.")
                mode = "MAYHEM"
            end
        end
      warn(mode)
    end
end)
