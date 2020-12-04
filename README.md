<div align="center">
	<h1>Custom Authentication with Kong</h1>
	<a href="https://www.joypixels.com/profiles/emoji/gorilla">
		<img
    height="80"
    width="80"
    alt="gorilla"
    src="https://raw.githubusercontent.com/portothree/kong-custom-auth/master/other/gorilla.png"
  />
	</a>
</div>

## The problem

Assume you have an in-house authentication which has already been used by your users. It can issue and validate JWT tokens and manage ACL but you still see yourself building custom code in each microservice to integrate with the custom auth service.

## This solution

Leverage Kong with a custom plugin to centralize the integration and allow each microservice to focus on the business logic.

## Installation

-   Download or clone the repository under the directory `usr/local/share/lua/5.1/plugins`.

```
/usr/local/share/lua/5.1/kong/plugins
  |-- custom-auth
	  |-- schema.lua
	  |-- handler.lua
	  |-- access.luaa
```

-   Configure Kong to load the plugin by adding `custom-auth` to the `plugins` property of your `kong.conf` (usually in `/etc/kong/kong.conf`) or via KONG_PLUGINS environment variable.

```
plugins = custom_auth
```

-   If using Kong Enterprise you should be able to find the custom plugin at the bottom of the plugins page.
-   If using a declarative configuration see the example below of how to enable this plugin in a service.

```
{
	"_format_version": "2.1",
	"_transform": true,
	"services": [
		{
			"name": "example-service",
			"url": "http://example.com",
			"routes": [
				{
					"name": "example-route",
					"paths": ["/"]
				}
			],
			"plugins": [
				{
					"name": "custom-auth",
					"config": {
						"validation_endpoint": "http://example.com/auth/validate/token",
						"token_header": "Authorization"
					}
				}
			]
		}
	],
	"consumers": [
		{
			"username": "example-user"
		}
	]
}
```

## Development

- `schema.lua`: Schema of the plugin configuration fields.
- `handler.lua`: Interface declaring functions to run in the lifecycle of a request/connection.
- `accecss.lua`: This file is invoked by `handler.lua` and has the actual authentication logic.
