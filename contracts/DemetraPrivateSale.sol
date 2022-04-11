// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/*
 *Demetra.finance
 *Security Provider
 *Inheritance protocol eliminates concerns about loss of crypto assets even after the death with assigning backup wallet or setup a will
 *Private sale contract with 3 Tiers with different allocation
 *Tier 0.0 -> public
 *Tier 1.0 -> 0.1 - 5 BNB
 *Tier 2.0 -> 5 - 20 BNB
 */

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DemetraPrivateSale is Ownable {
    
    bool public isPublic;
    //token attributes
    string public constant NAME = "DMT Private Sale"; //name of the contract
    uint256 public  maxCap = 400 * (10**18); // Max cap in BNB

    uint256 public saleStartTime; // start sale time
    uint256 public saleEndTime; // end sale time in tier 1

    uint256 public totalBnbReceivedInAllTier; // total bnd received

    uint256 public totalBnbInTierZero; // total bnb for tier Zero
    uint256 public totalBnbInTierOne; // total bnb for tier one
    uint256 public totalBnbInTierTwo; // total bnb for tier two

    uint256 public totalparticipants; // total participants
    address payable public projectOwner; // project Owner

    // max cap per tier

    uint256 public tierZeroMaxCap;
    uint256 public tierOneMaxCap;
    uint256 public tierTwoMaxCap;

    //max allocations per user in a tier

    uint256 public maxAllocaPerUserTierZero;
    uint256 public maxAllocaPerUserTierOne;
    uint256 public maxAllocaPerUserTierTwo;

    //min allocation per user in a tier

    uint256 public minAllocaPerUserTierZero;
    uint256 public minAllocaPerUserTierOne;
    uint256 public minAllocaPerUserTierTwo;

    //tier 1 is public no whitelist
    // address array for tier one whitelist
    //address[] private whitelistTierOne;
    address[] private whitelistTierOne;
    address[] private whitelistTierTwo;

    //mapping the user purchase per tier

    mapping(address => uint256) public buyInTierZero;
    mapping(address => uint256) public buyInTierOne;
    mapping(address => uint256) public buyInTierTwo;

    address[] public tierZeroParticipants;
    address[] public tierOneParticipants;
    address[] public tierTwoParticipants;
    

    // CONSTRUCTOR
    constructor(
        uint256 _saleStartTime,
        uint256 _saleEndTime,
        address payable _projectOwner,
        uint256 _tierOneValue, //percentage eg = 30
        uint256 _tierTwoValue //percentage eg = 70
      ) {
        isPublic = false; //whitelist

        saleStartTime = _saleStartTime;
        saleEndTime = _saleEndTime;

        projectOwner = _projectOwner;

        tierOneMaxCap = _tierOneValue * (maxCap / 100);
        tierTwoMaxCap = _tierTwoValue * (maxCap / 100);
        tierZeroMaxCap = maxCap - tierOneMaxCap - tierTwoMaxCap; //public

        minAllocaPerUserTierZero = 10 **17;
        minAllocaPerUserTierOne = 10**17;
        minAllocaPerUserTierTwo = 5 * (10**18);

        maxAllocaPerUserTierZero = 20 * 10**18;
        maxAllocaPerUserTierOne = 5 * 10**18;
        maxAllocaPerUserTierTwo = 20 * 10**18;

        totalparticipants = 0;
    }

    

     //function to set tier manually
    function changeTier(
        bool _isPublic,
        uint256 _tierOneValue,
        uint256 _tierTwoValue
    ) external onlyOwner {
        isPublic = _isPublic;
        if(isPublic){
            tierZeroMaxCap = maxCap - totalBnbReceivedInAllTier;
            tierOneMaxCap = totalBnbInTierOne;
            tierTwoMaxCap=totalBnbInTierTwo;
        }
        else{
            tierZeroMaxCap = 0;
            tierOneMaxCap = _tierOneValue * (maxCap / 100);
            tierTwoMaxCap = _tierTwoValue * (maxCap / 100);
        }
    }

    function setStartTime(uint256 start) external onlyOwner{
        saleStartTime = start;
    }
    function setEndTime(uint256 end) external onlyOwner{
        saleEndTime = end;
    }
    //add the address in Whitelist tier one to invest
    function addWhitelistOne(address _address) external onlyOwner {
        require(_address != address(0), "Invalid address");
        whitelistTierOne.push(_address);
    }

    //add the address in Whitelist tier two to invest
    function addWhitelistTwo(address _address) external onlyOwner {
        require(_address != address(0), "Invalid address");
        whitelistTierTwo.push(_address);
    }

   

    // check the address in whitelist tier two
    function getWhitelistOne(address _address) public view returns (bool) {
        uint256 i;
        uint256 length = whitelistTierOne.length;
        for (i = 0; i < length; i++) {
            if (whitelistTierOne[i] == _address) {
                return true;
            }
        }
        return false;
    }

    // check the address in whitelist tier three
    function getWhitelistTwo(address _address) public view returns (bool) {
        uint256 i;
        uint256 length = whitelistTierTwo.length;
        for (i = 0; i < length; i++) {
            if (whitelistTierTwo[i] == _address) {
                return true;
            }
        }
        return false;
    }

    

    // send bnb to the contract address
    receive() external payable {
        require(
            block.timestamp >= saleStartTime,
            "The sale is not started yet "
        ); // solhint-disable
        require(block.timestamp <= saleEndTime, "The sale is closed"); // solhint-disable
        require(
            totalBnbReceivedInAllTier + msg.value <= maxCap,
            "buyTokens: purchase would exceed max cap"
        );

        if (isPublic) {
            require(
                buyInTierZero[msg.sender] + msg.value >= minAllocaPerUserTierZero,
                "your purchasing Power is so Low"
            );
            require(
                buyInTierZero[msg.sender] + msg.value <= maxAllocaPerUserTierZero,
                "you are investing more than your Tier 0.0 limit!"
            );
            require(
                totalBnbInTierZero + msg.value <= tierZeroMaxCap,
                "buyTokens: purchase would exceed Tier one max cap"
            );
            require(
                buyInTierZero[msg.sender] +buyInTierOne[msg.sender] +buyInTierTwo[msg.sender] + msg.value <= maxAllocaPerUserTierZero,
                "buyTokens:You are investing more than your all Tiers limit!"
            );

            

            buyInTierZero[msg.sender] += msg.value;
            tierZeroParticipants.push(msg.sender);
            totalBnbReceivedInAllTier += msg.value;
            totalBnbInTierZero += msg.value;
            
             //payable(projectOwner).transfer(address(this).balance);
             Address.sendValue(payable(projectOwner), address(this).balance);
             //payable(projectOwner).sendValue(projectOwner,address(this).balance);
        } else if (getWhitelistOne(msg.sender)) {
            require(
                buyInTierOne[msg.sender] + msg.value >= minAllocaPerUserTierOne,
                "your purchasing Power is so Low"
            );
            require(
                totalBnbInTierOne + msg.value <= tierOneMaxCap,
                "buyTokens: purchase would exceed Tier 1.0 max cap"
            );
            require(
                buyInTierOne[msg.sender] + msg.value <= maxAllocaPerUserTierOne,
                "buyTokens:You are investing more than your Tier 1.0 limit!"
            );
            require(
                buyInTierZero[msg.sender] +buyInTierOne[msg.sender] +buyInTierTwo[msg.sender] + msg.value <= maxAllocaPerUserTierOne,
                "buyTokens:You are investing more than your all Tiers limit!"
            );

            buyInTierOne[msg.sender] += msg.value;
            tierOneParticipants.push(msg.sender);
            totalBnbReceivedInAllTier += msg.value;
            totalBnbInTierOne += msg.value;
            //sendValue(projectOwner, address(this).balance);
            //payable(projectOwner).transfer(address(this).balance);
            Address.sendValue(payable(projectOwner), address(this).balance);
        } else if (getWhitelistTwo(msg.sender)) {
            require(
                buyInTierTwo[msg.sender] + msg.value >=
                    minAllocaPerUserTierTwo,
                "your purchasing Power is so Low"
            );
            require(
                buyInTierTwo[msg.sender] + msg.value <=
                    maxAllocaPerUserTierTwo,
                "buyTokens:You are investing more than your tier-3 limit!"
            );
            require(
                totalBnbInTierTwo + msg.value <= tierTwoMaxCap,
                "buyTokens: purchase would exceed Tier three max cap"
            );
            require(
                buyInTierZero[msg.sender] +buyInTierOne[msg.sender] +buyInTierTwo[msg.sender] + msg.value <= maxAllocaPerUserTierTwo,
                "buyTokens:You are investing more than your all Tiers limit!"
            );
            buyInTierTwo[msg.sender] += msg.value;
            tierTwoParticipants.push(msg.sender);
            totalBnbReceivedInAllTier += msg.value;
            totalBnbInTierTwo += msg.value;
            //payable(projectOwner).transfer(address(this).balance);
            Address.sendValue(payable(projectOwner), address(this).balance);
        } else {
            revert();
        }
    }
}

