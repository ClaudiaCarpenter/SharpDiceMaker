//------------------------------------------------------------------------------------
//                                       D4
//------------------------------------------------------------------------------------

module draw_d4(face_edge, font_scale, vertical_offset, is_crystal) {

  if (is_crystal)
    draw_d4c(face_edge);
  else
    draw_d4t(face_edge);

  module draw_d4t(face_edge) {
    z_translation = triangle_height(face_edge) * .707052 + supports_height;
    point_down_if_printing = !generate_base ? [0, 180, 60] : [0, 0, 210];
    
    if (generate_base) {
      render_shape(3, face_edge - 2, triangle_height(face_edge) - 2, 0, 2.5);
    } else {
      translate([0, 0, z_translation])
        if (see_supports) { // need to make the shape hollow
            difference() {
              draw_tipped_shape();
              translate([0, 0, .0025])
                draw_tipped_shape();
            }
        } else
          draw_tipped_shape();

      if (draw_supports) {
        width = d4_face_edge * 1.005;
        height = triangle_height(d4_face_edge) * .95;
        render_supports(width, height, supports_height, 3);
      }
    }

    module draw_tipped_shape() {
      rotate(point_down_if_printing)
        difference() {
          intersection() {
            tetrahedron(d4_face_edge);
            if (cut_corners)
              rotate([0, 180, 0])
                tetrahedron(d4_face_edge * 3 * 0.85);
          }
          
          if (draw_text)
            draw_text(d4_face_edge);
        }
    }

    module draw_text(height) {
      digits = ["1", "2", "3", 
                "4", "3", "2", 
                "4", "2", "1", 
                "4", "1", "3"];

      height_multiplier = 0.24;
      text_depth = d4_extrude_depth;
      text_push = 0.26;

      rotate([180, 0, 0])
        translate([0, 0, 0.2 * height - text_depth]) {
          for (i = [0:2]) { 
            rotate([0, 0, 120 * i])
              translate([text_push * height, 0, 0])
                rotate([0, 0, -90])
                  extrude_text(digits[i], font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by);
          }
        }
        for (j = [0:2]) { 
          rotate([0, -70.5288, j * 120])
            translate([0, 0, 0.2 * height - text_depth])
              for (i = [0:2]) {
                rotate([0, 0, 120 * i])
                  translate([text_push * height - 0.5, 0, 0])
                    rotate([0, 0, -90])
                      extrude_text(digits[(j + 1) * 3 + i], font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by);
              }
        }
    }
  }

  module draw_d4c(die_height) {
    pointy_end_height = die_height * .27;
    d4_body_length = die_height - 2 * pointy_end_height;
    d4_body_width = d4_body_length * .8;
  
    z_translation = !generate_base ? die_height / 2 + supports_height : 1.55*die_height;
    point_down_if_printing = draw_supports ? [90, 0, 0] : [0, 0, 0];

    if (generate_base) {
      render_shape(4, d4_body_width - 3, d4_body_length - 3, 0, 0);
    } else {
      translate([0, 0, z_translation])
        rotate(point_down_if_printing) {
          difference() {
            crystal(d4_body_width, d4_body_length, pointy_end_height, see_supports, add_sprue=true);
            draw_text(d4_body_width);
          }
        }

      if (draw_supports) {
        width = 1.225 * d4_body_width;
        height = triangle_edge(pointy_end_height) * .865;
        rotate([0, 0, 45])
          render_supports(width, height, supports_height, 4);
      }
    }

    module draw_text(height) {
      // echo("\ndraw_text\n", height);
      digits = ["3", "4", "2", "1"];
      height_multiplier = 0.75;
      y_offset = 0;
      top_digit = "4";

      for (i = [0:3]) { 
        rotate([0, 90*i, 0])
          rotate([90, 90, 90]) {
            translate([0, y_offset, 0.5 * height - 1]) {
              extrude_text(digits[i], font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by, extrude_multiplier = (digits[i] == top_digit) ? 1.5 : 1);
            }
          }
      }
    }
  }
}


//------------------------------------------------------------------------------------
//                                       D6
//------------------------------------------------------------------------------------

module draw_d6(face_edge, font_scale, vertical_offset) {

  die_height = face_edge * sin(60);    
  z_translation = !generate_base ? die_height + supports_height : 19;
  // point_down_if_printing = draw_supports ? [0, 0, 0] : [0, 0, 0];
  point_down_if_printing = draw_supports ? [45, atan(1/sqrt(2)), 0] : [0, 0, 0];

