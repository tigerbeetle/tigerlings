#!/bin/bash
source ./tools/tb_function.sh

# Alright, alright -- enough about batching already!
# Let's dive into the meat of TigerBeetle's data model.

# In each of the transfers we've created so far, you may have noticed the fields
# `debit_account_id` and `credit_account_id`.

# These indicate where the money is coming from and going to, respectively.

# TigerBeetle has debits and credits, or double-entry accounting, built-in
# to provide financial consistency. Money is never created or destroyed, only moved between accounts.

# Let's illustrate debits and credits with an example.

# Let's say we have two accounts:
BANK=1200
CUSTOMER=1201

tb "create_accounts id=$BANK code=10 ledger=120,
                    id=$CUSTOMER code=10 ledger=120;"

# And let's say that at some earlier point, the customer deposited $100 into the bank.
tb "create_transfers id=12000 debit_account_id=$CUSTOMER credit_account_id=$BANK amount=100 ledger=120 code=10;"

# Now, the customer wants to withdraw $20 from the bank.
# Which account should be debited and which should be credited?
tb "create_transfers id=12001 debit_account_id=${???} credit_account_id=${???} amount=20 ledger=120 code=10;"

# For developers who are new to accounting, debits and credits can be a bit confusing.
# You can read more debits and credits in our primer on financial accounting:
# https://docs.tigerbeetle.com/coding/financial-accounting
