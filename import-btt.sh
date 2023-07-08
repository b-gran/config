mkdir -p ~/Library/Application\ Support/BetterTouchTool

echo "This operation will overwrite your BetterTouchTool configuration. Do you want to proceed?"
read choice
case "$choice" in
  y|Y ) ;;
  n|N ) echo "Exiting..."; exit 1;;
  * ) echo "Invalid input. Exiting..."; exit 1;;
esac

cp .btt/com.hegenberg.BetterTouchTool.plist ~/Library/Preferences/com.hegenberg.BetterTouchTool.plist
cp .btt/btt_data* ~/Library/Application\ Support/BetterTouchTool/
cp .btt/bttdata2 ~/Library/Application\ Support/BetterTouchTool/bttdata2
