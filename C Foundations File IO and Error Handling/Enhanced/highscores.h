#ifndef HEADER_HIGHSCORES_H
#define HEADER_HIGHSCORES_H

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "files.h"

#define NUM_HIGH_SCORES         10
#define HIGH_SCORE_UPPER_LIMIT  10000      // Enhanced code - constant to ensure scores are valid

#define POINTS_100           	100        // Score value for first-time correct guess
#define POINTS_75            	75         // Score value for second-time correct guess
#define POINTS_50            	50         // Score value for third-time or more correct guess
#define POINTS_20            	20         // For warm guess that missed being right by 1
#define POINTS_15            	15         // For warm guess that missed being right by 2
#define POINTS_10            	10         // For warm guess that missed being right by 3
#define POINTS_8             	8          // For warm guess that missed being right by 4
#define POINTS_5             	5          // For warm guess that missed being right by 5
#define ANSWER_MULTIPLIER	    5          // Multiplier for correct guess
#define FILE_NAME_HIGH_SCORES   "files\\highscores.bin"

// Structure to hold high score details
typedef struct highScore
{
    int score;
    char name[15];
} HighScore;

HighScore* initializeHighScores();
void updateHighScores(int newScore);
int compareValues(const void *value1, const void *value2);
int reverseSortingOrder(const void *value1, const void *value2);
int updatePlayerScore(int correctAnswer, int currentAnswer, 
    int numberOfGuesses, int currentScore);
int updateScoreForCorrectAnswer(int numberOfGuesses, int currentScore);
int updateScoreForWarmAnswer(int correctAnswer, int currentAnswer, int currentScore);
void saveHighScores();
void loadHighScores();
int highScoreIsInValidRange(int score);
int numberValidHighScores();

// Pointer to array, which stores high scores
HighScore* currentHighScores = NULL;

// Initializes the default scores
// It's very hard spelling initialize with a z, I'm British!
HighScore* initializeHighScores()
{
    int defaultScore = 0;

    HighScore* highScores = malloc(sizeof(*highScores) * NUM_HIGH_SCORES);

    for(int i = 0; i < NUM_HIGH_SCORES; i++)
    {
        // Allocate a default score, to denote the score elements are not in use
        highScores[i].score = defaultScore;
    }

    return highScores;
}

// Prompts the player to enter their name if the high score makes it on to the table
// Updates the high score with the new score and reorders it
void updateHighScores(int newScore)
{
    char newName[20];

    if(currentHighScores == NULL)
    {
        currentHighScores = initializeHighScores();
    }

    // High scores are sorted, so add the score if it's higher than the lowest score
    if(currentHighScores[NUM_HIGH_SCORES-1].score < newScore)
    {
        HighScore newHighScore;

        printf("Congratulations, you obtained a high score!\nPlease enter your name: ");
        scanf("%s", newHighScore.name);
        printf("\n");

        newHighScore.score = newScore;
        
        // Replace the last score in the array and re-sort
        currentHighScores[NUM_HIGH_SCORES-1] = newHighScore;
        qsort(currentHighScores, NUM_HIGH_SCORES, sizeof(HighScore), reverseSortingOrder);
    }
}

// Comparison function used for array sorting
int compareValues(const void *value1, const void *value2)
{
    return ((HighScore*)value1)->score - ((HighScore*)value2)->score;
}

// Reverses the sorting order, so scores are listed in descending order
int reverseSortingOrder(const void *value1, const void *value2)
{
    return -compareValues(value1, value2);
}

// Updates the current player's score
int updatePlayerScore(int correctAnswer, int currentAnswer, 
    int numberOfGuesses, int currentScore)
{
    int newScore = currentScore;

    // Increase the score if the correct answer has been provided
    if(correctAnswer == currentAnswer)
    {
        newScore = updateScoreForCorrectAnswer(numberOfGuesses, currentScore);
    }
    else
    {
        newScore = updateScoreForWarmAnswer(correctAnswer, currentAnswer, currentScore);
    }

    return newScore;
}

