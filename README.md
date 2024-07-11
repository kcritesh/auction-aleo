# 🏛️ Blind Auction

A first-price sealed-bid auction using Leo.

## Overview

A first-price sealed-bid auction (or blind auction) is a type of auction where each participant submits a bid without knowing the bids of other participants. The highest bid wins.

In this model, there are two roles: the auctioneer and the bidders.
- **Bidder**: A participant who places a bid.
- **Auctioneer**: The entity responsible for managing the auction.

### Assumptions
- The auctioneer acts honestly and resolves all bids in the order they are received without tampering.
- The number of bids is unlimited.
- The auctioneer knows the identity of all bidders, but bidders may not know the identities of other bidders.

### Requirements
- Bidders should not learn the value of other bids.

## Auction Process

The auction proceeds through several stages:
1. **Bidding**: Bidders submit their bids to the auctioneer by invoking the `place_bid` function.
2. **Resolution**: The auctioneer resolves the bids in the order they were received by invoking the `resolve` function. This process determines the winning bid.
3. **Finishing**: The auctioneer concludes the auction by invoking the `finish` function, which returns the winning bid to the bidder.

### Key Concepts
- `record` declarations
- `assert_eq` assertions
- Record ownership

## Running the Auction

Follow the [Leo Installation Instructions](https://developer.aleo.org/leo/installation).

This auction program can be executed using the following script. It simulates a three-party auction locally, running the functions in sequence.

```bash
cd auction
./run.sh
```

The `.env` file contains a private key and address used to sign transactions and verify record ownership. When running the program for different parties, update the `private_key` field in `.env` accordingly. Refer to `./run.sh` for a complete example of running the program as different parties.

## Walkthrough

- [Step 0: Initializing the Auction](#step0)
- [Step 1: The First Bid](#step1)
- [Step 2: The Second Bid](#step2)
- [Step 3: Select the Winner](#step3)

## <a id="step0"></a> Step 0: Initializing the Auction

The three parties in this example are:

```markdown
First Bidder Private Key:  
APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK
First Bidder Address: 
aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke

Second Bidder Private Key:
APrivateKey1zkpAFshdsj2EqQzXh5zHceDapFWVCwR6wMCJFfkLYRKupug
Second Bidder Address:
aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4

Auctioneer Private Key:
APrivateKey1zkp5wvamYgK3WCAdpBQxZqQX8XnuN2u11Y6QprZTriVwZVc
Auctioneer Address:
aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh
```

## <a id="step1"></a> Step 1: The First Bid

The first bidder places a bid of 10.

Set the first bidder's private key and address in `.env`.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK
" > .env
```

Invoke the `place_bid` function with the first bidder's address and the bid amount.

```bash
leo run place_bid aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke 10u64
```

## <a id="step2"></a> Step 2: The Second Bid

The second bidder places a bid of 90.

Set the second bidder's private key in `.env`.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpAFshdsj2EqQzXh5zHceDapFWVCwR6wMCJFfkLYRKupug
" > .env
```

Invoke the `place_bid` function with the second bidder's address and the bid amount.

```bash
leo run place_bid aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4 90u64
```

## <a id="step3"></a> Step 3: Select the Winner

The auctioneer determines the winning bid.

Set the auctioneer's private key in `.env`.

```bash
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp5wvamYgK3WCAdpBQxZqQX8XnuN2u11Y6QprZTriVwZVc
" > .env
```

Provide the two `Bid` records as input to the `resolve` transition function.

```bash 
leo run resolve "{
    owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh.private,
    bidder: aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke.private,
    amount: 10u64.private,
    is_winner: false.private,
    _nonce: 4668394794828730542675887906815309351994017139223602571716627453741502624516group.public
}" "{
    owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh.private,
    bidder: aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4.private,
    amount: 90u64.private,
    is_winner: false.private,
    _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
}"
```

## <a id="step4"></a> Step 4: Finish the Auction

Invoke the `finish` transition function with the winning `Bid` record.

```bash 
leo run finish "{
    owner: aleo1fxs9s0w97lmkwlcmgn0z3nuxufdee5yck9wqrs0umevp7qs0sg9q5xxxzh.private,
    bidder: aleo1esqchvevwn7n5p84e735w4dtwt2hdtu4dpguwgwy94tsxm2p7qpqmlrta4.private,
    amount: 90u64.private,
    is_winner: false.private,
    _nonce: 5952811863753971450641238938606857357746712138665944763541786901326522216736group.public
}"
```
