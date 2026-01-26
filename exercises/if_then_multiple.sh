#!/bin/bash
source ./tools/tb_function.sh

# We can use the technique described in ./if_else.sh to execute a transfer
# if a condition is met. We can use the same technique to execute multiple transfers
# if that condition is met by using linked transfers.

# However, our conditional set of transfers must ALL succeed in order for it to work.
# If one of them might fail, that technique is insufficient.

# We can instead use the technique illustrated here to check a condition and, if it is met,
# execute a set of transfers where the success or failure of one does not affect the others.

tb "create_accounts id=10000 code=10 ledger=100 flags=debits_must_not_exceed_credits,
                    id=10001 code=10 ledger=100,
                    id=1     code=10 ledger=1 flags=debits_must_not_exceed_credits,
                    id=2     code=10 ledger=1;"

tb "create_transfers id=100000 debit_account_id=10001 credit_account_id=10000 amount=100 ledger=100 code=10;"

# If amount > 100, all of the transfers will fail.
# If amount <= 100, the following events will happen:
# - Transfer 11 will succeed and set account 2's net credit balance to be 2.
# - Transfer 100003 will succeed, and transfer 13 will take 1 unit back from account 1 to account 2.
# - Transfer 100004 will fail, along with transfer 14, but this will not affect the others.
# - Transfer 100005 will succeed, and transfer 15 will take 1 unit back from account 1 to account 2.
# - Transfer 100006 and 16 will fail because account 1 no longer has a sufficient balance to transfer 1 unit.

AMOUNT=101 # try changing this to 100 to make the set of transfers succeed
tb "create_transfers id=100001 debit_account_id=10000 credit_account_id=10001 amount=$AMOUNT ledger=100 code=10 flags=linked | pending,
                     id=100002 pending_id=100001 flags=linked | void_pending_transfer,
                     id=11     debit_account_id=2     credit_account_id=1     amount=2       ledger=1   code=10,
                     
                     id=13     debit_account_id=1     credit_account_id=2     amount=1       ledger=1   code=10 flags=linked,
                     id=100003 debit_account_id=10000 credit_account_id=10001 amount=50      ledger=100 code=10,

                     id=14     debit_account_id=1     credit_account_id=2     amount=1       ledger=1   code=10 flags=linked,
                     id=100004 debit_account_id=10000 credit_account_id=10001 amount=99999   ledger=100 code=10,

                     id=15     debit_account_id=1     credit_account_id=2     amount=1       ledger=1   code=10 flags=linked,
                     id=100005 debit_account_id=10000 credit_account_id=10001 amount=50      ledger=100 code=10,
                     
                     id=16     debit_account_id=1     credit_account_id=2     amount=1       ledger=1   code=10 flags=linked,
                     id=100006 debit_account_id=10000 credit_account_id=10001 amount=50      ledger=100 code=10;"

tb "lookup_transfers id=100003, id=100004, id=100005, id=100006;"
