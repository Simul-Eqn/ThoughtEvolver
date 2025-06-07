extends AwaitableHTTPRequest

var headers = ["Content-Type: application/json"]

func text_to_emb(text): 
	#return [1,2,3,4,45]
	var url = "http://www.uiutech.xyz:7625/get_embedding"
	var response := await async_request(url, headers, HTTPClient.Method.METHOD_POST, JSON.stringify({"text": text}))
	
	if response.success() and response.status_ok():
		return (await response.body_as_json())["embedding"]
	else:
		return "ERROR!" 
