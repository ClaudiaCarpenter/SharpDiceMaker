include <PolyDice.scad>
include <fonts.scad>
include <supports.scad>

// spacing=d20_size*1.5;

// if(d2) move(x=spacing,y=-spacing) drawd2();
// if(d3) move(x=-spacing,y=-spacing*2) drawd3();
// if(d4) fwd(spacing) drawd4();
// if(d4c) move(x=-spacing,y=-spacing) drawd4c();
// if(d4i) move(x=spacing,y=-spacing*2) drawd4i();
// if(d4p) fwd(spacing*2) drawd4p();
// if(d6) drawd6();
// if(d8) back(spacing) drawd8();
// if(d10) move(x=-spacing,y=spacing) drawd10();
// if(d00) left(spacing) drawd00();
// if(d12) move(x=spacing,y=spacing) drawd12();
// if(d12r) back(spacing*2) drawd12r();
// if(d20) right(spacing) drawd20();

add_bumpers = true;
draw_face = true;
supports_offset = 3;
bumper_size=0.3;
text_depth=1;
text_font="Amita:style=Bold";

d20_size = 23;
d20_text_size = 19;
right(spacing) draw_d20(d20_size, supports_offset);

//d20_size = 23;
//d20_text_size = 19;

spacing=d20_size*1.5;

draw_d6(d6_size, supports_offset);


//------------------------------------------------------------------------------------
//                                      d4
//------------------------------------------------------------------------------------

module draw_d4(face_edge, support_height, do_draw_text) {
  d4_body_length = 1.25 * face_edge;
  pointy_end_height = face_edge / 1.25;
  die_height = d4_body_length + pointy_end_height * 2;

  z_translation = !generate_base ? die_height / 2 + support_height : 1.55*face_edge;
  point_down_if_printing = !generate_base ? [90, 0, 0] : [45, 0, 0];
  
  shape_rotation = [30.663, 22.5083, 30.2];
//  z_translation = d20_size * .629204 + support_height;
  translate ([0, 0, z_translation])
    rotate(shape_rotation)
      //color("white")
        drawd4c();
//
  if (support_height > 0) {
      width = face_edge * .66;
      height = triangle_height(face_edge/2) * .805;
      rotate([0, 0, 45])
        render_snap_off_supports(width, height, support_height, 5);
  }

}


//------------------------------------------------------------------------------------
//                                       D6
//------------------------------------------------------------------------------------

module draw_d6(face_edge, support_height, do_draw_text) {

  die_height = face_edge * sin(60);    
  shape_rotation = [45, atan(1/sqrt(2)), 0];
  z_translation = die_height + support_height;
  
  translate ([0, 0, z_translation])
    rotate(shape_rotation)
      //color("white")
        drawd6();

  if (support_height > 0) {
      width = triangle_width_from_hypotenuse_angle(40, face_edge) * 1.3;
      height = width * .57;
    echo(face_edge, width, height);
//      width = sqrt(face_edge * face_edge *2 );
//      height = face_edge * 0.58;
      rotate([0, 0, 60])
        render_snap_off_supports(width, height, support_height, 3);
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
  shape_rotation = [30.663, 22.5083, 21];
  z_translation = d20_size * .629204;
  translate ([0, 0, z_translation])
    rotate(shape_rotation) 
      drawd12();
}

//------------------------------------------------------------------------------------
//                                       D20
//------------------------------------------------------------------------------------

module draw_d20(face_edge, support_height) {
  shape_rotation = [30.663, 22.5083, 30.2];
  z_translation = d20_size * .629204 + support_height;
  translate ([0, 0, z_translation])
    rotate(shape_rotation)
      //color("white")
        drawd20();

  if (support_height > 0) {
      width = face_edge * .66;
      height = triangle_height(face_edge/2) * .805;
      rotate([0, 0, 45])
        render_snap_off_supports(width, height, support_height, 5);
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

