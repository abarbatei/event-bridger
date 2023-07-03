# event-bridger

POC for ClayNation Cardano - EVM event mapping

## Logistics summary

- Contract code: [src/EventBridger.sol](src/EventBridger.sol)

- Run tests (needed for gas report) with gas report: `forge test --gas-report -vvv`

- Deploy contract on Mumbai: `forge script script/EventBridgerDeployer.s.sol:EventBridgerDeployer --broadcast --chain-id 80001 --rpc-url "https://rpc.ankr.com/polygon_mumbai" --legacy`

- Verify contract on Mumbai (needed): `forge verify-contract --verifier-url https://api-testnet.polygonscan.com/api/ <DEPLOYED_CONTRACT_ADDRESS> src/EventBridger.sol:EventBridger <POLYSCAN_API_KEY>`

## Contract overview

`EventBridger` contract has 4 function:
- `emitERC721TransferEvent`:
    - emits 1 ERC721 Transfer event
- `emitERC721TransferEventBatch`:
    - emits as many ERC721 Transfer events as passed to it
    - warning, passing a lot here can make the function run out of gas (a few hundred can work)
    - `use this when testing`
- `emitERC1155TransferSingleEvent`
    - emits 1 ERC1155 TransferSingle event, possibly useful for an optimization, ignore for now
- `emitERC1155TransferBatchEvent`
    - emits 1 ERC1155 TransferBatch event, possibly useful for an optimization, ignore for now
## Setup project

Clone repo:
`git clone --recurse-submodules git@github.com:abarbatei/event-bridger.git`

If, for some reason, the `/lib/` libraries were not installed then you can manually add them via:

```
forge install foundry-rs/forge-std
forge install OpenZeppelin/openzeppelin-contracts
```

Copy `.env.example` as `.env` and add your deployer private key `DEPLOYER_PRIVATE_KEY` (warning as to never share this value or commit it in a project)

## Testing project

Simply run: `forge test`

- if you want to run only a specific test file you can use the `--match-path` argument
```
forge test --match-path test/EventBridger.t.sol
```

- if you want to run only a specific test (or matching pattern test) you can use the `--match-test` argument
```
forge test --match-test testEmitERC721
```

- for extra verbosity add `-vvv`. **v**s can be 1 (least verbose) or 3 (most verbose)

## Gas report

Gas report is only available for tested functions. To see gas report estimations you would need to actually run tests and add the `--gas-report` argument

Example output from executing `forge test --gas-report -vvv`:

```
Running 3 tests for test/EventBridger.t.sol:CounterTest
[PASS] testEmitERC721() (gas: 15261)
[PASS] testEmitERC721BatchManual() (gas: 12246)
[PASS] testEmitERC721Raw() (gas: 9709)
Test result: ok. 3 passed; 0 failed; finished in 709.88µs
| src/EventBridger.sol:EventBridger contract |                 |      |        |      |         |
|--------------------------------------------|-----------------|------|--------|------|---------|
| Deployment Cost                            | Deployment Size |      |        |      |         |
| 531161                                     | 2688            |      |        |      |         |
| Function Name                              | min             | avg  | median | max  | # calls |
| emitERC721TransferEvent                    | 4482            | 4482 | 4482   | 4482 | 2       |
| emitERC721TransferEventBatch               | 5588            | 5588 | 5588   | 5588 | 1       |
```

### Interpreting report
- under `Deployment Cost` is the gas value to deploy the contract and the next column has the deployed contract bytecode (bytes) size (`Deployment Size`)
- then 3rd line holds the names of the columns below
- example, there were 2 calls to the `EventBridger::emitERC721TransferEvent` function and both cost exactly 4482 in both instances

## Deploying contract

In foundry/forge, scripts are also written in Solidity. The `script/EventBridgerDeployer.s.sol` deploys the contract on-chain.

To dry-run test it execute the command:
`forge script script/EventBridgerDeployer.s.sol:EventBridgerDeployer`

To fully deploy on-chain you need the full arguments:
```
forge script script/EventBridgerDeployer.s.sol:EventBridgerDeployer --broadcast --chain-id <deployment_chain_id> --rpc-url "<what_RPC_url_to_use>"
```

Example deployment on **Mumbai**:

```
forge script script/EventBridgerDeployer.s.sol:EventBridgerDeployer --broadcast --chain-id 80001 --rpc-url "https://rpc.ankr.com/polygon_mumbai" --legacy
```

Observations
- add `--with-gas-price 4607624000` in case forge cannot estimate deployment gas (or whatever value you set it to)
    - or add `--legacy` (not needed for Polygon)
- more on [forge script commands here](https://book.getfoundry.sh/reference/forge/forge-script)
- if an error with too many request appear, change the RPC URL with another from [chainlist.org](https://chainlist.org/?testnets=true&search=mumbai)

## Verifying contract

In order for us as owners to interact with the contract using blockchain explorers (example https://polygonscan.com/) the contract must be verified.

In order to verify it execute the following command:

```
forge verify-contract --verifier-url <verifier_url> <deployed_contract_address> src/EventBridger.sol:EventBridger <explorer_api_key>
```

For Mumbai, the verifier URL is: https://api-testnet.polygonscan.com/api/

In order to get an `<explorer_api_key>` for Mumbai, you need to create an account (free) on https://polygonscan.com/ , generate a key and use the same key on https://mumbai.polygonscan.com/.

`<deployed_contract_address>` you get from the deployment operation

Example verification on Mumbai (you still need to change the address to your deployed contract address and add a valid polyscan API key)
```
forge verify-contract --verifier-url https://api-testnet.polygonscan.com/api/ 0xdeadbeefdeadbeefdeadbeefdeadbeef src/EventBridger.sol:EventBridger ABBABABABABABABABAB
```


