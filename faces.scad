//------------------------------------------------------------------------------------
//                                      d4
//------------------------------------------------------------------------------------

module draw_d4_crystal(face_edge, support_height, do_draw_text) {
  d4_body_length = 1.25 * face_edge;
  pointy_end_height = face_edge / 1.25;
  die_height = d4_body_length + pointy_end_height * 2;

  z_translation = !generate_base ? die_height / 2 + support_height : 1.55*face_edge;
  point_down_if_printing = !generate_base ? [90, 0, 0] : [45, 0, 0];

  if (generate_base) {
    render_base("bases/triangle.stl", (face_edge - 2) / 7);
  } else {
    translate([0, 0, z_translation])
      rotate(point_down_if_printing) {
        difference() {
          crystal(face_edge, d4_body_length, pointy_end_height, see_supports, add_sprue_hole, sprue_diameter, sprue_angle);
          draw_text(face_edge, do_draw_text);
        }
      }

    if (support_height > 0) {
      width = 1.225 * face_edge;
      height = 1.85 * triangle_height(face_edge/2);
      rotate([0, 0, 45])
        render_snap_off_supports(width, height, support_height, 4);
    }
  }
  

  module draw_text(height, do_draw_text) {
    digits = ["3", "4", "2", "1"];
    height_multiplier = 0.75;
    y_offset = 0;

    for (i = [0:3]) { 
      rotate([0, 90*i, 0])
        rotate([90, 90, 90]) {
          translate([0, y_offset, 0.5 * height - 1])
            extrude_text(digits[i], height, height_multiplier, do_draw_text);
        }
    }
  }
}


//------------------------------------------------------------------------------------
//                                       D6
//------------------------------------------------------------------------------------

module draw_d6(face_edge, support_height, do_draw_text) {

  die_height = face_edge * sin(60);    
  z_translation = !generate_base ? die_height + support_height : 19;
  point_down_if_printing = !generate_base ? [45, atan(1/sqrt(2)), 0] : [8, -8, 0];

  if (generate_base) {
    render_base("bases/cube.stl", (face_edge - 2) / 7);
  } else {
    translate([0, 0, z_translation]) {
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
        render_snap_off_supports(width, height, support_height, 3);
    }
  }

  module draw_tipped_shape() {
    rotate(point_down_if_printing) {
      difference() {
        intersection() {
          cube([face_edge, face_edge, face_edge], center = true);
          
          if (cut_corners)
            rotate([125, 0, 45])
              octahedron(face_edge*1.625);
        }
          
        draw_d6_text(face_edge, do_draw_text);
      }
    }
  }
}

module draw_d6_text(height, do_draw_text) {
  
  height_multiplier = 0.6;
  y_offset = -height_multiplier * font_scale / 100;
  digits = ["1", "2", "3", "4", "5", "6"];

  rotate([0, 0, 180]) {
    translate([0, y_offset, 0.5 * height - 1])
      extrude_text(digits[0], height, height_multiplier, do_draw_text);

    if (add_sprue_hole) {
      sprue_offset = height * 0.5 - sprue_diameter - 0.5;
      make_sprue_hole(sprue_offset, sprue_offset, 0.5 * height - 1, sprue_diameter, -sprue_angle);
    }
  }

  translate([0, -y_offset, -0.5 * height + 1])
    rotate([0, 180, 180])
      extrude_text(digits[5], height, height_multiplier, do_draw_text);

  for (i = [0:1]) { 
    rotate([90, 0, 90 * i]) {
      translate([0, y_offset, 0.5 * height - 1])
        extrude_text(digits[i * 2 + 1], height, height_multiplier, do_draw_text);

      translate([0, -y_offset, -0.5 * height + 1])
        rotate([0, 180, 180])
          extrude_text(digits[4 - i * 2], height, height_multiplier, do_draw_text);
    }
  }
}


//------------------------------------------------------------------------------------
//                                       D8
//------------------------------------------------------------------------------------

module draw_d8(face_edge, support_height, do_draw_text) {

  face_height = face_edge * 0.81654872074;
  z_translation = !generate_base ? face_edge * 0.70715 + support_height : 19;

