#!/bin/bash
source ./tools/tb_function.sh

# So far, all of the amounts we've been transferring have been integers.
# What if we want to transfer a fraction of a unit?

tb "create_accounts id=1700 code=10 ledger=170,
                    id=1701 code=10 ledger=170;"

# Let's try transferring 1.5 units between the two accounts:
amount=1.5

tb "create_transfers id=17000 debit_account_id=1700 credit_account_id=1701 amount=$amount ledger=170 code=10;"
# Uh oh! That doesn't work. (Maybe comment it out and we'll fix it below)

# TigerBeetle only uses integer amounts for precision and performance reasons.
# You should represent amounts as multiples of the smallest unit an asset supports.
# For example, if you're working with dollars, you might represent amounts in cents
# so $1.5 would be represented as amount=1500.

# The asset "scale" should be considered a property of the ledger. You can use a different scale for each ledger.

LEDGER_SCALE=2
# (We're using the "basic calculator" because bash doesn't support floating point numbers)
scaling_factor=$(echo "10 ^ $LEDGER_SCALE" | bc)
amount=$(echo "$amount * $scaling_factor" | bc)

tb "create_transfers id=17000 debit_account_id=1700 credit_account_id=1701 amount=${amount%.*} ledger=170 code=10;"

# Now we can look up the balance, but we'll get the amount as a multiple of the smallest unit.
balance=$(tb "lookup_accounts id=1700;" | grep "debits_posted" | cut -d'"' -f4)

# If we want to display the balance to the user, we'll want to scale it back down to a decimal.
# Math in bash is complicated -- but can you replace the ??? with the right operation?
balance=$(echo "scale=$LEDGER_SCALE; $balance ??? $scaling_factor" | bc)

if [[ $balance =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "Balance: $balance"
else
    echo "You should scale the balance before displaying it to the user!"
fi