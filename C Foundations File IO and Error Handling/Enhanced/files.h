#ifndef HEADER_FILES_H
#define HEADER_FILES_H

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <errno.h>

void saveSettings(int minimumValue, int maximumValue, int numberOfGuesses);
void loadSettings(int *minimumValue, int *maximumValue, int *numberOfGuesses);
void writeToLog(char logType[], char logText[]);
static char* getDateAndTime(int returnDateOnly);
void fileErrorHandler(char *fileDescription, int errorNumber);

#define STR_MINIMUM_VALUE       "minimumValue"
#define STR_MAXIMUM_VALUE       "maximumValue"
#define STR_NUMBER_OF_GUESSES   "numberOfGuesses"
#define STR_MINIMUM_LOG_LEVEL   "minimumLogLevel"
#define FILE_NAME_SETTINGS_INI  "files\\settings.ini"
#define FILE_NAME_LOG_PREFIX    "gglog_"  // Changed to a prefix only
#define FILE_NAME_TXT_EXTENSION ".txt"   // Added extension
#define LOG_LEVEL_ERROR         "ERROR"
#define LOG_LEVEL_INFO          "INFO"

void saveSettings(int minimumValue, int maximumValue, int numberOfGuesses)
{
    FILE *pfile = fopen(FILE_NAME_SETTINGS_INI, "w");

    if(pfile == NULL)
    {
        char errorMessage[150];
        sprintf(errorMessage, "Could not open file %s", FILE_NAME_SETTINGS_INI);
        writeToLog(LOG_LEVEL_ERROR, errorMessage);
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
    int errorReadingSettingsFound = 1;  // Assume error

    if(pfile != NULL)
    {
        // The while loop protects non-numeric values from being read in, and 
        // values in the wrong format from being read in
        while(fscanf(pfile, "%s = %d", currentSettingName, &currentSettingValue) == 2)
        {
            // Reset error flag so it can be checked again
            errorReadingSettingsFound = 1;

            if(strcmp(currentSettingName, STR_MINIMUM_VALUE) == 0)
            {
                *minimumValue = currentSettingValue;
                errorReadingSettingsFound = 0;
            }
            else if(strcmp(currentSettingName, STR_MAXIMUM_VALUE) == 0)
            {
                *maximumValue = currentSettingValue;
                errorReadingSettingsFound = 0;
            }
            else if(strcmp(currentSettingName, STR_NUMBER_OF_GUESSES) == 0)
            {
                *numberOfGuesses = currentSettingValue;
                errorReadingSettingsFound = 0;
            }
            else    // Denote an error was found if an unexxpected value is read
            {
                errorReadingSettingsFound = 1;
            }

            if(feof(pfile))
            {
                break;
            }
        }
    }

    // If an error has been captured, write out to the log
    if(errorReadingSettingsFound)
    {
        writeToLog(LOG_LEVEL_ERROR, 
            "Unexpected error reading settings.ini. Check the file is formatted correctly.");
    }

    // Only write the success message if no error was found
    if(fclose(pfile) == 0 && !errorReadingSettingsFound)
    {
        writeToLog(LOG_LEVEL_INFO, "Successfully read settings file.");
    }
}

void writeToLog(char logType[], char logText[])
{
    char *fileDate = getDateAndTime(1);
    char fileName[100] = FILE_NAME_LOG_PREFIX;
    
    // Build up the file name, with the date included
    strcat(fileName, fileDate);
    strcat(fileName, FILE_NAME_TXT_EXTENSION);
    
    // If a different file name is generated to the existing file,
    // the newly named file will be created
    FILE *pfile = fopen(fileName, "a");
    char *currentDate = getDateAndTime(0);

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
        fileErrorHandler(fileName, errno);
        printf("\n%s\t%s\t%s\n", currentDate, logType, logText);
    }

    fclose(pfile);
}

// Flag denotes whether only the date should be returned.
// If flag is 0, date and time are returned.
// If flag is 1, date is returned formatted for a file name.
static char* getDateAndTime(int returnDateOnly)
{
    time_t tempDate = time(NULL);
    struct tm *outputDate = localtime(&tempDate);
    static char currentTime[50];
    time(&tempDate);

    if(!returnDateOnly)
    {
        strftime(currentTime, sizeof(currentTime), "%x %T", outputDate);
    }
    else
    {
        strftime(currentTime, sizeof(currentTime), "%F", outputDate);
    }

    return currentTime;
}

void fileErrorHandler(char *fileDescription, int errorNumber)
{
    switch(errorNumber)
    {
        case EEXIST:
            printf("\nThe %s file already exists.", fileDescription);
            break;

        case EACCES:
            printf("\nThe %s file is not accessible. Please check your permissions.",
                fileDescription);
            break;

        default:
            printf("\nAn unexpected error occurred with file %s - error code %d.",
                fileDescription);
            break;
    }
}

#endif