  if (generate_base) {
    render_shape(4, face_edge - 3, face_edge - 3, -1, 0);
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
  
    if (draw_supports) {
      width = sqrt(face_edge * face_edge *2 );
      height = face_edge * 0.58;
      rotate([0, 0, 60])
        render_supports(width, height, supports_height, 3);
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
          
        draw_d6_text(face_edge, draw_text);
      }
    }
  }

  module draw_d6_text(height, draw_text) {
    
    height_multiplier = 0.6;
    y_offset = -height_multiplier * font_scale / 100;
    digits = ["6", "5", "4", "3", "2", "1"];

    sprue_offset = height/4; 
    rotate([0, 0, 180])
      translate([0, y_offset, 0.5 * height - 1]) {
        extrude_text(digits[0], font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by);
        if (add_sprue_hole && sprue_on_high) {
          make_sprue_hole(-(sprue_offset+0.5), sprue_offset, 0, sprue_diameter, 0);
        }
      }

    translate([0, -y_offset, -0.5 * height + 1]) {
      rotate([0, 180, 180])
        extrude_text(digits[5], font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by, extrude_multiplier = 1.5);
        if (add_sprue_hole && !sprue_on_high) {
          make_sprue_hole(-sprue_offset, sprue_offset-1, 0, sprue_diameter, 0);
        }
    }

    for (i = [0:1]) { 
      rotate([90, 0, 90 * i]) {
        translate([0, y_offset, 0.5 * height - 1])
          extrude_text(digits[i * 2 + 1], font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by);

        translate([0, -y_offset, -0.5 * height + 1])
          rotate([0, 180, 180])
            extrude_text(digits[4 - i * 2], font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by);
      }
    }
  }

}


//------------------------------------------------------------------------------------
//                                       D8
//------------------------------------------------------------------------------------

module draw_d8(face_edge, font_scale, vertical_offset) {

  face_height = face_edge * 0.81654872074;
  z_translation = !generate_base ? face_edge * 0.70715 + supports_height : 19;

  if (generate_base) {
    render_shape(3, face_edge - 3, triangle_height(face_edge) - 3, 0, 4);
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

    if (draw_supports) {
      width = face_edge * 1.225;
      height = face_edge * .7075;
      rotate([0, 0, 45])
        render_supports(width, height, supports_height, 4);
    }
  }

  module draw_tipped_shape() {
    point_down_if_printing = draw_supports ? [-54.7355, 0, 0] : [0, 0, 0];
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
        draw_d8_text(face_height, draw_text);
      }
    }
  }

  module draw_d8_text(height, draw_text) {
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
      sprue_digit = add_sprue_hole ? (sprue_on_high ? "8" : "1") : -1;
      face_edge = triangle_edge(height);

      rotate([0, 0, 180]) {
        translate([0, y_offset, 0.5 * height - text_depth])
          extrude_text(digit1, font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by * 2);
        if (digit1 == sprue_digit) {
              make_sprue_hole(-face_edge / 5, -height / 7, 0.5 * height - 1, sprue_diameter);
        }
      }

      translate([0, y_offset, -0.5 * height + text_depth])
        rotate([0, 180, 0]) {
          extrude_text(digit2, font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by * 2, extrude_multiplier = (digit2 == sprue_digit) ? 1.5 : 1);
          if (digit2 == sprue_digit) {
              make_sprue_hole(face_edge / 4, -height / 5, 0, sprue_diameter);
           }
        }
    }
  }
}

//------------------------------------------------------------------------------------
//                                     D10/D%
//------------------------------------------------------------------------------------
module draw_d10(face_edge, font_scale, vertical_offset, is_percentile, is_crystal) {

  digits = is_percentile ? ["50", "40", "10", "80", "70", "20", "90", "00", "30", "60"] :
                           ["5", "4", "1", "8", "7", "2", "9.", "0", "3", "6."];

  z_multiplier = is_crystal ? 1 : 0.74724;
  z_translation = !generate_base ? face_edge * z_multiplier + supports_height : 23;
  point_down_if_printing = draw_supports ? [312, 0, 0] : [12, 0, 0];
  angle = is_crystal ? 120 : 132;

  if (generate_base) {
    render_shape(4, face_edge - 2.5, face_edge - 2.5, 0, is_crystal ? -.5 : 0, is_crystal);
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

    if (draw_supports) {
      width_multiplier = is_crystal ? 1.105 : 1.2875;
      height_multiplier = is_crystal ? .8888888 : .6685;
      width = face_edge * width_multiplier;
      height = face_edge * height_multiplier;
      rotate([0, 0, 18])
        render_supports(width, height, supports_height, 5);
    }
  }


  module draw_tipped_shape() {
    sprue_digit = add_sprue_hole ? (sprue_on_high ? digits[6] : digits[7]) : -1;

