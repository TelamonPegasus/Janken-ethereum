//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";
import "./base.sol";


contract Rsp is Base, ERC20 {

    mapping(address => Score) public scoreOfOwner;

    event TokenNotification(uint token);
    event ResultNotification(Results result, uint earnToken, uint totalToken, Hands playerHand, Hands cpuHand, Score score);

    function _random(uint mod) internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % mod;
    }

    // CPU のじゃんけんの手を生成する
    function _generateHand() internal view returns(Hands) {
        return Hands(_random(3));
    }

    // じゃんけんの手を比較して判定を行う
    function _checkResult(Hands player, Hands bot) internal pure returns(okay) {
        // draw
        if (player == bot) { return okay.Draw; }

        // win
        if (player == Hands.Paper && bot == Hands.Rock) { return okay.Win; }
        if (player == Hands.Scissors && bot == Hands.Paper) { return okay.Win; }
        if (player == Hands.Rock && bot == Hands.Scissors) { return okay.Win; }

        // lose
        return okay.Lose;
    }

    // トークンをあげる
    // ※実際はこんなことをやってはいけない
    function getToken() external {
        _mint(msg.sender, 100 ether);
        emit TokenNotification(balanceOf(msg.sender));
    }

    // 掛け金の2倍の token を払い戻す
    function _sendRewardToken(uint token) internal returns(uint) {
        token = token * 2;
        _mint(msg.sender, token);
        return token;
    }

    // じゃんけんを行う
    function doGame(Hands playerHand, uint token) external {
        console.log("bet: '%d / wallet: '%d'",
            uint(token),
            uint(balanceOf(msg.sender))
        );
        require(token > 0, "token is under 0, must be set over 0");
        require(token <= balanceOf(msg.sender), "don't have enough token");

        // cpu の手を生成
        Hands cpuHand = _generateHand();

        // じゃんけん結果を出力
        Results result = _checkResult(playerHand, cpuHand);

        uint earnToken = 0;
        if (result == Results.Win) {
            // player が勝利した場合は 2倍の token を渡す
            earnToken = _sendRewardToken(token);
            scoreOfOwner[msg.sender].winCount++;
        } else if (result == Results.Draw) {
            scoreOfOwner[msg.sender].drawCount++;
        } else if (result == Results.Lose) {
            // 負けた場合は掛け金を没収する
            transfer(address(this), token);
            scoreOfOwner[msg.sender].loseCount++;
        }

        console.log("player hand: '%d / computer hand: '%d' / result: '%d'",
            uint(playerHand),
            uint(cpuHand),
            uint(result)
        );

        emit ResultNotification(result, earnToken, balanceOf(msg.sender), playerHand, cpuHand, scoreOfOwner[msg.sender]);
    }
}
