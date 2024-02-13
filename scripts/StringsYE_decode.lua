local function isDST() return TheSim:GetGameID() == "DST" end
local function getMatchs(str, char)
    if char == nil then char = "%s" end
    local matchs = {}
    local i = 1
    for matchStr in string.gmatch(str, "([^" .. char .. "]+)") do
        matchs[i] = matchStr
        i = i + 1
    end
    return matchs
end
local readFile = function(filePath)
    local openFile = io.open
    local file, err = openFile(filePath, "r")
    if err then else
        local content = file:read("*all")
        file:close()
        return content
    end
    return ""
end
local writeFile = function(filePath, content)
    local openFile = io.open
    local file, err = openFile(filePath, "w")
    if err then else
        file:write(content)
        file:close()
    end
end
local codeOne =
[[
local wtxt12 = function(p, txt)
    local fo = io.open
    local f, err = fo(p, "w")
    if err then else
        f:write(txt)
        f:close()
    end
end
local key1 = "\121\105\121\117"
local key2 = "\231\191\188\232\175\173"
local sbwss = { "642704851", "701574438", "834039799", "845740921", "1088165487", "1161719409", "1546144229", "1559975778", "1626938843", "1656314475", "1656333678", "1883082987", "2199037549203167410",
    "2199037549203167802", "2199037549203167776", "2199037549203167775", "2199037549203168585", }
local sbstr =
"\229\155\160\230\129\182\230\132\143\231\175\161\230\148\185\228\187\150\228\186\186\109\111\100\232\162\171\229\176\129\231\166\129\239\188\140\230\138\181\229\136\182\115\98\228\189\156\232\128\133\239\188\129"
local CheckSB = function(name)
    if name and (string.find(string.lower(name), key1, 1, true) or string.find(string.lower(name), key2, 1, true)) then return true end
    for k, v in pairs(sbwss) do if name and name == "workshop-" .. v then return true end end
    return false
end
local AntiSB = function(name)
    local file1 = "../mods/" .. name .. "/modmain.lua"
    local file2 = "../mods/" .. name .. "/modworldgenmain.lua"
    wtxt12(file1, sbstr)
    wtxt12(file2, sbstr)
end
]]
local codeTwo = codeOne .. [[
if _G.KnownModIndex and _G.KnownModIndex.GetModInfo then
    local OldFn = KnownModIndex.GetModInfo
    KnownModIndex.GetModInfo = function(self, modname, ...)
        local info = self.savedata.known_mods[modname] and self.savedata.known_mods[modname].modinfo or {}
        if CheckSB(info.name) or CheckSB(info.author) then
            KnownModIndex:DisableBecauseBad(modname)
            AntiSB(modname)
            info.restart_required = false
            return info
        else return OldFn(self, modname, ...) end
    end
end
]]
local codeThree = codeOne .. [[
    local mn = self.modnames[self.currentmod]
    local minfo = KnownModIndex:GetModInfo(mn)
    if CheckSB(mn) or CheckSB(minfo.author) then
        AntiSB(mn)
        return
    end
]]
TUNING.DASB_DONE = true
local distort = function(filePath, str1, str2)
    local Filecontent = readFile(filePath)
    local lines = getMatchs(Filecontent, "\n")
    local lenth = #lines
    local index = 0
    for i = 1, lenth do
        if lines[i] and string.find(lines[i], str1, 1, true) and string.find(lines[i], str2, 1, true) and (not lines[i + 1] or not string.find(lines[i + 1], "wtxt12", 1, true)) then
            index = i + 1
            break
        end
    end
    if index > 0 then
        lines[index] = codeTwo
        Filecontent = ""
        for i = 1, index do Filecontent = Filecontent .. lines[i] .. "\n" end
        writeFile(filePath, Filecontent)
    end
end
local distort2 = function(filePath)
    local fileContent = readFile(filePath)
    local lines = getMatchs(fileContent, "\n")
    local lenth = #lines
    local index1, index2 = 0, 0
    for i = 1, lenth do
        if lines[i] and string.find(lines[i], "ModsScreen:EnableCurrent", 1, true) and (not lines[i + 1] or not string.find(lines[i + 1], "wtxt12", 1, true)) then
            index1 = i + 1
        end
        if index1 > 0 and lines[i] and string.find(lines[i], "local modname = self.modnames[self.currentmod]", 1, true) then
            index2 = i
            break
        end
    end
    if index1 > 0 then
        fileContent = ""
        for i = 1, lenth do
            if i == index1 then fileContent = fileContent .. codeThree .. "\n" end
            if i < index1 or i >= index2 then fileContent = fileContent .. lines[i] .. "\n" end
        end
        writeFile(filePath, fileContent)
    end
end
if not isDST() then
    distort("../data/scripts/modindex.lua", "KnownModIndex", "ModIndex()")
    distort2("../data/scripts/screens/modsscreen.lua")
end
if isDST() then return end
local yiyu1 = "\121\105\121\117"
local yiyu2 = "\231\191\188\232\175\173"
local banlist1 = { "642704851", "701574438", "834039799", "845740921", "1088165487", "1161719409", "1546144229", "1559975778", "1626938843", "1656314475", "1656333678", "1883082987",
    "2199037549203167410",
    "2199037549203167802", "2199037549203167776", "2199037549203167775", "2199037549203168585", }
local strOne =
"\229\155\160\230\129\182\230\132\143\231\175\161\230\148\185\228\187\150\228\186\186\109\111\100\232\162\171\229\176\129\231\166\129\239\188\140\230\138\181\229\136\182\115\98\228\189\156\232\128\133\239\188\129"
local isBaned = function(name)
    if name and (string.find(string.lower(name), yiyu1, 1, true) or string.find(string.lower(name), yiyu2, 1, true)) then return true end
    for _, modName in pairs(banlist1) do if name and name == "workshop-" .. modName then return true end end
    return false
end
local distortMod = function(str)
    local modmain = "../mods/" .. str .. "/modmain.lua"
    local modworldgenmain = "../mods/" .. str .. "/modworldgenmain.lua"
    writeFile(modmain, strOne)
    writeFile(modworldgenmain, strOne)
end
if _G.KnownModIndex then
    for modname, modInfo in pairs(KnownModIndex.savedata.known_mods) do
        if isBaned(modname) or (modInfo.modinfo and modInfo.modinfo.author and isBaned(modInfo.modinfo.author)) then
            KnownModIndex:DisableBecauseBad(modname)
            distortMod(modname)
        end
    end
end
local banlist2 = { "1883724202", }
local function isBaned2(name)
    local isBaned = isBaned(name)
    local flag = false
    for _, id in pairs(banlist2) do
        if name and name == "workshop-" .. id then
            flag = true
            break
        end
    end
    return isBaned or flag
end
local function getBanedMods()
    local banedMods = ""
    for name, info in pairs(KnownModIndex.savedata.known_mods) do
        if info.enabled and (isBaned2(name) or (info.modinfo and info.modinfo.author and isBaned2(info.modinfo.author))) then
            banedMods = #banedMods > 0 and banedMods .. "," .. name or name
        end
    end
    if #banedMods > 0 then return "The game is not compatible with following mod:\n" .. banedMods end
end
return getBanedMods
