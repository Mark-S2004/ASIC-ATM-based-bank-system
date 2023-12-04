#include <iostream>
#include <vector>
using namespace std;
class CardHandlingModel {
private:
    int cardWidth;
    int passwordWidth;
    int balanceWidth;
    int usersNum;
    vector<int> balances;

public:
    CardHandlingModel(int cardWidth, int passwordWidth, int balanceWidth, int usersNum) {
        this->cardWidth = cardWidth;
        this->passwordWidth = passwordWidth;
        this->balanceWidth = balanceWidth;
        this->usersNum = usersNum;

        // Initialize balances for each user to zero
        balances.resize(usersNum, 0);
    }

    bool handleCard(int cardNumber, bool cardIn, bool cardOut, int passwordInput, int& updatedBalance) {
        if (cardIn) {
            // Check if the card number is valid
            if (cardNumber >= 0 && cardNumber < usersNum) {
                // Check if the password is correct
                if (passwordInput == cardNumber) {
                    updatedBalance = balances[cardNumber];
                    return true;  // Valid card and correct password
                } else {
                    updatedBalance = balances[cardNumber];
                    return false;  // Valid card but incorrect password
                }
            }
        }

        updatedBalance = 0;
        return false;  // Invalid card
    }
};

int main() {
    int cardWidth = 6;
    int passwordWidth = 16;
    int balanceWidth = 20;
    int usersNum = 10;

    CardHandlingModel model(cardWidth, passwordWidth, balanceWidth, usersNum);

    int cardNumber = 1;
    bool cardIn = true;
    bool cardOut = false;
    int passwordInput = 10;
    int updatedBalance = 0;

    bool validCard = model.handleCard(cardNumber, cardIn, cardOut, passwordInput, updatedBalance);

    if (validCard) {
        cout << "Valid card. Updated balance: " << updatedBalance << std::endl;
    } else {
        cout << "Invalid card or incorrect password." << std::endl;
    }

    return 0;
}