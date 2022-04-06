const DemetraPresale = artifacts.require("DemetraPresale");

module.exports = function (deployer) {
  var _saleStartTime = 1643186217; //14:00 GMT
  var _saleEndTime = 1643791017; //14:30 GMT
  var _projectOwner = "0xaACc673d3F15ee3fF555cb295ff7Accbea47291a";
  var _tierTwoValue = 30;
  var _tierThreeValue = 70;
  deployer.deploy(DemetraPresale,_saleStartTime,_saleEndTime,_projectOwner,_tierTwoValue,_tierThreeValue);
};
