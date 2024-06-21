#!/bin/bash
source ./tools/tb_function.sh

# When closing an account, you may want to calculate the account's net debit or net credit balance
# to zero that balance and transfer it to another account. This is a balancing transfer.

# Note that TigerBeetle does not yet support marking accounts as closed or frozen
# (though one or both of these will likely be added in the future).
# For now, you can zero out the account balance and use application logic to
# prevent transfers to or from the account.

# Let's create three accounts.
# The first is our operator account,
# the second has a credit balance,
# and the third has a debit balance.
tb "create_accounts id=2700 code=10 ledger=270,
                    id=2701 code=10 ledger=270 flags=debits_must_not_exceed_credits,
                    id=2702 code=10 ledger=270 flags=credits_must_not_exceed_debits;"

# We'll make sure the accounts have a positive credit and debit balance, respectively:
tb "create_transfers id=27000 debit_account_id=2700 credit_account_id=2701 amount=100 ledger=270 code=10,
                     id=27001 debit_account_id=2702 credit_account_id=2700 amount=200 ledger=270 code=10;"

# Now we're going to zero out the balance of one of the accounts:
(tb "create_transfers id=27002 debit_account_id=2701 credit_account_id=2700 amount=0 ledger=270 code=10 flags=balancing_debit;" || true)
# Notice that the amount is 0. TigerBeetle will calculate the account's net balance
# (in this case the net credit balance because we're using a balancing_debit) and transfer it to the other account.
# Also, we are ignoring the result of this command because if we run it a second time, it will return the
# error `tigerbeetle.CreateTransferResult.exists_with_different_amount` because the amount will be 100 rather than 0.

# Can you zero out the balance of the other account?
# (Remember, we don't want a `balancing_debit` in this case...)
tb "create_transfers id=27003 debit_account_id=2700 credit_account_id=2702 amount=??? ledger=270 code=10 flags=???;"

# Let's check that both accounts have a net balance of 0:
account_one=$(tb "lookup_accounts id=2701;")
if [[ $account_one != *"\"debits_posted\": \"100\""* && $account_one != *"\"credits_posted\": \"100\""* ]]; then
    echo "Account 2701 should have a net balance of 0."
    exit 1
fi

account_two=$(tb "lookup_accounts id=2702;")
if [[ $account_two != *"\"debits_posted\": \"200\""* && $account_two != *"\"credits_posted\": \"200\""* ]]; then
    echo "Account 2702 should have a net balance of 0."
    exit 1
fi
