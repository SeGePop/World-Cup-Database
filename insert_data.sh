#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#!/bin/bash

# Script to insert data from games.csv into worldcup database

echo $($PSQL "TRUNCATE games, teams")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1;")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #skip first row
  if [[ $YEAR != "year" ]]
    then
    #Construct the INSERT statement for teams

    #Check if winner is in the table
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM_ID ]]
    then
      TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      echo Inserted into teams: $WINNER
    fi
    # Check if opponent is in the table
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_ID ]]
    then
      TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      echo Inserted into teams: $OPPONENT 
    fi

    #Construct INSERT for games

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
    echo Inserted into table $YEAR, $ROUND, $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS

  fi
done