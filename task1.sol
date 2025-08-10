// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract voteContract {
    mapping(string => int256) private vote_map;

    function voteToSomebody(string memory name) public {
        vote_map[name] += 1;
    }

    function getVoteFromSomebody(string memory name)
        external
        view
        returns (int256)
    {
        return vote_map[name];
    }

    function resetVote(string memory name) public {
        vote_map[name] = 0;
    }
}

contract ReverseContract {
    function reverseStr(string memory input) external pure returns (string memory) {
        bytes memory strBytes = bytes(input);
        bytes memory reversed = new bytes(strBytes.length);
        
        for (uint i = 0; i < strBytes.length; i++) {
            reversed[i] = strBytes[strBytes.length - 1 - i];
        }
        
        return string(reversed);
    }
}

contract RomanNumberContract {
    function getNumberValue(string memory romanChar) public pure returns (uint256) {
        bytes1 char = bytes(romanChar)[0]; // 提取第一个字符（罗马数字是单字符）
        
        if (char == 'I') return 1;
        if (char == 'V') return 5;
        if (char == 'X') return 10;
        if (char == 'L') return 50;
        if (char == 'C') return 100;
        if (char == 'D') return 500;
        if (char == 'M') return 1000;
        
        revert("Invalid Roman numeral"); // 无效输入时回滚（比返回 0 更安全）
    }

    struct RomanNumeral {
        uint256 value;
        string symbol;
    }

    RomanNumeral[] private romanNumerals;

    constructor() {
        // 初始化罗马数字基数（包括减法规则）
        romanNumerals.push(RomanNumeral(1000, "M"));
        romanNumerals.push(RomanNumeral(900, "CM"));
        romanNumerals.push(RomanNumeral(500, "D"));
        romanNumerals.push(RomanNumeral(400, "CD"));
        romanNumerals.push(RomanNumeral(100, "C"));
        romanNumerals.push(RomanNumeral(90, "XC"));
        romanNumerals.push(RomanNumeral(50, "L"));
        romanNumerals.push(RomanNumeral(40, "XL"));
        romanNumerals.push(RomanNumeral(10, "X"));
        romanNumerals.push(RomanNumeral(9, "IX"));
        romanNumerals.push(RomanNumeral(5, "V"));
        romanNumerals.push(RomanNumeral(4, "IV"));
        romanNumerals.push(RomanNumeral(1, "I"));
    }
    
    function parseRomanNumeral(string memory input) external pure returns (uint256) {
        bytes memory strBytes = bytes(input);
        uint256 total = 0;
        uint256 prevValue = 0;

        // 从右向左解析（罗马数字规则）
        for (uint256 i = strBytes.length; i > 0; i--) {
            string memory currentChar = new string(1);
            bytes(currentChar)[0] = strBytes[i - 1];
            uint256 currentValue = getNumberValue(currentChar);

            // 如果当前字符比前一个字符小，则减去（如 IV = 5 - 1 = 4）
            if (currentValue < prevValue) {
                total -= currentValue;
            } else {
                total += currentValue;
            }
            prevValue = currentValue;
        }

        return total;
    }

    // 数字转罗马数字
    function toRoman(uint256 num) public view returns (string memory) {
        require(num > 0 && num < 4000, "Number out of range (1-3999)");
        string memory result;
        
        for (uint256 i = 0; i < romanNumerals.length; i++) {
            while (num >= romanNumerals[i].value) {
                result = string(abi.encodePacked(result, romanNumerals[i].symbol));
                num -= romanNumerals[i].value;
            }
        }
        
        return result;
    }
}

contract mergeTwoArr {
    function mergeTwoSortedArrays(uint256[] memory arr1, uint256[] memory arr2) external pure returns (uint256[] memory) {
        uint256 len1 = arr1.length;
        uint256 len2 = arr2.length;
        uint256[] memory merged = new uint256[](len1 + len2);
        uint256 i = 0; // arr1 的指针
        uint256 j = 0; // arr2 的指针
        uint256 k = 0; // merged 的指针

        // 遍历两个数组，按顺序合并
        while (i < len1 && j < len2) {
            if (arr1[i] < arr2[j]) {
                merged[k] = arr1[i];
                i++;
            } else {
                merged[k] = arr2[j];
                j++;
            }
            k++;
        }

        // 如果 arr1 还有剩余元素，直接追加
        while (i < len1) {
            merged[k] = arr1[i];
            i++;
            k++;
        }

        // 如果 arr2 还有剩余元素，直接追加
        while (j < len2) {
            merged[k] = arr2[j];
            j++;
            k++;
        }

        return merged;
    }   
}

contract BinarySearch {
    /**
     * @dev 二分查找（循环实现）
     * @param arr 已排序的数组（升序）
     * @param target 要查找的目标值
     * @return 返回目标值的索引，如果未找到返回 type(uint256).max
     */
    function binarySearch(uint256[] memory arr, uint256 target) public pure returns (uint256) {
        uint256 left = 0;
        uint256 right = arr.length;

        while (left < right) {
            uint256 mid = left + (right - left) / 2; // 防止溢出

            if (arr[mid] == target) {
                return mid; // 找到目标
            } else if (arr[mid] < target) {
                left = mid + 1; // 目标在右半部分
            } else {
                right = mid; // 目标在左半部分
            }
        }

        return type(uint256).max; // 未找到
    }
}
