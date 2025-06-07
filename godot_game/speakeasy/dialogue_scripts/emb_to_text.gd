extends AwaitableHTTPRequest

var headers = ["Content-Type: application/json"]

func emb_to_text(emb:Array, randomness=0.0): 	
	#return "HI"
	var url = "http://www.uiutech.xyz:7625/reconstruct_text"
	var response := await async_request(url, headers, HTTPClient.Method.METHOD_POST, JSON.stringify({"embedding": emb, 'randomness':randomness}))
	
	if response.success() and response.status_ok():
		#print(response.body_as_json())
		return (await response.body_as_json())["text"][0]
	else:
		print("GOT EERROR")
		print(response)
		print()
		return "ERROR!" 
