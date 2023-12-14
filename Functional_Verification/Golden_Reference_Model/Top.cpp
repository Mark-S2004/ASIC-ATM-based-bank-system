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

void deposit(int& balance, int depositValue) {
    balance += depositValue;
    cout << "Deposit of " << depositValue << " completed. Updated balance: " << balance << endl;
}

void withdraw(int& balance, int withdrawValue) {
    if (withdrawValue <= balance) {
        balance -= withdrawValue;
        cout << "Withdrawal of " << withdrawValue << " completed. Updated balance: " << balance << endl;
    } else {
        cout << "Insufficient funds. Withdrawal cannot be completed." << endl;
    }
}

void balanceCheck(int balance) {
    cout << "Current balance: " << balance << endl;
}

void performOperation(int id,int pswd,int language, unsigned short operation, int balance, int depositValue, int withdrawValue, bool anotherService) {
    if (checker(id,pswd)== true){
        switch (operation){
            case Deposit:
                deposit(balance,depositValue);
                break;
            case Withdraw:
                withdraw(balance,withdrawValue);
                break;    
            case BalanceCheck:
                balanceCheck(balance);
                break;   
            default:
                cout << "Please Enter a vaild operation.";
                break;
            }
    }
    
}

int main() {
    int cardNumber = 1;
    int password = 11;
    int language = 1;
    unsigned short operation = Deposit;
    int balance = 1000;
    int depositValue = 500;
    int withdrawValue = 200;
    bool anotherService = false;



    performOperation(cardNumber,password,language, operation, balance, depositValue, withdrawValue, anotherService);

}