local _Sn1A = {}
local _aScP = function(_Wb53, _p4ZH, _14SQ)
    assert(_14SQ >= _p4ZH, "max needs to be larger than min!")
    return math.min(math.max(_Wb53, _p4ZH), _14SQ)
end
_Sn1A.Clamp = _aScP
local _t1EQ = function(_BHFD) return math.min(math.max(_BHFD, 0x0), 0x1) end
_Sn1A.Clamp01 = _t1EQ
local _z63N = function(_9Pof) return math.floor(_9Pof + 0.5) end
_Sn1A.Round = _z63N
local _b1eu = function(_KnKR, _TUgN, _YpP8) return (_TUgN - _KnKR) * _YpP8 + _KnKR end
_Sn1A.Lerp = _b1eu
local _WlA1 = function(_Tl9D)
    local _nJp0 = 0x0
    for _ir3K, _PUG9 in pairs(_Tl9D) do _nJp0 = _nJp0 + 0x1 end
    return _nJp0
end
_Sn1A.TableCount = _WlA1
local _0xgf = function(_qX6Q, _B1Ok)
    for _q41Y, _oxwZ in pairs(_qX6Q) do if _oxwZ == _B1Ok then return true end end
    return false
end
_Sn1A.TableContains = _0xgf
local _1Lha = function(_7TIC, _1F7e) if not _0xgf(_7TIC, _1F7e) then table.insert(_7TIC, _1F7e) end end
_Sn1A.TableAdd = _1Lha
local _SPiy = function(_fvK5, _ptbw) for _4fJn, _Afws in pairs(_fvK5) do if _Afws == _ptbw then return _4fJn end end end
_Sn1A.TableGetIndex = _SPiy
local _xRio = function(_qfhH, _oEY5)
    local _3KBK = _SPiy(_qfhH, _oEY5)
    if _3KBK then table.remove(_qfhH, _3KBK) end
