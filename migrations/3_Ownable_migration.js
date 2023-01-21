const Migrations = artifacts.require("Ownable");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
