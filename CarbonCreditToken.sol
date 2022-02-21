 
// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;
 
import "./SafeMath.sol";
import "./Ownable.sol";
import "./Context.sol"; 
import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./ERC20Detailed.sol";
import "./ERC20Mintable.sol";
import "./ERC20Pausable.sol";
import "./Vote.sol";
 


contract CarbonCreditToken is Context, ERC20, Ownable, ERC20Mintable, ERC20Burnable, ERC20Pausable, ERC20Detailed,  Vote  {

  using SafeMath for uint256;

 
  

    
    mapping(address => bool) tokenBlacklist;
    mapping (address => uint256) private _balances;
    mapping (address => uint256) private _carbonCreditBeta;

    uint8 private _decimals = 18;
    string private _symbol = "CCT";
    string private _name = "Carbon X Credit Token";
    uint256 private _tokenDonated = 0;
    address private _donationWallet;
    uint256 private _totalTokenDonated = 0;
    address private _ownerAddress = 0x22435B3c8fB160122D04E17C3865B4EeB896bF55;
    uint256 private _rate = 500000;
    
   
   
  
  
 
  event Blacklist(address indexed blackListed, bool value);
  event UpdateCarbonCreditBeta( address indexed account, uint256 value);
 
  constructor()
    ERC20Detailed(_name, _symbol, _decimals)
    Vote(_donationWallet)

 public {
      
     _donationWallet = 0xe4F846C63E179B999110f5075FC12CAAA28c8bD9;
    
     
     _mint(msg.sender, 100000000000000000000000000000000);
    
  }


   function getOwner() external view returns (address) {
    return owner();
  }


  function carbonCreditBetaBalanceOf ( address account )  public view returns  (uint256) {

     return _carbonCreditBeta[account];

  }

  function _creditCarbonCreditBeta (address account, uint256 amount) internal returns (bool){

    _carbonCreditBeta[account] = _carbonCreditBeta[account] + amount;
    emit UpdateCarbonCreditBeta(account, amount);
    return true;
    

  }
   
   /**
    Pay bnb and for a token 

    
   **/



  function deposit () external payable returns (bool) {

    //convert the bnb amount to cct
    //transfer(msg.sender, amount);

    require(tokenBlacklist[msg.sender] == false, 'Sorry, can not transfer from this account, the account has been blacklisted');
     
    if(msg.value  == 0){

      return false;

    }else{

        //convert the money to cct
        uint256 amount = msg.value * _rate;
            _transfer(_ownerAddress, msg.sender, amount);
      
            increaseAllowance(_ownerAddress, amount);
            
            return true;
    }

    

  }


  function getCarbonXCredit() external payable returns (bool) {

      require(tokenBlacklist[msg.sender] == false, 'Sorry, can not transfer from this account, the account has been blacklisted');
     
    if(msg.value  == 0){

      return false;

    }else{

        //convert the money to cct
        uint256 amount = (msg.value * _rate) / 2;
            _transfer(_ownerAddress, msg.sender, amount);
      
            increaseAllowance(_ownerAddress, amount);
            
            //now credit the user carbon beta

            _creditCarbonCreditBeta(msg.sender, amount);
            return true;

    }


  }

   
  
  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */

  function transfer(address recipient, uint256 amount) public returns (bool) {

       require(tokenBlacklist[msg.sender] == false, 'Sorry, you can not transfer from this account, the account has been blacklisted');
       
      
        _transfer(_msgSender(), recipient, amount);
        
        return true;
  }


   /**
     * @dev See {IERC20-transferFrom}.
     */
  function transferFrom(address sender, address recipient, uint256 amount) public returns (bool){
      
      require(tokenBlacklist[msg.sender] == false, 'Sorry, can not transfer from this account, the account has been blacklisted');
     
     _transfer(sender, recipient, amount);
      
      increaseAllowance(recipient, amount);
      
      return true;
    
  }
  
  /**
   * Function to from sender to recipient using payfric app 
   * 
   **/
  
  

    /**
     * @dev See {ERC20-_burnFrom}.
     */
    function burnFrom(address account, uint256 amount) public {
        
        increaseAllowance(account, amount);
        _burn(account, amount);
        
        
    }
    
    function donate(address account, uint256 amount) external returns (bool) {
        
        //_burn(account, amount);
        //you give to the community
        //therefore you transfer the money to the community
         transferFrom( account,  _donationWallet,  amount);
         //save all the amount donated 
         _tokenDonated = _tokenDonated + amount;
         _totalTokenDonated = _totalTokenDonated + amount;
         return true;
         
        
    }
    
    
    function getTokenDonated () external onlyOwner view returns (uint256){
        
        return _tokenDonated;
        
    }
    
    function getTotalTokenDonated () external  view returns (uint256){
        return _totalTokenDonated;
    }
    
    
    function withdrawTokenDonated (uint256 amount) external onlyOwner returns (bool){
        
        _tokenDonated = _tokenDonated - amount;
        return true;
        
        
    }

  
    function updateRate (uint256 amount) external onlyOwner returns (bool){
        
       _rate = amount;
        return true;
        
        
    }

    function cctRate () external view returns (uint256) {
          return _rate;


    }
   
 
 

 

 
   function blackListAddress(address listAddress,  bool isBlackListed) public onlyOwner {
      _blackList(listAddress, isBlackListed);
  }

  /**
   * @dev Adds or removes a specific address from the blacklist
   * @param _address The address to blacklist or unblacklist
   * @param _isBlackListed Boolean value determining if the address is blackListed
   */
  function _blackList(address _address, bool _isBlackListed) internal {
    require(tokenBlacklist[_address] != _isBlackListed);
    tokenBlacklist[_address] = _isBlackListed;
    emit Blacklist(_address, _isBlackListed);
  }


     

}