local dycMisc = {}

---@param num number number to clamp
---@param max number max number
---@param min number min number
---@return number number number
---return number in range of min and max
local Clamp = function(num, max, min)
    assert(min >= max, "max needs to be larger than min!")
    return math.min(math.max(num, max), min)
end
dycMisc.Clamp = Clamp

---@param num number number to clamp
---@return number number number
---return number in range of 0 and 1
local Clamp01 = function(num) return math.min(math.max(num, 0), 1) end
dycMisc.Clamp01 = Clamp01

---@param num number number
---@return integer number roundUp number
local Round = function(num) return math.floor(num + 0.5) end
dycMisc.Round = Round

---@param a number start number
---@param b number end number
---@param t number percent
---@return number number number
local Lerp = function(a, b, t) return (b - a) * t + a end
dycMisc.Lerp = Lerp

---@param table table table to count
---@return number number table length
local TableCount = function(table)
    local count = 0
    for _, _ in pairs(table) do count = count + 1 end
    return count
end
dycMisc.TableCount = TableCount

---@param table table
---@param value any
---@return boolean ifContains if contains
local TableContains = function(table, value)
    for _, v in pairs(table) do if v == value then return true end end
    return false
end
dycMisc.TableContains = TableContains

---@param tableTo table
---@param value any
local TableAdd = function(tableTo, value) if not TableContains(tableTo, value) then table.insert(tableTo, value) end end
dycMisc.TableAdd = TableAdd

---@param table table
---@param value any
---@return any index
local TableGetIndex = function(table, value) for k, v in pairs(table) do if v == value then return k end end end
dycMisc.TableGetIndex = TableGetIndex

---@param tableTo table
---@param value any
local TableRemoveValue = function(tableTo, value)
    local index = TableGetIndex(tableTo, value)
    if index then table.remove(tableTo, index) end
end
dycMisc.TableRemoveValue = TableRemoveValue

