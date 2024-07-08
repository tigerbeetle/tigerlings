#!/bin/bash
source ./tools/tb_function.sh

# We've seen accounts and transfers with different IDs.
# What happens if we try to create the same account or transfer twice?

# Let's try creating the same account multiple times:

tb "create_accounts id=1100 code=10 ledger=110,
                    id=1100 code=10 ledger=110,
                    id=1101 code=10 ledger=110;"

tb "create_accounts id=1100 code=10 ledger=110;"

# These are both fine -- because the account details are exactly the same.

# What if we try to create the same account with different details?

tb "create_accounts id=1100 code=99 ledger=110;"
# Can you fix this so the request works?

# The same applies for transfers:
tb "create_transfers id=11000 debit_account_id=1100 credit_account_id=1101 amount=100 ledger=110 code=10,
                     id=11000 debit_account_id=1100 credit_account_id=1101 amount=100 ledger=110 code=10;"

tb "create_transfers id=11000 debit_account_id=1100 credit_account_id=1101 amount=100 ledger=110 code=10;"

# As before, this one will fail because the transfer details are different:
tb "create_transfers id=11000 debit_account_id=1100 credit_account_id=1101 amount=99999 ledger=110 code=10;"
# Can you fix this too?

# You may notice in the logs that duplicate requests will fail with the "exists" error.
# Most applications will want to handle this error as if it were a success.
# That ensures that requests can be retried in case the connection drops before the response is received.
# Resending the same request is safe and will not cause a second account or transfer to be created.
