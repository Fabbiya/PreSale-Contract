// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/*
 *Demetra.finance
 *Inheritance Protocol Provider
 *Inheritance protoloc eliminates concerns about loss of crypto assets after the death
 */

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract DemetraPresale is Ownable {
    //select sale : tier1 whitelist = 1 , tier2 whitelist = 2
    bool public isPublic;
    //token attributes
    string public constant NAME = "DMT Presale"; //name of the contract
    uint256 public  maxCap = 200 * (10**18); // Max cap in BNB

    uint256 public saleStartTime; // start sale time
    uint256 public saleEndTime; // end sale time in tier 1

    uint256 public totalBnbReceivedInAllTier; // total bnd received

    uint256 public totalBnbInTierOne; // total bnb for tier one
    uint256 public totalBnbInTierTwo; // total bnb for tier two
    uint256 public totalBnbInTierThree; // total bnb for tier three

    uint256 public totalparticipants; // total participants
    address payable public projectOwner; // project Owner

    // max cap per tier

    uint256 public tierOneMaxCap;
    uint256 public tierTwoMaxCap;
    uint256 public tierThreeMaxCap;

    //max allocations per user in a tier

    uint256 public maxAllocaPerUserTierOne;
    uint256 public maxAllocaPerUserTierTwo;
    uint256 public maxAllocaPerUserTierThree;

    //min allocation per user in a tier

    uint256 public minAllocaPerUserTierOne;
    uint256 public minAllocaPerUserTierTwo;
    uint256 public minAllocaPerUserTierThree;

    //tier 0 is puvlic no whitelist
    // address array for tier one whitelist
    //address[] private whitelistTierOne;
    address[] private whitelistTierTwo;
    address[] private whitelistTierThree;

    //mapping the user purchase per tier

    mapping(address => uint256) public buyInOneTier;
    mapping(address => uint256) public buyInTwoTier;
    mapping(address => uint256) public buyInThreeTier;

    

    // CONSTRUCTOR
    constructor(
        uint256 _saleStartTime,
        uint256 _saleEndTime,
        address payable _projectOwner,
        uint256 _tierTwoValue,
        uint256 _tierThreeValue
      ) {
        isPublic = false; //whitelist

        saleStartTime = _saleStartTime;
        saleEndTime = _saleEndTime;

        projectOwner = _projectOwner;

        tierTwoMaxCap = _tierTwoValue * (maxCap / 100);
        tierThreeMaxCap = _tierThreeValue * (maxCap / 100);
        tierOneMaxCap = maxCap - tierTwoMaxCap - tierThreeMaxCap; //public

        minAllocaPerUserTierOne = 1;
        minAllocaPerUserTierTwo = 10**17;
        minAllocaPerUserTierThree = 5 * (10**18);

        maxAllocaPerUserTierOne = 20 * 10**18;
        maxAllocaPerUserTierTwo = 5 * 10**18;
        maxAllocaPerUserTierThree = 20 * 10**18;

        totalparticipants = 0;
    }

    // function to update the tiers value manually
    function updateTierCaps(
        uint256 _tierOneValue,
        uint256 _tierTwoValue,
        uint256 _tierThreeValue
      ) external onlyOwner {
        tierOneMaxCap = _tierOneValue;
        tierTwoMaxCap = _tierTwoValue;
        tierThreeMaxCap = _tierThreeValue;
        maxCap = tierOneMaxCap + tierTwoMaxCap + tierThreeMaxCap;

        //maxAllocaPerUserTierOne = tierOneMaxCap / totalUserInTierOne;
        //maxAllocaPerUserTierTwo = tierTwoMaxCap / totalUserInTierTwo;
    }

     //function to set tier manually
    function changeTier(
        bool _isPublic,
        uint256 _salesStartTime,
        uint256 _salesEndTime
    ) external onlyOwner {
        isPublic = _isPublic;
        saleStartTime = _salesStartTime;
        saleEndTime = _salesEndTime;
    }

    //add the address in Whitelist tier two to invest
    function addWhitelistTwo(address _address) external onlyOwner {
        require(_address != address(0), "Invalid address");
        whitelistTierTwo.push(_address);
    }

    //add the address in Whitelist tier two to invest
    function addWhitelistThree(address _address) external onlyOwner {
        require(_address != address(0), "Invalid address");
        whitelistTierThree.push(_address);
    }

   

    // check the address in whitelist tier two
    function getWhitelistTwo(address _address) public view returns (bool) {
        uint256 i;
        uint256 length = whitelistTierTwo.length;
        for (i = 0; i < length; i++) {
            address _addressArr = whitelistTierTwo[i];
            if (_addressArr == _address) {
                return true;
            }
        }
        return false;
    }

    // check the address in whitelist tier three
    function getWhitelistThree(address _address) public view returns (bool) {
        uint256 i;
        uint256 length = whitelistTierThree.length;
        for (i = 0; i < length; i++) {
            address _addressArr = whitelistTierThree[i];
            if (_addressArr == _address) {
                return true;
            }
        }
        return false;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
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
                buyInOneTier[msg.sender] + msg.value >= minAllocaPerUserTierOne,
                "your purchasing Power is so Low"
            );
            require(
                totalBnbInTierOne + msg.value <= tierOneMaxCap,
                "buyTokens: purchase would exceed Tier one max cap"
            );
            require(
                buyInOneTier[msg.sender] + msg.value <= maxAllocaPerUserTierOne,
                "buyTokens:You are investing more than your tier-1 limit!"
            );

            require(
                buyInTwoTier[msg.sender] + msg.value <= maxAllocaPerUserTierOne,
                "buyTokens:You are investing more than your all tier limit!"
            );

            require(
                buyInThreeTier[msg.sender] + msg.value <= maxAllocaPerUserTierOne,
                "buyTokens:You are investing more than your all tier limit!"
            );

            buyInOneTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBnbInTierOne += msg.value;
            
             payable(projectOwner).transfer(address(this).balance);
        } else if (getWhitelistTwo(msg.sender)) {
            require(
                buyInTwoTier[msg.sender] + msg.value >= minAllocaPerUserTierTwo,
                "your purchasing Power is so Low"
            );
            require(
                totalBnbInTierTwo + msg.value <= tierTwoMaxCap,
                "buyTokens: purchase would exceed Tier two max cap"
            );
            require(
                buyInTwoTier[msg.sender] + msg.value <= maxAllocaPerUserTierTwo,
                "buyTokens:You are investing more than your tier-2 limit!"
            );

            buyInTwoTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBnbInTierTwo += msg.value;
            //sendValue(projectOwner, address(this).balance);
            payable(projectOwner).transfer(address(this).balance);
        } else if (getWhitelistThree(msg.sender)) {
            require(
                buyInThreeTier[msg.sender] + msg.value >=
                    minAllocaPerUserTierThree,
                "your purchasing Power is so Low"
            );
            require(
                buyInThreeTier[msg.sender] + msg.value <=
                    maxAllocaPerUserTierThree,
                "buyTokens:You are investing more than your tier-3 limit!"
            );
            require(
                totalBnbInTierThree + msg.value <= tierThreeMaxCap,
                "buyTokens: purchase would exceed Tier three max cap"
            );

            buyInThreeTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBnbInTierThree += msg.value;
            payable(projectOwner).transfer(address(this).balance);

        } else {
            revert();
        }
    }
}

