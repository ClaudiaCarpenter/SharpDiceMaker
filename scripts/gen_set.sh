OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
PRESETS="./SharpDiceMaker.json"
DIR="./dice"
NAME=""

gen_die() {
  printf "$OPENSCAD -o $DIR/$1.stl -D \"which_die=\"$1\"\" -p $PRESETS  -P \"$NAME\" \"$PRESETS\"\n"
  $OPENSCAD -o $DIR/$1.stl -D "which_die=\"$1\"" -p $PRESETS  -P "$NAME" "$PRESETS"
}

print_error() {
  RED='\033[1;31m'
  NC='\033[0m' # No Color
  printf "\n${RED}=> $1${NC}\n"
}

show_syntax() {
  printf "\nThis script renders a set of sharp DND dice using OpenSCAD.\n"
  printf "\nSyntax: ./scripts/gen_set.sh \"name\" [dir] [file.json]\n"
  printf "\n   • \"name\" is the preset stanza name of an OpenSCAD json config file (REQUIRED)\n"
  printf "   • \"dir\" is the directory to put the rendered dice in (optional - default: \"$DIR\")\n"
  printf "   • \"file.json\" is the config file to use (optional - default: \"$PRESETS\")\n\n"
}

check_args() {
  if [ $# -eq 0 ] || [ $1 = "-h" ] || [ $1 = "-H" ] || [ $1 = "/h" ] || [ $1 = "/H" ]; then
      show_syntax
      exit
  fi

  if [ "$2" ]; then
    DIR=$2
  fi

  if [ "$3" ] && [[ -f "$3" ]]; then
    PRESETS=$3
  fi

  PRESET=$(grep $1 $PRESETS)
  if [ -z "$PRESET" ]; then
      print_error "Preset \"$1\" not found in $PRESETS"
      show_syntax
      exit
  fi

  NAME=$1
}

check_args $1 $2

clear
printf "\nPlease at bit wait while your dice are generated in \"$DIR\" using the preset \"$NAME\" from $PRESETS...\n"
start_time=$(date +%s)

mkdir $DIR > /dev/null

# echo
# echo Generating supported dice

gen_die d4 $1
# gen_die d4c $1
# gen_die d6 $1
# gen_die d8 $1
# gen_die d10 $1
# gen_die d100 $1
# gen_die d12 $1
# gen_die d20 $1

# END_TIME=date +%s
# printf "\nEnding at $END_TIME"

end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
printf "\nDone in $elapsed seconds.\n\n"
