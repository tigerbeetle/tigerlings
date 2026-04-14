#!/bin/bash
source ./tools/tb_function.sh

# Our last exercise created multiple accounts in one request and multiple transfers in another.

# In the previous exercise we created multiple transfers, but each in a separate request.
# We said that everything in TigerBeetle is batched for efficiency and performance
# -- so let's take advantage of that!

# The maximum number of events we can send in a single request is 8189.
# Let's create 8189 accounts across two batches:
create_account_batch="create_accounts "
for ((i=0; i<4000; i++)); do
    create_account_batch+="id=$((100000 + i)) code=10 ledger=100, "
done
tb "${create_account_batch%, };"

create_account_batch="create_accounts "
for ((i=4000; i<8189; i++)); do
    create_account_batch+="id=$((100000 + i)) code=10 ledger=100, "
done
tb "${create_account_batch%, };"

# Now let's do the same for transfers!
# (We have to split them into batches because of the REPL's command-line size limit.)

create_transfer_batch="create_transfers "
for ((i=0; i<1400; i++)); do
    create_transfer_batch+="id=$((1000 + i)) debit_account_id=$((100000 + i)) credit_account_id=$((100000 + (1 + i) % 8189)) amount=1 code=10 ledger=100, "
done
tb "${create_transfer_batch%, };"

create_transfer_batch="create_transfers "
for ((i=1400; i<2800; i++)); do
    create_transfer_batch+="id=$((1000 + i)) debit_account_id=$((100000 + i)) credit_account_id=$((100000 + (1 + i) % 8189)) amount=1 code=10 ledger=100, "
done
tb "${create_transfer_batch%, };"
