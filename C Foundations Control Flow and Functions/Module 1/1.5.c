#include <stdio.h>

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

        scanf("%d", &selection);
        
        if(selection == 1)
        {
            printf("You'll be able to play the game soon!\n\n");
        }
        else if(selection == 2)
        {
            printf("Settings menu coming soon!\n\n");
        }
        else if(selection == 3)
        {
            printf("Most guesses coming soon!\n\n");
        }
        else if(selection == 4)
        {
            exit = 1;
        }
        else
        {
            printf("Invalid selection - please select 1 to 4.\n\n");
        }
    }
}