    rotate(point_down_if_printing) {
      difference() {
        deltohedron(face_edge, angle);
        rotate([48, 0, 0])
          deltohedron_text(face_edge, font_scale, vertical_offset, angle, extrude_depth, -0.8*(font_scale / 100.0), 0, digits, is_percentile ? 0.3 : 0.4, draw_text, !is_crystal ? 2 : 0, sprue_digit);
      }
    }
  }
}

module deltohedron_text(height, font_scale, vertical_offset, angle, text_depth, text_push, text_offset, digits, height_multiplier, draw_text, add_y_offset, sprue_digit, sprue_offset_x = 0, sprue_offset_y = 0, sprue_diameter_local = sprue_diameter) {
  //echo("deltohedron_text", height, font_scale, vertical_offset, angle, text_depth, text_push, text_offset, digits, height_multiplier, draw_text, add_y_offset);
  rotate([0, 0, 72]) // makes numbers right side up
    for (i = [0:4]) { 
      rotate([0, 0, 72 * i])
        rotate([angle, 0, 0]) {
          index = i * 2 + text_offset;
          deltohedron_text_pair(height, font_scale, vertical_offset, text_depth, digits[index + 1], digits[index], height_multiplier, draw_text, add_y_offset, sprue_digit, sprue_offset_x, sprue_offset_y, sprue_diameter_local);
        }
    }
}

module deltohedron_text_pair(height, font_scale, vertical_offset, text_depth, digit1, digit2, height_multiplier, draw_text, add_y_offset, sprue_digit, sprue_offset_x = 0, sprue_offset_y = 0, sprue_diameter_local = sprue_diameter) {
  y_offset = -height_multiplier * font_scale/100 + add_y_offset;
  inset_depth = 0.5 * height - text_depth;
  echo(sprue_offset_x = sprue_offset_x, sprue_offset_y = sprue_offset_y);
  // Draw top half
  translate([0, y_offset, inset_depth]) {
    extrude_text(digit1, font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by);
    if (digit1 == sprue_digit) {
      echo("top half", sprue_digit=sprue_digit);
      make_sprue_hole(sprue_offset_x, -height/3 + sprue_offset_y, 1, sprue_diameter_local);
    }
  }

  // Draw bottom half
  translate([0, -y_offset, -inset_depth]) {
    rotate([0, 180, 180]) {
      extrude_text(digit2, font_scale, vertical_offset, height, height_multiplier, draw_text, offset_four_by);
      if (digit2 == sprue_digit) {
        echo("bottom half", sprue_digit=sprue_digit);
        make_sprue_hole(sprue_offset_x, -height/3 + sprue_offset_y, 1, sprue_diameter_local);        
      }
    }
  }
}

//------------------------------------------------------------------------------------
//                                       D12
//------------------------------------------------------------------------------------

module draw_d12(face_edge, font_scale, vertical_offset) {
  
  height_multiplier = .32;
  face_height = face_edge * 1.42;
  z_translation = !generate_base ? face_edge * 0.89347 + supports_height : 17;
  point_down_if_printing = draw_supports ? [-37.3775, 0, 0] : [0, 0, 0];
  
  if (generate_base) {
    render_shape(5, face_edge / 2 -1, 0, 0);
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

    if (draw_supports) {
      width = face_edge * 1.03;
      height = face_edge * .226;
      rotate([0, 0, 90])
        render_supports(width, height, supports_height, 3);
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
      
        draw_d12_text(face_height, 116.565, height_multiplier, draw_text);
      }
    }
  }

  module draw_d12_text(height, slope, height_multiplier, draw_text) {
    digits = ["2", "11", "4", "9.", "6.", "7", "5", "8", "3", "10"];
    sprue_digit = add_sprue_hole ? (sprue_on_high ? "12" : "1") : -1;
    sprue_offset_x = height * height_multiplier / 2 * (sprue_on_high ? 1.2 : 1);
    sprue_offset_y = height * height_multiplier * 1.1;
    sprue_local_diameter = sprue_on_high ? 1.75 : sprue_diameter;

    rotate([0, 0, 324]) // makes numbers right side up
      deltohedron_text_pair(height, font_scale, vertical_offset, extrude_depth, "12", "1", height_multiplier, draw_text, 0, sprue_digit, sprue_offset_x, sprue_offset_y, sprue_local_diameter);

    deltohedron_text(height, font_scale, vertical_offset, slope, extrude_depth, 0, height/80, digits, height_multiplier, draw_text, 0);
  }

}

//------------------------------------------------------------------------------------
//                                       D20
//------------------------------------------------------------------------------------

module draw_d20(face_edge, font_scale, vertical_offset) {
  
