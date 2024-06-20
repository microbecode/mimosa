import { hash } from "starknet";
import * as starknet from "@scure/starknet";

const sn = hash.computePoseidonHashOnElements([0xf00n, 0n, 1n]);

const scr = starknet.poseidonHashMany([0xf00n, 0n, 1n]);

console.log(`have: ${sn})}`);
console.log(`have: 0x${scr.toString(16)}`);
console.log(
  "need: 0x2fb4b56113252d12708bc6a9b4976c19b5d3badc99f4db151896bb0c7895774",
);
