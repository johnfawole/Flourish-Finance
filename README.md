# Flourish Finance
This project is a smart personal finance contract for people to manage their spending and saving habits.

## Smart Contract Overview
At a high-level, there are two smart contracts in this contract. 

1. The first is a saving timelock, where people can lock money for 100 days and withdraw it afterward. They can lock their funds for several goals, such as a wedding, a new house, or an investment.
2. The second one is a spend-and-save contract. It works like this: for every purchase people make onchain, 20% of their entire balance will be kept in a separate wallet they have provided. This will help people become better spenders.

I wrote a more [in-depth explanation of the contracts here](https://johnfawole.hashnode.dev/learn-how-to-build-personal-finance-smart-contracts-on-linea).

## Security Considerations
Smart contract security is important to bear in mind from Day 1, so it even informed the smart contract architecture and logic.

Here are a few security steps:

* including a modifier that blocks-off reentrancy
* ensuring that only those who have registered can call functions
* adding `onlyOwner` modifier so only the team can call some functions
* checking against zero addresses to prevent

## Business Model
There are two ways the protocol plans two ways:

1. The 10% of the `penaltyFee` people will pay when they want to urgently withdraw while the timelock is on.
2. 0.2% fees for all on-chain spendings.

## Testing and Deployment
I shot a [YouTube tutorial](https://www.youtube.com/watch?v=p9PgHzD5fsk) showing how to test and deploy the contracts to Linea.

Subsequently, I will add Foundry tests of the contracts to this repo.

## Talk to Me
If you want to talk to me about anything relating to this code, technical writing, or smart contract development, [Twitter](https://x.com/jofawole) is where you will find me.
