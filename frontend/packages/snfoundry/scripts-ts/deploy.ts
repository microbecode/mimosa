import { deployContract, exportDeployments } from "./deploy-contract";

const ETH = 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7n;
const STRK =
  0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938dn;

const deployScript = async (): Promise<void> => {
  await deployContract({ token_address: ETH }, "Mimosa");
};

deployScript()
  .then(() => {
    exportDeployments();
    console.log("All Setup Done");
  })
  .catch(console.error);
