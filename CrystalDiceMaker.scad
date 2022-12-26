//////------------------------------------------
// Dnd Crystal Dice 3D Maker
//------------------------------------------

/* [Which Die] */

// ^ render one die at a time => use d100 for d%
which_die = "d20"; //  ["d4","d4c","d6","d8","d10","d10c","d100","d100c","d12","d20","d20c"]

/* [Text Options] */

// ^ use Help > Font List > click > Copy to Clipboard
font = "petrock-thinner"; // ["petrock-thinner","PetRock\\-Dice:style=Regular","Kingthings Petrock:style=Regular", "Antraxja  Goth 1938:style=Regular","Amita:style=Regular","Argos MF:style=Regular","Bloody Stump:style=Regular","Boismen:style=Light","Cardosan:style=Regular","Caslon Antique:style=Regular","C[0, 180, 60]aslonishFraxx:style=Regular","Celtic Garamond the 2nd:style=Regular","Demons and Darlings:style=Regular","Linotype Didot:style=Bold","Dice\\-Digits:style=Regular", "Donree's Claws:style=Regular","Dumbledor 2:style=Regular","Dunbar Tall:style=Regular","Dungeon:style=Regular","Dice\\-Digits:style=Regular","Dragon Fire:style=Regular","Fanjofey AH:style=Regular","First Order Condensed:style=Condensed","Gothic\\-Numbers:style=Regular","Grusskarten Gotisch:style=Regular","Hobbiton:style=Regular","Hobbiton Brushhand:style=Hobbiton brush","Huggles:style=Regular","Kabinett Fraktur:style=Regular","KG Lego House:style=Regular","Klarissa:style=Regular","Lycanthrope:style=Regular","Manuskript Gothisch:style=Regular","Midjungards:style=Italic","Night Mare:style=Regular","October Crow:style=Regular","Old London:style=Regular","PerryGothic:style=Regular","Poppl Fraktur CAT:style=Regular","Pretty\\-Numbers:style=Regular","Rane Insular:style=Regular","Redressed:style=Regular","RhymeChronicle1494:style=not included.","Austie Bost Simple Simon:style=Regular","Spooky Pumpkin regular:style=Regular","Spooky Skeleton:style=Regular","Tencele Latinwa:style=Regular","Unquiet Spirits:style=Regular","White Storm:style=Regular","XalTerion:style=Regular"]
// ^ true to draw the numbers, false to make blank faces
draw_text = true;
// ^ tweak until the 4 looks right
offset_four_by = 0; // [-5.0:0.1:5.0]
// ^ depth of text extrusion in mm
extrude_depth = 1.6; // [0.5:0.1:2.0]
// ^ spacing multiplier for numbers with periods
period_spacing = 1; // [-2.0:0.1:2.0]
// ^ trims sharp vertices, but not the edges
cut_corners = false;

/* [Dice Sizing] */

d4_height = 21; // [5:0.1:100]
d4_font_scale = 100;
d4_vertical_offset = 0; // [-5.0:0.1:5.0]
d4_extrude_depth = 1.6;
d4c_height = 34; // [5:0.1:100]
d4c_font_scale = 100; 
d4c_vertical_offset = 0; // [-5.0:0.1:5.0]
d6_height  = 16; // [5:0.1:100]
d6_vertical_offset = 0; // [-5.0:0.1:5.0]
d6_font_scale = 100; 
d8_height  = 26; // [5:0.1:100]
d8_font_scale = 100; 
d8_vertical_offset = 0; // [-5.0:0.1:5.0]
d10_height = 23; // [5:0.1:100]
d10_font_scale = 100; 
d10_vertical_offset = 0; // [-5.0:0.1:5.0]
d10c_height = 30; // [5:0.1:100]
d10c_font_scale = 100; 
d10c_vertical_offset = 0; // [-5.0:0.1:5.0]
d12_height = 23; // [5:0.1:100]
d12_font_scale = 100; 
d12_vertical_offset = 0; // [-5.0:0.1:5.0]
d20_height = 28; // [5:0.1:100]
d20_font_scale = 100;
d20_vertical_offset = 0; // [-5.0:0.1:5.0]
d20c_height = 38; // [5:0.1:100]
d20c_font_scale = 100;
d20c_vertical_offset = 0; // [-5.0:0.1:5.0]

/* [D20] */
  
d20_face_scale = 90;
d20_face_rotation = 0;
d20_face_offset = 0.0; // [-10.0:0.05:3.0]
d20_replace_digit = 0; // [0:20]
d20_svg_file = "svg/scull_crossbones.svg";

/* [Wall Supports] */

// ^ height in mm for wall supports (0 for none)
supports_height = 3; // [0:15]
// ^ render the supports, despite the height
draw_supports = true;
// ^ check to have a wider base for your supports
supports_raft = true;
// ^ height in mm
supports_raft_height = 1;
// ^ size in mm for wall supports connector
supports_connecting_width = 0.3; // [0.2:0.1:1]

make_face_text_deeper = false;

/* [Normally Hidden] */
show_bounding_box = false;

// true to hollow out the die and cut in half
see_supports = false;

generate_base = false;
generate_base_shape = false;
add_sprue_hole = true;
sprue_on_high = true;
sprue_diameter = 2;
skip_high_number = false;
skip_low_number = false;
skip_sprue_numbers = true;

trim_underneath = true;

include <shapes.scad>
include <util.scad>
include <faces.scad>
include <fonts.scad>

d4_face_edge = triangle_edge(d4_height);
d4c_face_edge = d4c_height;
d6_face_edge  = d6_height * 1;
d8_face_edge  = d8_height * .707;
d10_face_edge = d10_height * 0.68;
d10c_face_edge = d10c_height * 0.5;
d12_face_edge  = d12_height * 0.5597;
d20_face_edge  = d20_height * 0.5062;
d20c_face_edge  = d20c_height * 0.5062;

module drawWhich(which="d4") {
  echo(supports_height);
 difference() {
    if (which=="d4")    draw_d4(d4_face_edge,     d4_font_scale,    d4_vertical_offset, false);
    if (which=="d4c")   draw_d4(d4c_face_edge,    d4c_font_scale,   d4c_vertical_offset, true);
    if (which=="d6")    draw_d6(d6_face_edge,     d6_font_scale,    d6_vertical_offset);
    if (which=="d8")    draw_d8(d8_face_edge,     d8_font_scale,    d8_vertical_offset);
    if (which=="d10")   draw_d10(d10_face_edge,   d10_font_scale,   d10_vertical_offset,  false, false);
    if (which=="d10c")  draw_d10(d10c_face_edge,  d10c_font_scale,  d10c_vertical_offset, false, true);
    if (which=="d100")  draw_d10(d10_face_edge,   d10_font_scale,   d10_vertical_offset,  true, false);
    if (which=="d100c") draw_d10(d10c_face_edge,  d10c_font_scale,  d10c_vertical_offset, true, true);
    if (which=="d12")   draw_d12(d12_face_edge,   d12_font_scale,   d12_vertical_offset);
    if (which=="d20")   draw_d20(d20_face_edge,   d20_font_scale,   d20_vertical_offset);
    if (which=="d20c")   draw_d20(d20c_face_edge,   d20c_font_scale,   d20c_vertical_offset);

    if (trim_underneath) // cuts off anything below z=0
      translate([0, 0, -5])
        cylinder(h=10, r1=d20c_face_edge, r2=d20c_face_edge, center = true);
  }
}

drawWhich(which_die);
  