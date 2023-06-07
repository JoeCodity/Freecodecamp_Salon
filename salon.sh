#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
#echo -e "\n ~~~ Salon appointment service ~~~\n"
MAIN_MENU(){
if [[ $1 ]]
then
echo "$1"

fi
echo -e "1) Cut"
echo -e "2) Color"
echo -e "3) Perm"
echo -e "4) Exit"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) APPOINT_SERVICE 'Cut' ;;
  2) APPOINT_SERVICE 'Color' ;;
  3) APPOINT_SERVICE 'Perm' ;;
  4) EXIT ;;
  *) MAIN_MENU ;;
esac
}

APPOINT_SERVICE(){
echo -e "\n You selected $1 please enter your phone number:"
read  CUSTOMER_PHONE
if [[ -z $CUSTOMER_PHONE ]]
then
MAIN_MENU "Invalid input"
fi
#check if customer is in list
CUSTOMER_ID=$($PSQL "Select customer_id from customers where phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_ID ]]
then
  echo -e "\n Please enter your name:"
  read CUSTOMER_NAME
  if [[ -z $CUSTOMER_NAME ]]
then
MAIN_MENU "Invalid input"
fi
RESULT_INSERT_NAME=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
CUSTOMER_ID=$($PSQL "Select customer_id from customers where phone = '$CUSTOMER_PHONE'")
else 
CUSTOMER_NAME=$($PSQL "Select name from customers where phone = '$CUSTOMER_PHONE'")
fi
  echo -e "\n Please enter your preferred time:"
  read SERVICE_TIME
if [[ -z $SERVICE_TIME ]]
then
MAIN_MENU "Invalid input"
fi

INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
if [[ $INSERT_APPOINTMENT='INSERT 0 1' ]]
then
echo "I have put you down for $1 at $SERVICE_TIME, $CUSTOMER_NAME."
else
echo 'Ooops something went wrong'
fi
}

EXIT(){
echo 'Thank you and goodbye'
}

MAIN_MENU



