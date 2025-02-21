#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

int obtainNumericUserInput();
int* getMostGuessesList(int numberOfGuesses);
void displayMostGuesses();

#define NUM_MOST_GUESSES    10

int main()
{
    int selection;
    int exit = 0;

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
                printf("Settings menu coming soon!\n\n");
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