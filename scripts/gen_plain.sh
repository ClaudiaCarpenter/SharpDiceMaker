rmdir -rf ./dice_plain
mkdir ./dice_plain
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice_plain/d4p.stl -D 'which_die="d4"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice_plain/d6p.stl -D 'which_die="d6"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice_plain/d8p.stl -D 'which_die="d8"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice_plain/d10p.stl -D 'which_die="d10"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice_plain/d12p.stl -D 'which_die="d12"' -D 'draw_text=false' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice_plain/d20p.stl -D 'which_die="d20"' -D 'draw_text=false' SharpDiceMaker.scad
