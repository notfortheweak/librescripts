#check execution policy, set to unrestricted if not already set to allow script execution   
#Check to see if PSGallery is installed and if not install it.
#Check to see if PSGallery is set as a trusted repository, set it to trusted if not already set.
#Check to see if PowershellGet is installed, install if not installed.
#Check to see if PackageManagement is installed, install if not installed.
#check to see if ExchangeOnlineManagement is installed, install if not installed.
#Connect to Exchange Online, prompt for credentials if not already connected.
#Get all mail rules including hidden for a user which is prompted for, display the rules inlcluding their creation date& time, the rule details, and the rule's enabled status.
#Export the Exchange Online mail rules to a CSV file, the file name should include the user's name and the date of export.
#Anticipate end user wanting to delete all recently created mail rules within the last 72 hours and provide an option to do so, if the user opts to delete the recently created mail rules, delete all mail rules created within the last 72 hours and display the names of the deleted rules.