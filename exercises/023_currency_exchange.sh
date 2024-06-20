#!/bin/bash
source ./tools/tb_function.sh

# Each ledger in TigerBeetle represents a single currency, asset, or group of accounts
# and we saw earlier that you can only transfer between accounts on the same ledger.

# What if you want to transfer between accounts on different ledgers?
# You'll need to implement a currency exchange using linked transfers.

USD_LEDGER=230
INR_LEDGER=231

LIQUIDITY_ACCOUNT=10
CUSTOMER_ACCOUNT=20

# First, we'll create 4 accounts on 2 ledgers.
# 2 accounts are customer accounts and 2 are "liquidity" accounts.
tb "create_accounts id=2300 code=$LIQUIDITY_ACCOUNT ledger=$USD_LEDGER,
                    id=2301 code=$CUSTOMER_ACCOUNT  ledger=$USD_LEDGER,
                    id=2302 code=$LIQUIDITY_ACCOUNT ledger=$INR_LEDGER,
                    id=2303 code=$CUSTOMER_ACCOUNT  ledger=$INR_LEDGER;"

# The liquidity accounts are either accounts owned by the operator, or
# they could be third-party liquidity providers.

# Let's pretend that we're getting the exchange rate from an external source.
# (This exchange rate might be out of date when you're reading this!)
USD_TO_INR_EXCHANGE_RATE=83.63

# For precision, we're going to use a scale of 6 decimal places for both ledgers.
ASSET_SCALE=6

USD_AMOUNT=$(echo "100 * (10 ^ $ASSET_SCALE)" | bc)
INR_AMOUNT=$(echo "scale=0; $USD_AMOUNT * $USD_TO_INR_EXCHANGE_RATE / 1" | bc)

# Now, let's create a transfer that debits the customer's USD account and credits the customer's INR account.
# Can you fill in the missing values?
tb "create_transfers id=23000 debit_account_id=2301 credit_account_id=??? amount=$USD_AMOUNT ledger=$USD_LEDGER code=10 flags=???,
                     id=23001 debit_account_id=??? credit_account_id=2303 amount=$INR_AMOUNT ledger=$INR_LEDGER code=10;"

# This same mechanism can be used to transfer assets between any two (or more!) different ledgers.
