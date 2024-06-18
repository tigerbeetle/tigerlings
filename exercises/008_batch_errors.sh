#!/bin/bash
source ./tools/tb_function.sh

# In the last exercise, we created each transfer in a separate request.
# Let's do the same thing again but this time we'll send the transfers in a single request.

# Here are our ledger mappings:
USD_LEDGER=80
EUR_LEDGER=81
YEN_LEDGER=82

# And our accounts:
tb "create_accounts id=800 code=10 ledger=${USD_LEDGER},
                    id=801 code=10 ledger=${USD_LEDGER},
                    id=802 code=10 ledger=${EUR_LEDGER},
                    id=803 code=10 ledger=${EUR_LEDGER},
                    id=804 code=10 ledger=${YEN_LEDGER},
                    id=805 code=10 ledger=${YEN_LEDGER};"

# Sorry to make you correct the same error again...
# But before you do -- note that you see an error for each transfer in the batch!
tb "create_transfers id=80000 debit_account_id=800 credit_account_id=801 amount=100 ledger=${EUR_LEDGER} code=10,
                     id=80001 debit_account_id=802 credit_account_id=803 amount=100 ledger=${YEN_LEDGER} code=10,
                     id=80002 debit_account_id=804 credit_account_id=805 amount=100 ledger=${USD_LEDGER} code=10;"

# By default, all events in a request succeed or fail separately.
# (There is a feature we'll learn about later that enables us to atomically `link` events together.)
