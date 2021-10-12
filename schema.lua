local typedefs = require "kong.db.schema.typedefs"

return {
    name = "custom-auth",
    fields = {
	{ protocols = typedefs.protocols_http },
	{ config = {
	    type = "record",
	    fields = {
		{ validation_endpoint = typedefs.url({ required = true }) },
		{ ssl_verify	= { type = "boolean", default = true, required = false } },
		{ token_header	= { type = "string", default = "Authorization", required = true } },
	    }
	}
    }
}
}
