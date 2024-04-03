#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
then

 WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # if not found
  if [[ -z $WINNER_TEAM_ID ]]
  then
    # insert team
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
then
echo Inserted into teams, $WINNER
fi
    # get new team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  fi

  # OPPONENT
OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # if not found
  if [[ -z $OPPONENT_TEAM_ID ]]
  then
    # insert team
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
then
echo Inserted into teams, $OPPONENT
fi
    # get new team_id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  fi
  

fi

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,winner_goals,opponent_goals,opponent_id) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS, $OPPONENT_TEAM_ID)")

if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
then
echo Inserted into games, $WINNER vs $OPPONENT

fi

done