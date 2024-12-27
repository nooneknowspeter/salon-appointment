#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

# global vars
SERVICE_ID_SELECTED="service_id"
CUSTOMER_PHONE="customer's phone number"
CUSTOMER_NAME="customer's name"
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

  VALID_SERVICE=$($PSQL "SELECT service_id, name FROM services where service_id=$SERVICE_ID_SELECTED")

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    # send to main menu
    MAIN_MENU "Please enter a valid service."
  elif [[ -z $VALID_SERVICE ]]; then
    MAIN_MENU "I could not find that service. Try again."
  else
    # calls function to query and insert user information
    BOOKING
  fi

}

# query and input user information
BOOKING() {

  # conditional to print first argument
  if [[ $1 ]]; then
    echo -e "\n$1"
  else
    echo -e "\nWhat's your phone number?"
  fi

  # read phone number from user
  read CUSTOMER_PHONE

  # query phone number from database
  QUERY_PHONE_NUMBER=$($PSQL "SELECT phone, name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $QUERY_PHONE_NUMBER ]]; then
    # if query is empty, no matching phone number
    echo -e "\nI don't have a record for that phone number, what's your name?"

    # user inputs name
    read CUSTOMER_NAME

    INSERT_USER_INFORMATION=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    echo "What time would you like your cut, $CUSTOMER_NAME"

    read SERVICE_TIME

  else
    echo "What time would you like your _, $CUSTOMER_NAME"
  fi

}

MAIN_MENU
