#!/bin/bash

# Vérifier si un argument est fourni
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  # Connexion à la base de données PostgreSQL (modifie les paramètres si nécessaire)
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  # Vérification de l'argument : peut être un atomic_number, un symbole ou un nom
  ELEMENT=$1
  if [[ $ELEMENT =~ ^[0-9]+$ ]]; then
    QUERY="SELECT * FROM elements 
    JOIN properties USING(atomic_number)
    JOIN types USING(type_id)
    WHERE atomic_number=$ELEMENT;"
  else
    QUERY="SELECT * FROM elements
    JOIN properties USING(atomic_number)
    JOIN types USING(type_id)
    WHERE symbol='$ELEMENT' OR name='$ELEMENT';"
  fi

  # Exécuter la requête SQL
  RESULT=$($PSQL "$QUERY")

  # Si aucun élément n'est trouvé
  if [[ -z $RESULT ]]; then
    echo "I could not find that element in the database."
  else
    # Extraire les informations du résultat
    echo "$RESULT" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      # Afficher les informations de l'élément
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi