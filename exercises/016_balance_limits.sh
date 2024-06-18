#!/bin/bash
source ./tools/tb_function.sh

# Now, let's return to our bank example and add some balance limits.

# It may be tempting to use `lookup_accounts` or `get_account_balances`
# to check the account balance in the application logic before creating a transfer.
# However, this is unsafe!
# The account balance could change between the time you check it and the time you create the transfer.

# Instead, we can use the built-in features to enforce balance limits atomically in the database.
BANK=1600
CUSTOMER=1601

# We're going to create the CUSTOMER account with the flag that ensures that its
# credits do not exceed its debits.
tb "create_accounts id=$BANK code=10 ledger=160,
                    id=$CUSTOMER code=10 ledger=160 flags=credits_must_not_exceed_debits;"

# Let's create a transfer where the customer deposits $100 into the bank.
tb "create_transfers id=16000 debit_account_id=$CUSTOMER credit_account_id=$BANK amount=100 ledger=160 code=10;"

# Now, the customer wants to withdraw money fromt the bank.
# But they're trying to withdraw too much! Can you fix the amount so this transfer succeeds?
tb "create_transfers id=16001 debit_account_id=$BANK credit_account_id=$CUSTOMER amount=200 ledger=160 code=10;"
