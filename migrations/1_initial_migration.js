const DemetraPrivateSale = artifacts.require("DemetraPrivateSale");

module.exports = function (deployer) {
  var _saleStartTime = 1649703600; 
  var _saleEndTime = 1650265200; 
  var _projectOwner = "0xB54F3E78A0215320bC383d1236A3AFfeBeC4af3d";
  var _tierTwoValue = 30;
  var _tierThreeValue = 70;
  var _whitelistTier1 = [
      "0xb2a05f7ec48910e581eec4b521325ab1857850c9",
      "0xa9abf4f35792d1e01ffd0023fd54aa6ab659630a",
      "0xaf8bf0da3f4485f72b8d8b09ceb0de9d87e58570",
      "0xd640bdd3c961456966b24f421008c57849ec462e",
      "0x1a1606227bb734c8ad152fe64ca88ed0f98f8083",
      "0xb8e89a610ac50360c017973b6135358d9c9bb5ba",
      "0x94d0b565b4889afc869600e1d116edd1d0ffe909",
      "0x3c372f0a7ba1713012de5cae6d6db1dc439aff17",
      "0xaa877109eca3e8084d096abbbba777920cff2de0",
      "0xf761d3b01bb5cfbc1957059e8f849dc90236f832",
      "0x7e7e7383b0d84e6524a92882f743da12d38b17bf",
      "0x3e87b23b02e5980c1fbc2a981c7b80cc167dd918",
      "0x8ffcbca77572d1ea0193059690bf5a5978efa7be",
      "0xdff79ed751f6fcacff91a30aa49323202a3d90df",
      "0x3d7cc0677454158bef757059792671498511365f",
      "0x5f1ed387df106c07f35c8ffc1fb7dff36d2e05d1",
      
  ]
  var _whitelistTier2 = [
    "0xfd9d11095ec4dffbc54eabd96dcf90c9ed897e51",
    "0x15f62c92c5a1b3172b071e3391c82bf815c5e4c8",
    "0x8ca38e86a315d73667e34af762f37a91dc6d60ec",
    "0x45761ee110b5a26cfd15f25a4cdab9d961c0d646",
    "0xad512a11f498879ee3949caadc1561847fbea81b",
    "0x61e0baae8f290b4ae6bd44dfa2b12be316a48400",
    "0x19f03deb28fdb750f487ca4940a28879fd5d9096",
    "0xbe0d91088cd5acbeb0d57ed526c2644bd02102c2",
    "0x37ad540c876fcecf80090493f02068b115ddf8b6",
    "0x9d9c4552908e92fd761f515f78301e04a3601038",
    "0x107d9774abcf262e58509b152317a7708bafe474",
    "0xaacc673d3f15ee3ff555cb295ff7accbea47291a"
  ]
  deployer.deploy(DemetraPrivateSale,_saleStartTime,_saleEndTime,_projectOwner,_tierTwoValue,_tierThreeValue,_whitelistTier1,_whitelistTier2);
};
