local _Access = { conf = {} }
local http = require "resty.http"
local pl_stringx = require "pl.stringx"
local cjson = require "cjson.safe"

function _Access.error_response(message, status)
    local jsonString = '{"data": [], "error": { "code":"' .. status ..'", "message": "' .. message .. '"}}'
    ngx.header["Content-Type"] = "application/json"
    ngx.status = status
    ngx.say(jsonString)
    ngx.exit(status)
end

function _Access.validate_token(token)
    local httpc = http:new()

    local res, err = httpc:request_uri(_Access.conf.validation_endpoint, {
	method = "POST",
	ssl_verify = _Access.conf.ssl_verify,
	headers = {
	    ["Content-Type"] = "application/json",
	    ["Authorization"] = token
	}
    })

    if not res then
	return { status = 0 }
    end

    if res.status ~= 200 then
	return { status = res.status }
    end

    return { status = res.status, body = res.body }
end

function _Access.run(conf)
    _Access.conf = conf
    local token = ngx.req.get_headers()[_Access.conf.token_header] or ngx.var.cookie_token

    if not token then
	_Access.error_response("Unauthenticated", ngx.HTPP_UNAUTHORIZED)
    end

    local request_path = ngx.var.request_uri

    local res = _Access.validate_token(token)

    if not res then
	_Access.error_response("Authentication server error", ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    if res.status ~= 200 then
	_Access.error_response("Authentication refused the resquest", ngx.HTTP_UNAUTHORIZED)
    end

    ngx.req.clear_header(_Access.conf.token_header)
end	

return _Access
