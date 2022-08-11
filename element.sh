#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# code review done

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    WHERE="elements.atomic_number=$1"
  else
    WHERE="elements.symbol='$1' OR elements.name='$1'"
  fi

  ELEMENT=$($PSQL "SELECT elements.atomic_number, symbol, name, melting_point_celsius, boiling_point_celsius, atomic_mass, type FROM elements INNER JOIN properties ON properties.atomic_number=elements.atomic_number INNER JOIN types ON properties.type_id=types.type_id WHERE $WHERE")

  if [[ $ELEMENT ]]
  then
    echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MELTING_POINT BAR BOILING_POINT BAR ATOMIC_MASS BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
else
  echo "Please provide an element as an argument."
fi
