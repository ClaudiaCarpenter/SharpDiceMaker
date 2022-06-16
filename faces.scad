//------------------------------------------------------------------------------------
//                                       D4
//------------------------------------------------------------------------------------

module draw_d4(face_edge, support_height, do_draw_text, is_crystal) {
  if (is_crystal)
    draw_d4c(face_edge, support_height, do_draw_text);
  else
    draw_d4t(face_edge, support_height, do_draw_text);
}

module draw_d4t(face_edge, support_height, do_draw_text) {
  z_translation = triangle_height(face_edge) * .707052 + support_height;
  point_down_if_printing = !generate_base ? [0, 180, 60] : [0, 0, 210];
  
  if (generate_base) {
    render_shape(3, face_edge - 2, triangle_height(face_edge) - 2);
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
      render_supports(width, height, support_height, 3);
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
        
        if (do_draw_text)
          draw_d4_text(d4_face_edge, do_draw_text);
      }
  }

  module draw_d4_text(height, do_draw_text) {
    digits = ["1", "2", "3", 
              "4", "3", "2", 
              "4", "2", "1", 
              "4", "1", "3"];

    height_multiplier = 0.24;
    text_depth = extrude_depth;
    text_push = 0.26;

    rotate([180, 0, 0])
      translate([0, 0, 0.2 * height - text_depth]) {
        if (add_sprue_hole) {
          make_sprue_hole(0, 0, 0, sprue_diameter, sprue_angle);
        }
        for (i = [0:2]) { 
          rotate([0, 0, 120 * i])
            translate([text_push * height, 0, 0])
              rotate([0, 0, -90])
                extrude_text(digits[i], height, height_multiplier, do_draw_text, offset_four_by);
        }
      }
      for (j = [0:2]) { 
        rotate([0, -70.5288, j * 120])
          translate([0, 0, 0.2 * height - text_depth])
            for (i = [0:2]) {
              rotate([0, 0, 120 * i])
                translate([text_push * height - 0.5, 0, 0])
                  rotate([0, 0, -90])
                    extrude_text(digits[(j + 1) * 3 + i], height, height_multiplier, do_draw_text, offset_four_by);
            }
      }
  }
}

module draw_d4c(die_height, support_height, do_draw_text) {
  pointy_end_height = die_height * .27;
  d4_body_length = die_height - 2 * pointy_end_height;
  d4_body_width = d4_body_length * .8;
 
  z_translation = !generate_base ? die_height / 2 + support_height : 1.55*die_height;
  point_down_if_printing = !generate_base ? [90, 0, 0] : [45, 0, 0];

  if (generate_base) {
    render_shape(4, d4_body_width - 3, d4_body_length - 3);
  } else {
    translate([0, 0, z_translation])
      rotate(point_down_if_printing) {
        difference() {
          crystal(d4_body_width, d4_body_length, pointy_end_height, see_supports, false);
          draw_text(d4_body_width, do_draw_text);
        }
      }

    if (draw_supports) {
      width = 1.225 * d4_body_width;
      height = triangle_edge(pointy_end_height) * .865;
      rotate([0, 0, 45])
        render_supports(width, height, support_height, 4);
    }
  }
  

  module draw_text(height, do_draw_text) {
    digits = ["3", "4", "2", "1"];
    height_multiplier = 0.75;
    y_offset = 0;

    for (i = [0:3]) { 
      rotate([0, 90*i, 0])
        rotate([90, 90, 90]) {
          translate([0, y_offset, 0.5 * height - 1]) {
            extrude_text(digits[i], height, height_multiplier, do_draw_text, offset_four_by);
              if (digits[i] == "1" && add_sprue_hole) {
                make_sprue_hole(d4_body_width * .25, d4_body_length * .25, 0, sprue_diameter, sprue_angle);
              }
            }
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
    render_shape(4, face_edge - 3, face_edge - 3);
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
        render_supports(width, height, support_height, 3);
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
      extrude_text(digits[0], height, height_multiplier, do_draw_text, offset_four_by);

    if (add_sprue_hole) {
      sprue_offset = height * 0.5 - sprue_diameter - 0.5 - 1;
      make_sprue_hole(sprue_offset, sprue_offset, 0.5 * height - 1, sprue_diameter, 0);
    }
  }

  translate([0, -y_offset, -0.5 * height + 1])
    rotate([0, 180, 180])
      extrude_text(digits[5], height, height_multiplier, do_draw_text, offset_four_by);

  for (i = [0:1]) { 
    rotate([90, 0, 90 * i]) {
      translate([0, y_offset, 0.5 * height - 1])
        extrude_text(digits[i * 2 + 1], height, height_multiplier, do_draw_text, offset_four_by);

      translate([0, -y_offset, -0.5 * height + 1])
        rotate([0, 180, 180])
          extrude_text(digits[4 - i * 2], height, height_multiplier, do_draw_text, offset_four_by);
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
    render_shape(3, face_edge - 3, triangle_height(face_edge) - 3);
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
        render_supports(width, height, support_height, 4);
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
        extrude_text(digit1, height, height_multiplier, do_draw_text, offset_four_by * 2);
        
        if (add_sprue_hole && digit1 == "1") {
          width = triangle_edge(height);
          x = -(width * 0.38 - sprue_diameter * 1.5);
          y = x / 2;
          make_sprue_hole(x, y, 0.5 * height - 1, sprue_diameter, sprue_angle);
        }
    }

    translate([0, y_offset, -0.5 * height + text_depth])
      rotate([0, 180, 0])
        extrude_text(digit2, height, height_multiplier, do_draw_text, offset_four_by * 2);
  }
}

//------------------------------------------------------------------------------------
//                                     D10/D%
//------------------------------------------------------------------------------------
module draw_d10(face_edge, support_height, is_percentile, do_draw_text, is_crystal) {

