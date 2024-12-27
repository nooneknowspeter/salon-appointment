#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

BOOKING() {

  # conditional to print first argument
  if [[ $1 ]]; then
    echo -e "\n$1"
  else
    echo "Welcome to My Salon, how can I help you?"
  fi

  # query services from database
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  # displaying services
  echo "$AVAILABLE_SERVICES" | while read ID BAR SERVICE; do
    echo "$ID) $SERVICE"
  done

  # user input for selected service
  read SELECTED_SERVICE

  VALID_SERVICE=$($PSQL "SELECT service_id, name FROM services where service_id=$SELECTED_SERVICE")

  if [[ ! $SELECTED_SERVICE =~ ^[0-9]+$ ]]; then
    # send to main menu
    BOOKING "Please enter a valid service."
  elif [[ -z $VALID_SERVICE ]]; then
    BOOKING "I could not find that service. Try again."
  else
    echo "What's your phone number?"

    read PHONE_NUMBER
  fi

}

BOOKING
