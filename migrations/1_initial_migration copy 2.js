const Migrations = artifacts.require("ItemManager");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
