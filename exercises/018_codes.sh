#!/bin/bash
source ./tools/tb_function.sh

# Every account and transfer has a `code` -- and you might have wondered what that's about.

# The `code` is a way to indicate the type of account or the reason for a transfer.

# In your application, you probably want to store a mapping from
# human-readable names to these codes.

OPERATOR_ACCOUNT=10
INDIVIDUAL_ACCOUNT=20
BUSINESS_ACCOUNT=21

DEPOSIT=10
WITHDRAWAL=11
TRANSFER=12

tb "create_accounts id=1800 code=$OPERATOR_ACCOUNT ledger=100,
                    id=1801 code=$INDIVIDUAL_ACCOUNT ledger=100 flags=debits_must_not_exceed_credits,
                    id=1802 code=$BUSINESS_ACCOUNT ledger=100 flags=debits_must_not_exceed_credits;"

# Can you add the correct `code` for each of these transfers?

# Here, we're debiting the operator and crediting the individual.
# After this transfer, the operator will _owe_ the individual more money.
tb "create_transfers id=18000 debit_account_id=1800 credit_account_id=1801 amount=100 ledger=100 code=${???};"

# Now, money is moving from the individual to the business...
tb "create_transfers id=18001 debit_account_id=1801 credit_account_id=1802 amount=100 ledger=100 code=${???};"

# And finally, the business is moving money back to the operator, decreasing the operator's debt to them.
tb "create_transfers id=18002 debit_account_id=1802 credit_account_id=1800 amount=100 ledger=100 code=${???};"
