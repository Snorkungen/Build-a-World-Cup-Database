#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

GET_TEAM_ID () {
  TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$*';")"
  echo $TEAM_ID
}

ADD_TEAM () {
  TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$*';")"
  if [[ -z $TEAM_ID ]]; then
    TEAM_ID="$($PSQL "INSERT INTO teams (name) VALUES('$*');")"
    echo "Added to teams: $*"
  fi
}

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  if [[ $YEAR == year ]]; then continue; fi

  ADD_TEAM $WINNER
  ADD_TEAM $OPPONENT

done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  if [[ $YEAR == year ]]; then continue; fi

  WINNER_ID=$(GET_TEAM_ID $WINNER)
  OPPONENT_ID=$(GET_TEAM_ID $OPPONENT)

  $PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);"

done

