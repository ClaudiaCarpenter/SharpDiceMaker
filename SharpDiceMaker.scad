include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
//////------------------------------------------
// Dnd Sharp Dice Renderer
//------------------------------------------

/* [Display Options] */

// ^ trims sharp vertices, but not the edges
cut_corners = false;
// ^ use Help > Font List > click > Copy to Clipboard
font = "Lato:style=Medium";

// ^ font percentage sizing scale
font_scale = 100;
// ^ true to draw the numbers, false to make blank faces
draw_text = true;
// ^ depth of text extrusion in mm
text_extrude_depth = 1;

/* [Which Dice + Sizes] */

// ^ render one die at a time => use d100 for d%
which_die = "round"; //  ["d4","d6","d8","d10","d100","d12","d20","round"]

height_d4 = 34;
height_d6  = 16;
height_d8  = 26;
height_d10 = 30;
d12_height  = 23;
height_d20  = 28;

/* [D20] */

d20_replace_digit = 1; // [0:20]
d20_svg_file = "svg/scull_crossbones.svg";
d20_face_rotation = 0;
d20_face_scale = 100;
d20_face_offset = 0.0; // [-10.0:0.1:10.0]

/* [Wall Supports] */
supports_height = 3; // [0:10]
// ^ height in mm for wall supports (0 for none)

/* [Hidden] */

// true to hollow out the die and cut in half
see_supports = false;

// true make 2d projection of the die shape
do_projection = false;

// true to rotate the die point down for printing
// false to rotate to longest length for projections
rotate_for_printing = true;

d10_angle = 120; // original: 132

d4_ratio = 2.85;
d6_ratio = 1;
d8_ratio = 1.4;
d10_ratio = 2;
d12_ratio = 1.8;
d20_ratio = 2;

d4_face_edge = height_d4 / 2.85;
d6_face_edge  = height_d6 / 1;
d8_face_edge  = height_d8 / 1.4;
d10_face_edge = height_d10 / 2;
d12_face_edge  = d12_height / 1.8;
d20_face_edge  = height_d20 / 2;

include <shapes.scad>
include <faces.scad>

use <fonts/numbers/Dungeon.ttf>
use <fonts/icons/Evilz.ttf>

module drawWhich(which="d4") {
  intersection() {
    if (which=="d4") draw_d4_crystal(d4_face_edge, supports_height, draw_text);
    if (which=="d6") draw_d6(d6_face_edge, supports_height, draw_text);
    if (which=="d8") draw_d8(d8_face_edge, supports_height, draw_text);
    if (which=="d10")  draw_d10(d10_face_edge, supports_height, false, draw_text);
    if (which=="d100") draw_d10(d10_face_edge, supports_height, true, draw_text);
    if (which=="d12") draw_d12(d12_face_edge, supports_height, draw_text);
    if (which=="d20") draw_d20(d20_face_edge, supports_height, draw_text);
    if (which=="round") {
ten = square(50);
cut = 5;
linear_extrude(height=14) {
  translate([25,25,0])text("C",size=30, valign="center", halign="center");
  translate([85,25,0])text("5",size=30, valign="center", halign="center");
  translate([85,85,0])text("3",size=30, valign="center", halign="center");
  translate([25,85,0])text("7",size=30, valign="center", halign="center");
}
linear_extrude(height=13) {
  polygon(round_corners(ten, cut=cut, $fn=96*4));
  translate([60,0,0])polygon(round_corners(ten,  method="smooth", cut=cut, $fn=96));
  translate([60,60,0])polygon(round_corners(ten, method="smooth", cut=cut, k=0.32, $fn=96));
  translate([0,60,0])polygon(round_corners(ten, method="smooth", cut=cut, k=0.7, $fn=96));
}      
    }
    // cut off anything below z=0
    translate([0, 0, 50])
      cylinder(h=100, r1=100, r2=100, center = true);
  }
}

drawWhich(which_die);
  