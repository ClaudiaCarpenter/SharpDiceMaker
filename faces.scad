//------------------------------------------------------------------------------------
//                                     Utils
//------------------------------------------------------------------------------------

function calc_spacing(digits) = len(digits) > 1 ? font_two_digit_spacing / 100 : 1;

module extrude_text(some_text, height, multiplier) {
  translate([len(some_text) > 1 ? -(100 - font_two_digit_spacing) / 100: 0, 0, -extrude_depth + 1])
    linear_extrude(height = extrude_depth + 1)
      text(some_text, size = height * multiplier * font_scale / 100, spacing = calc_spacing(some_text), valign="center", halign="center", font=font);
}


module render_svg(svg_file, svg_rotation, svg_scale, svg_offset) {
  translate([0, svg_offset, -extrude_depth + 1])
    rotate([0, 0, svg_rotation])
      scale([svg_scale, svg_scale, 1])
        linear_extrude(height = extrude_depth + 1)
          import(svg_file, center = true);
}

//------------------------------------------------------------------------------------
//                                       D4
//------------------------------------------------------------------------------------

module draw_d4(face_edge, support_height, do_draw_text) {
  die_height = triangle_height(face_edge);
  z_translation = 1.4141035 * die_height / 2 + support_height;
  point_down_if_printing = rotate_for_printing ? [0, 180, 60] : [0, 0, 210];
  
  translate([0, 0, z_translation])
    rotate(point_down_if_printing)
      difference() {
        intersection() {
          tetrahedron(face_edge, see_supports);
          
          if (cut_corners)
            rotate([0, 180, 0])
              tetrahedron(face_edge * 3 * 0.85);
        }
        
        if (do_draw_text)
          draw_d4_text(face_edge);
      }

  if (support_height > 0) {
    width = face_edge;
    height = triangle_height(face_edge) * .95;
    render_supports(width, height, support_height, 3);
  }
}

module draw_d4_text(height) {
  digits = ["1", "2", "3", 
            "4", "3", "2", 
            "4", "2", "1", 
            "4", "1", "3"];

  height_multiplier = 0.24;
  text_depth = 0.6;
  text_push = 0.26;
  
  rotate([180, 0, 0])
    translate([0, 0, 0.2 * height - text_depth])
      for (i = [0:2]) { 
        rotate([0, 0, 120 * i])
          translate([text_push * height, 0, 0])
            rotate([0, 0, -90])
              extrude_text(digits[i], height, height_multiplier);
      }

      for (j = [0:2]) { 
        rotate([0, -70.5288, j * 120])
          translate([0, 0, 0.2 * height - text_depth])
            for (i = [0:2]) {
              rotate([0, 0, 120 * i])
                translate([text_push * height, 0, 0])
                  rotate([0, 0, -90])
                    extrude_text(digits[(j + 1) * 3 + i], height, height_multiplier);
            }
      }
}

//------------------------------------------------------------------------------------
//                                      D4C
//------------------------------------------------------------------------------------

include <BOSL2/std.scad>
include <BOSL2/shapes.scad>
include <BOSL2/polyhedra.scad>

module draw_d4_crystal(face_edge, support_height, do_draw_text) {
  d4c_body_length = 1.25 * face_edge;
  end_height = face_edge / 1.25;
  die_height = d4c_body_length + end_height * 2;
  z_translation = die_height / 2 + support_height;
  point_down_if_printing = rotate_for_printing ? [90, 0, 0] : [0, 0, 0];

  translate([0, 0, die_height / 2 + support_height])
    rotate(point_down_if_printing) {
      difference() {
        crystal(face_edge, d4c_body_length, end_height, see_supports);

        if (do_draw_text)
          draw_d4c_text(face_edge);
      }
    }

  if (support_height > 0) {
    width = 1.225 * face_edge;
    height = 1.85 * triangle_height(face_edge/2);
    rotate([0, 0, 45])
      render_supports(width, height, support_height, 4);
  }
}