  if (generate_base) {
    render_base("bases/triangle.stl", (face_edge - 3.5) / 7, true);
  } else {
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
      width = face_edge * 1.225;
      height = face_edge * .7075;
      rotate([0, 0, 45])
        render_snap_off_supports(width, height, support_height, 4);
    }
  }

  module draw_tipped_shape() {
    point_down_if_printing = !generate_base ? [-54.7355, 0, 0] : [35.2645 * 2.325, 0, 0];
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
        draw_d8_text(face_height, do_draw_text);
      }
    }
  }
}

module draw_d8_text(height, do_draw_text) {
  text_depth = extrude_depth;
  height_multiplier = 0.5;
  digits = ["4", "2", "8", "3", "6", "1", "7", "5"];
  rotate_face = 109.4712;
  y_offset = height / 20;

  draw_pair("4", "5");

  rotate([rotate_face, 0, 120])
    rotate([0, 0, 60])
      draw_pair("3", "6");

  rotate([rotate_face, 0, 0])
    rotate([0, 0, 180])
      draw_pair("2", "7");

  rotate([rotate_face, 0, 240])
    rotate([0, 0, -60])
      draw_pair("1", "8");

  module draw_pair(digit1, digit2) {
    rotate([0, 0, 180]) {
      translate([0, y_offset, 0.5 * height - text_depth])
        extrude_text(digit1, height, height_multiplier, do_draw_text);
        
        if (add_sprue_hole && digit1 == "1")
          make_sprue_hole(height * 0.5 - sprue_diameter * 0.5 - 1.5, -(height * 0.5 - sprue_diameter * 0.5) + 3.2, 0.5 * height - 1, sprue_diameter, sprue_angle);
    }

    translate([0, y_offset, -0.5 * height + text_depth])
      rotate([0, 180, 0])
        extrude_text(digit2, height, height_multiplier, do_draw_text);
  }
}

//------------------------------------------------------------------------------------
//                                     D10/D%
//------------------------------------------------------------------------------------
module draw_d10(face_edge, support_height, is_percentile, do_draw_text) {

  digits = is_percentile ? ["40", "70", "80", "30", "20", "90", "00", "10", "60", "50"] :
                           ["0", "1", "2", "9.", "8", "3", "4", "7", "6.", "5"];

  z_translation = !generate_base ? face_edge + support_height : 23;
  point_down_if_printing = !generate_base ? [312, 0, 0] : [42, 36, 0];

  if (generate_base) {
    render_base("bases/crystal.stl", (face_edge - 4) / 8, true);
  } else {
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
      width = face_edge * 1.12;
      height = face_edge * .8888888;
      rotate([0, 0, 18])
        render_snap_off_supports(width, height, support_height, 5);
    }
  }

  module draw_tipped_shape() {
    rotate(point_down_if_printing) {
      difference() {
        deltohedron(face_edge);
        
        rotate([48, 0, 0])
          deltohedron_text(face_edge, d10_angle, 1, -0.8*(font_scale / 100.0), 0, digits, is_percentile ? 0.3 : 0.4, do_draw_text);
      }
    }
  }
}

module deltohedron_text_pair(height, text_depth, digit1, digit2, height_multiplier, do_draw_text) {
  y_offset = -height_multiplier * font_scale/100;
  inset_depth = 0.5 * height - text_depth;

  // Draw top half
  translate([0, y_offset, inset_depth]) {
    extrude_text(digit1, height, height_multiplier, do_draw_text);

    if (add_sprue_hole && (digit1 == "1" || digit1 == "70"))
      make_sprue_hole(y_offset + .5, -height / 3 + y_offset, 1.5, sprue_diameter, sprue_angle);
   }

  // Draw bottom half
  translate([0, -y_offset, -inset_depth]) {
    rotate([0, 180, 180]) {
      extrude_text(digit2, height, height_multiplier, do_draw_text);

    if (add_sprue_hole && (digit2 == "1" || digit2 == "70"))
      make_sprue_hole(height / 3 - sprue_diameter * 0.5 - .75, y_offset + sprue_diameter * 0.5, 1.5, sprue_diameter, sprue_angle);
    }
  }
}