  digits = is_percentile ? ["40", "70", "80", "30", "20", "90", "00", "10", "60", "50"] :
                           ["0", "1", "2", "9.", "8", "3", "4", "7", "6.", "5"];

  z_multiplier = is_crystal ? 1 : 0.74724;
  z_translation = !generate_base ? face_edge * z_multiplier + support_height : 23;
  point_down_if_printing = !generate_base ? [312, 0, 0] : [42, 36, 0];
  angle = is_crystal ? 120 : 132;


  if (generate_base) {
    render_shape(4, face_edge - 2.5, face_edge - 2.5, is_crystal);
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
        render_supports(width, height, support_height, 5);
    }
  }

  module draw_tipped_shape() {
    rotate(point_down_if_printing) {
      difference() {
        deltohedron(face_edge, angle);
        rotate([48, 0, 0])
          deltohedron_text(face_edge, angle, extrude_depth, -0.8*(font_scale / 100.0), 0, digits, is_percentile ? 0.3 : 0.4, do_draw_text, !is_crystal ? 2 : 0, 0, is_crystal ? -.75 : .25);
      }
    }
  }
}

module deltohedron_text(height, angle, text_depth, text_push, text_offset, digits, height_multiplier, do_draw_text, add_y_offset, sprue_offset_x = 0, sprue_offset_y = 0) {
  rotate([0, 0, 72]) // makes numbers right side up
    for (i = [0:4]) { 
      rotate([0, 0, 72 * i])
        rotate([angle, 0, 0]) {
          index = i * 2 + text_offset;
          deltohedron_text_pair(height, text_depth, digits[index + 1], digits[index], height_multiplier, do_draw_text, add_y_offset, sprue_offset_x, sprue_offset_y);
        }
    }
}

module deltohedron_text_pair(height, text_depth, digit1, digit2, height_multiplier, do_draw_text, add_y_offset, sprue_offset_x = 0, sprue_offset_y = 0) {
  y_offset = -height_multiplier * font_scale/100 + add_y_offset;
  inset_depth = 0.5 * height - text_depth;

  // Draw top half
  translate([0, y_offset, inset_depth]) {
    extrude_text(digit1, height, height_multiplier, do_draw_text, offset_four_by);
    maybe_add_sprue_hole(digit1, sprue_offset_x, sprue_offset_y);
  }

  // Draw bottom half
  translate([0, -y_offset, -inset_depth]) {
    rotate([0, 180, 180]) {
      extrude_text(digit2, height, height_multiplier, do_draw_text, offset_four_by);
      maybe_add_sprue_hole(digit2, sprue_offset_x, sprue_offset_y);
    }
  }

  module maybe_add_sprue_hole(digit, sprue_offset_x, sprue_offset_y) {
    if (add_sprue_hole && (digit == "1" || digit == "70")) {
      x = sprue_offset_x;
      y = -height / 2.75 + vertical_offset + sprue_offset_y;
      color("black", .9) make_sprue_hole(x, y, 1.5, sprue_diameter, sprue_angle);
    }
  }
}

//------------------------------------------------------------------------------------
//                                       D12
//------------------------------------------------------------------------------------

module draw_d12(face_edge, support_height, do_draw_text) {
  
  height_multiplier = .32;
  face_height = face_edge * 1.42;
  z_translation = !generate_base ? face_edge * 0.89347 + support_height : 17;
  point_down_if_printing = !generate_base ? [-37.3775, 0, 0] : [-127.3775, 0, 0];
  
