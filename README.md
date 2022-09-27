# pou-lua
**WARNING: this requires socket module**


This module was made to get easy access to Pou server (app.pou.me)

# Examples
```lua
local Pou = require('pou')
local Client = Pou.login("example@example.com", "password")
local top = Client.topLikes(true) --true to return table, false to return string
local user = Client.getUserByNickname("Pou",true) --true to return table, false to return string
print(user.i) -- 98
Client.like(98)
```
