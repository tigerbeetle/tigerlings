#!/bin/bash
source ./tools/tb_function.sh

# Moving money around isn't all that interesting if we can't see the results.

# Let's create two accounts:
tb "create_accounts id=1300 code=10 ledger=130,
                    id=1301 code=10 ledger=130;"

# And we can look up the accounts (the REPL prints the results as JSON objects):
tb "lookup_accounts id=1300, id=1301, id=1302;"
# (Note that only accounts that exist are returned.)

# Now, we'll create a transfer between them and then check their balances again:
tb "create_transfers id=13000 debit_account_id=1300 credit_account_id=1301 amount=100 ledger=130 code=10;"

tb "lookup_accounts id=1300, id=1301;"

# Can you create another transfer so that account 1300 ends up with a net debit balance of 70?
# (Hint: the debits_posted will remain at 100, but the credits_posted will increase to 30.)
# Can you create another transfer so that account 1300 ends up with debits_posted of 70?
tb "create_transfers id=13001 debit_account_id=??? credit_account_id=??? amount=30 ledger=130 code=10;"

output=$(tb "lookup_accounts id=1300")
if [[ $output != *"\"debits_posted\": \"100\""* && $output != *"\"credits_posted\": \"30\""* ]]; then
    echo "Didn't find the expected debits_posted and credits_posted values in the account."
    exit 1
fi