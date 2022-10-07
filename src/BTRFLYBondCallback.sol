// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

import {BondBaseCallback} from "./bases/BondBaseCallback.sol";
import {IBondAggregator} from "./interfaces/IBondAggregator.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {TransferHelper} from "./lib/TransferHelper.sol";
import {IMariposa} from "./interfaces/IMariposa.sol";

contract BTRFLYBondCallback is BondBaseCallback {
    using TransferHelper for ERC20;

    address public immutable MULTISIG;
    IMariposa public immutable mariposa;

    error ZeroAddress();

    constructor(
        IBondAggregator aggregator_,
        address multisig_,
        address mariposa_
    ) BondBaseCallback(aggregator_) {
        if (multisig_ == address(0)) revert ZeroAddress();
        if (mariposa_ == address(0)) revert ZeroAddress();

        MULTISIG = multisig_;
        mariposa = IMariposa(mariposa_);
    }

    /// @inheritdoc BondBaseCallback
    function _callback(
        uint256 id_,
        ERC20 quoteToken_,
        uint256 inputAmount_,
        ERC20 payoutToken_,
        uint256 outputAmount_
    ) internal override {
        //Transfer token to REDACTED multisig
        quoteToken_.safeTransfer(MULTISIG, inputAmount_);
        //Mint BTRFLY to msg.sender
        mariposa.mintFor(msg.sender, outputAmount_);
    }
}
