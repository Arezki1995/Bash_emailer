
#!/bin/bash




temp=$(mktemp -t temp.XXXXXX)
temp2=$(mktemp -t temp2.XXXXXX)
SMTPADDRESS="smtp.googlemail.com:587"

function installPackages(){
	echo "Installing required packages ..."
	sudo apt-get install sendemail libio-socket-ssl-perl libnet-ssleay-perl		
}

#------------------------------------------------------------------------------------------------
function splash(){
dialog --backtitle "BASHMAIL" --title "BASHMAIL - Arezki 2018" --msgbox "\nWelcome to Bash mail !\n\nThis program allows you to send email from your Gmail account to your favorite destination." 0 0
}

#------------------------------------------------------------------------------------------------
function getSubject(){
dialog --backtitle "BASHMAIL" --inputbox "Email subject:" 10 80 2> $temp
	if [ $? == 1 ]; then
	clear
	exit
fi
SUBJECT=$(cat $temp)
}
#------------------------------------------------------------------------------------------------
function getBody(){
dialog --backtitle "BASHMAIL" --title "Email body:" --editbox body.tmp 100 100 2> body.tmp
	if [ $? == 1 ]; then
	clear
	exit
fi
MESSAGE=$(cat body.tmp)

}

#------------------------------------------------------------------------------------------------
function getUserEmail(){
while [ true ]; do 
dialog --backtitle "BASHMAIL" --inputbox "ENTER YOUR GMAIL ADDRESS:" 10 50 2> $temp
	if [ $? == 1 ]; then
	clear
	exit
fi

if cat $temp | grep "@gmail.com"; then
	break
else
	dialog --backtitle "BASHMAIL" --title "INVALID GMAIL ADDRESS" --msgbox "\nTry again with this format:\n\n   <.............>@gmail.com" 8 35
fi

done
SMTPFROM=$(cat $temp)

}

#------------------------------------------------------------------------------------------------
function getDestEmail(){
while [ true ]; do 
dialog --backtitle "BASHMAIL" --inputbox "ENTER DESTINATION ADRESS:" 10 50 2> $temp
	if [ $? == 1 ]; then
	clear
	exit
fi

if cat $temp | grep "@"; then
	break
else
	dialog --backtitle "BASHMAIL" --title "INVALID EMAIL ADDRESS" --msgbox "\nTry again with this format:\n\n   <.............>@<.........>" 8 35
fi

done
SMTPTO=$(cat $temp)
}


#------------------------------------------------------------------------------------------------
function getPassword(){
dialog --backtitle "BASHMAIL" --insecure --passwordbox "Authentication to your Gmail account. Enter password:" 8 70 2> $temp
PASSWORD=$(cat $temp)

}
#------------------------------------------------------------------------------------------------

function getReview(){
echo -e "

from:\t$SMTPFROM
to:\t$SMTPTO
\n

Subject: $SUBJECT

Messsage:
$MESSAGE
" > $temp

dialog --title "REVIEW" --ok-label "SEND" --extra-button --extra-label "EDIT" --textbox $temp 120 120 
if [ $? == 3 ]; then
	getBody
	getReview
fi

}

#------------------------------------------------------------------------------------------------
function menu(){
	dialog --menu "Main menu" 0 0 3 1 "Start" 2 "Install Required Packages" 3 "Quit" 2> $temp 
	selected=$(cat $temp)	
	case selected in
	1)
		return
		break;;		
	2)
		installPackages
		return		
		break;;
	3)
		clear
		exit
		break;;
	*)
		echo "NOT AN OPTION"
	esac
}
##################################################################################################
# EXECUTION FLOW
splash
menu
getSubject
getBody
getUserEmail
getDestEmail
getPassword
getReview

#sendEmail -f $SMTPFROM -t $SMTPTO -u $SUBJECT -m $MESSAGE -s $SMTPADDRESS -xu $USERNAME -xp $PASSWORD -o tls=yes






