// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.
import { SigningStargateClient } from "@cosmjs/stargate";
import { Registry } from "@cosmjs/proto-signing";
import { Api } from "./rest";
import { MsgDeletePoll } from "./types/voter/tx";
import { MsgUpdatePoll } from "./types/voter/tx";
import { MsgCreatePoll } from "./types/voter/tx";
const types = [
    ["/jclyons52.voter.voter.MsgDeletePoll", MsgDeletePoll],
    ["/jclyons52.voter.voter.MsgUpdatePoll", MsgUpdatePoll],
    ["/jclyons52.voter.voter.MsgCreatePoll", MsgCreatePoll],
];
const registry = new Registry(types);
const defaultFee = {
    amount: [],
    gas: "200000",
};
const txClient = async (wallet, { addr: addr } = { addr: "http://localhost:26657" }) => {
    if (!wallet)
        throw new Error("wallet is required");
    const client = await SigningStargateClient.connectWithSigner(addr, wallet, { registry });
    const { address } = (await wallet.getAccounts())[0];
    return {
        signAndBroadcast: (msgs, { fee = defaultFee, memo = null }) => memo ? client.signAndBroadcast(address, msgs, fee, memo) : client.signAndBroadcast(address, msgs, fee),
        msgDeletePoll: (data) => ({ typeUrl: "/jclyons52.voter.voter.MsgDeletePoll", value: data }),
        msgUpdatePoll: (data) => ({ typeUrl: "/jclyons52.voter.voter.MsgUpdatePoll", value: data }),
        msgCreatePoll: (data) => ({ typeUrl: "/jclyons52.voter.voter.MsgCreatePoll", value: data }),
    };
};
const queryClient = async ({ addr: addr } = { addr: "http://localhost:1317" }) => {
    return new Api({ baseUrl: addr });
};
export { txClient, queryClient, };
