import { deployContract, exportDeployments } from "./deploy-contract";

const ETH = 0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7n;
const STRK =
  0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938dn;

const deployScript = async (): Promise<void> => {
  await deployContract({ token_address: STRK }, "Mimosa");
};

deployScript()
  .then(() => {
    exportDeployments();
    console.log("All Setup Done");
  })
  .catch(console.error);
