#!/bin/bash
source ./tools/tb_function.sh
set +e

# In the previous exercise, we used the `user_data_128` field to "connect"
# multiple accounts and multiple transfers.

# However, that doesn't actually ensure that those groups of accounts or
# group of transfers are created atomically. It is possible for one to fail
# while the other succeeds.

# If we want to atomically create multiple accounts or multiple transfers together,
# we need to `link` them.

# Let's say we once again want to create 4 accounts across 2 ledgers: 
# The `linked` flag links one event _to the next event in the request_.
# The last event in a linked group _does not have the flag set_.
tb "create_accounts id=2100 code=10 ledger=200 flags=linked,
                    id=2101 code=11 ledger=201,
                    id=2102 code=12 ledger=200 flags=linked,
                    id=2103 code=13 ledger=201;"

# Now, accounts 2100 and 2101 are linked, so that either both will be created or neither will be created.
# Accounts 2102 and 2103 are also linked in this way.

# Note that multiple groups of linked events can exist together in a single request.

# Now, let's create some transfers!

# Can you modify this request so:
# - The first 2 transfers succeed together
# - The 3rd transfer fails on its own
# - The 4th and 5th transfers fail together
# - The 6th transfer succeeds on its own

output=$(tb "create_transfers id=21000 debit_account_id=2100 credit_account_id=2102 amount=100 ledger=200 code=10 flags=linked,
                              id=21001 debit_account_id=2101 credit_account_id=2103 amount=100 ledger=201 code=10 flags=linked,
                              id=21002 debit_account_id=2102 credit_account_id=2100 amount=100 ledger=299 code=10 flags=linked,
                              id=21003 debit_account_id=2103 credit_account_id=2101 amount=100 ledger=201 code=10 flags=linked,
                              id=21004 debit_account_id=2199 credit_account_id=2101 amount=100 ledger=200 code=10 flags=linked,
                              id=21005 debit_account_id=2100 credit_account_id=2102 amount=100 ledger=200 code=10 flags=linked;")

if [[ $output =~ *"Failed to create transfer \(0|1|5\)"* || 
      $output != *"Failed to create transfer (2): tigerbeetle.CreateTransferResult.transfer_must_have_the_same_ledger_as_accounts."* ||
      $output != *"Failed to create transfer (3): tigerbeetle.CreateTransferResult.linked_event_failed."* ||
      $output != *"Failed to create transfer (4): tigerbeetle.CreateTransferResult.debit_account_not_found."* ]]; then

    echo "Uh oh! The transfers didn't have the expected results."
    exit 1
fi

set -e
