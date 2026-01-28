![Tigerlings](https://github.com/tigerbeetle/tigerlings/assets/3262610/d1b43eec-3ff1-4876-b725-e99fbec730fe)

Welcome to Tigerlings!

[TigerBeetle](https://tigerbeetle.com) is the financial transactions database built for unparalleled performance and mission-critical safety.

This project is an interactive tutorial that teaches you how to use TigerBeetle by fixing small scripts.
Each script has some small error that you'll need to correct -- but don't worry, we'll explain everything you need to know!

This project was directly inspired by the [Ziglings](https://ziglings.org) and [rustlings](https://github.com/rust-lang/rustlings) projects.

## Getting Started

```shell
git clone https://github.com/tigerbeetle/tigerlings.git
cd tigerlings
./run.sh
```

The [run.sh](./run.sh) script runs each exercise, one at a time, and stops at the first broken one.

You can get started with exercise [000_download.sh](./exercises/000_download.sh), which, as you might guess, helps you download TigerBeetle.

Once you've fixed the download script, run [run.sh](./run.sh) again to have it go to the next exercise.

You can jump directly to a specific exercise number (e.g., `./run.sh 15`) to avoid waiting for all exercises to re-run once you solved them. 
Note that the setup exercises (000–002) always run regardless.

Happy learning!

## Need Help?

If you have questions about any of the exercises, feel free to open an issue on this repository or ask a question in the [TigerBeetle Slack](https://slack.tigerbeetle.com/invite). We're here to help!

You might also be interested in reading more in the [TigerBeetle docs](https://docs.tigerbeetle.com/).

## What's Covered

- Downloading TigerBeetle
- Creating the data file
- Running the server
- Creating accounts
- Creating transfers
- Ledgers
- Batching events
- Idempotency
- Debits and credits
- Looking up accounts
- Historical account balances
- Query API (coming soon!)
- Balance limits
- Asset scales and integer amounts
- Account and transfer codes
- Timestamps
- User data
- Linked transfers
- Multi-debit, multi-credit transfers
- Currency exchange
- Two-phase transfers (pending, posting, voiding, timeouts, and partial amounts)
- Balancing transfers (used when closing accounts)
- Balance-conditional transfers
- Balance bounds
- Correcting transfers
- Rate limiting (by request rate, bandwidth, and transfer amount)
