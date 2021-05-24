package keeper

import (
	"github.com/jclyons52/voter/x/voter/types"
)

var _ types.QueryServer = Keeper{}
