#!/bin/bash
source ./tools/tb_function.sh

# In the last two exercises, we used TigerBeetle to rate limit user requests by number and bandwidth.
# We can also rate limit accounts to ensure that users do not send more than a certain amount of money per time unit.

# This time, we're going to set up 4 accounts on 2 ledgers:
# Both accounts 3301 and 3303 represent the same user.
USER_ID=123456
USD_LEDGER=330
RATE_LIMITING_LEDGER=331
tb "create_accounts id=3300 code=10 ledger=$USD_LEDGER,
                    id=3301 code=10 ledger=$USD_LEDGER user_data_128=$USER_ID flags=debits_must_not_exceed_credits,
                    id=3302 code=10 ledger=$RATE_LIMITING_LEDGER,
                    id=3303 code=10 ledger=$RATE_LIMITING_LEDGER user_data_128=$USER_ID flags=debits_must_not_exceed_credits;"

# Now, we'll fund the user's USD account with $10000.
# And let's say we want to limit the user to spending $100 per minute.
tb "create_transfers id=33000 debit_account_id=3300 credit_account_id=3301 amount=10000 ledger=$USD_LEDGER code=10,
                     id=33001 debit_account_id=3302 credit_account_id=3303 amount=100   ledger=$RATE_LIMITING_LEDGER code=10;"

for ((i=1; i<=11; i++)); do
    id=$((33002 + (i * 2)))
    # What flags should these two transfers have? (Hint: they aren't the same.)
    tb "create_transfers id=${id}       debit_account_id=3301 credit_account_id=3300 amount=10 ledger=$USD_LEDGER code=10 flags=???,
                                  id=$((id + 1)) debit_account_id=3303 credit_account_id=3302 amount=10 timeout=60 ledger=$RATE_LIMITING_LEDGER code=10 flags=???;"
done
# The last two of these transfers will fail because the user has exceeded the rate limit.

tb "lookup_accounts id=3301;"

# You can uncomment these lines to sleep for 60 seconds before creating another transfer
# (that will work because the user will be within the rate limit).
# sleep 60
# tb "create_transfers id=33030 debit_account_id=3301 credit_account_id=3300 amount=10 ledger=$USD_LEDGER code=10 flags=linked,
#                      id=33031 debit_account_id=3303 credit_account_id=3302 amount=10 timeout=60 ledger=$RATE_LIMITING_LEDGER code=10 flags=pending;"
