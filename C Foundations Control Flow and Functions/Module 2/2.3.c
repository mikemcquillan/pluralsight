#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

int obtainNumericUserInput();
int* getMostGuessesList(int numberOfGuesses);
void displayMostGuesses();
void displaySettingsMenu(int minimumValue, int maximumValue);

#define NUM_MOST_GUESSES    10

int main()
{
    int selection;
    int exit = 0;
    int minimumValue = 1, maximumValue = 30;

    while(exit == 0)
    {
        printf("Welcome to the Guessing Game!\n");
        printf("1. Play Guessing Game\n");
        printf("2. Settings\n");
        printf("3. Most Guesses\n");
        printf("4. Exit\n\n");
        printf("Please enter your selection: ");

        selection = obtainNumericUserInput();

        switch(selection)
        {
            case 1:
                printf("You'll be able to play the game soon!\n\n");
                break;
            case 2:
                displaySettingsMenu(minimumValue, maximumValue);
                break;
            case 3:
                displayMostGuesses();
                break;
            case 4:
                exit = 1;
                break;
            default:
                printf("Invalid selection - please select 1 to 4.\n\n");
                break;
        }        
    }
}

int obtainNumericUserInput()
{
    int inputStatus, tempValue, selection;

    do
    {
        inputStatus = scanf("%d", &selection);
    } while(inputStatus != 1 && (tempValue = getchar()) != EOF && tempValue != '\n');

    return selection;    
}

int* getMostGuessesList(int numberOfGuesses)
{
    int* guesses = (int*)malloc(numberOfGuesses * sizeof(int));
    int minimumNumber = 2, maximumNumber = 35;

    for(int i = 0; i < numberOfGuesses; i++)
    {
        guesses[i] = rand() % (maximumNumber - minimumNumber + 1) + minimumNumber;
    }

    return guesses;
}

void displayMostGuesses()
{
    printf("Most Guesses Table\n");

    int* mostGuesses = getMostGuessesList(NUM_MOST_GUESSES);

    for(int i = NUM_MOST_GUESSES - 1; i >= 0; i--)
    {
        printf("%d. %d\n", i + 1, mostGuesses[i]);
    }

    printf("\nPress a key to return to the main menu.");
    getch();
}

void displaySettingsMenu(int minimumValue, int maximumValue)
{
    int selection, backToMainMenu = 0;

    while(backToMainMenu == 0)
    {
        printf("Guessing Game Settings\n\n");
        printf("1. Set Minimum Value (current value: %d)\n", minimumValue);
        printf("2. Set Maximum Value (current value: %d)\n", maximumValue);
        printf("3. Back to Main Menu\n\n");
        printf("Please enter your selection and hit ENTER (please select 1 to 3): ");

        selection  = obtainNumericUserInput();

        switch(selection)
        {
            case 1:
                printf("Please specify the minimum possible value that can be guessed: ");
                int newMinimumValue = obtainNumericUserInput();

                if(newMinimumValue < maximumValue && newMinimumValue > 0)
                {
                    minimumValue = newMinimumValue;
                }
                else
                {
                    printf("Value is invalid - the value must be larger than zero, "
                           "and lower than the current maximum value (%d).\n\n",
                           maximumValue);                        
                }
                break;

            case 2:
                printf("Please specify the maximum possible value that can be guessed: ");
                int newMaximumValue = obtainNumericUserInput();

                if(newMaximumValue > minimumValue)
                {
                    maximumValue = newMaximumValue;
                }
                else
                {
                    printf("Value is invalid - the value must be higher "
                           "than the current minimum value (%d).\n\n",
                           minimumValue);
                }
                break;

            case 3:
                backToMainMenu = 1;
                break;

            default:
                break;
        }
    }
}