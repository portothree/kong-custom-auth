local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.custom-auth.access"

local TokenHandler = BasePlugin:extend()

function TokenHandler:new()
    TokenHandler.super.new(self, "custom-auth")
end

function TokenHandler:access(conf)
    TokenHandler.super.access(self)
    access.run(conf)
end

return TokenHandler
