#ifndef HEADER_FILES_H
#define HEADER_FILES_H

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <errno.h>

void saveSettings(int minimumValue, int maximumValue, int numberOfGuesses);
void loadSettings(int *minimumValue, int *maximumValue, int *numberOfGuesses);
void writeToLog(char logType[], char logText[]);
static char* getDateAndTime();

#define STR_MINIMUM_VALUE       "minimumValue"
#define STR_MAXIMUM_VALUE       "maximumValue"
#define STR_NUMBER_OF_GUESSES   "numberOfGuesses"
#define FILE_NAME_SETTINGS_INI  "files\\settings.ini"
#define FILE_NAME_LOG           "gglog.txt"

void saveSettings(int minimumValue, int maximumValue, int numberOfGuesses)
{
    FILE *pfile = fopen(FILE_NAME_SETTINGS_INI, "w");

    if(pfile == NULL)
    {
        char errorMessage[150];
        sprintf(errorMessage, "Could not open file %s", FILE_NAME_SETTINGS_INI);
        writeToLog("ERROR", errorMessage);
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

void writeToLog(char logType[], char logText[])
{
    FILE *pfile = fopen(FILE_NAME_LOG, "wx");
    char *currentDate = getDateAndTime();

    if(pfile != NULL)
    {
        fprintf(pfile, "%s\t%s\t%s\n", currentDate, logType, logText);

        if(ferror(pfile) != 0)
        {
            perror("Could not write to log file");
        }
    }
    else
    {
        if(errno == EEXIST)
        {
            printf("\nThe logging file already exists.");
        }
        else
        {
            printf("\nLOGGING IS NOT ENABLED - Something went wrong. Error number: %d", errno);
        }
    }

    fclose(pfile);
}

static char* getDateAndTime()
{
    time_t tempDate = time(NULL);
    struct tm *outputDate = localtime(&tempDate);
    static char currentTime[50];
    time(&tempDate);

    strftime(currentTime, sizeof(currentTime), "%x", outputDate);

    return currentTime;
}

#endif