---@param str string
---@param subStr string
---@return boolean ifStringStartWith
local function StringStartWith(str, subStr)
    if str == nil or subStr == nil then return false end
    return string.sub(str, 1, #subStr) == subStr
end
dycMisc.StringStartWith = StringStartWith

---@param str string
---@param separators string
---@return string[] spls
local function StrSpl(str, separators)
    if separators == nil then separators = "%s" end
    local spls = {}
    local i = 1
    for world in string.gmatch(str, "([^" .. separators .. "]+)") do
        spls[i] = world
        i = i + 1
    end
    return spls
end
dycMisc.StrSpl = StrSpl

---@return table
local NewDrml = function()
    return {
        urlD = "http://dreamlo.com/lb/",
        mode = "",
        content = "",
        data = {},
        ReadAsync = function(self, name1, callback, name2)
            if name2 == nil then return end
            self:Clear()
            self.mode = "read"
            local url = self.urlD .. name1 .. "/pipe-get/" .. name2
            TheSim:QueryServer(url,
                function(content, rawCallback, _)
                    if rawCallback and string.len(content) > 1 then
                        self.content = content
                        if string.len(content) > 5 then
                            local datas = StrSpl(content, "|")
                            if #datas > 5 then
                                self.data[datas[1]] = {}
                                self.data[datas[1]].text = self:D2T(datas[4]) or ""
                                self.data[datas[1]].score = tonumber(datas[2]) or 0
                                self.data[datas[1]].seconds = tonumber(datas[3]) or 0
                                self.data[datas[1]].date = datas[5] or ""
                                self.data[datas[1]].index = tonumber(datas[6]) or 0
                            elseif #datas == 5 then
                                self.data[datas[1]] = {}
                                self.data[datas[1]].text = ""
                                self.data[datas[1]].score = tonumber(datas[2]) or 0
                                self.data[datas[1]].seconds = tonumber(datas[3]) or 0
                                self.data[datas[1]].date = datas[4] or ""
                                self.data[datas[1]].index = tonumber(datas[5]) or 0
                            end
                        end
                    end
                    if callback then callback(self, rawCallback) end
                end, "GET")
        end,
        ReadAllAsync = function(self, name, callback)
            self:Clear()
            self.mode = "read"
            local url = self.urlD .. name .. "/pipe"
            TheSim:QueryServer(url,
                function(content, rawCallback, _)
                    if rawCallback and string.len(content) > 1 then
                        content = string.gsub(content, "\r", "")
                        self.content = content
                        local lines = StrSpl(content, "\n")
                        if #lines < 1 then
                            if callback then callback(self, rawCallback) end
                            return
                        end
                        for _, line in pairs(lines) do
                            if string.len(line) > 5 then
                                local datas = StrSpl(line, "|")
                                if #datas > 5 then
                                    self.data[datas[1]] = {}
                                    self.data[datas[1]].text = self:D2T(datas[4]) or ""
                                    self.data[datas[1]].score = tonumber(datas[2]) or 0
                                    self.data[datas[1]].seconds = tonumber(datas[3]) or 0
                                    self.data[datas[1]].date = datas[5] or ""
                                    self.data[datas[1]].index = tonumber(datas[6]) or 0
                                elseif #datas == 5 then
                                    self.data[datas[1]] = {}
                                    self.data[datas[1]].text = ""
                                    self.data[datas[1]].score = tonumber(datas[2]) or 0
                                    self.data[datas[1]].seconds = tonumber(datas[3]) or 0
                                    self.data[datas[1]].date = datas[4] or ""
                                    self.data[datas[1]].index = tonumber(datas[5]) or 0
                                end
                            end
                        end
                    end
                    if callback then callback(self, rawCallback) end
                end, "GET")
        end,
        WriteAsync = function(self, name1, callback, name2, id1, id2, str)
            if name2 == nil then return end
            id1 = id1 or 0
            id2 = id2 or 0
            str = str or ""
            self:Clear()
            self.mode = "write"
            local url = self.urlD .. name1 .. "/add/" .. name2 .. "/" .. id1 .. "/" .. id2 .. "/" .. self:T2D(str)
            TheSim:QueryServer(url,
                function(content, rawCallback, _)
                    if rawCallback and string.len(content) > 1 then
                        content = string.gsub(content, "\r", "")
                        self.content = content
                    end
                    if callback then callback(self, rawCallback) end
                end, "GET")
        end,
        D2T = function(strTo, str)
            str = str or strTo
            str = string.gsub(str, "%^c%$", ":")
            str = string.gsub(str, "%^s%$", "/")
            str = string.gsub(str, "%^q%$", "%?")
            str = string.gsub(str, "%^e%$", "=")
            str = string.gsub(str, "%^a%$", "&")
            str = string.gsub(str, "%^p%$", "%%")
            str = string.gsub(str, "%^m%$", "%*")
            str = string.gsub(str, "%^v%$", "|")
            str = string.gsub(str, "%^o%$", "#")
            str = string.gsub(str, "%^s2%$", "\\")
            str = string.gsub(str, "%^g%$", ">")
            str = string.gsub(str, "%^l%$", "<")
            str = string.gsub(str, "%^n%$", "\r\n")
            str = string.gsub(str, "%^t%$", "\t")
            return str
        end,
        T2D = function(strTo, str)
            str = str or strTo
            str = string.gsub(str, "\r", "")
            str = string.gsub(str, ":", "%^c%$")
            str = string.gsub(str, "/", "%^s%$")
            str = string.gsub(str, "%?", "%^q%$")
            str = string.gsub(str, "=", "%^e%$")
            str = string.gsub(str, "&", "%^a%$")
            str = string.gsub(str, "%%", "%^p%$")
            str = string.gsub(str, "%*", "%^m%$")
            str = string.gsub(str, "|", "%^v%$")
            str = string.gsub(str, "#", "%^o%$")
            str = string.gsub(str, "\\", "%^s2%$")
            str = string.gsub(str, ">", "%^g%$")
            str = string.gsub(str, "<", "%^l%$")
            str = string.gsub(str, "\n", "%^n%$")
            str = string.gsub(str, "\t", "%^t%$")
            return str
        end,
        IsResultOK = function(self)
            if self.mode == "write" then
                return self.content ~= nil and string.find(self.content, "OK") ~= nil
            else
                return self.content ~= nil and
                    string.len(self.content) > 0
            end
        end,
        Clear = function(self)
            self.content = ""
            self.data = {}
            self.mode = ""
        end,
    }
end
dycMisc.NewDrml = NewDrml

---@return table
local GTData = function()
    return {
        content = "",
        data = {},
        Parse = function(self, content)
            self:Clear()
            content = string.gsub(content, "\r", "")
            content = string.gsub(content, ";", "\n")
            self.content = content
            local lines = StrSpl(content, "\n")
            for _, line in pairs(lines) do
                if string.len(line) > 2 then
                    line = string.gsub(line, "\t", "|")
                    local data = StrSpl(line, "|")
                    if #data > 1 then
                        self.data[data[1]] = {}
                        self.data[data[1]].text = data[2] or ""
                        if string.len(data[2]) > 1 then
                            local array = StrSpl(data[2], ",")
                            if #array > 0 then
                                for _, value in pairs(array) do
                                    if string.len(value) > 2 then
                                        local kv = StrSpl(value, "-")
                                        if #kv > 1 then self.data[data[1]][kv[1]] = kv[2] end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,
        ReadAllAsync = function(self, urlTo, callback)
            self:Clear()
            local url = urlTo
            TheSim:QueryServer(url, function(content, rawCallback, _)
                if rawCallback and string.len(content) > 1 then self:Parse(content) end
                if callback then callback(self, rawCallback) end
            end, "GET")
        end,
        Clear = function(_vqk8)
            _vqk8.content = ""
            _vqk8.data = {}
        end,
    }
end
dycMisc.GTData = GTData

---@return table
local LocalData = function()
    return {
        path = "mod_config_data/",
        name = "dyc",
        SetName = function(self, name) self.name = name end,
        SetString = function(self, name, func)
            TheSim:SetPersistentString(
                self.path .. self.name .. "_" .. name, func, ENCODE_SAVES, function(_, _) end)
        end,
        GetString = function(self, name, func)
            TheSim:GetPersistentString(
                self.path .. self.name .. "_" .. name, function(arg1, arg2) if func then func(arg1 and arg2) end end)
        end,
        EraseString = function(self, name)
            TheSim:ErasePersistentString(
                self.path .. self.name .. "_" .. name, function(_) end)
        end,
    }
end
dycMisc.LocalData = LocalData

---@return { [string|number] : string|number }
local function GetAnimInfo(self)
    if self and self.AnimState and self.entity then
        local debugString = self.entity:GetDebugString()
        local _, _, bank, build, anim, frame1, frame2 = debugString:find("bank:%s?(%S*)%s?build:%s?(%S*)%s?anim:[^:]*:(%S*)%s?Frame:%s?([0-9%.]*)/([0-9%.]*)")
        bank = bank ~= "OUTOFSPACE" and bank or nil
        build = build ~= "OUTOFSPACE" and build or nil
        frame1 = frame1 and #frame1 > 0 and tonumber(frame1) or 0
        frame2 = frame2 and #frame2 > 0 and tonumber(frame2) or 0
        local percent = frame2 > 0 and frame1 % frame2 / frame2 or 0
        return { bank = bank, build = build, anim = anim, frame1 = frame1, frame2 = frame2, percent = percent }
    end
end
dycMisc.GetAnimInfo = GetAnimInfo

return dycMisc
