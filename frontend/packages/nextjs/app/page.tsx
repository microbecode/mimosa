"use client";

import Link from "next/link";
import type { NextPage } from "next";
import { Address } from "~~/components/scaffold-stark";
import { useAccount, useBalance } from "@starknet-react/core";
import { Address as AddressType } from "@starknet-react/chains";
import { DebugContracts } from "./debug/_components/DebugContracts";
import {
  createContractCall,
  useScaffoldMultiWriteContract,
} from "~~/hooks/scaffold-stark/useScaffoldMultiWriteContract";
import { useDeployedContractInfo } from "~~/hooks/scaffold-stark/useDeployedContractInfo";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-stark/useScaffoldWriteContract";
import { useEffect, useState } from "react";

const strk = "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d";
const user1 = "0x64b48806902a367c8598f4f95c305e8c1a1acba5f082d294a43793113115691";
const user2 = "0x78662e7352d062084b0010068b99288486c2d8b914f6e2a55ce945f8792c8b1";

function BalanceComponent({ address }: { address: string }) {
  const [balanceState, setBalanceState] = useState<BigInt>();
  // {
  //   isLoading: true,
  //   isError: false,
  //   error: null,
  //   data: null
  // });

  const balanceResult = useBalance({
    address,
    token: strk,
    watch: true
  });

  useEffect(() => {
    if (!balanceResult.isLoading) {
      setBalanceState(balanceResult.data?.value);
    }
  });//, [balanceResult.isLoading, balanceResult.isError, balanceResult.data]);

  return <>{ balanceState?.toString() }</>

  // if (balanceState.isLoading) return <div>Loading ... (Address: {address})</div>;
  // if (balanceState.isError || !balanceState.data)
  //   return <div>Error: {balanceState.error?.message || 'Unknown error'}</div>;

  // return <div>{balanceState.data.value.toString()} {balanceState.data.symbol}</div>;
}

const Home: NextPage = () => {
  const connectedAddress = useAccount();

  const mimosa = useDeployedContractInfo("Mimosa");

  const [commitmentValue, setCommitmentValue] = useState<string>("");
  const [user1Balance, setUser1Balance] = useState<string>(
    "1000000000000000000000"
  );
  const [user2Balance, setUser2Balance] = useState<string>(
    "1000000000000000000000"
  );

  useEffect(() => {
    if (commitmentValue) {
      // TODO: convert to Poseidon hash and send to contract
    }
  }, [commitmentValue]);

  const handleCommitmentChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setCommitmentValue(e.target.value);
  };

  const [withdrawIndexValue, setWithdrawIndexValue] = useState<string>("");
  const [withdrawProofValue, setWithdrawProofValue] = useState<string>("");
  const [withdrawPreimageValue, setWithdrawPreimageValue] =
    useState<string>("");

  const handleWithdrawIndexChange = (
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    setWithdrawIndexValue(e.target.value);
  };
  const handleWithdrawProofChange = (
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    setWithdrawProofValue(e.target.value);
  };
  const handleWithdrawPreimageChange = (
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    setWithdrawPreimageValue(e.target.value);
  };

  const deposit = useScaffoldMultiWriteContract({
    calls: [
      createContractCall("Eth", "approve", [mimosa.data?.address, 100]),
      createContractCall("Mimosa", "deposit", [commitmentValue]),
    ],
  });

  const withdraw = useScaffoldWriteContract({
    contractName: "Mimosa",
    functionName: "withdraw",
    // TODO: proof should be a list of bigints, handle it
    args: [[Number(withdrawProofValue)], Number(withdrawPreimageValue)],
    //args: [0, [0], 0]
  });

  return (
    <>
      <div className="flex items-center flex-col py-8 pt-10">
        <div className="px-5">
          <div className="flex justify-center items-center space-x-2">
            <p className="my-2 font-medium text-black">Connected Address:</p>
            <Address address={connectedAddress.address as AddressType} />
          </div>
        </div>
      </div>

      {
        <div className="flex justify-center w-full p-4">
          <div className="flex flex-col items-start space-y-2 bg-white shadow-md rounded-lg p-6 max-w-md w-full">
            <p className="text-lg font-semibold text-gray-700">Deposit:</p>
            <input
              type="text"
              value={commitmentValue}
              onChange={handleCommitmentChange}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Secret (felt252)"
            />
            <div
              onClick={() => {
                deposit.writeAsync();
              }}
              className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              Deposit into Mimosa
            </div>
          </div>
        </div>
      }

      {
        <div className="flex justify-center w-full p-4 ">
          <div className="flex flex-col items-start space-y-2 bg-white shadow-md rounded-lg p-6 max-w-md w-full">
            <p className="text-lg font-semibold text-gray-700">Withdraw:</p>
            <input
              type="text"
              value={withdrawProofValue}
              onChange={handleWithdrawProofChange}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Proof (Span<felt252>)"
            />
            <input
              type="text"
              value={withdrawPreimageValue}
              onChange={handleWithdrawPreimageChange}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Secret (felt252)"
            />
            <div
              onClick={() => {
                withdraw.writeAsync();
              }}
              className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              Withdraw from Mimosa
            </div>
          </div>
        </div>
      }

      {
      <div className="flex flex-col items-center w-full">
        <p className="mb-2 text-center text-black">User 1 STRK: <BalanceComponent address={user1} /></p>
        <p className="mb-2 text-center text-black">User 2 STRK: <BalanceComponent address={user2} /></p>
      </div>
      }

    </>
  );
};

export default Home;
