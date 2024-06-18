#!/bin/bash
source ./tools/tb_function.sh

# In the previous exercise, we saw the first use of one of the `user_data` fields.
# Now, let's see what else we can do with `user_data`!

# A common use case for the `user_data_128` field is to store an external
# identifier that connects multiple accounts or multiple transfers, or
# connects them to a record in an external system.

USER_1=1000000001
USER_2=1000000002

# Let's create 4 accounts across 2 ledgers.
# Notice that each has a separate ID (because all account IDs are unique within the cluster).
# Each user has 2 accounts, both of which use the same `user_data_128` field to identify them.
tb "create_accounts id=2000 code=10 ledger=200 user_data_128=${USER_1},
                    id=2001 code=11 ledger=200 user_data_128=${USER_2},
                    id=2002 code=12 ledger=201 user_data_128=${USER_1},
                    id=2003 code=13 ledger=201 user_data_128=${USER_2};"

# Now let's create some transfers.

# Can you use this payment ID to connect the two transfers?
PAYMENT_1=9000000001
tb "create_transfers id=20000 debit_account_id=2000 credit_account_id=2001 amount=100 ledger=200 code=10,
                     id=20001 debit_account_id=2002 credit_account_id=2003 amount=100 ledger=201 code=10;"

# (Note that if you run this script a second time, you'll need to increment the transfer `id` to avoid 
# a conflict with previously created transfers.)

# Note that it isn't currently possible to look up accounts or transfers by `user_data_128`.
# However, `user_data` fields are already being indexed by TigerBeetle, so these indices will
# be ready to use when new query API functions are added.

# We'll just double-check that the transfers include the payment ID.
transfer_lookup=$(tb "lookup_transfers id=20000, id=20001")
if [[ "$transfer_lookup" != *"\"user_data_128\": \"$PAYMENT_1\""*"\"user_data_128\": \"$PAYMENT_1\""* ]]; then
  echo "Uh oh! The transfers didn't include the payment ID."
  exit 1
fi