// Updates score for a correct answer
int updateScoreForCorrectAnswer(int numberOfGuesses, int currentScore)
{
    int newScore = currentScore;

    switch(numberOfGuesses)
    {
        case 1:
            newScore += (POINTS_100 * ANSWER_MULTIPLIER);
            break;

        case 2:
            newScore += (POINTS_75 * ANSWER_MULTIPLIER);
            break;

        default:
            newScore += (POINTS_50 * ANSWER_MULTIPLIER);
            break;
    }

    return newScore;
}

// Updates score for a warm answer
int updateScoreForWarmAnswer(int correctAnswer, int currentAnswer, int currentScore)
{
    int difference = abs(correctAnswer - currentAnswer);
    int newScore = currentScore;

    switch(difference)
    {
        case 1:
            newScore += POINTS_20;
            break;

        case 2:
            newScore += POINTS_15;
            break;

        case 3:
            newScore += POINTS_10;
            break;

        case 4:
            newScore += POINTS_8;
            break;

        case 5:
            newScore += POINTS_5;
            break;
    }

    return newScore;
}

void saveHighScores()
{
    FILE *pfile = fopen(FILE_NAME_HIGH_SCORES, "wb");
    int totalValidScores = numberValidHighScores();

    if(pfile != NULL && currentHighScores != NULL)
    {
        int result = fwrite(currentHighScores, sizeof(HighScore), NUM_HIGH_SCORES, pfile);
        
        if(fflush(pfile) != 0)
        {
            writeToLog(LOG_LEVEL_ERROR, "Saving of high scores failed.");
            perror("High score file flush failed");
        }
        else
        {   
            char errorMessage[150];
            sprintf(errorMessage, "Updated high scores file. Number of high scores written: %d. Number valid scores: %d.", result, totalValidScores);
            writeToLog(LOG_LEVEL_INFO, errorMessage);
        }
    }

    fclose(pfile);
}

void loadHighScores()
{
    FILE *pfile = fopen(FILE_NAME_HIGH_SCORES, "rb");
    int counter = 0;
    HighScore hs;
    currentHighScores = initializeHighScores();
    int corruptedHighScoreFound = 0;

    if(pfile != NULL)
    {
        // Add this line to display the five lowest scores
        // Multiple the sizeof(hs) by the number of scores you wish to offset by
        // to start reading from that point
        // E.g. to display just 1 score, multiply by 9
        // (assuming there are 10 scores in the file)
        fseek(pfile, sizeof(hs) * 5, SEEK_SET);
        
        // You can seek to a point in the file
        // If you want to return to the start of the file, 
        // call rewind with the file pointer
        // In this case, this acts as though the fseek line was never executed
        rewind(pfile);

        while(fread(&hs, sizeof(hs), 1, pfile) == 1)
        {
            if(!highScoreIsInValidRange(hs.score))
            {
                strcpy(hs.name, "");
                hs.score = 0;
                writeToLog(LOG_LEVEL_ERROR, "High score corrupted - removed score from list.");
                corruptedHighScoreFound = 1;
            }

            currentHighScores[counter] = hs;
            counter++;
        }
    }
    else
    {
        writeToLog(LOG_LEVEL_ERROR, "Incorrect number of elements read from high score file.");
        perror("Incorrect number of elements read from high score file");
    }

    qsort(currentHighScores, NUM_HIGH_SCORES, sizeof(HighScore), reverseSortingOrder);
    
    fclose(pfile);

    if(corruptedHighScoreFound)
    {
        if(remove(FILE_NAME_HIGH_SCORES) == 0)
        {
            writeToLog(LOG_LEVEL_ERROR, "Corrupted high scores found. High score file deleted.");
        }
    }
}

int highScoreIsInValidRange(int score)
{
    return score > HIGH_SCORE_UPPER_LIMIT ? 0 : 1;
}

int numberValidHighScores()
{
    int validScoreTotal = 0;

    for(int i = 0; i < NUM_HIGH_SCORES; i++)
    {
        validScoreTotal += currentHighScores[i].score > 0 ? 1 : 0;
    }

    return validScoreTotal;
}

#endif