#!/bin/bash
source ./tools/tb_function.sh

# This example shows how to pool a certain amount from multiple accounts to transfer to a single account.
# Note that it builds on the mechanisms introduced in ./if_then_multiple.sh

OPERATOR_ACCOUNT=10000
POOL_ACCOUNT=10001
CHECK_ACCOUNT=10002
ACCOUNT_1=10003
ACCOUNT_2=10004
TARGET_ACCOUNT=10005
IF_ACCOUNT=10
IF_OPERATOR=11
tb "create_accounts id=$OPERATOR_ACCOUNT code=10 ledger=100,
                    id=$CHECK_ACCOUNT code=10 ledger=100 flags=credits_must_not_exceed_debits,
                    id=$POOL_ACCOUNT code=10 ledger=100,
                    id=$ACCOUNT_1 code=10 ledger=100 flags=debits_must_not_exceed_credits,
                    id=$ACCOUNT_2 code=10 ledger=100 flags=debits_must_not_exceed_credits,
                    id=$TARGET_ACCOUNT code=10 ledger=100 flags=debits_must_not_exceed_credits,
                    id=$IF_ACCOUNT code=10 ledger=1 flags=debits_must_not_exceed_credits,
                    id=$IF_OPERATOR code=10 ledger=1;"

echo "funding accounts 1 and 2 with 100 units"

# Now, we'll fund Accounts 1 and 2 with 100 units each.
tb "create_transfers id=1000 debit_account_id=$OPERATOR_ACCOUNT credit_account_id=$ACCOUNT_1 amount=100 ledger=100 code=10,
                     id=1001 debit_account_id=$OPERATOR_ACCOUNT credit_account_id=$ACCOUNT_2 amount=100 ledger=100 code=10;"

# Now, we want to pool funds between ACCOUNT_1 and ACCOUNT_2 to transfer to TARGET_ACCOUNT. 
POOL_AMOUNT=250 # Change this to 150 to make the transfers succeed.

echo "pooling funds from accounts 1 and 2 to transfer to target account"

# This looks very complicated, so let's go through each block of transfers.

# The first block checks that the sum of the balances of ACCOUNT_1 and ACCOUNT_2 is greater than or equal to the POOL_AMOUNT.
# If they are, that whole first block of transfers will fail.

# If the first block of transfers fails, the second block of transfers will succeed
# (because the transfer with id=10 intentionally appears in both the first and second blocks -- it will only succeed once).
# This block of transfers transfers 2 units to the IF_ACCOUNT
# AND it *DEBITS* the POOL_ACCOUNT by the POOL_AMOUNT.

# The third and fourth blocks of transfers transfer *EXACTLY* the POOL_AMOUNT from ACCOUNT_1 and ACCOUNT_2 to the POOL_ACCOUNT.
# In each of these blocks, the first transfer (id=11 and id=12) take 1 unit from the IF_ACCOUNT
# (these would fail if the second block of transfers hadn't put 2 units in the IF_ACCOUNT).
# Then, they transfer (id=1009, id=1011) the lesser of the POOL_AMOUNT and the net credit balance of ACCOUNT_1 or ACCOUNT_2 to the POOL_ACCOUNT.
# Then, if the POOL_ACCOUNT now has a credit balance that is *GREATER* than the POOL_AMOUNT they transfer (id=1010, id=1012) the execess back to the account it came from.
# It is important that this last transfer in these blocks is *NOT* linked, because it will fail if the POOL_ACCOUNT's credit balance is less than or equal to the POOL_AMOUNT.

# Finally, the last block of transfers transfers the POOL_AMOUNT from the POOL_ACCOUNT to the TARGET_ACCOUNT
# and resets the POOL_ACCOUNT's net balance back to 0.

output=$(tb "create_transfers id=1002 debit_account_id=$CHECK_ACCOUNT credit_account_id=$OPERATOR_ACCOUNT amount=$((POOL_AMOUNT - 1)) ledger=100 code=10 flags=linked, 
                     id=1003 debit_account_id=$ACCOUNT_1 credit_account_id=$CHECK_ACCOUNT amount=0 ledger=100 code=10 flags=linked | pending | balancing_debit,
                     id=1004 debit_account_id=$ACCOUNT_2 credit_account_id=$CHECK_ACCOUNT amount=0 ledger=100 code=10 flags=linked | pending | balancing_debit,
                     id=1005 pending_id=1003 code=10 flags=linked | void_pending_transfer,
                     id=1006 pending_id=1004 code=10 flags=linked | void_pending_transfer,
                     id=10 debit_account_id=$IF_OPERATOR credit_account_id=$IF_ACCOUNT amount=2 ledger=1 code=10 flags=linked | pending,
                     id=11 pending_id=10 code=10 flags=void_pending_transfer,
                     id=1007 debit_account_id=$OPERATOR_ACCOUNT credit_account_id=$CHECK_ACCOUNT amount=0 ledger=100 code=10 flags=balancing_credit,

                     id=10 debit_account_id=$IF_OPERATOR credit_account_id=$IF_ACCOUNT amount=2 ledger=1 code=11 flags=linked,
                     id=1008 debit_account_id=$POOL_ACCOUNT credit_account_id=$OPERATOR_ACCOUNT amount=$POOL_AMOUNT ledger=100 code=10,

                     id=11 debit_account_id=$IF_ACCOUNT credit_account_id=$IF_OPERATOR amount=1 ledger=1 code=10 flags=linked,
                     id=1009 debit_account_id=$ACCOUNT_1 credit_account_id=$POOL_ACCOUNT amount=$POOL_AMOUNT ledger=100 code=10 flags=balancing_debit,
                     id=1010 debit_account_id=$POOL_ACCOUNT credit_account_id=$ACCOUNT_1 amount=0            ledger=100 code=10 flags=balancing_debit,
                     
                     id=12 debit_account_id=$IF_ACCOUNT credit_account_id=$IF_OPERATOR amount=1 ledger=1 code=10 flags=linked,
                     id=1011 debit_account_id=$ACCOUNT_2 credit_account_id=$POOL_ACCOUNT amount=$POOL_AMOUNT ledger=100 code=10 flags=balancing_debit,
                     id=1012 debit_account_id=$POOL_ACCOUNT credit_account_id=$ACCOUNT_2 amount=0            ledger=100 code=10 flags=balancing_debit,

                     id=1013 debit_account_id=$POOL_ACCOUNT credit_account_id=$TARGET_ACCOUNT amount=$POOL_AMOUNT ledger=100 code=10 flags=balancing_debit;")
                    #  id=1014 debit_account_id=$OPERATOR_ACCOUNT credit_account_id=$POOL_ACCOUNT amount=0 ledger=100 code=10 flags=balancing_credit;")
echo "$output"

tb "lookup_accounts id=$POOL_ACCOUNT, id=$CHECK_ACCOUNT, id=$ACCOUNT_1, id=$ACCOUNT_2, id=$TARGET_ACCOUNT;"
