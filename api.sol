pragma solidity >=0.8.0;

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainInfo {
    /**
     * @dev 返回当前区块信息
     * @return blockNumber 当前区块号
     * @return blockTimestamp 当前区块时间戳
     * @return miner 矿工地址
     * @return gasPrice 当前交易的 Gas 价格（单位：wei）
     */
    function getBlockInfo() public view returns (
        uint256 blockNumber,
        uint256 blockTimestamp,
        address miner,
        uint256 gasPrice
    ) {
        blockNumber = block.number;          // 当前区块号
        blockTimestamp = block.timestamp;    // 区块时间戳（UNIX 时间）
        miner = block.coinbase;             // 矿工地址（打包该区块的地址）
        gasPrice = tx.gasprice;             // 当前交易的 Gas 价格
    }
}