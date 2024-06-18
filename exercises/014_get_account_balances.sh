#!/bin/bash
source ./tools/tb_function.sh

# In addition to looking up the current state of accounts,
# we can also look up historical account balances.

# Note that this feature needs to be enabled when the account is created for this to work!

# Let's create two accounts, one with history enabled and one without:
tb "create_accounts id=1400 code=10 ledger=140 flags=history,
                    id=1401 code=10 ledger=140;"

# And we'll create some transfers between them:
tb "create_transfers id=14000 debit_account_id=1400 credit_account_id=1401 amount=100 ledger=140 code=10,
                     id=14001 debit_account_id=1400 credit_account_id=1401 amount=100 ledger=140 code=10,
                     id=14002 debit_account_id=1400 credit_account_id=1401 amount=100 ledger=140 code=10;"

# Uh oh! We're trying to look up historical balances for an account that doesn't have history enabled.
tb "get_account_balances account_id=1401;"