module draw_d4c_text(height) {
  height_multiplier = 0.75;
  digits = ["3", "4", "2", "1"];
  for (i = [0:3]) { 
    rotate([0, 90*i, 0])
      rotate([90, 90, 90]) {
        translate([0, 0, 0.5 * height - 1])
          extrude_text(digits[i], height, height_multiplier);
      }
  }

}

//------------------------------------------------------------------------------------
//                                       D6
//------------------------------------------------------------------------------------

module draw_d6(face_edge, support_height, do_draw_text) {

  die_height = face_edge * sin(60);    
  translate([0, 0, die_height + support_height]) {
    if (see_supports) { // need to make the shape hollow
      difference() {
        draw_tipped_shape();
        translate([0, 0, .0025])
          draw_tipped_shape();
      }
    } else
     draw_tipped_shape();
  }

  if (support_height > 0) {
    width = sqrt(face_edge * face_edge *2 );
    height = face_edge * 0.58;
    rotate([0, 0, 60])
      render_supports(width, height, support_height, 3);
  }

  module draw_tipped_shape() {
    point_down_if_printing = rotate_for_printing ? [45, atan(1/sqrt(2)), 0] : [0, 0, 0];

    rotate(point_down_if_printing) {
      difference() {
        intersection() {
          cube([face_edge, face_edge, face_edge], center = true);
          
          if (cut_corners)
            rotate([125, 0, 45])
              octahedron(face_edge*1.625);
        }
          
        if (do_draw_text)
          draw_d6_text(face_edge);
      }
    }
  }
}

module draw_d6_text(height) {
  
  height_multiplier = 0.6;
  digits = ["1", "2", "3", "4", "5", "6"];

  rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - 1])
      extrude_text(digits[0], height, height_multiplier);

  translate([0, 0, -0.5 * height + 1])
    rotate([0, 180, 180])
      extrude_text(digits[5], height, height_multiplier);

  for (i = [0:1]) { 
    rotate([90, 0, 90 * i]) {
      translate([0, 0, 0.5 * height - 1])
        extrude_text(digits[i * 2 + 1], height, height_multiplier);

      translate([0, 0, -0.5 * height + 1])
        rotate([0, 180, 180])
          extrude_text(digits[4 - i * 2], height, height_multiplier);
    }
  }
}


//------------------------------------------------------------------------------------
//                                       D8
//------------------------------------------------------------------------------------

module draw_d8(face_edge, support_height, do_draw_text) {

  face_height = face_edge * 0.81654872074;
  translate ([0, 0, face_edge * 0.70715 + support_height]) {
    if (see_supports) { // need to make the shape hollow
      difference() {
        draw_tipped_shape();
        translate([0, 0, .0025])
          draw_tipped_shape();
      }
    } else
     draw_tipped_shape();
  }

  if (support_height > 0) {
    width = face_edge * 1.225;
    height = face_edge * .7075;
    rotate([0, 0, 45])
      render_supports(width, height, support_height, 4);
  }

  module draw_tipped_shape() {
    point_down_if_printing = rotate_for_printing ? [-54.7355, 0, 0] : [35.2645, 0, 0];
    rotate(point_down_if_printing) {
      difference() {
        intersection() {
          octahedron(face_height);
          
          if (cut_corners) {
            edge_length = face_height * 1.61111;
            rotate([45, 35, -30])
              cube([edge_length, edge_length, edge_length], center = true);
          }
      }
      if (do_draw_text)
        draw_d8_text(face_height);
      }
    }
  }
}

module draw_d8_text(height) {
  text_depth = 0.6;
  height_multiplier = 0.5;
  digits = ["4", "2", "8", "3", "6", "1", "7", "5"];
  text_offset = height * 0.0681;

  rotate([0, 0, 180])
    translate([0, text_offset, 0.5 * height - text_depth])
      extrude_text(digits[0], height, height_multiplier);

  translate([0, text_offset, -0.5 * height + text_depth])
    rotate([0, 180, 180])
      extrude_text(digits[7], height, height_multiplier);

  for (i = [0:2]) { 
    rotate([109.47122, 0, 120 * i]) {
      translate([0, text_offset, 0.5 * height - text_depth])
        extrude_text(digits[i*2 + 1], height, height_multiplier);

      translate([0, 0, -0.5 * height + text_depth])
        rotate([0, 180, 180])
          extrude_text(digits[6 - i * 2], height, height_multiplier);
    }
  }
}

