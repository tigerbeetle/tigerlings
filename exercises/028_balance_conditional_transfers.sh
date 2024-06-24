#!/bin/bash
source ./tools/tb_function.sh

# In an earlier exercise, we showed how you can use built-in flags to limit an account's balance.

# Now, we're going to use a combination of features to show how to do a transfer
# if and only if an account has a certain balance. We call this a balance-conditional transfer.
# Note that this is an advanced feature and is not typically used in most applications.

# First, we'll create a couple of accounts:
OPERATOR_ACCOUNT=2800
CONTROL_ACCOUNT=2801
SOURCE_ACCOUNT=2810
DESTINATION_ACCOUNT=2811

tb "create_accounts id=$OPERATOR_ACCOUNT code=10 ledger=280,
                    id=$CONTROL_ACCOUNT code=10 ledger=280,
                    id=$SOURCE_ACCOUNT code=10 ledger=280 flags=debits_must_not_exceed_credits,
                    id=$DESTINATION_ACCOUNT code=10 ledger=280 flags=debits_must_not_exceed_credits;"

# Let's put some funds in the SOURCE_ACCOUNT:
tb "create_transfers id=28000 debit_account_id=$OPERATOR_ACCOUNT credit_account_id=$SOURCE_ACCOUNT amount=100 ledger=280 code=10;"

# Now we're going to create a set of 3 linked transfers.
# The first transfer will only succeed if the SOURCE_ACCOUNT has a balance that exceeds the THRESHOLD_AMOUNT.
# The second transfers the THRESHOLD_AMOUNT back from the CONTROL_ACCOUNT to the SOURCE_ACCOUNT.
# Finally, the third makes the actual transfer to the DESTINATION_ACCOUNT.
THRESHOLD_AMOUNT=200
TRANSFER_AMOUNT=50
tb "create_transfers id=28001 debit_account_id=$SOURCE_ACCOUNT credit_account_id=$CONTROL_ACCOUNT amount=$THRESHOLD_AMOUNT ledger=280 code=10 flags=linked,
                     id=28002 debit_account_id=$CONTROL_ACCOUNT credit_account_id=$SOURCE_ACCOUNT amount=$THRESHOLD_AMOUNT ledger=280 code=10 flags=linked, 
                     id=28003 debit_account_id=$SOURCE_ACCOUNT credit_account_id=$DESTINATION_ACCOUNT amount=$TRANSFER_AMOUNT ledger=280 code=10;"

# Uh oh -- this fails because the SOURCE_ACCOUNT's balance doesn't meet the threshold.
# Can you fix the THRESHOLD_AMOUNT so that the transfers succeed?