module deltohedron_text(height, angle, text_depth, text_push, text_offset, digits, height_multiplier, do_draw_text) {
  rotate([0, 0, 72]) // makes numbers right side up
    for (i = [0:4]) { 
      rotate([0, 0, 72 * i])
        rotate([angle, 0, 0]) {
          index = i * 2 + text_offset;
          deltohedron_text_pair(height, text_depth, digits[index + 1], digits[index], height_multiplier, do_draw_text);
        }
    }
}

//------------------------------------------------------------------------------------
//                                       D12
//------------------------------------------------------------------------------------

module draw_d12(face_edge, support_height, do_draw_text) {
  
  height_multiplier = .35;
  face_height = face_edge * 1.42;
  z_translation = !generate_base ? face_edge * 0.89347 + support_height : 17;
  point_down_if_printing = !generate_base ? [-37.3775, 0, 0] : [-127.3775, 0, 0];
  
  if (generate_base) {
    render_base("bases/pentagon.stl", (face_edge - 2) / 7, true);
  } else {
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
        render_snap_off_supports(width, height, support_height, 3);
    }
  }

  module draw_tipped_shape() {
    rotate(point_down_if_printing) {
      difference() {
        intersection() {
          dodecahedron(face_height, 116.565, 1);

          if (cut_corners)
            rotate([35, 10, -18])
              icosahedron(face_height * 1.218);
        }
      
        draw_d12_text(face_height, 116.565, height_multiplier, do_draw_text);
      }
    }
  }
}

module draw_d12_text(height, slope, height_multiplier, do_draw_text) {
  digits = ["2", "11", "4", "9.", "6.", "7", "5", "8", "3", "10"];
 
  rotate([0, 0, 324]) // makes numbers right side up
    deltohedron_text_pair(height, extrude_depth, "12", "1", height_multiplier, do_draw_text);

  deltohedron_text(height, slope, 0.6, 0, height/80, digits, height_multiplier, do_draw_text);
}

//------------------------------------------------------------------------------------
//                                       D20
//------------------------------------------------------------------------------------

module draw_d20(face_edge, support_height, do_draw_text) {
  
  z_translation = !generate_base ? face_edge * 0.9878 + support_height : 23;
  face_height = face_edge * 1.56995960338;
  point_down_if_printing = !generate_base ? [35.264, 13.285, 18] : [35.264, 13.285, 18];
  
