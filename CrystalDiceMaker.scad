//------------------------------------------
// Dnd Crystal Dice 3D Maker
//------------------------------------------

/* [Display Options] */

// ^ trims sharp vertices, but not the edges
cut_corners = false;
// ^ use Help > Font List > click > Copy to Clipboard
font = "Caslon Antique:style=Regular"; // ["Antraxja  Goth 1938:style=Regular","Boismen:style=Light","Cardosan:style=Regular","Caslon Antique:style=Regular","CaslonishFraxx:style=Regular","Celtic Garamond the 2nd:style=Regular","Demons and Darlings:style=Regular","Donree's Claws:style=Regular","Dumbledor 2:style=Regular","Dungeon:style=Regular","Dragon Fire:style=Regular","Fanjofey AH:style=Regular","First Order Condensed:style=Condensed","Grusskarten Gotisch:style=Regular","Hobbiton:style=Regular","Hobbiton Brushhand:style=Hobbiton brush","Huggles:style=Regular","Kabinett Fraktur:style=Regular","KG Lego House:style=Regular","Klarissa:style=Regular","Lycanthrope:style=Regular","Manuskript Gothisch:style=Regular","Midjungards:style=Italic","Night Mare:style=Regular","October Crow:style=Regular","Old London:style=Regular","PerryGothic:style=Regular","Poppl Fraktur CAT:style=Regular","Rane Insular:style=Regular","Redressed:style=Regular","RhymeChronicle1494:style=not included.","Austie Bost Simple Simon:style=Regular","Spooky Pumpkin regular:style=Regular","Tencele Latinwa:style=Regular","Unquiet Spirits:style=Regular","White Storm:style=Regular","XalTerion:style=Regular"]

// ^ whenever you're replacing a number with an icon
icon_font = ""; // ["axe for warrior:style=Regular","Evilz:style=Regular","ILL oCtoBer 98:style=Normal","Punkinhead:style=Regular","rpg\\-awesome:style=Regular"]

// ^ font percentage sizing scale
font_scale = 100;
// ^ font spacing for numbers greater than 9
horizontal_spacing = 1; // [0:0.1:1]
// ^ font spacing for numbers greater than 9
vertical_offset = 0; // [-5.0:0.1:5.0]
// ^ true to draw the numbers, false to make blank faces
draw_text = true;
// ^ depth of text extrusion in mm
extrude_depth = 1; // [0.5:0.1:2.0]Antraxja  Goth

/* [Which Dice + Sizes] */

// ^ render one die at a time => use d100 for d%
which_die = "d20"; //  ["d4","d6","d8","d10","d100","d12","d20"]

d4_height = 34;
d6_height  = 16;
d8_height  = 26;
d10_height = 30;
d12_height  = 23;
d20_height  = 28;

/* [D20 SVGs] */

// ^ to replace a digit on your d20 with an svg or text, first pick which digit:
d20_replace_digit = 1; // [0:20]

// ^ then, enter the text:
d20_text = "";

// ^ OR enter the path to the file:
d20_svg_file = "svg/scull_crossbones.svg";

// ^ helpful if the svg has an end that's wider than the other
d20_face_rotation = 0;

// ^ percentage sizing scale
d20_face_scale = 100;

// ^ for tweaking the placement, play with this value
d20_face_offset = 0.0; // [-10.0:0.05:3.0]

/* [Wall Supports] */

// ^ height in mm for wall supports (0 for none)
supports_height = 3; // [0:10]

// ^ check to have a wider base for your supports
supports_raft = true;

// ^ size in mm for wall supports connector
supports_connecting_width = 0.2; // [0.2:0.1:1]

/* [Normally Hidden] */
show_bounding_box = false;


// true to hollow out the die and cut in half
see_supports = false;

// true make 2d projection of the die shape
do_projection = false;

generate_base = false;

trim_underneath = true;

d10_angle = 120; // original: 132

d4_face_edge = d4_height * .35125;
d6_face_edge  = d6_height * 1;
d8_face_edge  = d8_height * .707;
d10_face_edge = d10_height * 0.5;
d12_face_edge  = d12_height * 0.5597;
d20_face_edge  = d20_height * 0.5062;

include <shapes.scad>
include <faces.scad>
include <fonts.scad>

module drawWhich(which="d4") {
  intersection() {
    if (which=="d4") draw_d4_crystal(d4_face_edge, supports_height, draw_text);
    if (which=="d6") draw_d6(d6_face_edge, supports_height, draw_text);
    if (which=="d8") draw_d8(d8_face_edge, supports_height, draw_text);
    if (which=="d10")  draw_d10(d10_face_edge, supports_height, false, draw_text);
    if (which=="d100") draw_d10(d10_face_edge, supports_height, true, draw_text);
    if (which=="d12") draw_d12(d12_face_edge, supports_height, draw_text);
    if (which=="d20") draw_d20(d20_face_edge, supports_height, draw_text);

    if (trim_underneath) // cuts off anything below z=0
      translate([0, 0, 50])
        cylinder(h=100, r1=100, r2=100, center = true);
  }
}

drawWhich(which_die);
  