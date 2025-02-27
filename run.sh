#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# Define private keys and addresses for bidders and auctioneer
FIRST_BIDDER_KEY="APrivateKey1zkpFGMiXFbKxvRrNWCtRi2XnLzaKTHm84GVtFJbv77CE3L5"
FIRST_BIDDER_ADDRESS="aleo14hkynnhkpd65fxsxy0cdwnlvqy9dr8sqmnkmmvgjmm82nxlvnyzsv8sxlh"
SECOND_BIDDER_KEY="APrivateKey1zkp9q9gzYpvtRhjkyjhzrajXGHcqZCTeaqhR9vo8Bgt2s2J"
SECOND_BIDDER_ADDRESS="aleo1qx24pjhjn07euyrrh79wefvl94n6ax82nnvv94yg0d0esm8gs5qsy5yezm"
AUCTIONEER_KEY="APrivateKey1zkp5Q3MDxFrrjN7jwVcARzA7sENy5PrFkGAt1oE3E1nUuie"
AUCTIONEER_ADDRESS="aleo1k0qjm8remr3y7ha0fdt7c227jz9v57hn9exmpcrvegqhxr5ue5xq2k3csd"

echo "
We will be playing the role of three parties.

The private key and address of the first bidder.
private_key: $FIRST_BIDDER_KEY
address: $FIRST_BIDDER_ADDRESS

The private key and address of the second bidder.
private_key: $SECOND_BIDDER_KEY
address: $SECOND_BIDDER_ADDRESS

The private key and address of the auctioneer.
private_key: $AUCTIONEER_KEY
address: $AUCTIONEER_ADDRESS
"

echo "
Let's start an auction!

###############################################################################
########                                                               ########
########           Step 0: Initialize a new 2-party auction            ########
########                                                               ########
###############################################################################
"

echo "
Let's take the role of the first bidder - we'll swap in the private key and address of the first bidder to .env.

We're going to run the transition function \"place_bid\", slotting in the first bidder's public address and the amount that is being bid. The inputs are the user's public address and the amount being bid.
"

# Swap in the private key of the first bidder to .env.
echo "
NETWORK=testnet
PRIVATE_KEY=$FIRST_BIDDER_KEY
" > .env

# Have the first bidder place a bid of 10.
leo run place_bid $FIRST_BIDDER_ADDRESS 10u64

echo "
###############################################################################
########                                                               ########
########         Step 1: The first bidder places a bid of 10           ########
########                                                               ########
###############################################################################
"

echo "
Now we're going to place another bid as the second bidder, so let's switch our keys to the second bidder and run the same transition function, this time with the second bidder's keys, public address, and different amount.
"

# Swap in the private key of the second bidder to .env.
echo "
NETWORK=testnet
PRIVATE_KEY=$SECOND_BIDDER_KEY
" > .env

# Have the second bidder place a bid of 90.
leo run place_bid $SECOND_BIDDER_ADDRESS 90u64

echo "
###############################################################################
########                                                               ########
########          Step 2: The second bidder places a bid of 90         ########
########                                                               ########
###############################################################################
"

echo "
Now, let's take the role of the auctioneer, so we can determine which bid wins. Let's swap our keys to the auctioneer and run the resolve command on the output of the two bids from before. The resolve command takes the two output records from the bids as inputs and compares them to determine which bid wins.
"

# Swaps in the private key of the auctioneer to .env.
echo "
NETWORK=testnet
PRIVATE_KEY=$AUCTIONEER_KEY
" > .env

# Have the auctioneer select the winning bid.
leo run resolve "{
    owner: $AUCTIONEER_ADDRESS.private,
    bidder: $FIRST_BIDDER_ADDRESS.private,
    amount: 10u64.private,
    is_winner: false.private,
    _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
}" "{
    owner: $AUCTIONEER_ADDRESS.private,
    bidder: $SECOND_BIDDER_ADDRESS.private,
    amount: 90u64.private,
    is_winner: false.private,
    _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
}"

echo "
###############################################################################
########                                                               ########
########     Step 3: The auctioneer determines the winning bidder      ########
########                                                               ########
###############################################################################
"

echo "
Keeping the key environment the same since we're still the auctioneer, let's finalize the auction and label the winning output as the winner. The finish transition takes the winning output bid as the input and marks it as such.
"

# Have the auctioneer finish the auction.
leo run finish "{
    owner: $AUCTIONEER_ADDRESS.private,
    bidder: $SECOND_BIDDER_ADDRESS.private,
    amount: 90u64.private,
    is_winner: false.private,
    _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
}"

echo "
###############################################################################
########                                                               ########
########              The auctioneer completes the auction.            ########
########                                                               ########
###############################################################################
"
