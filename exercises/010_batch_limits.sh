#!/bin/bash
source ./tools/tb_function.sh

# Our last exercise created multiple accounts in one request and multiple transfers in another.

# In the previous exercise we created multiple transfers, but each in a separate request.
# We said that everything in TigerBeetle is batched for efficiency and performance
# -- so let's take advantage of that!

# Let's go crazy here and create 8190 accounts in a single request!
# Why 8190? That's the maximum number we can send in a request.
create_account_batch="create_accounts "
for ((i=0; i<8190; i++)); do
    create_account_batch+="id=$((100000 + i)) code=10 ledger=100, "
done

# Create the accounts (removing the trailing comma and space)
tb "${create_account_batch%, };"

# Now let's do the same for transfers!

create_transfer_batch="create_transfers "
for ((i=0; i<8191; i++)); do
    create_transfer_batch+="id=$((100000 + i))
        debit_account_id=$((100000 + i))
        credit_account_id=$((100000 + (1 + i) % 8190))
        amount=100
        code=10 
        ledger=80, "
done

tb "${create_transfer_batch%, };"
# Uh oh! We might have gone a _little_ overboard and created one too many transfers!

# (If you're running TigerBeetle using a debug build, you'll see that this error
# is triggered by an assertion failure in the client. TigerBeetle makes heavy use
# of assertions to ensure that it operates as expected.)
