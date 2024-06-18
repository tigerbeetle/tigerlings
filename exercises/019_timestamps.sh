#!/bin/bash
source ./tools/tb_function.sh

# Time is critical for distributed systems like TigerBeetle, as well as for business transactions.

# TigerBeetle automatically timestamps every event when it is received by the primary replica.

tb "create_accounts id=1900 code=10 ledger=190,
                    id=1901 code=10 ledger=190;"

# Now let's look up those accounts and extract the timestamps.
account_timestamps=$(tb "lookup_accounts id=1900, id=1901;" | grep -o '"timestamp": "[^"]\+"')
echo $account_timestamps

# If you look in the logs, you'll see the two timestamps.
# The timestamps are in nanoseconds since the Unix epoch.

# Also, the second timestamp is exactly 1 nanosecond after the first timestamp.
# In TigerBeetle, timestamps are monotonically increasing and unique.
# Each event in a request will have a timestamp that is strictly greater than the previous event.

# What if we want to store the wall clock time when we create an account or transfer?
time_now=$(date +%s000000000)

# Let's create a transfer and try attaching the timestamp:
transfer_id=19000
tb "create_transfers id=$transfer_id debit_account_id=1900 credit_account_id=1901 amount=100 ledger=190 code=10 timestamp=${time_now};"

# Now let's check if it worked...
transfer_has_our_timestamp=$(tb "lookup_transfers id=$transfer_id;" | grep "\"$time_now\"")

if [[ -z "$transfer_has_our_timestamp" ]]; then
    echo "Uh oh, our timestamp wasn't attached to the transfer!"
    exit 1
fi

# Uh oh -- attaching the timestamp like that didn't work!
# The `timestamp` field is overwritten by the server.
# We need to include our timestamp in the `user_data_64` field instead.

# Can you modify the request to include the timestamp in the `user_data_64` field instead?
# (Note that you'll also need to increment the transfer `id` to avoid a conflict with the previous transfer.)

# Both accounts and transfers have 3 user_data fields: `user_data_32`, `user_data_64`, and `user_data_128`.
# You can use these fields however you want, but `user_data_64` is often used to store a timestamp.
