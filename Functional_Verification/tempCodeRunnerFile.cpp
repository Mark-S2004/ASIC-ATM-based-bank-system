          cout << "Select another service: 0-Deposit - 1-Withdraw - 2-BalanceCheck: ";
                cin >> operation;
                performOperation(rst, id, pswd, language, operation, depositValue, withdrawValue, false);