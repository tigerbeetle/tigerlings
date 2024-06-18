#!/bin/bash
source ./tools/tb_function.sh

# In the previous exercise, we created some accounts on different ledgers.
# But what do ledgers represent?

# Ledgers partition accounts into groups.
# These groups can represent anything you want. Often, they are used
# to represent different currencies, assets, or they can be used for
# multi-tenant setups where each ledger represents a different customer.

# In our application logic, we might store a mapping between each currency
# and the numeric ledger identifier we'll use in TigerBeetle:
USD_LEDGER=70
EUR_LEDGER=71
YEN_LEDGER=72

tb "create_accounts id=700 code=10 ledger=${USD_LEDGER},
                    id=701 code=10 ledger=${USD_LEDGER},
                    id=702 code=10 ledger=${EUR_LEDGER},
                    id=703 code=10 ledger=${EUR_LEDGER},
                    id=704 code=10 ledger=${YEN_LEDGER},
                    id=705 code=10 ledger=${YEN_LEDGER};"

tb "create_transfers id=70000 debit_account_id=700 credit_account_id=701 amount=100 ledger=${EUR_LEDGER} code=10;"

tb "create_transfers id=70001 debit_account_id=702 credit_account_id=703 amount=100 ledger=${YEN_LEDGER} code=10;"

tb "create_transfers id=70002 debit_account_id=704 credit_account_id=705 amount=100 ledger=${USD_LEDGER} code=10;"

# Uh oh! We mixed up which transfer is on which ledger. Can you fix them?
