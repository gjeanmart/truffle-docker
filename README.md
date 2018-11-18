# truffle-docker

A docker container to deploy a Truffle project and access the Truffle JSON artifacts via an API

## Getting started

**Deploy a local Truffle project located in `/path/to/truffle/project`**

```
docker run -it \
  -p 8888:8888 \
  -v /path/to/truffle/project:/project \
  -e NETWORK=docker \
  -e API_PORT=8888 \
  -e API_HOST=0.0.0.0 \
  gjeanmart/truffle-docker
```

**Deploy a Git remote Truffle project**
```
docker run -it \
  -p 8888:8888 \
  -e NETWORK=docker \
  -e GIT_URL=git@github.com:my_username/my_truffle_repo.git \
  -e API_PORT=8888 \
  -e API_PORT=8888 \
  -e API_HOST=0.0.0.0 \
  gjeanmart/truffle-docker
```



### Environment variables

| Name | Mandatory | Default | Description |
| -------- | -------- | -------- | -------- |
| GIT_URL | no |  | Git project to retrieve (if empty, a volume must be set to bind a local project to $SRC_DIR) |
| GIT_BRANCH | no | master | Git branch used id $GIT_URL is set |
| SRC_DIR | no | /project | Diretory of the Truffle project |
| NETWORK | no | development | Network to deploy  |
| API_PORT | no | 8888 | API port |
| API_HOST | no | 0.0.0.0 | API host  |

### Port

| Port | Description |
| -------- | -------- | 
| 8888 | API | 



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

Docker-compose using a separate ethereum node (see [partity-dev-docker](https://github.com/kauri-io/parity-docker))

```
version: '3.2'
services:
     
  parity-node:
    image: gjeanmart/parity-dev-docker
    ports:
      - "8545:8545"
    networks:
      - default

  truffle:
    image: gjeanmart/truffle-docker
    ports:
      - "8888:8888"
    volumes:
      - /path/to/truffle/project:/project
    depends_on:
      - parity-node
    environment:
      NETWORK: docker
      API_PORT: 8888
      API_HOST: 0.0.0.0
    networks:
      - default

networks:
  default:

```

truffle.js

```
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    docker: {
      host: "parity-node",
      port: 8545,
      network_id: "*"
    },
  }
}

```

## 
