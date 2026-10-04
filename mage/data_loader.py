import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data(*args, **kwargs):
    """
    Trigger an Airbyte sync via API.
    """
    airbyte_api_url = "https://api.airbyte.com/v1/jobs"
    connection_id = "CONNECTION_ID_HERE"
    
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": "Bearer AIRBYTE_TOKEN_HERE"
    }
    
    payload = {
        "connectionId": connection_id,
        "jobType": "sync"
    }
    
    # Send the live request to trigger Airbyte
    response = requests.post(airbyte_api_url, json=payload, headers=headers)
    return response.json()


@test
def test_output(output, *args) -> None:
    assert output is not None, 'The output is undefined'