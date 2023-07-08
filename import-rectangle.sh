mkdir -p ~/Library/Preferences/com.knollsoft.Rectangle.plist

echo "This operation will overwrite your Rectangle configuration. Do you want to proceed?"
read choice
case "$choice" in
  y|Y ) ;;
  n|N ) echo "Exiting..."; exit 1;;
  * ) echo "Invalid input. Exiting..."; exit 1;;
esac

cp .rectangle/com.knollsoft.Rectangle.plist ~/Library/Preferences/com.knollsoft.Rectangle.plist
