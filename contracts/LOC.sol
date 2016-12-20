pragma solidity ^0.4.4;

import "ChronoMintConfigurable.sol";

contract LOC is ChronoMintConfigurable {
  enum Status  {maintenance, active, suspended, bankrupt}
  Status public status;
  uint public approverCount;

  function LOC(string _name, address _mint, address _controller, uint _issueLimit, string _publishedHash){
    chronoMint = _mint;
    status = Status.maintenance;
    stringSettings["name"] = _name;
    stringSettings["publishedHash"] = _publishedHash;
    settings["issueLimit"] = _issueLimit;
    settings["redeemed"] = 0;
  }

  function approved() onlyMint{
    setStatus(Status.active);
  }

  function isController(address _ad) returns(bool) {
    if (_ad == settings["controller"])
      return true;
    else
      return false;
  }

  modifier onlyController() {
    if ((isController(msg.sender) && status == Status.active) || isMint(msg.sender)) {
      _;
      } else {
        return;
      }
  }

  function getName() returns(string) {
    return stringSettings["name"];
  }

  function setStatus(Status _status) onlyMint {
    status = _status;
  }

  function setIssueLimit(uint _issueLimit) onlyMint {
    settings["issueLimit"] = _issueLimit;
  }

  function setController(address _controller) onlyController {
    settings["controller"] = _controller;
  }

  function setWebsite(string _website) onlyController {
    stringSettings["website"] = _website;
  }
}
