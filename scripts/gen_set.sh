OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
PRESETS="./SharpDiceMaker.json"

gen_die() {
  echo
  echo $1.stl...
  $OPENSCAD -o ./dice/$1.stl -D "which_die=\"$1\"" -p $PRESETS  -P "sutro supports" SharpDiceMaker.scad
}

rm -rf ./dice
mkdir ./dice

clear
echo
echo Generating supported dice

gen_die d4
gen_die d4c
gen_die d6
gen_die d8
gen_die d10
gen_die d100
gen_die d12
gen_die d20

echo
echo Done
