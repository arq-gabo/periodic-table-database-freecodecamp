PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function if the element not exist in database
NOT_EXIST_ELEMENT_RETURN(){
  echo "I could not find that element in the database."
}

# Function if the element exist in database
EXIST_ELEMENT_RETURN(){
  echo "$1" | awk -F '|' '{print "The element with atomic number " $1 " is " $2 " ("$3"). It'\''s a " $4 ", with a mass of " $5 " amu. " $2 " has a melting point of " $6 " celsius and a boiling point of " $7 " celsius." }'
}

# Conditional if argument exist
if [[ $1 ]]
then
  # Conditional if the argument is number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT elements.atomic_number AS atomic_number, elements.name AS name, elements.symbol AS symbol, types.type AS type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1;")
    if [[ -z $ELEMENT ]]
    then
      NOT_EXIST_ELEMENT_RETURN
    else
      EXIST_ELEMENT_RETURN $ELEMENT
    fi
  # Conditional if the argument is s chemical symbol with first upercase character fallow Second lowercase character
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    ELEMENT=$($PSQL "SELECT elements.atomic_number AS atomic_number, elements.name AS name, elements.symbol AS symbol, types.type AS type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1';")
    if [[ -z $ELEMENT ]]
    then
      NOT_EXIST_ELEMENT_RETURN
    else
      EXIST_ELEMENT_RETURN $ELEMENT
    fi
  # Conditional if the argument is a chemical name
  else
    ELEMENT=$($PSQL "SELECT elements.atomic_number AS atomic_number, elements.name AS name, elements.symbol AS symbol, types.type AS type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.name = '$1';")
    if [[ -z $ELEMENT ]]
    then
      NOT_EXIST_ELEMENT_RETURN
    else
      EXIST_ELEMENT_RETURN $ELEMENT
    fi
  fi
else
   echo "Please provide an element as an argument."
fi
