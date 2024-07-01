#!/bin/bash
source ./tools/tb_function.sh

# We can also use TigerBeetle to account for non-financial resources.
# For example, we can use TigerBeetle to rate-limit the number of requests to a service.

# Let's say we want to limit each user to 10 requests per minute.
tb "create_accounts id=3100 code=10 ledger=310,
                    id=3101 code=10 ledger=310 flags=debits_must_not_exceed_credits;"

# We'll first transfer 10 credits from the operator account to the user account.
tb "create_transfers id=31000 debit_account_id=3100 credit_account_id=3101 amount=10 ledger=310 code=10;"

# Now, each time the user makes a request, we'll create a pending transfer with a timeout to temporarily debit the user's account.
# How long should the timeout be? (Hint: the timeout is an interval in seconds.)
TIMEOUT=???
for ((i=1; i<=11; i++)); do
    id=$((31000 + i))
    output=$(tb "create_transfers id=${id} debit_account_id=3101 credit_account_id=3100 amount=1 timeout=${TIMEOUT} ledger=310 code=10 flags=pending;")
    echo "$output"
done
# The last of these transfers will fail because the user has exceeded the rate limit.

# If you want to test this, you can uncomment the following lines to sleep for 60 seconds before creating the last transfer.
# sleep $TIMEOUT
# tb "create_transfers id=31012 debit_account_id=3101 credit_account_id=3100 amount=1 timeout=30 ledger=310 code=10 flags=pending;"

# Note that in this exercise, we are creating pending transfers that we will never post or void.
# Instead, we are going to let TigerBeetle expire them after the timeout, returning the debited amount to the user's account.
# This is a simple way to implement rate limiting using the leaky bucket algorithm.
