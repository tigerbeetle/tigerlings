#!/bin/bash
source ./tools/tb_function.sh

# Now we know how to use linked transfers.
# Let's use them to create more complex transfers.

# In TigerBeetle, every transfer has a single debit and a single credit.
# However, you may have cases where you want to debit a single account and credit multiple accounts,
# or debit multiple accounts and credit a single account.
# Linked transfers make this possible (while keeping TigerBeetle's API simple and efficient).

# Let's create 4 accounts on the same ledger:
tb "create_accounts id=22000 code=10 ledger=220,
                    id=22001 code=10 ledger=220,
                    id=22002 code=10 ledger=220,
                    id=22003 code=10 ledger=220;"

# Now, we want these transfers to atomically debit one account and credit the other three.
# Can you help fix this request?
tb "create_transfers id=220000 debit_account_id=22000 credit_account_id=22001 amount=100 ledger=220 code=10 flags=???,
                     id=220001 debit_account_id=22000 credit_account_id=22002 amount=100 ledger=220 code=10 flags=???,
                     id=220002 debit_account_id=22000 credit_account_id=22003 amount=100 ledger=220 code=10 flags=???;"
