pragma solidity >=0.4.0 <0.7.0;

import { Ownable } from "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/ownership/Ownable.sol";
import { IERC20 } from "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/IERC20.sol";

contract FantasyLeague is Ownable{
    IERC20 public dai;
    address admin;
    uint tournamentId;
    
    constructor(IERC20 _dai, address _admin) public {
        dai = _dai;
        admin = _admin;
        tournamentId = 100;
    }
    
    struct Participant { 
        mapping (address => uint) betters;
        address[] betterList;
        uint totalBet;
    }
    
    struct Tournament{
         mapping (address => Participant) participants;
         bool isComplete;
         address winner;
         uint totalBet;
    }
        
    mapping (uint => Tournament) public tournaments;
    
    function addTournament() public {
        require(msg.sender == admin);
        Tournament storage tournament = tournaments[tournamentId];
        tournament.isComplete = false;
        tournamentId += 1;
    }

    function addParticipants(address[] memory _participantsArray, uint _tournamentId) public {
        require(msg.sender == admin);
        Tournament storage tournament = tournaments[_tournamentId];
        for(uint256 i = 0; i < _participantsArray.length; i++) {
             Participant storage participant = tournament.participants[_participantsArray[i]];
             participant.totalBet = 0;
             tournament.totalBet = 0;
        }
    }
    
    function bet(uint _tournamentId, address _betOn, uint _amount) public {
        Tournament storage tournament = tournaments[_tournamentId];
        require((dai.transferFrom(msg.sender, address(this), _amount) && tournament.isComplete == false), 'Could not transfer DAI');
        Participant storage participant = tournament.participants[_betOn];
        participant.betters[msg.sender] += _amount;
        tournament.totalBet += _amount; 
        participant.betterList.push(msg.sender);
    }
    
    function settle(uint _tournamentId, address _winner) public {
        Tournament storage tournament = tournaments[_tournamentId];
        require((msg.sender == admin && tournament.isComplete == false), 'Send from admin account');
        Participant storage participant = tournament.participants[_winner];

        for(uint256 i = 0; i < participant.betterList.length; i++) {
            dai.transfer(participant.betterList[i], dai.balanceOf(address(this))/ participant.betterList.length );
        }
        tournament.isComplete = true;
        tournament.winner = _winner;
    }
    
    function getTournamentDetails() public view returns(uint) {
        return (tournamentId);
    }
    
    function getTotalBet(uint _tournamentId) public view returns(address, uint){
        return (tournaments[_tournamentId].winner, tournaments[_tournamentId].totalBet);
    }
    
}