  if (generate_base) {
    rotate([0, 0, 180])
    render_base("bases/triangle.stl", (face_edge - 2) / 7, true);
  } else {
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
        render_snap_off_supports(width, height, support_height, 5);
    }
  }

  module draw_tipped_shape() {
    rotate(point_down_if_printing) {
      difference() {
        intersection() {
          icosahedron(face_height);
          
          if(cut_corners)
            rotate([-10, 35, -28])
              dodecahedron(face_height*1.2,116.565,1);
        }
        
        draw_d20_text(face_height, do_draw_text);
      }
    }
  }

  module draw_d20_text(height, do_draw_text) {
    rotate([70.5288, 0, 60])
      draw_face(height, 0);

    rotate([0, 0, 60 + w])
      draw_face(height, 4);

    for (i = [1:3]) { 
      rotate([0, 0, i * 120])
        rotate([109.471, 0, 0])
          rotate([0, 0, w])
            draw_face(height, 4 + i * 4);
    }

    module draw_face(height, j) {
      // Order is important, as opposite dice faces must add up to 21
      digits = ["18", "1",  "6.", "12", 
                "20", "7",  "10", "17", 
                "9.", "5",  "14", "2", 
                "3",  "13", "11", "16", 
                "15", "19", "4",  "8"];
      
      // Draw index, where index in [0, 4, 8, 12, 16] => "18", "20", "9", "3", "15"
      rotate([0, 0, 180])
        draw_numbers(height, digits[j]);
      
      // Draw index+1, index+2, index+3
      for (i = [0:2])
        rotate([109.47122, 0, 120 * i])
          draw_numbers(height, digits[i + j + 1]);
        
      module draw_numbers(height, digit) {
        height_multiplier = .22;
        y_offset = -height_multiplier * font_scale/100;

        rotate([0, 0, 39])
          translate([0, y_offset, 0.5 * height - 1]) {
            if (d20_replace_digit > 0 && str(d20_replace_digit) == digit) {
              if (d20_text != "") {
                rotate([0, 0, d20_face_rotation])
                  translate([0, -d20_face_offset])
                    extrude_text(d20_text, height, height_multiplier * d20_face_scale / 100, icon_font, do_draw_text);

              } else if (d20_svg_file != "") {
                svg_scale_multiplier = .45 / 10000;
                render_svg(d20_svg_file, d20_face_rotation, svg_scale_multiplier * d20_face_scale * height, 4 * (d20_face_offset + height_multiplier * d20_face_scale / 100));

              } else {
                extrude_text(digit, height, height_multiplier, do_draw_text);
              }
            } else {
              extrude_text(digit, height, (digit == "20") ? height_multiplier * d20_face_scale / 100 : height_multiplier, do_draw_text);
            }

            if (add_sprue_hole && digit == "1") {
              x_offset = -height * 0.25 + sprue_diameter / 2 + 1;
              y_offset = -triangle_height(height) * 0.22 + sprue_diameter / 2 + 1;
              make_sprue_hole(x_offset, y_offset, 1.5, sprue_diameter, sprue_angle);
            }
        }
      }
    }
  }
}





 //------------------------------------------------------------------------------------
//                               Text / Image Utils
//------------------------------------------------------------------------------------
module render_svg(svg_file, svg_rotation, svg_scale, svg_offset, do_draw_text) {
  if (do_draw_text) {
    if (show_bounding_box) {
      echo("extrude_svg", svg_file, svg_rotation, svg_scale, svg_offset);
      extrude_it();
      %bounding_box() extrude_it();
    } else
      extrude_it();
  }

  module extrude_it() {
    translate([0, svg_offset, -extrude_depth + 1])
      rotate([0, 0, svg_rotation])
        scale([svg_scale, svg_scale, 1])
          linear_extrude(height = extrude_depth + 1)
            import(svg_file, center = true);
  }
}

module extrude_text(some_text, height, multiplier, do_draw_text, potential_font ="") {
 if (do_draw_text) {
    if (show_bounding_box) {
      echo("extrude_text", some_text, height, multiplier, vertical_offset*multiplier);
      extrude_it();
      %bounding_box() extrude_it();
    } else
      extrude_it();
  }

  module extrude_it() {
    translate([0, vertical_offset * multiplier, -extrude_depth + 1])
      linear_extrude(height = extrude_depth + 1)
        text(some_text, size = height * multiplier * font_scale / 100, valign="center", halign="center", font=(potential_font != "" ? potential_font : font));
  }
}

module render_base(base_file, ratio, draw_stand = true) {
  if (draw_stand)
    translate([0, 0, 5])
      rotate([180, 0, 0])
        import("bases/base.stl");

  translate([0, 0, 5])
    scale([ratio, ratio, ratio])
      import(base_file);
}

module bounding_box() { 

    // a 3D approx. of the children projection on X axis 
    module xProjection() 
        translate([0,1/2,-1/2]) 
            linear_extrude(1) 
                hull() 
                    projection() 
                        rotate([90,0,0]) 
                            linear_extrude(1) 
                                projection() children(); 
  
    // a bounding box with an offset of 1 in all axis
    module bbx()  
        minkowski() { 
            xProjection() children(); // x axis
            rotate(-90)               // y axis
                xProjection() rotate(90) children(); 
            rotate([0,-90,0])         // z axis
                xProjection() rotate([0,90,0]) children(); 
        } 
    
    // offset children() (a cube) by -1 in all axis
    module shrink()
      intersection() {
        translate([ 1, 1, 1]) children();
        translate([-1,-1,-1]) children();
      }

   shrink() bbx() children(); 
}

