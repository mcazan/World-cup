#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
  # insert winners into database

  # get winner_id
  if [[ $WINNER != "winner" && $OPPONET != 'opponent' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    # if not found 
    if [[ -z $WINNER_ID ]]
    then
      # insert winner
      INSERT_WINNER=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')") 
      if [[ $INSERT_WINNER == 'INSERT 0 1' ]]
      then 
        echo "Inserted into teams, winner $WINNER"
      # get new winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")    
      fi
    fi

    # insert opponets into database

    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponet
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $INSERT_OPPONENT == 'INSERT 0 1' ]]
      then
        echo "Inserted into teams, opponent $OPPONENT"
        # get new opponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")  
      fi  
    fi 

    # insert games into database
    if [[ $YEAR != 'year' ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
      then 
        echo "Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
      fi  
    fi  
  fi   
done  