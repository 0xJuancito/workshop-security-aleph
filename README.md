# Workshop: Smart Contracts Security with Foundry

##### 🎹 By Juancito | https://x.com/0xJuancito

###### Special mention to 📚 [Aleph](https://www.aleph.crecimiento.build/) 🪷 [The Red Guild](https://discord.com/invite/eegRCDmwbM) & 🤖 [WebtrES](https://discord.com/invite/eegRCDmwbM)

## Requisites

### Install Foundry

```
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

https://book.getfoundry.sh/getting-started/installation

## Foundry

### Tests

To run tests:

```
forge test
```

- `-vv` shows console.log output.
- `-vvvvv` shows execution and setup traces for all tests.

To run specific tests:

- `--mt` runs tests matching the specified regex.

Example:

```
forge test --mt test_Depositor -vv
```

### Cheatsheet

- https://milotruck.github.io/blog/Foundry-Cheatsheet/

## Security

### Challenges

Challenges can be found in the [/test](./test) folder.

Your goal is to make all tests PASS ✨

You'll find the tags `START OF SOLUTION` and `END OF SOLUTION` on each test file. You should write your solution there.

You may create and instantiate new contracts to help you with the solution, as long as the `new Contract()` is instantiated and called between those tags.

Cheatcodes are not allowed of course :)

**Solutions can be found in the `solutions` branch`**

```
git checkout -b solutions
forge test
```

### Checklists

- https://github.com/cryptofinlabs/audit-checklist
- https://github.com/transmissions11/solcurity
- https://solodit.xyz/checklist

### Resources

- [Solidity Security Patterns](https://medium.com/coinmonks/security-patterns-208394299142)
- [FREI-PI (Function Requirements - Effects - Interactions - Protocol Invariants)](https://www.nascent.xyz/idea/youre-writing-require-statements-wrong)
- [Weird ERC20](https://github.com/d-xo/weird-erc20)

### Learn & Practice

- [WebtrES Discord](https://discord.com/invite/eegRCDmwbM)
- [Smart Contract Security Course - Cyfrin Updraft](https://updraft.cyfrin.io/courses/security)
- [Ethernaut CTF](https://ctf.openzeppelin.com/)
- [Damn Vulnerability DeFi CTF](https://www.damnvulnerabledefi.xyz/)

### Tools

- [Solidity Visual Developer](https://marketplace.visualstudio.com/items?itemName=tintinweb.solidity-visual-auditor)

## Thanks!

![congratulations-evangelion](https://github.com/user-attachments/assets/1e51fb31-82d6-48c1-a5f7-25d330bf89b3)
