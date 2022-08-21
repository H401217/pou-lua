# pou-lua
**WARNING: this requires socket module**
This module was made to get easy access to Pou server (app.pou.me)

# Examples
```lua
local Pou = require('pou')
local Client = Pou.login("example@example.com", "password")
local top = Client.topLikes(true) --true to return table, false to return string
```
