extends AwaitableHTTPRequest

var headers = ["Content-Type: application/json"]

func evaluate(question, rep): 
	#return [1,2,3,4,45]
	var url = "http://www.uiutech.xyz:7625/evaluate"
	var response := await async_request(url, headers, HTTPClient.Method.METHOD_POST, JSON.stringify({"question": question, "response": rep}))
	
	if response.success() and response.status_ok():
		return (await response.body_as_json())["result"]
	else:
		return "ERROR!" 
