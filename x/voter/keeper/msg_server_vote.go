package keeper

import (
	"context"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/jclyons52/voter/x/voter/types"
)

func (k msgServer) CreateVote(goCtx context.Context, msg *types.MsgCreateVote) (*types.MsgCreateVoteResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	voteList := k.GetAllVote(ctx)
	for _, existingVote := range voteList {
		if existingVote.Creator == msg.Creator && existingVote.PollID == msg.PollID {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Vote already cast.")
		}
	}

	id := k.AppendVote(
		ctx,
		msg.Creator,
		msg.PollID,
		msg.Option,
	)

	return &types.MsgCreateVoteResponse{
		Id: id,
	}, nil
}

func (k msgServer) UpdateVote(goCtx context.Context, msg *types.MsgUpdateVote) (*types.MsgUpdateVoteResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	var vote = types.Vote{
		Creator: msg.Creator,
		Id:      msg.Id,
		PollID:  msg.PollID,
		Option:  msg.Option,
	}

	// Checks that the element exists
	if !k.HasVote(ctx, msg.Id) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("key %d doesn't exist", msg.Id))
	}

	// Checks if the the msg sender is the same as the current owner
	if msg.Creator != k.GetVoteOwner(ctx, msg.Id) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	k.SetVote(ctx, vote)

	return &types.MsgUpdateVoteResponse{}, nil
}

func (k msgServer) DeleteVote(goCtx context.Context, msg *types.MsgDeleteVote) (*types.MsgDeleteVoteResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if !k.HasVote(ctx, msg.Id) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("key %d doesn't exist", msg.Id))
	}
	if msg.Creator != k.GetVoteOwner(ctx, msg.Id) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	k.RemoveVote(ctx, msg.Id)

	return &types.MsgDeleteVoteResponse{}, nil
}
