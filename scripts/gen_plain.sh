OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
PRESETS="./SharpDiceMaker.json"

gen_die() {
  echo
  echo "$1p.stl..."
  $OPENSCAD -o ./dice_plain/$1p.stl -D "which_die=\"$1\"" -p $PRESETS  -P "sutro plain" SharpDiceMaker.scad
}

rm -rf ./dice_plain
mkdir ./dice_plain

clear
echo
echo Generating plain dice

gen_die d4
gen_die d4c
gen_die d6
gen_die d8
gen_die d10
gen_die d12
gen_die d20

echo
echo Done

