# じゃんけん on Ethereum

**Demo**

![janken](img/demo.gif)

Ropsten テストネットにデプロイしたじゃんけんコントラクトをつかった DApps です。

独自のトークンであるRSP(RockScissorsPaper) をベットしてプレイできます。

プレイはこちら

- [じゃんけん](https://lirlia.github.io/Rock-paper-scissors-ethereum/)

## 遊び方

- Chrome Addon で MetaMask をインストールする
- Metamask にログインする
- 使用するネットワークを `Ropsten テストネット` にする
- `Ropsten テストネット` の ETH を faucet サイトで取得する
  - [Ropsten testnet faucet](https://faucet.egorfine.com/)
- [じゃんけん](https://lirlia.github.io/Rock-paper-scissors-ethereum/) にアクセスして、右上の仮想通貨のアイコンをクリックし`RSPトークン` をチャージする。
- トークンがチャージされたら好きな手を選んでじゃんけんをする

## 使用技術

- Solidity
- Hardhat
- JavaScript(jQuery/ethers.js)
