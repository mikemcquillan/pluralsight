#include <stdio.h>

int main()
{
    int selection;
    int exit = 0;

    printf("Welcome to the Guessing Game!\n");
    printf("1. Play Guessing Game\n");
    printf("2. Settings\n");
    printf("3. Most Guesses\n");
    printf("4. Exit\n\n");

    while(exit == 0)
    {
        scanf("%d", &selection);
        
        if(selection == 4)
        {
            exit = 1;
        }
    }
}