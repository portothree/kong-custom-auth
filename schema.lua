local typedefs = require "kong.db.schema.typedefs"

return {
	name = "kong-custom-auth",
	fields = {
		{ protocols = typedefs.protocols_http },
		{ config = {
				type = "record",
				fields = {
					{ validation_endpoint = typedefs.url({ required = true }) },
					{ token_header = { type = "string", default = "Authorization", required = true } }
				}
			}
		}
	}
}
