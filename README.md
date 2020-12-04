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
