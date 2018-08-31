# truffle-docker

A docker container to deploy a Truffle project and access the contract address via an API

## Getting started

```
docker run -it \
	-p 8888:8888 \
	-v /path/to/truffle/project:/project \
	-e ACTION=migrate \
	-e NETWORK=development \
	-e RPC_HOST=localhost \
	-e RPC_PORT=8545 \
	-e API_PORT=8888 \
	-e API_HOST=0.0.0.0 \
	gjeanmart/truffle-docker
```

### Port

| Port | Description |
| -------- | -------- | 
| 8888 | API | 


### Volumes

| Name | Mandatory | Description |
| -------- | -------- | -------- |
| /project  | yes | Path to the truffle project | 


### Environment variables

| Name | Mandatory | Default | Description |
| -------- | -------- | -------- | -------- |
| ACTION | yes |  | action to execute {migrate\|...} |
| NETWORK | no | development | Network to deploy  |
| RPC_HOST | no | localhost | RPC host  |
| RPC_PORT | no | 8545 | RPC port  |
| API_PORT | no | 8888 | API port |
| API_HOST | no | 0.0.0.0 | API host  |


## API

### Get Smart Contract address
Retrieve the smart contract address for a given contract name

-   **URL:** `/api/{smart_contract}`    
-   **Method:** `GET`
-   **Header:** `N/A`
-   **URL Params:** 

| Name | Mandatory | Default | Description |
| -------- | -------- | -------- | -------- |
| smart_contract | yes |  | Smart Contract filename (witout extension `.sol`) |

-   **Sample Request:**
```
$ curl 'http://localhost:8888/api/MyContract'
```

-   **Success Response:**
    -   **Code:** 200  
        **Content:** 
```
{
    "name": "MyContract",
    "address": "0xd5f051401ca478b34c80d0b5a119e437dc6d9df5",
}
```


### Get Smart Contract Truffle artefact
Retrieve the smart contract Truffle artefacts for a given contract name

-   **URL:** `/api/{smart_contract}/all`    
-   **Method:** `GET`
-   **Header:** `N/A`
-   **URL Params:** 

| Name | Mandatory | Default | Description |
| -------- | -------- | -------- | -------- |
| smart_contract | yes |  | Smart Contract filename (witout extension `.sol`) |

-   **Sample Request:**
```
$ curl 'http://localhost:8888/api/MyContract/all'
```

-   **Success Response:**
    -   **Code:** 200  
        **Content:** 
```
{
  ...
}
```


## docker-compose

Dockr-compose using a separate ethereum node (see [partity-dev-docker](https://github.com/kauri-io/parity-docker))

```
version: '3.2'
services:
     
  parity:
    image: gjeanmart/parity-dev-docker
    ports:
      - "8545:8545"
    volumes:
      - .ethereum_data:/root/.local/share/io.parity.ethereum
      - .ethereum_log:/data/parity-logs
    networks:
      - default

  truffle:
    image: gjeanmart/truffle-docker
    ports:
      - "8888:8888"
    volumes:
      - /path/to/truffle/project:/project
    depends_on:
      - parity
    environment:
      CONTRACT_NAME: SmartContractName
      ACTION: migrate
      NETWORK: docker
      RPC_HOST: parity
      API_PORT: 8888
      API_HOST: 0.0.0.0
    networks:
      - default

networks:
  default:

```

## Improvments

- Have an option to run Ganache-cli locally
- More validation on mandatory|optional variables
- Add actions for other function (`compile`, `test`, `debug`)
