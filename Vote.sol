 
// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;
 
import "./Ownable.sol";
import "./ERC20.sol";
 


contract Vote is ERC20, Ownable {


    mapping (address => uint256) private _votePower;  

    uint256 private _yesVote;
    uint256 private _noVote;
    uint256 private _voteCharge; 
    bool private _openVote;
     
    
    address private _ownerAccount;
    

    constructor(address _address) 
    public {
        
        _voteCharge= 20000;
        
        _ownerAccount = _address;
        _yesVote = 0;
        _noVote = 0;

       _openVote = false; //they can start voting
     
  }


  function  noVoteResult() external view returns (uint256) {
    return _noVote;
  }

 function yesVoteResult () external view returns (uint256){
      return _yesVote;
 }

 function voteResult () public view returns (bool){

   if(_yesVote > _noVote){
      return true;
   }else{
     return false;
   }
   
 }

 function voteCharge() external view returns (uint256){
   return _voteCharge;
 }

   

  function voteIsOpen() external view returns (bool){
      return _openVote;
  }

    
 

   function goVote(address account, bool vote, uint256 amount) external returns (uint256){

    //you can only vote when vote is open
       require(_openVote == true, 'Sorry, vote not open yet'); 

        require(amount >= _voteCharge, "Amount is less than the vote charge");
        
       //burn the vote 
        _burn(account, _voteCharge);
        
          if(vote == true){
    
              _yesVote = _yesVote + 1;
              return _yesVote;
    
          }else{
            _noVote = _noVote + 1;
            return _noVote;
          }
        
    

  }


    

//check if they can start vote or not
 function changeVoteStatus (bool voteType ) external onlyOwner returns (bool){
   _openVote = voteType;
   return true;
 }


  function updateVoteCharge (uint256 amount) external onlyOwner returns (bool){

      _voteCharge = amount;
      return true;
  }


  

 
}