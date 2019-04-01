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
| COMMAND | no | migrate | migrate \| compile |
| GIT_URL | no |  | Git project to retrieve (if empty, a volume must be set to bind a local project to $SRC_DIR) |
| GIT_BRANCH | no | master | Git branch used id $GIT_URL is set |
| GIT_FOLDER | no | / | Folder within the repo where the Truffle project takes place  |
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

-   **URL:** `/api/{smart_contract}/all?path=/abi`    
-   **Method:** `GET`
-   **Header:** `N/A`
-   **URL Params:**

| Name | Mandatory | Default | Description |
| -------- | -------- | -------- | -------- |
| smart_contract | yes |  | Smart Contract filename (witout extension `.sol`) |
| path | no |  | JSON Path |

-   **Sample Request:**
```
$ curl 'http://localhost:8888/api/MyContract/all'
```

-   **Success Response:**
    -   **Code:** 200  
        **Content:**
```
{
  "contractName": "MyContract",
  "abi": [...],
  "bytecode": "0x60806040...ca0029",
  "sourceMap": "...",
  "deployedSourceMap": "...",
  "source": "pragma solidity ^0.4.24;...",
  "sourcePath": "/project/contracts/MyContract.sol",
  "ast": {}
  "compiler": {
    "name": "solc",
    "version": "0.4.24+commit.e67f0147.Emscripten.clang"
  },
  "networks": {
    "17": {
      "events": {},
      "links": {},
      "address": "0xd29915f1a3ff9846fe5d8d9d2c954de21932af7f",
      "transactionHash": "0x043b125abfabd9758802c838dd037bc6f160500068b2c31e0149fa03186ea05a"
    }
  },
  "schemaVersion": "2.0.1",
  "updatedAt": "2018-11-19T14:58:40.322Z"
}
```

## FAQ

### How to use with docker-compose

Docker-compose using a separate ethereum node (see [partity-dev-docker](https://github.com/kauri-io/parity-docker))

*docker-compose.yml*

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

*truffle.js*

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

### What if the GitHub repo is private

It is possible to clone a private repo by passing a GitHub SSH keypair by sharing your a keypair to the container

```
  truffle:
    image: gjeanmart/truffle-docker
    ports:
      - "8888:8888"    
    volumes:
      - /home/$USER/.ssh/id_rsa:/root/.ssh/id_rsa
      - /home/$USER/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub
    environment:
      GIT_URL: git@github.com:username/my_private_repo.git
      NETWORK: docker
```      
