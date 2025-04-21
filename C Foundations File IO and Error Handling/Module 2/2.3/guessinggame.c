#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "highscores.h"
#include "files.h"

// Function prototypes/declarations
void displayMainMenu();
int obtainNumericUserInput();
void displaySettingsMenu(int* minimumValue, int* maximumValue, int* numberOfGuesses);
void playGame(int, int, int);
int generateRandomNumber(int minimumValue, int maximumValue);
void displayHighScoreTable();
void cleanUp(int minimumValue, int maximumValue, int numberOfGuesses);

// Constants for colours
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// Constants for menu options
#define MENU_OPTION_1        1
#define MENU_OPTION_2        2
#define MENU_OPTION_3        3
#define MENU_OPTION_4        4

// Main method - program execution starts here
int main()
{
    displayMainMenu();
    
    return 1;
}

// Displays the main menu and handles user requests
void displayMainMenu()
{
    int selection;
    int exit = 0;
    int minimumValue = 1, maximumValue = 30;
    int numberOfGuesses = 3;

    loadSettings(&minimumValue, &maximumValue, &numberOfGuesses);
    loadHighScores();

    // Menu displays until user exits
    while(exit == 0)
    {
        // Display menu
        printf(ANSI_COLOR_YELLOW "*****************************\n" ANSI_COLOR_RESET);
        printf(ANSI_COLOR_YELLOW "Welcome to the Guessing Game!\n" ANSI_COLOR_RESET);
        printf(ANSI_COLOR_YELLOW "*****************************\n\n" ANSI_COLOR_RESET);
        printf("1. Play Guessing Game\n");
        printf("2. Settings\n");
        printf("3. High Scores\n");
        printf("4. Exit\n\n");
        printf(ANSI_COLOR_MAGENTA "Please enter your selection: " ANSI_COLOR_RESET);

        // Obtain user selection
        selection = obtainNumericUserInput();

        switch(selection)
        {
            case MENU_OPTION_1:             // Play the game
                playGame(minimumValue, maximumValue, numberOfGuesses);
                break;
            case MENU_OPTION_2:             // Display settings menu
                displaySettingsMenu(&minimumValue, &maximumValue, &numberOfGuesses);
                break;
            case MENU_OPTION_3:             // Display the high score table
                displayHighScoreTable();
                break;
            case MENU_OPTION_4:             // Quit program
                exit = 1;
                break;
            default:            // Handle invalid input
                printf("Invalid selection - please select 1 to 4.\n\n");
                break;
        }        
    }

    cleanUp(minimumValue, maximumValue, numberOfGuesses);
}

// Cleans up resources when program is closing
void cleanUp(int minimumValue, int maximumValue, int numberOfGuesses)
{
    saveSettings(minimumValue, maximumValue, numberOfGuesses);
    saveHighScores();
    free(currentHighScores);        // Free up high score memory
    currentHighScores = NULL;
}

// Prompts user for input until a number is entered
int obtainNumericUserInput()
{
    int inputStatus, tempValue, selection;

    // Loop over the input, determining whether a number has been entered
    // If inputStatus is 1, have the expected number of values
    // If any of the values entered are non-numeric, return nothing
    // Ignore new lines
    do
    {
        inputStatus = scanf("%d", &selection);
    } while(inputStatus != 1 && (tempValue = getchar()) != EOF && tempValue != '\n');

    return selection;    
}

void displayHighScoreTable()
{
    printf(ANSI_COLOR_YELLOW "******************\n" ANSI_COLOR_RESET);
    printf(ANSI_COLOR_YELLOW "High Score Table\n" ANSI_COLOR_RESET);
    printf(ANSI_COLOR_YELLOW "******************\n\n" ANSI_COLOR_RESET);

    if (currentHighScores == NULL || currentHighScores[0].score == 0)
    {
        printf("There are no high scores. Play a game and try to hit a high score!\n");
    }
    else
    {
        // Output the high scores on-screen
        for(int i = 0; i <= (NUM_HIGH_SCORES - 1); i++)
        {
            if(currentHighScores[i].score > 0)
            {
                printf("%d.\t%s\t\t\t%d\n", i + 1, currentHighScores[i].name, currentHighScores[i].score);
            }
        }
    }
    
    printf(ANSI_COLOR_MAGENTA "\nPress a key to return to the main menu.\n" ANSI_COLOR_RESET);
    getch();
}

