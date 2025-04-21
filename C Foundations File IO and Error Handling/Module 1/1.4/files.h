#ifndef HEADER_FILES_H
#define HEADER_FILES_H

#include <stdio.h>
#include <string.h>

void saveSettings(int minimumValue, int maximumValue, int numberOfGuesses);
void loadSettings(int *minimumValue, int *maximumValue, int *numberOfGuesses);

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

void loadSettings(int *minimumValue, int *maximumValue, int *numberOfGuesses)
{
    FILE *pfile = fopen(FILE_NAME_SETTINGS_INI, "r");
    char currentSettingName[20];
    int currentSettingValue;

    if(pfile != NULL)
    {
        while(fscanf(pfile, "%s = %d", currentSettingName, &currentSettingValue) == 2)
        {
            if(strcmp(currentSettingName, STR_MINIMUM_VALUE) == 0)
            {
                *minimumValue = currentSettingValue;
            }
            else if(strcmp(currentSettingName, STR_MAXIMUM_VALUE) == 0)
            {
                *maximumValue = currentSettingValue;
            }
            else if(strcmp(currentSettingName, STR_NUMBER_OF_GUESSES) == 0)
            {
                *numberOfGuesses = currentSettingValue;
            }

            if(feof(pfile))
            {
                break;
            }
        }
    }

    fclose(pfile);
}

#endif