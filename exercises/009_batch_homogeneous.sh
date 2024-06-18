#!/bin/bash
source ./tools/tb_function.sh

# The previous exercise created multiple accounts in one request and multiple transfers in another.

# Can we combine the two?

tb "create_accounts     id=900 code=10 ledger=90,
                        id=901 code=10 ledger=90,
    create_transfers    id=90000 debit_account_id=900 credit_account_id=901 amount=100 ledger=90 code=10,
                        id=90001 debit_account_id=900 credit_account_id=901 amount=100 ledger=90 code=10;"

# Nope!
# Every request batches events of the same type.
# This makes processing events more efficient because the batches are homogeneous.

# Can you fix this so we send the transfers in a separate request?
