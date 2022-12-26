OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
PRESETS="./CrystalDiceMaker.json"
DIR="./dice/$1"
NAME=""

gen_die() {
  printf "Rendering $DIR/$1.stl...\n"
  $OPENSCAD -o $DIR/$1.stl -D "which_die=\"$1\"" -p $PRESETS -P "$NAME" CrystalDiceMaker.scad
}

gen_base() {
  printf "Rendering $DIR/$1.svg...\n"
  $OPENSCAD -o $DIR/$1.svg -D "which_die=\"$1\"" -p $PRESETS -P "$NAME" CrystalDiceMaker.scad
}

print_error() {
  RED='\033[1;31m'
  NC='\033[0m' # No Color
  printf "\n${RED}=> $1${NC}\n"
}

show_syntax() {
  printf "\nThis script renders a set of sharp-edged crystal DND dice using OpenSCAD.\n"
  printf "\nSyntax: ./scripts/make_dice.sh \"name\" [file.json]\n"
  printf "\n   • \"name\" is the preset stanza name of an OpenSCAD json config file (REQUIRED)\n"
  printf "   • \"file.json\" is the config file to use (optional - default: \"$PRESETS\")\n\n"
}

check_args() {
  if [ $# -eq 0 ] || [ $1 = "-h" ] || [ $1 = "-H" ] || [ $1 = "/h" ] || [ $1 = "/H" ]; then
      show_syntax
      exit
  fi

  if [ "$2" ] && [[ -f "$2" ]]; then
    PRESETS=$2
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
printf "\nYour dice are being generated in \"$DIR\" using the preset \"$NAME\" from $PRESETS\n\n"
start_time=$(date +%s)

mkdir ./dice 2> /dev/null
mkdir $DIR 2> /dev/null

# echo
# echo Generating supported dice

# gen_die d4 $1
gen_die d4c $1
gen_die d6 $1
gen_die d8 $1
# gen_die d10 $1
gen_die d10c $1
# gen_die d100 $1
gen_die d100c $1
gen_die d12 $1
gen_die d20 $1
gen_die d20c $1

end_time=$(date +%s)
elapsed=$(( (end_time - start_time) ))
printf "\nDone in $elapsed seconds.\n\n"
