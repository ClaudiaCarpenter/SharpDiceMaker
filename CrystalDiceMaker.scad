//------------------------------------------
// Dnd Crystal Dice 3D Maker
//------------------------------------------

/* [Options] */

// ^ render one die at a time => use d100 for d%
which_die = "d4c"; //  ["d2","d4","d4c","d6","d8","d10","d10c","d100","d100c","d12","d20","d20c"]

// ^ true to draw the numbers, false to make blank faces
draw_text = true;

// ^ render the supports, despite the height
draw_supports = true;

// ^ use Help > Font List > click > Copy to Clipboard 
font = "petrock\\-thinner:style=Regular"; //"Kingthings Petrock:style=Regular"; // "black\\-majik:style=Regular"; // ["black\\-majik:style=Regular", "Darksame:style=Regular", "Waltograph:style=Regular", "Hairy Monster Solid:style=Solid", "Black Magic:style=Regular", "Creepster:style=Regular", "petrock-thinner","PetRock\\-Dice:style=Regular","Kingthings Petrock:style=Regular", "Antraxja  Goth 1938:style=Regular","Amita:style=Regular","Argos MF:style=Regular","Bloody Stump:style=Regular","Boismen:style=Light","Cardosan:style=Regular","Caslon Antique:style=Regular","C[0, 180, 60]aslonishFraxx:style=Regular","Celtic Garamond the 2nd:style=Regular","Demons and Darlings:style=Regular","Linotype Didot:style=Bold","Dice\\-Digits:style=Regular", "Donree's Claws:style=Regular","Dumbledor 2:style=Regular","Dunbar Tall:style=Regular","Dungeon:style=Regular","Dice\\-Digits:style=Regular","Dragon Fire:style=Regular","Fanjofey AH:style=Regular","First Order Condensed:style=Condensed","Gothic\\-Numbers:style=Regular","Grusskarten Gotisch:style=Regular","Hobbiton:style=Regular","Hobbiton Brushhand:style=Hobbiton brush","Huggles:style=Regular","Kabinett Fraktur:style=Regular","KG Lego House:style=Regular","Klarissa:style=Regular","Lycanthrope:style=Regular","Manuskript Gothisch:style=Regular","Midjungards:style=Italic","Night Mare:style=Regular","October Crow:style=Regular","Old London:style=Regular","PerryGothic:style=Regular","Poppl Fraktur CAT:style=Regular","Pretty\\-Numbers:style=Regular","Rane Insular:style=Regular","Redressed:style=Regular","RhymeChronicle1494:style=not included.","Austie Bost Simple Simon:style=Regular","Spooky Pumpkin regular:style=Regular","Spooky Skeleton:style=Regular","Tencele Latinwa:style=Regular","Unquiet Spirits:style=Regular","White Storm:style=Regular","XalTerion:style=Regular"]

height_d2 = 25;
height_d4 = 21;
height_d4c = 34; 
height_d6  = 16;
height_d8  = 26;
height_d10 = 23;
height_d10c = 30;
d12_height = 23;
height_d20 = 28;
height_d20c = 38;

d4_font_scale = 100;
d4c_font_scale = 100; 
d6_font_scale = 100; 
d8_font_scale = 100; 
d10_font_scale = 100; 
d10c_font_scale = 100; 
d12_font_scale = 100; 
d20_font_scale = 100;
d20c_font_scale = 100;

/* [Other Options] */


font_face_scale = 65;

d2_font_scale = 100;
d2_vertical_offset = 0;
d4_vertical_offset = 0;
d4_extrude_depth = 0.8;
d4c_vertical_offset = 0;
d6_vertical_offset = 0;
d8_vertical_offset = 0;
d10_vertical_offset = 0;
d10c_vertical_offset = 0;
d100c_vertical_offset = 0;
d12_vertical_offset = 0;
d20_vertical_offset = 0;
d20c_vertical_offset = 0;


rotate_text=false;

point_down = false;
supports_only = false;

//// ^ depth of text extrusion in mm
extrude_depth = 0.8; // [0.00:0.01:2.00]
extrude_quality = 4;