  z_translation = draw_supports ? face_edge * 0.9878 + supports_height : face_edge;
  face_height = face_edge * 1.56995960338;
  point_down_if_printing = [35.264, 13.285, 18]; // draw_supports ? [35.264, 13.285, 18] : [0, 0, 0];
  is_chonk= face_edge > 16;

  if (generate_base) {
    render_shape(3, face_edge - 2, triangle_height(face_edge) - 2, 0, 4);
  } else {
  // if (generate_base) {
    //render_shape(3, face_edge * 0.78571428571, 0, 0);
    // render_shape(3, face_edge, 0, 0);
  // } else {
  // if (generate_base) {
  //   if (is_chonk) 
  //     render_shape_from_stl("bases/d20mc.stl", -1.5, -3, 10.75); 
  //   else
  //     render_shape_from_stl("bases/d20m.stl", -1, -2, 12); 
  // } else {
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

    if (draw_supports) {
      width = face_edge * 1.53;
      height = face_edge * .5465;
      rotate([0, 0, 90])
        render_supports(width, height, supports_height, 5);
    }
  }

  module draw_tipped_shape() {
    //color("gray")
    rotate(point_down_if_printing) {
      difference() {
        intersection() {
          icosahedron(face_height);
          
          if(cut_corners)
            rotate([-10, 35, -28])
              dodecahedron(face_height*1.2,116.565,1);
        }
        //color("white")
        draw_d20_text(face_height, draw_text);
      }
    }
  }

  module draw_d20_text(height, draw_text) {
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
      digits_all =        ["18", "1",  "6.", "12", "20", "7",  "10", "17", "9.", "5", "14", "2",  "3",  "13", "11", "16", "15", "19", "4",  "8"];
      digits_no_low =     ["18", " ",  "6.", "12", "20", "7",  "10", "17", "9.", "5", "14", "2",  "3",  "13", "11", "16", "15", "19", "4",  "8"];
      digits_blank_low =  ["18", " ",  "6.", "12", "20", "7",  "10", "17", "9.", "5", "14", "2",  "3",  "13", "11", "16",  "15", "", "4",  "8"];
      digits_no_high =    ["18", "1",  "6.", "12", " ", "7",  "10", "17", "9.", "5", "14", "2",  "3",  "13", "11", "16", "15", "19", "4",  "8"];
      digits_blank_high = ["18", "1",  "6.", "12", " ", "7",  "10", "17", "9.", "5",  "14", "", "3",  "13", "11", "16", "15", "19", "4",  "8"];

      digits = skip_low_number ? digits_no_low : (skip_high_number ? digits_no_high : skip_sprue_numbers ? (sprue_on_high ? digits_blank_high : digits_blank_low) : digits_all);

      sprue_digit = add_sprue_hole ? (sprue_on_high ? digits[4] : digits[1]) : -1;
      sprue_offset_x = sprue_on_high ? height / 18 : -height / 4;
      sprue_offset_y = sprue_on_high ? height / 2 - height / 5: height / 6.5 - height / 3;

      // Draw index, where index in [0, 4, 8, 12, 16] => "18", "20", "9", "3", "15"
      rotate([0, 0, 180])
        draw_numbers(height, digits[j]);
      
      // Draw index+1, index+2, index+3
      for (i = [0:2])
        rotate([109.47122, 0, 120 * i])
          draw_numbers(height, digits[i + j + 1]);
        
      module draw_numbers(height, digit) {
        //echo("draw_numbers", height, digit);
        height_multiplier = .22;
        y_offset = -height_multiplier * font_scale/100;
        z_offset = 0.5 * height - 1;

        rotate([0, 0, 39])
          translate([0, y_offset, z_offset]) {
            if (d20_replace_digit > 0 && str(d20_replace_digit) == digit && d20_svg_file != "") {
              svg_scale_multiplier = .45 / 10000;
              render_svg(d20_svg_file, d20_face_rotation, svg_scale_multiplier * d20_face_scale * height, 4 * (d20_face_offset + height_multiplier * d20_face_scale / 100));
            } else {
              extrude_multiplier = 1;
              calc_height_multiplier = (digit == "20") ? height_multiplier * d20_face_scale / 100 : height_multiplier;
              extrude_text(digit, font_scale, vertical_offset, height, calc_height_multiplier, 
                           draw_text, offset_four_by, extrude_multiplier);
              if (digit == sprue_digit) {
                echo("top half", sprue_digit=sprue_digit);
                make_sprue_hole(sprue_offset_x, sprue_offset_y, 1, sprue_diameter * height / 28, 20);
              }
            }
        }
      }
    }
  }
}