  if (generate_base) {
    render_shape(5, face_edge / 2 -1);
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
        render_supports(width, height, support_height, 3);
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
    deltohedron_text_pair(height, extrude_depth, "12", "1", height_multiplier, do_draw_text, 0, -height * height_multiplier * 0.5, height * height_multiplier * 1.33);

  deltohedron_text(height, slope, extrude_depth, 0, height/80, digits, height_multiplier, do_draw_text, 0); //
}

//------------------------------------------------------------------------------------
//                                       D20
//------------------------------------------------------------------------------------

module draw_d20(face_edge, support_height, do_draw_text) {
  
  z_translation = !generate_base ? face_edge * 0.9878 + support_height : 23;
  face_height = face_edge * 1.56995960338;
  point_down_if_printing = [0, 0, 0]; //!generate_base ? [35.264, 13.285, 18] : [35.264, 13.285, 18];
  
  if (generate_base) {
    rotate([0, 0, 180])
      render_shape(3, face_edge - 2, triangle_height(face_edge) - 2);
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
      width = face_edge * 1.53;
      height = face_edge * .5465;
      rotate([0, 0, 90])
        render_supports(width, height, support_height, 5);
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
        z_offset = 0.5 * height - 1;

        rotate([0, 0, 39])
          translate([0, y_offset, z_offset]) {
            if (d20_replace_digit > 0 && str(d20_replace_digit) == digit && d20_svg_file != "") {
              svg_scale_multiplier = .45 / 10000;
              render_svg(d20_svg_file, d20_face_rotation, svg_scale_multiplier * d20_face_scale * height, 4 * (d20_face_offset + height_multiplier * d20_face_scale / 100));
            } else {
              extrude_text(digit, height, (digit == "20") ? height_multiplier * d20_face_scale / 100 : height_multiplier, do_draw_text, offset_four_by);
            }

            if (add_sprue_hole && digit == "1") {
              x_offset = -height * 0.2 + sprue_diameter / 2 + 1;
              y_offset = -triangle_height(height) * 0.15 + sprue_diameter / 2 + 1;
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
module render_svg(svg_file, svg_rotation, svg_scale, svg_offset, do_draw_text = true) {
 if (do_draw_text) {
     if (show_bounding_box) {
      extrude_it();
      %bounding_box() extrude_it();
    } else 
      extrude_it();
  }

  module extrude_it() {
    echo("rendering", svg_file);
    translate([0, svg_offset, -extrude_depth + 1])
      rotate([0, 0, svg_rotation])
        scale([svg_scale, svg_scale, 1])
          linear_extrude(height = extrude_depth + 1)
            import(svg_file, center = true);
      echo("rendered", svg_file);
  }
}

module extrude_text(some_text, height, multiplier, do_draw_text, offset_four) {
 if (do_draw_text) {
    if (show_bounding_box) {
      echo("extrude_text", some_text, height, multiplier, vertical_offset*multiplier);
      extrude_it();
      %bounding_box() extrude_it();
    } else
      extrude_it();
  }

  module extrude_it() {
    size = height * multiplier * font_scale / 100;
    x = (some_text == "4") ? offset_four : 0;
    translate([x, vertical_offset * multiplier, -extrude_depth + 1])
      linear_extrude(height = extrude_depth + 1)
        text(some_text, size = height * multiplier * font_scale / 100, valign="center", halign="center", font=font);
  }
}

module render_base(base_file, ratio, draw_stand = false) {
  echo("render_base", base_file, ratio);

  translate([0, 0, draw_stand ? 5 : 0])
    scale([ratio, ratio, ratio])
      import(base_file);
}

module render_shape(num, width, height, is_crystal = -1) {

  color("gray")
    translate([0, 0, 5])
      rotate([180, 0, 0])
        import("bases/base.stl");

  if (num == 3)
    render_polygon([[0, height/2], [width/2, -height/2], [-width/2, -height/2], [0, height/2]]);

  else if (num == 4) {
    if (is_crystal != -1) {
      y_top = (is_crystal ? .26 : .221) * width;
      y_bottom = (is_crystal ? 1.02 : .88) * width;
      x_side = (is_crystal ? .37 : .44) * width;
      render_polygon([[0, -y_top], [x_side, 0], [0, y_bottom], [-x_side, 0], [0, -y_top]]);

    } else
      render_polygon([[-width/2, height/2], [width/2, height/2], [width/2, -height/2], [-width/2, -height/2], [-width/2, height/2]]);

  } else
    render_polygon(pentagon(width));

  module render_polygon(points) {
  color("white")
    translate([0, 0, 7])
      linear_extrude(height = 5, center = true) 
        polygon(points = points);
  }
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

