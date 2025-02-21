#include <stdio.h>

int main()
{
    int selection;

    printf("Welcome to the Guessing Game!\n");
    printf("1. Play Guessing Game\n");
    printf("2. Settings\n");
    printf("3. Most Guesses\n");
    printf("4. Exit\n\n");

    scanf("%d", &selection);

    printf("Selection is %d", selection);
}