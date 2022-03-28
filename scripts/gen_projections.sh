rm -rf ../projections
mkdir ../projections
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ../projections/d4.svg -D 'do_projection=true' -D 'which_die="d4"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ../projections/d6.svg -D 'do_projection=true' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ../projections/d8.svg -D 'do_projection=true' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ../projections/d10.svg -D 'do_projection=true' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ../projections/d12.svg -D 'do_projection=true' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ../projections/d20.svg -D 'do_projection=true' -D 'draw_text=false' SharpDiceMaker.scad