//------------------------------------------------------------------------------------
//                                     D10/D%
//------------------------------------------------------------------------------------
module draw_d10(face_edge, support_height, is_percentile, do_draw_text) {

  digits = is_percentile ? ["40", "70", "80", "30", "20", "90", "00", "10", "60", "50"] :
                           ["0", "1", "2", "9", "8", "3", "4", "7", "6", "5"];

  underscores = is_percentile ? [] : ["", "", "", UND, "", "", "", "", UND, ""];

  translate ([0, 0, face_edge + support_height]) {
    if (see_supports) { // need to make the shape hollow
      difference() {
        draw_tipped_shape();
        translate([0, 0, .0025])
          draw_tipped_shape();
      }
    } else
     draw_tipped_shape();
  }

  if (support_height > 0) {
    width = face_edge * 1.1;
    height = face_edge * .8888888;
    rotate([0, 0, 18])
      render_supports(width, height, support_height, 5);
  }

  module draw_tipped_shape() {
    point_down_if_printing = rotate_for_printing ? [312, 0, 0] : [222, 0, 0];

    rotate(point_down_if_printing) {
      difference() {
        deltohedron(face_edge);
        
        if (draw_text)
          rotate([48, 0, 0])
            deltohedron_text(face_edge, d10_angle, 1, 0, 0, digits, underscores, is_percentile ? 0.30 : 0.4);
      }
    }
  }
}

module deltohedron_text(height, angle, text_depth, text_push, text_offset, digits, underscores, height_multiplier) {
  
  has_underscores = len(underscores) > 0;

  rotate([0, 0, 72]) // make numbers right side up
    for (i = [0:4]) { 
      rotate([0, 0, 72 * i])
        rotate([angle, 0, 0]) {
          index = i * 2 + text_offset;
  
          // Draw top half
          translate([0, text_push - text_offset, 0.5 * height - text_depth])
            extrude_text(digits[index + 1], height, height_multiplier);

          if (has_underscores)
            translate([0, 2 * (text_push - 5 * font_scale / 100) / 3 - height/20, 0.5 * height - text_depth])
              extrude_text(underscores[index + 1], height, height_multiplier);

          // Draw bottom half
          translate([0, -text_push - (text_offset), -0.5 * height + text_depth])
            rotate([0, 180, 180])
              extrude_text(digits[index], height, height_multiplier);

          if (has_underscores)
            translate([0, -2 * (text_push - 5 * font_scale / 100) / 3 + height/15, -0.5 * height + text_depth])
              rotate([0, 180, 0])
              extrude_text(underscores[index], height, height_multiplier);
        }
    }
}

//------------------------------------------------------------------------------------
//                                       D12
//------------------------------------------------------------------------------------

module draw_d12(face_edge, support_height, do_draw_text) {
  
  z_translation = face_edge * 0.89347 + support_height;
  face_height = face_edge * 1.42;

  translate ([0, 0, z_translation]) {
    if (see_supports) { // need to make the shape hollow
      difference() {
        draw_tipped_shape();
        translate([0, 0, .0025])
          draw_tipped_shape();
      }
    } else
     draw_tipped_shape();
  }

  if (support_height > 0) {
    width = face_edge * 1.03;
    height = face_edge * .226;
    rotate([0, 0, 90])
      render_supports(width, height, support_height, 3, false);
  }

  module draw_tipped_shape() {
    point_down_if_printing = rotate_for_printing ? [-37.3775, 0, 0] : [-127.3775, 0, 0];
    rotate(point_down_if_printing) {
      difference() {
        intersection() {
          dodecahedron(face_height, 116.565, 1);

          if (cut_corners)
            rotate([35, 10, -18])
              icosahedron(face_height * 1.218);
        }
      
        if (do_draw_text)
          draw_d12_text(face_height, 116.565);
      }
    }
  }
}

module draw_d12_text(height, slope, height_multiplier = 0.32) {
  
