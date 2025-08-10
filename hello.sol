// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract OddNumberCalculator {
        /**
     * @dev 计算1到n的所有奇数和
     * @param n 上限数字
     * @return 奇数和
     */
    function sumOddNumbers(uint256 n) public pure returns (uint256) {
        require(n > 0, "n must be greater than 0");
        
        uint256 sum = 0;
        
        // 使用for循环计算奇数和
        for (uint256 i = 1; i <= n; i += 2) {
            sum += i;
        }
        
        return sum;
    }
    /**
     * @dev 安全调用外部合约的函数，使用try/catch处理异常
     * @param targetContract 目标合约地址
     * @param data 调用数据
     * @return success 是否调用成功
     * @return result 调用结果（如果成功）
     */
    function safeExternalCall(
        address targetContract,
        bytes memory data
    ) public returns (bool success, bytes memory result) {
        // 使用try/catch处理外部调用
        try this.externalCall(targetContract, data) returns (bytes memory _result) {
            return (true, _result);
        } catch Error(string memory reason) {
            // 捕获revert/require的错误信息
            emit ExternalCallFailed(reason);
            return (false, bytes(reason));
        } catch (bytes memory lowLevelData) {
            // 捕获低级错误
            emit LowLevelCallFailed(lowLevelData);
            return (false, lowLevelData);
        }
    }
    
    /**
     * @dev 实际执行外部调用的内部函数
     */
    function externalCall(
        address targetContract,
        bytes memory data
    ) external returns (bytes memory) {
        (bool success, bytes memory result) = targetContract.call(data);
        
        require(success, "External call failed");
        return result;
    }
    
    // 事件记录调用失败
    event ExternalCallFailed(string reason);
    event LowLevelCallFailed(bytes lowLevelData);
}