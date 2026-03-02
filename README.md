# Provably random raffle contract

1. user can enter by paying a fee
    1. the ticket fee will go to the winner after the draw
2. after X peroid of time, the contract will pick a random winner
    1. the winner will be picked randomly
3. use chainlink VRF and Chainlink automation
    1. Chainlink VRF for randomness
    2. Chainlink automation for triggering the draw


# Test

1. write deploy scripts
2. write tests
    1. local chain
    2. sepolia
    3. real net