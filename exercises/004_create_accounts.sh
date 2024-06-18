#!/bin/bash
source ./tools/tb_function.sh

# In the previous exercise, we mentioned that every request is batched.
# Now, let's use that to create multiple accounts at the same time.

# We want to create a couple of accounts.
# However, this request has a problem. Can you spot it?
tb "create_accounts id=300 code=10 ledger=40,
                    id=401 code=10;"

# Hint 1: All account IDs are globally unique (and we created an account in the previous exercise...).
# Hint 2: All accounts are partitioned into `ledgers` (more on this soon).

# Don't worry about the `code` for now, we'll go over that later.
