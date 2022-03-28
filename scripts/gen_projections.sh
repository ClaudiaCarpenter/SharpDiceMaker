rm -rf ./projections
mkdir ./projections
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./projections/d4.svg -D 'do_projection=true' -D 'which_die="d4"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./projections/d6.svg -D 'do_projection=true' -D 'which_die="d6"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./projections/d8.svg -D 'do_projection=true' -D 'which_die="d8"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./projections/d10.svg -D 'do_projection=true' -D 'which_die="d10"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./projections/d12.svg -D 'do_projection=true' -D 'which_die="d12"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./projections/d20.svg -D 'do_projection=true' -D 'which_die="d20"' -D 'draw_text=false' SharpDiceMaker.scad
