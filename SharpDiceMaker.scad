//------------------------------------------
// Dnd Sharp Dice Renderer
//------------------------------------------

/* [Display Options] */

// ^ trims sharp vertices, but not the edges
cut_corners = false;
// ^ use Help > Font List, click to select a font and then click Copy to Clipboard
font = "Josefin Sans:style=SemiBold";
// ^ font percentage sizing scale
font_scale = 100;
// ^ font spacing for numbers greater than 9
font_two_digit_spacing = 100;
// ^ true to draw the numbers, false to make blank faces
draw_text = true;
// ^ depth of text extrusion in mm
extrude_depth = 2;
// ^ character to draw below 6 under 9 - needs to be bottom aligned
underscore_glyph = "…";

// Polyhedral dice sizing is currently rather haphazard. People often reference
// the Chessex set, but even those are arbitrary. The sizes below just come from a
// a set I rather like. :)

/* [Which Dice + Sizes] */

// ^ render one die at a time => use d100 for d%
which_die = "d20"; //  ["d4","d6","d8","d10","d100","d12","d20"]

// ^ D4 face height (mm) 24 => 21 tall
d4_face_height = 24; // 24 => 21 tall
// ^ D6 face height (mm) 16 => 16 tall
d6_face_height  = 16; // 16 => 16 tall
// ^ D8 face height (mm) 18 => 26 tall
d8_face_height  = 18; // 18 => 26 tall
// ^ D10/D% face height (mm) 15 => 26 tall
d10_face_height = 15; // 15 => 26 tall
// ^ D12 longest face height (mm) 11 => 20 tall
d12_face_height  = 11; // 11 => 20 tall
// ^ D20 face height (mm) 11 => 20 tall
d20_face_height  = 15; // 11 => 20 tall

/* [D20 SVGs] */

// ^ to replace a digit on your d20 with an svg, first slide to a number between 1 and 20
d20_svg_replace_digit = 0; // [0:20]
// ^ then, enter the path to the file:
d20_svg_file = "svg/scull_crossbones.svg";
// ^ helpful if the svg has an end that's wider than the other
d20_svg_rotation = 0;
// ^ percentage sizing scale
d20_svg_scale = 100;
// ^ for tweaking the placement, play with this value
d20_svg_offset = 0;

/* [Hidden] */

// shorten user variable to align in arrays
UND = underscore_glyph;
// true make 2d projection of the die shape
do_projection = false;
// true to rotate the die point down for printing
// false to rotate to longest length for projections
rotate_for_printing = true;

include <shapes.scad>
include <faces.scad>

module projectWhich(which="d4") {
  if (which=="d4") projection(cut = false) draw_d4(draw_text);
  if (which=="d6") projection(cut = false) draw_d6(draw_text);
  if (which=="d8") projection(cut = false) draw_d8(draw_text);
  if (which=="d10") projection(cut = false) draw_d10(draw_text);
  if (which=="d12") projection(cut = false) draw_d12(draw_text);
  if (which=="d20") projection(cut = false) draw_d20(draw_text);
}

module drawWhich(which="d4") {
  if (which=="d4") draw_d4(draw_text);
  if (which=="d6") draw_d6(draw_text);
  if (which=="d8") draw_d8(draw_text);
  if (which=="d10") draw_d10(draw_text);
  if (which=="d100") draw_d100(draw_text);
  if (which=="d12") draw_d12(draw_text);
  if (which=="d20") draw_d20(draw_text);
}

if (do_projection)
  projectWhich(which_die);
else
  drawWhich(which_die);

