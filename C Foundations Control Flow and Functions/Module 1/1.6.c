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
        
        switch(selection)
        {
            case 1:
                printf("You'll be able to play the game soon!\n\n");
                break;
            case 2:
                printf("Settings menu coming soon!\n\n");
                break;
            case 3:
                printf("Most Guesses coming soon!\n\n");
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