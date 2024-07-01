#!/bin/bash
source ./tools/tb_function.sh

# In TigerBeetle, both accounts and transfers are immutable so they cannot be modified
# or deleted once they are created.

# You can use a new transfer to correct mistakes, undo the effects of previous transfers,
# or to adjust the effects of previous transfers.

tb "create_accounts id=3000 code=10 ledger=300,
                    id=3001 code=10 ledger=300;"

# Let's say that we have these two transfers:
tb "create_transfers id=30000 debit_account_id=3000 credit_account_id=3001 amount=100 ledger=300 code=10 user_data_128=12345,
                     id=30001 debit_account_id=3000 credit_account_id=3001 amount=199 ledger=300 code=10 user_data_128=67890;"

# Now, we want to create two transfers to:
# 1. Undo the effects of the first transfer.
# 2. Correct the amount of the second transfer to be 100 instead of 199.

# Can you fill in the correct amounts?
tb "create_transfers id=30002 debit_account_id=3001 credit_account_id=3000 amount=??? ledger=300 code=90 user_data_128=12345,
                     id=30003 debit_account_id=3001 credit_account_id=3000 amount=??? ledger=300 code=91 user_data_128=67890;"

# Note that we can use the user_data_128 field to link the new transfers to the original transfers.
# Also, we can use the code field to indicate the purpose of these transfers.
