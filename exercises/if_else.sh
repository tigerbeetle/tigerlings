#!/bin/bash
source ./tools/tb_function.sh

tb "create_accounts id=10000 code=10 ledger=100 flags=debits_must_not_exceed_credits,
                    id=10001 code=10 ledger=100,
                    id=1     code=10 ledger=1,
                    id=2     code=10 ledger=1;"

tb "create_transfers id=100001 debit_account_id=10001 credit_account_id=10000 amount=100 ledger=100 code=10;"

# If amount > 100, the first two transfers will fail.
# If amount <= 100, the first two transfers will succeed and the third and fourth will fail.
# We're deliberately trying to create transfer 100000 in both branches with different codes.
AMOUNT=101
tb "create_transfers id=100002 debit_account_id=10000 credit_account_id=10001 amount=$AMOUNT ledger=100 code=10 flags=linked,
                     id=100000 debit_account_id=1 credit_account_id=2 amount=1 ledger=1 code=1,
                     
                     id=100003 debit_account_id=10000 credit_account_id=10001 amount=50 ledger=100 code=10 flags=linked,
                     id=100000 debit_account_id=1 credit_account_id=2 amount=1 ledger=1 code=2;"

tb "lookup_transfers id=100000;"
