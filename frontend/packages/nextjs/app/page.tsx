"use client";

import Link from "next/link";
import type { NextPage } from "next";
import { Address } from "~~/components/scaffold-stark";
import { useAccount } from "@starknet-react/core";
import { Address as AddressType } from "@starknet-react/chains";
import { DebugContracts } from "./debug/_components/DebugContracts";
import {
  createContractCall,
  useScaffoldMultiWriteContract,
} from "~~/hooks/scaffold-stark/useScaffoldMultiWriteContract";
import { useDeployedContractInfo } from "~~/hooks/scaffold-stark/useDeployedContractInfo";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-stark/useScaffoldWriteContract";

const Home: NextPage = () => {
  const connectedAddress = useAccount();

  const mimosa = useDeployedContractInfo("Mimosa");

  const deposit = useScaffoldMultiWriteContract({
    calls: [
      createContractCall("Eth", "approve", [mimosa.data?.address, 100]),
      createContractCall("Mimosa", "deposit", ["0xf00"]),
    ]
  });

  // const withdraw = useScaffoldWriteContract({
  //   contractName: "Mimosa",
  //   functionName: "withdraw",
  //   args: [0n, [1n, 1n], 0xf00n], // index, proof, preimage
  // });

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <div className="flex justify-center items-center space-x-2">
            <p className="my-2 font-medium text-black">Connected Address:</p>
            <Address address={connectedAddress.address as AddressType} />
          </div>
        </div>
      </div>

      {
        <div
          onClick={() => {
            deposit.writeAsync();
          }}
          className="inline-block px-4 py-2 bg-primary text-primary-content border-none rounded cursor-pointer text-center"
        >
          Deposit into Mimosa
        </div>
      }
      {
        <>
          <div style={{ padding: "10px" }}></div>
          <div
            onClick={() => {
              //withdraw.writeAsync();
              alert("not implemented yet");
            }}
            className="inline-block px-4 py-2 bg-primary text-primary-content border-none rounded cursor-pointer text-center"
          >
            Withdraw from Mimosa
          </div>
        </>
      }

      <DebugContracts />
    </>
  );
};

export default Home;
