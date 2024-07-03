#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
GET_ELEMENT_INFORMATION () {
  #if no input
  if [[ -z $1 ]]
  then echo Please provide an element as an argument.
       exit 0
  fi

  #Argument
  ARGUMENT=$1
  #Query element
  GET_ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e
                       JOIN properties p ON e.atomic_number = p.atomic_number
                       JOIN types t ON p.type_id = t.type_id 
                       WHERE e.atomic_number::text = '$ARGUMENT' OR e.symbol = '$ARGUMENT' OR e.name = '$ARGUMENT'") 
  if [[ -z $GET_ELEMENT ]]
  then echo "I could not find that element in the database."
  else
    echo "$GET_ELEMENT" | while IFS="|" read A_NUMBER SYMBOL NAME A_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}
GET_ELEMENT_INFORMATION $1
