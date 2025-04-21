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
    FILE *pfile = fopen(FILE_NAME_SETTINGS_INI, "a");

    if(pfile == NULL)
    {
        printf("Could not open file %s.", FILE_NAME_SETTINGS_INI);
    }
    else
    {
        fputs(STR_MINIMUM_VALUE, pfile);
        fputc('\n', pfile);
        fputs(STR_MAXIMUM_VALUE, pfile);
        fputc('\n', pfile);
        fputs(STR_NUMBER_OF_GUESSES, pfile);
    }

    fclose(pfile);
}

#endif