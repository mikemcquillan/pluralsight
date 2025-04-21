#ifndef HEADER_FILES_H
#define HEADER_FILES_H

#include <stdio.h>

void saveSettings(int minimumValue, int maximumValue, int numberOfGuesses);

#define STR_MINIMUM_VALUE       "minimumValue"
#define STR_MAXIMUM_VALUE       "maximumValue"
#define STR_NUMBER_OF_GUESSES   "numberOfGuesses"
#define FILE_NAME_SETTINGS_INI  "files\\settings.ini"

void saveSettings(int minimumValue, int maximumValue, int numberOfGuesses)
{
    FILE *pfile = fopen(FILE_NAME_SETTINGS_INI, "w");

    if(pfile == NULL)
    {
        printf("Could not open file %s.", FILE_NAME_SETTINGS_INI);
    }
    else
    {
        fprintf(pfile, "%s = %d\n", STR_MINIMUM_VALUE, minimumValue);
        fprintf(pfile, "%s = %d\n", STR_MAXIMUM_VALUE, maximumValue);
        fprintf(pfile, "%s = %d\n", STR_NUMBER_OF_GUESSES, numberOfGuesses);
    }

    fclose(pfile);
}

#endif