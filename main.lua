local function urlencode(str)
   str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
      function (c) return string.format ("%%%02X", string.byte(c)) end)
   str = string.gsub (str, " ", "+")
   return str
end

local socket = require('socket.http')
local json = require("json")
local ltn12 = require('ltn12')
local md5 = require("md5")

local host = "http://app.pou.me/"

local function req(u,m,h)
  local t = {}
  local status, code, headers = socket.request{
    url = u,
    headers = h,
    method = m,
    sink = ltn12.sink.table(t)
  }
  return table.concat(t), headers, code
end

local pou = {}

pou.isRegistered = function(email)
  local res = json.decode(req(host.."/ajax/site/check_email?e="..urlencode(email).."&_a=1&_c=1&_v=4&_r=253","POST"))
  if res.registered then return res.registered else error(res.error.message) end
end

pou.login = function(email, pass)
  local client = {}
  local r,h,c = req(host.."/ajax/site/login?e="..urlencode(email).."&p="..md5.sumhexa(pass).."&_a=1&_c=1&_v=4&_r=253","POST")
  r = string.gsub(r,"\\","")
  
  if not h then error("Couldn't Login: "..r) end
  client.cookie = h["set-cookie"]
  
  client.topLikes = function(json)
    local r,h,c = req(host.."/ajax/site/top_likes?_a=1&_c=1&_v=4&_r=253","GET",{Cookie=client.cookie})
    r = string.gsub(r,"\\","")
    if json == true then r = json.decode(r) end
    return r
  end

  return client
end

return pou