// ^ spacing multiplier for numbers with periods
period_spacing = 1; // [-2.0:0.1:2.0]
// ^ trims sharp vertices, but not the edges
cut_corners = false;
double_digit_spacing_20 = 1.1;
double_digit_spacing = 1.2;

// ^ height in mm for wall supports (0 for none)
supports_height = 3; // [0:15]
// ^ size in mm for wall supports connector
supports_connecting_width = 0.3; // [0.2:0.1:1]

make_face_text_deeper = false;


/* [Hidden] */

svg_path = ""; // "/Users/claudiacarpenter/Dev/SharpDiceMaker/dice/motw dice/svg";
svg_path_offset = 0.6;
svg_overlay = "";
svg_overlay_offset=0;

add_high_number_border=false;

// ^ tweak until the 4 looks right
offset_four_by = 0; // [-5.0:0.1:5.0]
d2_1_text = "high";
d2_2_text = "low";
d2_num_sides = 8;
d2_thickness = 4;


d20_face_scale = 90;
d20_face_rotation = 0;
d20_face_offset = 0.0; // [-10.0:0.05:3.0]
d20_replace_digit = 0; // [0:20]
d20_svg_file = "svg/scull_crossbones.svg";

d6_is_fate = false;


// ^ check to have a wider base for your supports
supports_raft = true;
// ^ height in mm
supports_raft_height = 1;

show_bounding_box = false;

// true to hollow out the die and cut in half
see_supports = false;

generate_base = false;
generate_base_shape = false;
add_sprue_hole = false;
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

finishing = .15;
d4_face_edge = triangle_edge(height_d4) + finishing;
d4c_face_edge = height_d4c + finishing;
d6_face_edge  = (height_d6 + finishing) * 1;
d8_face_edge  = (height_d8 + finishing) * .707;
d10_face_edge = (height_d10 + finishing) * 0.68;
d10c_face_edge = (height_d10c + finishing) * 0.5;
d12_face_edge  = (d12_height + finishing) * 0.5597;
d20_face_edge  = (height_d20 + finishing) * 0.5062;
d20c_face_edge  = (height_d20c + finishing) * 0.5062;

font_sizing_pct = font_face_scale / 100;

module drawWhich(which="d4") {
 difference() {
    if (which=="d2")    draw_d2(height_d2 + finishing,     d2_font_scale,    d2_vertical_offset);
    if (which=="d4")    draw_d4(d4_face_edge,     d4_font_scale * font_sizing_pct,    d4_vertical_offset, false);
    if (which=="d4c")   draw_d4(d4c_face_edge,    d4c_font_scale * font_sizing_pct,   d4c_vertical_offset, true);
    if (which=="d6")    draw_d6(d6_face_edge,     d6_font_scale * font_sizing_pct,    d6_vertical_offset);
    if (which=="d8")    draw_d8(d8_face_edge,     d8_font_scale * font_sizing_pct,    d8_vertical_offset);
    if (which=="d10")   draw_d10(d10_face_edge,   d10_font_scale * font_sizing_pct,   d10_vertical_offset,  false, false);
    if (which=="d10c")  draw_d10(d10c_face_edge,  d10c_font_scale * font_sizing_pct,  d10c_vertical_offset, false, true);
    if (which=="d100")  draw_d10(d10_face_edge,   d10_font_scale * font_sizing_pct,   d10_vertical_offset,  true, false);
    if (which=="d100c") draw_d10(d10c_face_edge,  d10c_font_scale * font_sizing_pct,  d100c_vertical_offset, true, true);
    if (which=="d12")   draw_d12(d12_face_edge,   d12_font_scale * font_sizing_pct,   d12_vertical_offset);
    if (which=="d20")   draw_d20(d20_face_edge,   d20_font_scale * font_sizing_pct,   d20_vertical_offset);
    if (which=="d20c")   draw_d20(d20c_face_edge,   d20c_font_scale * font_sizing_pct,   d20c_vertical_offset);

    if (trim_underneath) // cuts off anything below z=0
      translate([0, 0, -5])
        cylinder(h=10, r1=d20c_face_edge, r2=d20c_face_edge, center = true);
  }
}

drawWhich(which_die);
  