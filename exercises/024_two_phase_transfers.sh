#!/bin/bash
source ./tools/tb_function.sh

# Sometimes, you want to synchronize a transfer in TigerBeetle with one
# in an external system. This could be a national payment system, a
# bank transfer, or cryptocurrency.

# Two-phase transfers enable you to reserve funds and then execute the
# transfer or cancel it depending on the outcome of the external system.

tb "create_accounts id=2400 code=10 ledger=240,
                    id=2401 code=10 ledger=240;"

# Let's create two pending transfers using the `pending` flag:
tb "create_transfers id=24000 debit_account_id=2400 credit_account_id=2401 amount=200 ledger=240 code=10 flags=pending,
                     id=24001 debit_account_id=2401 credit_account_id=2400 amount=100 ledger=240 code=10 flags=pending;"

# If we look up the account balance, we can see the amounts appear as `debits_pending` and `credits_pending`:
tb "lookup_accounts id=2400, id=2401;"

# Now we can execute or "post" the transfer:
tb "create_transfers id=24000 pending_id=24000 amount=200 flags=post_pending_transfer;"

# Uh oh! That doesn't work. The second transfer is a separate transfer so it needs its own unique ID.

# Can you fix this so that the second transfer is voided?
# Hint: we need to use the `void_pending_transfer` flag.
tb "create_transfers id=24003 pending_id=??? flags=???;"

# Finally, we can look up the accounts again to see their final balances:
tb "lookup_accounts id=2400, id=2401;"

# Note that we don't need to specify the debit_account_id, credit_account_id, ledger, or code
# for the transfers that post or void pending transfers.
# We could if we wanted to -- but they need to be the same as in the pending transfer
# (with the exception of the `amount`, which we'll explain in another exercise).
