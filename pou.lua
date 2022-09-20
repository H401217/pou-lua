_G.cookie = ""
local socket = require('socket.http')
local json = require("json")
local ltn12 = require('ltn12')
local md5 = require("md5")

local host = "http://app.pou.me/"
local versionCode = 254

local function urlencode(str)
   str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
      function (c) return string.format ("%%%02X", string.byte(c)) end)
   str = string.gsub (str, " ", "+")
   return str
end

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

function get(path,_json)
  if _json == true then
    return json.decode(req(host..path.."&s=0&_a=1&_c=1&_v=4&_r="..versionCode,"GET",{Cookie = tostring(_G.cookie)}))
  else
    return req(host..path.."&s=0&_a=1&_c=1&_v=4&_r="..versionCode,"GET",{Cookie = tostring(_G.cookie)})
  end
end
function post(path,_json)
  if _json == true then
    return json.decode(req(host..path.."&s=0&_a=1&_c=1&_v=4&_r="..versionCode,"POST",{Cookie = tostring(_G.cookie)}))
  else
    return req(host..path.."&s=0&_a=1&_c=1&_v=4&_r="..versionCode,"POST",{Cookie = tostring(_G.cookie)})
  end
end

--Module
local pou = {}

pou.isRegistered = function(email)
  local res = post("/ajax/site/check_email?e="..urlencode(email),false)
  --if res.registered then return res.registered else error("An error occurred") end
return res
end

pou.login = function(email, pass)
  local client = {}
  
  local r,h,c = post("/ajax/site/login?e="..urlencode(email).."&p="..md5.sumhexa(pass),false)
  --r = string.gsub(r,"\\","")
  client.me = r
  local _success_,___r = pcall(function() json.decode(r) end)
  if success then r = ___r end
  if r.error then error("Couldn't Login: "..r.error.message) end
  _G.cookie = h["set-cookie"]
  
  client.topLikes = function(j) --true for table, false for json string
    local a,b,c = get("/ajax/site/top_likes?_a=1&_c=1&_v=4&_r=254",j) return a
  end
  
  client.getUserByNickname = function(nick,j)
    local r,h,c = post("/ajax/search/visit_user_by_nickname?n="..urlencode(nick),j) return r
  end
  
  client.getUserByEmail = function(email,j)
    local r,h,c = post("/ajax/search/visit_user_by_email?e="..urlencode(email),j) return r
  end
  
  client.getUserById = function(id,j)
    local r,h,c = post("/ajax/user/visit?id="..id,j) return r
  end

  client.randomUser = function(j)
    local r,h,c = post("/ajax/search/visit_random_user?foo=",j) return r
  end

  client.getFavorites = function(id,j)
    local r,h,c = post("/ajax/user/favorites?id="..id,j) return r
  end

  client.getLikers = function(id,j)
    local r,h,c = post("/ajax/user/likers?id="..id,j) return r
  end

  client.getVisitors = function(id,j)
    local r,h,c = post("/ajax/user/visitors?id="..id,j) return r
  end

  client.getMessages = function(id,j)
    local r,h,c = post("/ajax/user/messages?id="..id,j) return r
  end
  
  client.changePassword = function(old,new,j)
    local r,h,c = post("/ajax/account/change_password?o="..md5.sumhexa(old).."&n="..md5.sumhexa(new),j) return r
  end
    --[[client.delete = function(j)
    local r,h,c = post("/ajax/account/delete_account,j) return r
  end]]

  return client
end
return pou
