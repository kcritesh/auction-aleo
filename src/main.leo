program auction.aleo {

    // Represents a bid in the auction.
    // - `owner`: The address of the entity managing the auction.
    // - `bidder`: The address of the person who placed the bid.
    // - `amount`: The bid amount.
    // - `is_winner`: True if this is the winning bid.
    record Bid {
        owner: address,
        bidder: address,
        amount: u64,
        is_winner: bool,
    }

    // Allows a user to place a bid.
    // - `bidder`: The address of the person placing the bid.
    // - `amount`: The bid amount.
    // The function checks if the caller is the same as the bidder.
    // The auction manager's address is hardcoded.
    transition place_bid(bidder: address, amount: u64) -> Bid {
        // Ensure the caller is the person placing the bid.
        assert_eq(self.caller, bidder);

        // Create and return a new Bid record.
        return Bid {
            owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh,
            bidder: bidder,
            amount: amount,
            is_winner: false,
        };
    }

    // Determines the winning bid between two bids.
    // - `first`: The first bid.
    // - `second`: The second bid.
    // The function checks if the caller is the auction manager.
    // In case of a tie, the first bid wins.
    transition resolve(first: Bid, second: Bid) -> Bid {
        // Ensure the caller is the auction manager.
        assert_eq(self.caller, aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh);

        // Compare the bid amounts and return the higher bid.
        if (first.amount >= second.amount) {
            return first;
        } else {
            return second;
        }
    }

    // Finalizes the auction by marking the winning bid.
    // - `bid`: The winning bid.
    // The function checks if the caller is the auction manager.
    transition finish(bid: Bid) -> Bid {
        // Ensure the caller is the auction manager.
        assert_eq(self.caller, aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh);

        // Mark the bid as the winning bid and transfer ownership to the bidder.
        return Bid {
            owner: bid.bidder,
            bidder: bid.bidder,
            amount: bid.amount,
            is_winner: true,
        };
    }
}