end
_Sn1A.TableRemoveValue = _xRio
local function _VCS2(_XAKI, _JUg2)
    if _XAKI == nil or _JUg2 == nil then return false end
    return string.sub(_XAKI, 0x1, #_JUg2) == _JUg2
end
_Sn1A.StringStartWith = _VCS2
local function _jvbW(_jPQb, _H3ia)
    if _H3ia == nil then _H3ia = "%s" end
    local _ndQU = {}
    local _EgDu = 0x1
    for _N9B7 in string.gmatch(_jPQb, "([^" .. _H3ia .. "]+)") do
        _ndQU[_EgDu] = _N9B7
        _EgDu = _EgDu + 0x1
    end
    return _ndQU
end
_Sn1A.StrSpl = _jvbW
local _wDF7 = function()
    return {
        urlD = "http://dreamlo.com/lb/",
        mode = "",
        content = "",
        data = {},
        ReadAsync = function(_gJPF, _8px3, _CcWn, _3zc1)
            if _3zc1 == nil then return end
            _gJPF:Clear()
            _gJPF.mode = "read"
            local _tRPU = _gJPF.urlD .. _8px3 .. "/pipe-get/" .. _3zc1
            TheSim:QueryServer(_tRPU,
                function(_TZdC, _rWok, _3dzP)
                    if _rWok and string.len(_TZdC) > 0x1 then
                        _gJPF.content = _TZdC
                        if string.len(_TZdC) > 0x5 then
                            local _jT58 = _jvbW(_TZdC, "|")
                            if #_jT58 > 0x5 then
                                _gJPF.data[_jT58[0x1]] = {}
                                _gJPF.data[_jT58[0x1]].text = _gJPF:D2T(_jT58[0x4]) or ""
                                _gJPF.data[_jT58[0x1]].score = tonumber(_jT58[0x2]) or 0x0
                                _gJPF.data[_jT58[0x1]].seconds = tonumber(_jT58[0x3]) or 0x0
                                _gJPF.data[_jT58[0x1]].date = _jT58[0x5] or ""
                                _gJPF.data[_jT58[0x1]].index = tonumber(_jT58[0x6]) or 0x0
                            elseif #_jT58 == 0x5 then
                                _gJPF.data[_jT58[0x1]] = {}
                                _gJPF.data[_jT58[0x1]].text = ""
                                _gJPF.data[_jT58[0x1]].score = tonumber(_jT58[0x2]) or 0x0
                                _gJPF.data[_jT58[0x1]].seconds = tonumber(_jT58[0x3]) or 0x0
                                _gJPF.data[_jT58[0x1]].date = _jT58[0x4] or ""
                                _gJPF.data[_jT58[0x1]].index = tonumber(_jT58[0x5]) or 0x0
                            end
                        end
                    end
                    if _CcWn then _CcWn(_gJPF, _rWok) end
                end, "GET")
        end,
        ReadAllAsync = function(_oNb7, _PXsC, _tpAn)
            _oNb7:Clear()
            _oNb7.mode = "read"
            local _7JNP = _oNb7.urlD .. _PXsC .. "/pipe"
            TheSim:QueryServer(_7JNP,
                function(_YVnq, _Gmnm, _am9y)
                    if _Gmnm and string.len(_YVnq) > 0x1 then
                        _YVnq = string.gsub(_YVnq, "\r", "")
                        _oNb7.content = _YVnq
                        local _Ngej = _jvbW(_YVnq, "\n")
                        if #_Ngej < 0x1 then
                            if _tpAn then _tpAn(_oNb7, _Gmnm) end
                            return
                        end
                        for _EeNQ, _PRe6 in pairs(_Ngej) do
                            if string.len(_PRe6) > 0x5 then
                                local _HLjc = _jvbW(_PRe6, "|")
                                if #_HLjc > 0x5 then
                                    _oNb7.data[_HLjc[0x1]] = {}
                                    _oNb7.data[_HLjc[0x1]].text = _oNb7:D2T(_HLjc[0x4]) or ""
                                    _oNb7.data[_HLjc[0x1]].score = tonumber(_HLjc[0x2]) or 0x0
                                    _oNb7.data[_HLjc[0x1]].seconds = tonumber(_HLjc[0x3]) or 0x0
                                    _oNb7.data[_HLjc[0x1]].date = _HLjc[0x5] or ""
                                    _oNb7.data[_HLjc[0x1]].index = tonumber(_HLjc[0x6]) or 0x0
                                elseif #_HLjc == 0x5 then
                                    _oNb7.data[_HLjc[0x1]] = {}
                                    _oNb7.data[_HLjc[0x1]].text = ""
                                    _oNb7.data[_HLjc[0x1]].score = tonumber(_HLjc[0x2]) or 0x0
                                    _oNb7.data[_HLjc[0x1]].seconds = tonumber(_HLjc[0x3]) or 0x0
                                    _oNb7.data[_HLjc[0x1]].date = _HLjc[0x4] or ""
                                    _oNb7.data[_HLjc[0x1]].index = tonumber(_HLjc[0x5]) or 0x0
                                end
                            end
                        end
                    end
                    if _tpAn then _tpAn(_oNb7, _Gmnm) end
                end, "GET")
        end,
        WriteAsync = function(_vant, _zU1y, _GOBb, _zZ6C, _X3Yn, _lqT2, _579g)
            if _zZ6C == nil then return end
            _X3Yn = _X3Yn or 0x0
            _lqT2 = _lqT2 or 0x0
            _579g = _579g or ""
            _vant:Clear()
            _vant.mode = "write"
            local _RqT5 = _vant.urlD .. _zU1y .. "/add/" .. _zZ6C .. "/" .. _X3Yn .. "/" .. _lqT2 .. "/" .. _vant:T2D(_579g)
            TheSim:QueryServer(_RqT5,
                function(_dl0a, _9P93, _pPN0)
                    if _9P93 and string.len(_dl0a) > 0x1 then
                        _dl0a = string.gsub(_dl0a, "\r", "")
                        _vant.content = _dl0a
                    end
                    if _GOBb then _GOBb(_vant, _9P93) end
                end, "GET")
        end,
        D2T = function(_NMr0, _ULiO)
            _ULiO = _ULiO or _NMr0
            _ULiO = string.gsub(_ULiO, "%^c%$", ":")
            _ULiO = string.gsub(_ULiO, "%^s%$", "/")
            _ULiO = string.gsub(_ULiO, "%^q%$", "%?")
            _ULiO = string.gsub(_ULiO, "%^e%$", "=")
            _ULiO = string.gsub(_ULiO, "%^a%$", "&")
            _ULiO = string.gsub(_ULiO, "%^p%$", "%%")
            _ULiO = string.gsub(_ULiO, "%^m%$", "%*")
            _ULiO = string.gsub(_ULiO, "%^v%$", "|")
            _ULiO = string.gsub(_ULiO, "%^o%$", "#")
            _ULiO = string.gsub(_ULiO, "%^s2%$", "\\")
            _ULiO = string.gsub(_ULiO, "%^g%$", ">")
            _ULiO = string.gsub(_ULiO, "%^l%$", "<")
            _ULiO = string.gsub(_ULiO, "%^n%$", "\r\n")
            _ULiO = string.gsub(_ULiO, "%^t%$", "\t")
            return _ULiO
        end,
        T2D = function(_W51e, _ruxC)
            _ruxC = _ruxC or _W51e
            _ruxC = string.gsub(_ruxC, "\r", "")
            _ruxC = string.gsub(_ruxC, ":", "%^c%$")
            _ruxC = string.gsub(_ruxC, "/", "%^s%$")
            _ruxC = string.gsub(_ruxC, "%?", "%^q%$")
            _ruxC = string.gsub(_ruxC, "=", "%^e%$")
            _ruxC = string.gsub(_ruxC, "&", "%^a%$")
            _ruxC = string.gsub(_ruxC, "%%", "%^p%$")
            _ruxC = string.gsub(_ruxC, "%*", "%^m%$")
            _ruxC = string.gsub(_ruxC, "|", "%^v%$")
            _ruxC = string.gsub(_ruxC, "#", "%^o%$")
            _ruxC = string.gsub(_ruxC, "\\", "%^s2%$")
            _ruxC = string.gsub(_ruxC, ">", "%^g%$")
            _ruxC = string.gsub(_ruxC, "<", "%^l%$")
            _ruxC = string.gsub(_ruxC, "\n", "%^n%$")
            _ruxC = string.gsub(_ruxC, "\t", "%^t%$")
            return _ruxC
        end,
        IsResultOK = function(_UVRp)
            if _UVRp.mode == "write" then
                return _UVRp.content ~= nil and string.find(_UVRp.content, "OK") ~= nil
            else
                return _UVRp.content ~= nil and
                    string.len(_UVRp.content) > 0x0
            end
        end,
        Clear = function(_5F7o)
            _5F7o.content = ""
            _5F7o.data = {}
            _5F7o.mode = ""
        end,
    }
end
_Sn1A.NewDrml = _wDF7
local _86Di = function()
    return {
        content = "",
        data = {},
        Parse = function(_448F, _N2pt)
            _448F:Clear()
            _N2pt = string.gsub(_N2pt, "\r", "")
            _N2pt = string.gsub(_N2pt, ";", "\n")
            _448F.content = _N2pt
            local _Pivf = _jvbW(_N2pt, "\n")
            for _ifih, _tWSO in pairs(_Pivf) do
                if string.len(_tWSO) > 0x2 then
                    _tWSO = string.gsub(_tWSO, "\t", "|")
                    local _rGiE = _jvbW(_tWSO, "|")
                    if #_rGiE > 0x1 then
                        _448F.data[_rGiE[0x1]] = {}
                        _448F.data[_rGiE[0x1]].text = _rGiE[0x2] or ""
                        if string.len(_rGiE[0x2]) > 0x1 then
                            local _8y5h = _jvbW(_rGiE[0x2], ",")
                            if #_8y5h > 0x0 then
                                for _Oc1Y, _haT2 in pairs(_8y5h) do
                                    if string.len(_haT2) > 0x2 then
                                        local _7vBy = _jvbW(_haT2, "-")
                                        if #_7vBy > 0x1 then _448F.data[_rGiE[0x1]][_7vBy[0x1]] = _7vBy[0x2] end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,
        ReadAllAsync = function(_feWM, _zLgZ, _wZ4m)
            _feWM:Clear()
            local _oY0x = _zLgZ
            TheSim:QueryServer(_oY0x, function(_VDHp, _7hPN, _rH7i)
                if _7hPN and string.len(_VDHp) > 0x1 then _feWM:Parse(_VDHp) end
                if _wZ4m then _wZ4m(_feWM, _7hPN) end
            end, "GET")
        end,
        Clear = function(_vqk8)
            _vqk8.content = ""
            _vqk8.data = {}
        end,
    }
end
_Sn1A.GTData = _86Di
local _vtJn = function()
    return {
        path = "mod_config_data/",
        name = "dyc",
        SetName = function(_TGew, _rfUY) _TGew.name = _rfUY end,
        SetString = function(_iOKt, _kvgD, _YlB7)
            TheSim:SetPersistentString(
                _iOKt.path .. _iOKt.name .. "_" .. _kvgD, _YlB7, ENCODE_SAVES, function(_yjv1, _N8Ef) end)
        end,
        GetString = function(_P614, _pMNp, _zl82)
            TheSim:GetPersistentString(
                _P614.path .. _P614.name .. "_" .. _pMNp, function(_x0EM, _7O79) if _zl82 then _zl82(_x0EM and _7O79) end end)
        end,
        EraseString = function(_kQjj, _2LZK)
            TheSim:ErasePersistentString(
                _kQjj.path .. _kQjj.name .. "_" .. _2LZK, function(_lnSs) end)
        end,
    }
end
_Sn1A.LocalData = _vtJn
local function _KOjm(_XPeI)
    if _XPeI and _XPeI.AnimState and _XPeI.entity then
        local _S0eN = _XPeI.entity:GetDebugString()
        local _nJKI, _nJKI, bank, build, anim, frame1, frame2 = _S0eN:find("bank:%s?(%S*)%s?build:%s?(%S*)%s?anim:[^:]*:(%S*)%s?Frame:%s?([0-9%.]*)/([0-9%.]*)")
        bank = bank ~= "OUTOFSPACE" and bank or nil
        build = build ~= "OUTOFSPACE" and build or nil
        frame1 = frame1 and #frame1 > 0x0 and tonumber(frame1) or 0x0
        frame2 = frame2 and #frame2 > 0x0 and tonumber(frame2) or 0x0
        local _PS39 = frame2 > 0x0 and frame1 % frame2 / frame2 or 0x0
        return { bank = bank, build = build, anim = anim, frame1 = frame1, frame2 = frame2, percent = _PS39 }
    end
end
_Sn1A.GetAnimInfo = _KOjm
return _Sn1A
