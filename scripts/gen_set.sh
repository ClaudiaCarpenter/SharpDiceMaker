rm -rf ./dice
mkdir ./dice
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice/d4.stl -D 'which_die="d4"' -D 'draw_text=true' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice/d6.stl -D 'which_die="d6"' -D 'draw_text=true' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice/d8.stl -D 'which_die="d8"' -D 'draw_text=true' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice/d10.stl -D 'which_die="d10"' -D 'draw_text=true' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice/d100.stl -D 'which_die="d100"' -D 'draw_text=true' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice/d12.stl -D 'which_die="d12"' -D 'draw_text=true' SharpDiceMaker.scad
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o ./dice/d20.stl -D 'which_die="d20"' -D 'draw_text=true' \
    -D 'd20_svg_replace_digit = 20' -D 'd20_svg_file = "svg/dragon.svg"' \
    -D 'd20_svg_rotation = 180' -D 'd20_svg_scale=110' -D 'd20_svg_offset = 1' SharpDiceMaker.scad