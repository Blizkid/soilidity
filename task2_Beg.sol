// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeggingContract {
    address public owner;
    
    // 捐赠记录
    mapping(address => uint256) public donations;
    uint256 public totalDonations;
    
    // 事件
    event DonationReceived(address indexed donor, uint256 amount);
    event Withdrawal(address indexed owner, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // 捐赠排行榜结构
    struct DonorRank {
        address donor;
        uint256 amount;
    }
    DonorRank[3] public topDonors; 

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // 接受捐赠（ payable 函数）
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        _updateTopDonors(msg.sender, donations[msg.sender]);

        emit DonationReceived(msg.sender, msg.value);
    }

    // 更新排行榜
    function _updateTopDonors(address donor, uint256 newAmount) private {
        // 检查是否已经是前3名
        bool alreadyInTop = false;
        uint256 existingIndex = 0;
        
        for(uint256 i = 0; i < 3; i++) {
            if(topDonors[i].donor == donor) {
                alreadyInTop = true;
                existingIndex = i;
                break;
            }
        }
        
        // 如果已经是前3名，更新金额并重新排序
        if(alreadyInTop) {
            topDonors[existingIndex].amount = newAmount;
        } 
        // 如果不是前3名，检查是否能进入排行榜
        else {
            // 找出排行榜中金额最小的
            uint256 minIndex = 0;
            for(uint256 i = 1; i < 3; i++) {
                if(topDonors[i].amount < topDonors[minIndex].amount) {
                    minIndex = i;
                }
            }
            
            // 如果新金额大于排行榜中的最小值，则替换
            if(newAmount > topDonors[minIndex].amount) {
                topDonors[minIndex] = DonorRank(donor, newAmount);
            }
        }
        
        // 重新排序排行榜
        _sortTopDonors();
    }
    
    // 排序排行榜
    function _sortTopDonors() private {
        for(uint256 i = 1; i < 3; i++) {
            for(uint256 j = 0; j < i; j++) {
                if(topDonors[i].amount > topDonors[j].amount) {
                    DonorRank memory temp = topDonors[i];
                    topDonors[i] = topDonors[j];
                    topDonors[j] = temp;
                }
            }
        }
    }

    // 提取合约余额（仅所有者）
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        payable(owner).transfer(balance);
        
        emit Withdrawal(owner, balance);
    }

    // 获取合约总余额
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 获取特定地址的捐赠总额
    function getDonationAmount(address donor) public view returns (uint256) {
        return donations[donor];
    }
    
    // 获取总捐赠额
    function getTotalDonations() public view returns (uint256) {
        return totalDonations;
    }
    
    // 回退函数，直接接受ETH转账
    receive() external payable {
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }
}