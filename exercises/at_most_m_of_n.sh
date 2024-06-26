#!/bin/bash
source ./tools/tb_function.sh

tb "create_accounts id=10000 code=10 ledger=100,
                    id=10001 code=10 ledger=100,
                    id=1     code=10 ledger=1 flags=debits_must_not_exceed_credits,
                    id=2     code=10 ledger=1;"

# Here, we want at most 2 of these transfers to succeed.
# We do that by making each real transfer transfer 1 unit on ledger 1 to an account whose balance is limited to 2.
output=$(tb "create_transfers id=1      debit_account_id=2     credit_account_id=1     amount=2   ledger=1   code=1, 

                     id=100002 debit_account_id=10000 credit_account_id=10001 amount=10  ledger=100 code=10 flags=linked,
                     id=2      debit_account_id=1     credit_account_id=2     amount=1   ledger=1   code=1,
                     
                     id=100003 debit_account_id=10000 credit_account_id=0     amount=100 ledger=100 code=10 flags=linked,
                     id=3      debit_account_id=1     credit_account_id=2     amount=1   ledger=1   code=1,
                     
                     id=100004 debit_account_id=10000 credit_account_id=10001 amount=1000 ledger=100 code=10 flags=linked,
                     id=4      debit_account_id=1     credit_account_id=2     amount=1   ledger=1   code=1,

                     id=100005 debit_account_id=10000 credit_account_id=10001 amount=10000 ledger=100 code=10 flags=linked,
                     id=5      debit_account_id=1     credit_account_id=2     amount=1   ledger=1   code=1,
                     
                     id=6      debit_account_id=2     credit_account_id=1     amount=0     ledger=1   code=10 flags=balancing_credit;")
echo "$output"

tb "lookup_accounts id=1, id=10000;"
