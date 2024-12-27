#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

# global vars
SERVICE_ID_SELECTED="service_id"
NAME_OF_SERVICE="name of service"
CUSTOMER_PHONE="customer's phone number"
CUSTOMER_NAME="customer's name"
CUSTOMER_ID="id of customer"
SERVICE_TIME="time customer wants their service"

# main menu
MAIN_MENU() {

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
  read SERVICE_ID_SELECTED

  VALID_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  NAME_OF_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $VALID_SERVICE")

  # # formats service name by removing spaces
  # NAME_OF_SERVICE=$(echo $SERVCE | sed 's/ |/"/')

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    # send to main menu
    MAIN_MENU "Please enter a valid service."
  elif [[ -z $VALID_SERVICE ]]; then
    MAIN_MENU "I could not find that service. Try again."
  else
    # calls function to query and insert user information
    USER_INFORMATION
  fi

}

# query and input user information
USER_INFORMATION() {

  # conditional to print first argument
  if [[ $1 ]]; then
    echo -e "\n$1"
  else
    echo -e "\nWhat's your phone number?"
  fi

  # read phone number from user
  read CUSTOMER_PHONE

  # query phone number from database
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]; then
    # if query is empty, no matching phone number
    echo -e "\nI don't have a record for that phone number, what's your name?"

    # user inputs name
    read CUSTOMER_NAME

    INSERT_USER_INFORMATION=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    BOOK_TIME

  else

    BOOK_TIME
  fi

}

# create appointment
BOOK_TIME() {

  echo -e "\nWhat time would you like your $(echo $NAME_OF_SERVICE | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"

  read SERVICE_TIME

  # query customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $(echo $NAME_OF_SERVICE | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}

MAIN_MENU
