#!/bin/bash
source ./tools/tb_function.sh

# In the previous exercise, we learned about two-phase transfers.
# Sometimes, however, you don't want to keep funds reserved for too long.

# Pending transfers allow you to specify an optional timeout to prevent liquidity from
# being locked up indefinitely.

tb "create_accounts id=2500 code=10 ledger=250,
                    id=2501 code=10 ledger=250;"

# Let's create two pending transfers, both of which have a timeout:
tb "create_transfers id=25000 debit_account_id=2500 credit_account_id=2501 amount=200 ledger=250 code=10 flags=pending timeout=1,
                     id=25001 debit_account_id=2500 credit_account_id=2501 amount=100 ledger=250 code=10 flags=pending timeout=86400;"

# Note that timeouts are set in seconds from when the pending transfer is received by the TigerBeetle primary,
# rather than as absolute timestamps.

sleep 2

# Now, we'll try to post both transfers.
# Can you fix this request to post both transfers?
output=$(tb "create_transfers id=25002 pending_id=??? flags=post_pending_transfer,
                              id=25003 pending_id=25001 flags=???;")
echo "$output"

# Notice that the first transfer returns an error because the pending transfer already timed out.

# We can also check the account balances to see that only the second transfer was posted:
tb "lookup_accounts id=2500, id=2501;"

if [[ $output != *"Failed to create transfer (0): tigerbeetle.CreateTransferResult.pending_transfer_expired."* ]]; then
    echo "The first transfer should have timed out!"
    exit 1
fi
