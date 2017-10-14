initialization
testQueringActions

	| interface response localTimeOffset |

	localTimeOffset := TimeZones local offset.

	interface := RESTActionsInterface workingWith: (RESTActionsContext workingWith: rootSystem).

	(rootSystem systemImplementing: #ActionManagementSystemInterface)
		registerNamed: 'List DNS records'
		toEvaluate:
			(ZnRequest new
				requestLine:
					(ZnRequestLine empty
						method: #GET;
						uri: 'https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records' asZnUrl;
						version: ZnConstants defaultHTTPVersion;
						yourself);
				headers:
					{('X-Auth-Email' -> 'patchinko@gmail.com').
					('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')};
				yourself).

	response := interface actions.

	self
		assert: response
		equals: ('[
	{
		"name" : "List DNS records",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"http_request" : {
			"request_line" : {
				"method" : "GET",
				"URL" : "https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records",
				"version" : "HTTP/1.1"
			},
			"headers" : [
				{
					"key" : "X-Auth-Email",
					"value" : "patchinko@gmail.com"
				},
				{
					"key" : "X-Auth-Key",
					"value" : "93b0b7a99ad1fc123d0d2b6508849db7e64"
				}
			]
		}
	}
]' expandMacrosWith: localTimeOffset)