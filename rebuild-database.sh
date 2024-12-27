#!/bin/bash

DATABASE(){

  echo -e "\nenter \n1 for rebuild \nor \n2 for dumping"

  read INPUT

  if [[ $INPUT = 1 ]] 
  then
    echo "1"

    echo -e "\nrebuilding database\n"

    sleep 2

    psql -U postgres < salon.sql
  elif [[ $INPUT = 2 ]]
  then
    echo "2"

    echo -e "\ndumping database\n"

    sleep 2

    pg_dump -cC --inserts -U freecodecamp salon > salon.sql
  else
    echo "not a valid option"

    DATABASE
  fi
  

}

DATABASE
