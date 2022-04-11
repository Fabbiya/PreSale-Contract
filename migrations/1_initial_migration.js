const DemetraPrivateSale = artifacts.require("DemetraPrivateSale");

module.exports = function (deployer) {
  var _saleStartTime = 1649574000; 
  var _saleEndTime = 1650265200; 
  var _projectOwner = "0xB54F3E78A0215320bC383d1236A3AFfeBeC4af3d";
  var _tierTwoValue = 30;
  var _tierThreeValue = 70;
  deployer.deploy(DemetraPrivateSale,_saleStartTime,_saleEndTime,_projectOwner,_tierTwoValue,_tierThreeValue);
};
