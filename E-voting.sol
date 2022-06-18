//SPDX License Identifier: MIT
pragma solidity ^0.8.0;

contract ELECTIONS {

    // struct is a method to create your own data type

    //voters: voted = bool , access to vote = uint, vote index(total number of votes and whom voted) = uint

    struct Voter {
        bool voted;
        uint vote;
        uint index; 
    } 
    
    struct Proposal {

        //bytes are a basic unit measurement of information in computer processing
        //can also use string but it takes more gass fees
        string name; //the name of each proposal
        uint voteCount; //number of accumulated votes
    }

    Proposal [] public proposals;

    //mapping allows for us to create a store value with keys and indexxes

    mapping (address => Voter) public voters;
    //voters get address as a key and voter for value

    address public chairperson;

    constructor(string[] memory proposalNames){
//memory defines a temporary data location during run time only of methods
// like we haven't mentioned proposalNames anywhere above in structure
//we guarantee space for it 
// msg.sender is a global variable that states the person who is currently connecting to te contract 

    chairperson = msg.sender;

//add 1 person to chairperson weight
    voters[chairperson].index =1;

//will add the proposal names to the smart contracts upon deployment
    for(uint i=0; i<proposalNames.length; i++) {
        proposals.push(Proposal({
            name:proposalNames[i],
            voteCount:0
        }));
    }
    }

//function authenticate votes
function approval (address voter) public {
    require(msg.sender==chairperson,"only chairperson can give access to vote");
    //require that the voter haven't voted yet
    require(!voters[voter].voted, "The voter has already voted");
    require(voters[voter].index==0);

    voters[voter].index=1;
}

//function for voting
function vote (uint proposal) public{
    Voter storage sender = voters[msg.sender];
    require(sender.index !=0, "Has not allowed to vote");
    require(!sender.voted, "Already voted");
    sender.voted=true;
    sender.vote=proposal;

  //  proposals[proposal].voteCount = proposals[proposal].voteCount + sender.index;
    proposals[proposal].voteCount += sender.index;
} 

//function for results



//function that shows the winning proposal by integer
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningCount = 0;
        for(uint i=0; i<proposals.length;i++) {
            if(proposals[i].voteCount>winningCount){
                winningCount = proposals[i].voteCount;                
                winningProposal_ = i;
            }
        }
    }


//function that shows the winner by name
    function winningName() public view returns (string memory winningName_) {
       winningName_= proposals[winningProposal()].name;
    }


}