  text_depth = 0.6;
  digits = ["2", "11", "4", "9", "6", "7", "5", "8", "3", "10"];
  underscores = ["", "", "", UND, UND, "", "", "", "", "", "", ""];
  
  rotate([0, 0, 180])
    translate([0, 0, 0.5 * height - text_depth])
      extrude_text("12", height, height_multiplier);

  translate([0, 0, -0.5 * height + text_depth])
    rotate([0, 180, 0])
      extrude_text("1", height, height_multiplier);
  
  deltohedron_text(height, slope, 0.6, 0, 0, digits, underscores, height_multiplier);
}

//------------------------------------------------------------------------------------
//                                       D20
//------------------------------------------------------------------------------------

module draw_d20(face_edge, support_height, do_draw_text) {
  
  z_translation = face_edge * 0.9878 + support_height;
  face_height = face_edge * 1.56995960338;
  
  translate ([0, 0, z_translation]) {
    if (see_supports) { // need to make the shape hollow
      difference() {
        draw_tipped_shape();
        translate([0, 0, .0025])
          draw_tipped_shape();
      }
    } else
     draw_tipped_shape();
  } 

  if (support_height > 0) {
    width = face_edge * 1.53;
    height = face_edge * .5465;
    rotate([0, 0, 90])
      render_supports(width, height, support_height, 5);
  }

  module draw_tipped_shape() {
    rotate([35.264, 13.285, 18]) {
      difference() {
        intersection() {
          icosahedron(face_height);
          
          if(cut_corners)
            rotate([-10, 35, -28])
              dodecahedron(face_height*1.2,116.565,1);
        }
        
        if (do_draw_text)
          draw_d20_text(face_height);
      }
    }
  }
}

module draw_d20_text(height) {

    rotate([70.5288, 0, 60])
      draw_d20_text_set(height, 0);

    rotate([0, 0, 60 + w])
      draw_d20_text_set(height, 4);

    for (i = [1:3]) { 
      rotate([0, 0, i * 120])
        rotate([109.471, 0, 0])
          rotate([0, 0, w])
            draw_d20_text_set(height, 4 + i * 4);
    }
}

module draw_d20_text_set(height, j) {
  
   digits =      ["18",  "1",  "6", "12", 
                 "20",  "7", "10", "17", 
                 "9",   "5", "14",  "2", 
                 "3",  "13", "11", "16", 
                 "15", "19",  "4",  "8"];
  
  underscores = ["", "", UND, "", 
                 "", "", "", "",
                UND, "", "", "",
                "", "", "", "",
                "", "", "", ""];

  // Draw index, where index in [0, 4, 8, 12, 16] => "18", "20", "9", "3", "15"
  rotate([0, 0, 180])
    draw_d20_text_face(height, digits[j], underscores[j]);
  
  // Draw index+1, index+2, index+3
  for (i = [0:2])
    rotate([109.47122, 0, 120 * i])
     draw_d20_text_face(height, digits[i + j + 1], underscores[i + j + 1]);
}

module draw_d20_text_face(height, digit, underscore) {

  height_multiplier = .21;
  offset = len(underscore) > 0 ? (5 * font_scale / 100 / 6) : 0;
  
  rotate([0, 0, 39])
    translate([0, offset, 0.5 * height - 1])
      if (d20_replace_digit > 0 && str(d20_replace_digit) == digit) {
        if (d20_text != "") {
          rotate([0, 0, d20_face_rotation])
            extrude_text(d20_text, height, height_multiplier * d20_face_scale / 100);
        } else if (d20_svg_file != "") {
          svg_scale_multiplier = .45 / 10000;
          render_svg(d20_svg_file, d20_face_rotation, svg_scale_multiplier * d20_face_scale * height, d20_face_offset);
        } else {
          extrude_text(digit, height, height_multiplier);
        }
      } else {
        extrude_text(digit, height, height_multiplier);
      }
      
  rotate([0, 0, 39])
    translate([0, -(5 * font_scale / 100 / 2.5), 0.5 * height - 1])
      extrude_text(underscore, height, height_multiplier);      
}