// Displays the settings menu and handles input
// minimumValue and maximumValue dictate guessing range for the game
// numberOfGuesses states how many guesses the player can make
// These parameters are passed by reference
void displaySettingsMenu(int* minimumValue, int* maximumValue, int* numberOfGuesses)
{
    int selection, backToMainMenu = 0;

    // Loop will iterate until user asks to return to the main menu
    while(backToMainMenu == 0)
    {
        printf(ANSI_COLOR_MAGENTA "**********************\n" ANSI_COLOR_RESET);
        printf(ANSI_COLOR_MAGENTA "Guessing Game Settings\n" ANSI_COLOR_RESET);
        printf(ANSI_COLOR_MAGENTA "**********************\n\n" ANSI_COLOR_RESET);
        printf("1. Set Minimum Value (current value: %d)\n", *minimumValue);
        printf("2. Set Maximum Value (current value: %d)\n", *maximumValue);
        printf("3. Set Number of Allowed Guesses (current value: %d)\n", *numberOfGuesses);
        printf("4. Back to Main Menu\n\n");
        printf(ANSI_COLOR_MAGENTA "Please enter your selection and hit ENTER (please select 1 to 4): " ANSI_COLOR_RESET);

        // Obtain user selection
        selection  = obtainNumericUserInput();

        switch(selection)
        {
            case MENU_OPTION_1:     // Obtain new minimum input value
                printf(ANSI_COLOR_MAGENTA "Please specify the minimum possible value that can be guessed: " ANSI_COLOR_RESET);
                int newMinimumValue = obtainNumericUserInput();

                if(newMinimumValue < *maximumValue && newMinimumValue > 0)
                {
                    // Store new minimum value if it is valid
                    *minimumValue = newMinimumValue;
                }
                else
                {
                    // Display error if minimum value is not valid
                    printf(ANSI_COLOR_RED "Value is invalid - the value must be larger than zero, "
                           "and lower than the current maximum value (%d).\n\n" ANSI_COLOR_RESET,
                           *maximumValue);                        
                }
                break;

            case MENU_OPTION_2:     // Obtain new maximum input value
                printf(ANSI_COLOR_MAGENTA "Please specify the maximum possible value that can be guessed: " ANSI_COLOR_RESET);
                int newMaximumValue = obtainNumericUserInput();

                if(newMaximumValue > *minimumValue)
                {
                    // Store new maximum value if it is valid
                    *maximumValue = newMaximumValue;
                }
                else
                {
                    // Display error if maximum value is invalid
                    printf(ANSI_COLOR_RED "Value is invalid - the value must be higher "
                           "than the current minimum value (%d).\n\n" ANSI_COLOR_RESET,
                           *minimumValue);
                }
                break;

            case MENU_OPTION_3:     // Updates the allowed number of guesses
                printf(ANSI_COLOR_MAGENTA "Please enter how many guesses a player has during the game: " ANSI_COLOR_RESET);
                int newNumberOfGuesses = obtainNumericUserInput();

                if(newNumberOfGuesses > 0)
                {
                    *numberOfGuesses = newNumberOfGuesses;
                }
                else
                {
                    printf(ANSI_COLOR_RED "Value is invalid - you must allow at least one guess.\n\n" ANSI_COLOR_RESET);
                }
                break;

            case MENU_OPTION_4:     // Returns the user to the main menu
                backToMainMenu = 1;
                break;

            default:
                break;
        }
    }
}

// Game function - contains game logic
void playGame(int minimumValue, int maximumValue, int maximumNumberOfGuesses)
{
    int cheatModeOn = 1;        // Set to 0 to hide the answer
    int playerNumberOfGuesses = 0;
    int currentPlayerAnswer = 0, closeGuessRange = 5, gameWon = 0;
    int correctAnswer = generateRandomNumber(minimumValue, maximumValue);
    int currentPlayerScore = 0;

    // Loop for the required number of player guesses
    for(int i = 0; i < maximumNumberOfGuesses; i++)
    {
        if(cheatModeOn)
        {
            // Display answer if cheat mode is on
            printf(ANSI_COLOR_CYAN "Cheat mode is enabled - the correct answer is %d.\n" ANSI_COLOR_RESET, correctAnswer);
        }

        // Store user answer
        printf(ANSI_COLOR_MAGENTA "Try to guess the number! This is attempt %d of %d. Please enter your guess: " ANSI_COLOR_RESET,
               (playerNumberOfGuesses + 1), maximumNumberOfGuesses);
        currentPlayerAnswer = obtainNumericUserInput();

        // Increment the number of guesses
        playerNumberOfGuesses++;

        // Update the player's score
        currentPlayerScore = updatePlayerScore(correctAnswer, currentPlayerAnswer, 
                                               playerNumberOfGuesses, currentPlayerScore);

        if(currentPlayerAnswer == correctAnswer)
        {
            // If the answer is correct, quit the game
            gameWon = 1;
            break;
        }
        else if(currentPlayerAnswer >= (correctAnswer - closeGuessRange) &&
                currentPlayerAnswer <= (correctAnswer + closeGuessRange))
                {
                    // Answer is in the warm range
                    printf(ANSI_COLOR_YELLOW "Sorry, wrong guess. But you're pretty warm! Score: %d.\n\n" ANSI_COLOR_RESET, currentPlayerScore);
                }
        else
        {
            // Completely wrong answer!
            printf(ANSI_COLOR_RED "Sorry, that's wrong! Score: %d.\n\n" ANSI_COLOR_RESET, currentPlayerScore);
        }
    }       // End of loop

    if(gameWon)
    {
        // Game winner message
        printf(ANSI_COLOR_GREEN "*********************************************************************************\n" ANSI_COLOR_RESET);
        printf(ANSI_COLOR_GREEN "Congratulations, you're an amazing guesser! You won the game after %d attempt(s).\n" ANSI_COLOR_RESET,
               playerNumberOfGuesses);
        printf(ANSI_COLOR_GREEN "Your score: %d.\n" ANSI_COLOR_RESET, currentPlayerScore);
        printf(ANSI_COLOR_GREEN "*********************************************************************************\n" ANSI_COLOR_RESET);
    }
    else
    {
        // Game over message
        printf(ANSI_COLOR_RED "******************************************\n" ANSI_COLOR_RESET);
        printf("Bad luck, you lost. Better luck next time!\n");
        printf("Your score: %d.\n", currentPlayerScore);
        printf(ANSI_COLOR_RED "******************************************\n" ANSI_COLOR_RESET);
    }

    // Update the high score table
    updateHighScores(currentPlayerScore);
}

// Generates a random number within the specified range
int generateRandomNumber(int minimumValue, int maximumValue)
{
    int randomValue = rand() % (maximumValue - minimumValue + 1) + minimumValue;
    return randomValue;
}