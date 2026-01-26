#!/bin/bash
source ./tools/tb_function.sh

# In the previous two exercises, we created and posted some two-phase transfers.

# There is one more detail related to two-phase transfers that we haven't covered yet: partial amounts.

tb "create_accounts id=2600 code=10 ledger=260,
                    id=2601 code=10 ledger=260;"

# Let's create 3 pending transfers:
tb "create_transfers id=26000 debit_account_id=2600 credit_account_id=2601 amount=500 ledger=260 code=10 flags=pending,
                     id=26001 debit_account_id=2600 credit_account_id=2601 amount=300 ledger=260 code=10 flags=pending,
                     id=26002 debit_account_id=2600 credit_account_id=2601 amount=100 ledger=260 code=10 flags=pending;"

# Now, we'll post them -- but we're going to specify different amounts:
output=$(tb "create_transfers id=26003 pending_id=26000 amount=500 flags=post_pending_transfer,
                              id=26004 pending_id=26001 amount=200 flags=post_pending_transfer,
                              id=26005 pending_id=26002 amount=200 flags=post_pending_transfer;")

# Uh oh! That didn't work!
# The first transfer is actually okay -- specifying the same amount as the pending transfer posts the full amount.
# The second is also okay, because the amount is less than the pending transfer.
# But that third transfer...
# Can you fix it?

# Once it posts, you can check the account balances to see the results.
tb "lookup_accounts id=2600, id=2601;"

if [[ $output == *"Failed to create transfer (2): tigerbeetle.CreateTransferResult.exceeds_pending_transfer_amount."* ]]; then
    echo "The third transfer should have been posted!"
    exit 1
fi
