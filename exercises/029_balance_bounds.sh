#!/bin/bash
source ./tools/tb_function.sh

# This is an advanced exercise that shows how you can keep an account's balance
# between an upper and a lower bound.

# We're going to set up 4 accounts:
CONTROL_ACCOUNT=2900
OPERATOR_ACCOUNT=2901
SOURCE_ACCOUNT=2910
DESTINATION_ACCOUNT=2911

tb "create_accounts id=$CONTROL_ACCOUNT code=10 ledger=290 flags=credits_must_not_exceed_debits,
                    id=$OPERATOR_ACCOUNT code=10 ledger=290,
                    id=$SOURCE_ACCOUNT code=10 ledger=290 flags=debits_must_not_exceed_credits,
                    id=$DESTINATION_ACCOUNT code=10 ledger=290 flags=debits_must_not_exceed_credits;"

# Let's say we wanted to ensure that a certain account's balance stays between 0 and 100.
# In this case, we're applying this to the DESTINATION_ACCOUNT.

# The DESTINATION_ACCOUNT has the flag `debits_must_not_exceed_credits`, which means that
# it must maintain a positive credit balance. Let's see how we implement an upper bound
# on that account's credit balance.

# We'll start off by putting some funds in the SOURCE_ACCOUNT:
tb "create_transfers id=29000 debit_account_id=$OPERATOR_ACCOUNT credit_account_id=$SOURCE_ACCOUNT amount=1000 ledger=290 code=10;"

# Here's where it gets a little crazy.
LIMIT_AMOUNT=100
TRANSFER_AMOUNT=200
tb "create_transfers id=29001 debit_account_id=$SOURCE_ACCOUNT      credit_account_id=$DESTINATION_ACCOUNT amount=$TRANSFER_AMOUNT ledger=290 code=10 flags=linked,
                     id=29002 debit_account_id=$CONTROL_ACCOUNT     credit_account_id=$OPERATOR_ACCOUNT    amount=$LIMIT_AMOUNT    ledger=290 code=10 flags=linked,
                     id=29003 debit_account_id=$DESTINATION_ACCOUNT credit_account_id=$CONTROL_ACCOUNT     amount=0                ledger=290 code=10 flags=balancing_debit | pending | linked,
                     id=29004 pending_id=29003 flags=void_pending_transfer | linked,
                     id=29005 debit_account_id=$OPERATOR_ACCOUNT    credit_account_id=$CONTROL_ACCOUNT     amount=$LIMIT_AMOUNT    ledger=290 code=10;"
                
# This is a set of linked transfers, so either all of them will succeed or none of them will.
# The first transfer is the one we actually want to create.
# In the second transfer, we debit the CONTROL_ACCOUNT by the LIMIT_AMOUNT.
# (The CONTROL_ACCOUNT has the `credits_must_not_exceed_debits` flag so the credits cannot exceed the LIMIT_AMOUNT.)
# The third transfer pretends to do a `balancing_debit` transfer to send the DESTINATION_ACCOUNT's *net credit balance* to the CONTROL_ACCOUNT.
# The third transfer will only succeed if the DESTINATION_ACCOUNT's credit balance is within bounds after the first transfer.
# The fourth transfer voids the third transfer (that's why we said it "pretends" to do a `balancing_debit`).
# Finally, the fifth transfer resets the CONTROL_ACCOUNT's net balance to zero.

# Can you fix the TRANSFER_AMOUNT so that our batch of transfers succeeds? (Hint: it should be less than the LIMIT_AMOUNT.)
