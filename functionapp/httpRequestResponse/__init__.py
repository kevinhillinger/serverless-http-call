import logging
import azure.functions as func
import http.client

def call_flaskapp(host):
    conn = http.client.HTTPConnection(host, 5000)
    conn.connect()
    conn.request("GET", "/")
    response = conn.getresponse()
    body = response.read().decode()
    conn.close()
    return body

def main(req: func.HttpRequest) -> func.HttpResponse:
    # logging.info('Python HTTP trigger function processed a request.')
    
    host = req.params.get('host')
    if not host:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            host = req_body.get('host')

    if host:
        response_from_flaskapp = call_flaskapp(host)
        message = f"Response from {host}:\n{response_from_flaskapp}."

        logging.info(message)
        return func.HttpResponse(message)
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a host in the query string or in the request body for a personalized response.",
             status_code=200
        )