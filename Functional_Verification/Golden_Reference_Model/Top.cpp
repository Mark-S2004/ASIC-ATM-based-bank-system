#include <iostream>
using namespace std;

int cards[] = {1,2,3,4,5,6,7};
int balance[] = {1000,2000,3000,4000,5000,6000,7000};
int passwords[] = {11,22,33,44,55,66,77};

enum operation {Deposit,Withdraw,BalanceCheck};



bool checker(int enteredCard, int enteredPassword) {

    int index = -1;  
    int len =sizeof(cards) / sizeof(cards[0]);
    for (int i = 0; i < len; ++i) {
        if (cards[i] == enteredCard) {
            index = i;  
            break;      
        }
    }

    if (index != -1) {
        if (enteredPassword == passwords[index]) {
            cout << "Login successful! Balance: $" << balance[index] << endl;
            return true;
        } else {
            cout << "Incorrect password for card number " << enteredCard << endl;
        }
    } else {
        cout << "Incorrect Card number " << enteredCard << endl;
    }
    return false;

}

int deposit(int& balance, int depositValue) {
    balance += depositValue;
    cout << "Deposit of " << depositValue << " completed. Updated balance: " << balance << endl;
    return balance;
}

int withdraw(int& balance, int withdrawValue) {
    if (withdrawValue <= balance) {
        balance -= withdrawValue;
        cout << "Withdrawal of " << withdrawValue << " completed. Updated balance: " << balance << endl;
    } else {
        cout << "Insufficient funds. Withdrawal cannot be completed." << endl;
    }
    return balance;
}

int balanceCheck(int balance) {
    cout << "Current balance: " << balance << endl;
    return balance;
}
// 1305QA

int performOperation(int rst, int card_in, int id, int pswd, int language, unsigned short operation, int depositValue, int withdrawValue, bool anotherService) {
    if (rst == 1 && card_in) {
        if (checker(id, pswd) == true) {
            switch (operation) {
                case Deposit:
                    deposit(balance[id - 1], depositValue);
                    break;
                case Withdraw:
                    withdraw(balance[id - 1], withdrawValue);
                    break;
                case BalanceCheck:
                    balanceCheck(balance[id - 1]);
                    break;
                default:
                    cout << "Please enter a valid operation." << endl;
                    break;
            }
            if (anotherService) {
                cout << "Select another service: 0-Deposit - 1-Withdraw - 2-BalanceCheck: ";
                cin >> operation;
                performOperation(rst, card_in, id, pswd, language, operation, depositValue, withdrawValue, false);
            }
        }
    } else if (rst == 0) {
        cout << "Done Reset " << endl;
        cout << "Balance: $0.00" << endl;
    } else if (!card_in) {
        cout << "There is no card in ATM " << endl;
    }

    return balance[id - 1];
 
}


int main() {
    int rst = 1;
    int card_in = 1;
    int cardNumber = 2;
    int password = 22;
    int language = 1;
    unsigned short operation = Deposit;
    int depositValue = 500;
    int withdrawValue = 200;
    bool anotherService = true;



    performOperation(rst,card_in,cardNumber,password,language, operation, depositValue, withdrawValue, anotherService);
    cout << "Thank you for using our services. Goodbye!" << endl;

}