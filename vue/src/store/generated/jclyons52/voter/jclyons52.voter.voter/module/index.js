// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.
import { SigningStargateClient } from '@cosmjs/stargate'
import { Registry } from '@cosmjs/proto-signing'
import { Api } from './rest'
import { MsgCreatePoll } from './types/voter/tx'
import { MsgCreateVote } from './types/voter/tx'
import { MsgUpdatePoll } from './types/voter/tx'
import { MsgDeletePoll } from './types/voter/tx'
import { MsgUpdateVote } from './types/voter/tx'
import { MsgDeleteVote } from './types/voter/tx'
const types = [
	['/jclyons52.voter.voter.MsgCreatePoll', MsgCreatePoll],
	['/jclyons52.voter.voter.MsgCreateVote', MsgCreateVote],
	['/jclyons52.voter.voter.MsgUpdatePoll', MsgUpdatePoll],
	['/jclyons52.voter.voter.MsgDeletePoll', MsgDeletePoll],
	['/jclyons52.voter.voter.MsgUpdateVote', MsgUpdateVote],
	['/jclyons52.voter.voter.MsgDeleteVote', MsgDeleteVote]
]
export const MissingWalletError = new Error('wallet is required')
const registry = new Registry(types)
const defaultFee = {
	amount: [],
	gas: '200000'
}
const txClient = async (wallet, { addr: addr } = { addr: 'http://localhost:26657' }) => {
	if (!wallet) throw MissingWalletError
	const client = await SigningStargateClient.connectWithSigner(addr, wallet, { registry })
	const { address } = (await wallet.getAccounts())[0]
	return {
		signAndBroadcast: (msgs, { fee, memo } = { fee: defaultFee, memo: '' }) => client.signAndBroadcast(address, msgs, fee, memo),
		msgCreatePoll: (data) => ({ typeUrl: '/jclyons52.voter.voter.MsgCreatePoll', value: data }),
		msgCreateVote: (data) => ({ typeUrl: '/jclyons52.voter.voter.MsgCreateVote', value: data }),
		msgUpdatePoll: (data) => ({ typeUrl: '/jclyons52.voter.voter.MsgUpdatePoll', value: data }),
		msgDeletePoll: (data) => ({ typeUrl: '/jclyons52.voter.voter.MsgDeletePoll', value: data }),
		msgUpdateVote: (data) => ({ typeUrl: '/jclyons52.voter.voter.MsgUpdateVote', value: data }),
		msgDeleteVote: (data) => ({ typeUrl: '/jclyons52.voter.voter.MsgDeleteVote', value: data })
	}
}
const queryClient = async ({ addr: addr } = { addr: 'http://localhost:1317' }) => {
	return new Api({ baseUrl: addr })
}
export { txClient, queryClient }
