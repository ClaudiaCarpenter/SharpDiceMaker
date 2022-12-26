module dodecahedron(height, slope, cutoff) {
    intersection() {
        // Make a cube
        cube([2 * height, 2 * height, cutoff * height], center = true); 

        // Loop i from 0 to 4, and intersect results
        intersection_for(i = [0:4]) { 
            // Make a cube, rotate it 116.565 degrees around the X axis,
            // then 72 * i around the Z axis
            rotate([0, 0, 72 * i])
            rotate([slope, 0, 0])
            cube([2 * height, 2 * height, height], center = true); 
        }
    }
}

module deltohedron(height, angle) {
    cut_modifier = 1.43;
    
    rotate([48, 0, 0])
    intersection() {
        dodecahedron(height, angle, 2);
        
        if (cut_corners)
            cylinder(
                d=cut_modifier*height,
                h=1.38*height,
                center = true);
    }
}

module octahedron(height) {
    intersection() {
        // Make a cube
        cube([2 * height, 2 * height, height], center = true); 

        intersection_for(i = [0:2]) { 
            // Make a cube, rotate it 109.47122 degrees around the X axis,
            // then 120 * i around the Z axis
            rotate([109.47122, 0, 120 * i])
              cube([2 * height, 2 * height, height], center = true); 
        }
    }
}


w=-15.525;
module icosahedron(height) {
    intersection() {
        octahedron(height);

        rotate([0, 0, 60 + w])
            octahedron(height);

        intersection_for(i = [1:3]) { 
            rotate([0, 0, i * 120])
            rotate([109.471, 0, 0])
            rotate([0, 0, w])
            octahedron(height);
        }
    }
}

module tetrahedron(height, makeHollow = false) {

  if (makeHollow)
    difference() {
      draw_shape();
      translate([0, 0, -.0025])
        draw_shape();
    }
  else
    draw_shape();

  module draw_shape() {
    scale([height, height, height]) {
        polyhedron(
            points = [
                [-0.288675, 0.5, /* -0.27217 */ -0.20417],
                [-0.288675, -0.5, /* -0.27217 */ -0.20417],
                [0.57735, 0, /* -0.27217 */ -0.20417],
                [0, 0, /* 0.54432548 */ 0.612325]
            ],
            faces = [
                [1, 2, 0],
                [3, 2, 1],
                [3, 1, 0],
                [2, 3, 0]
            ]
        );
    }
  }
}

include <BOSL2/std.scad>
include <BOSL2/shapes.scad>
include <BOSL2/polyhedra.scad>

module crystal(face_edge, body_length, end_height, makeHollow = false, add_sprue, sprue_diameter = 2, sprue_angle = 0) {
  echo("crystal", face_edge, body_length, end_height, makeHollow, add_sprue, sprue_diameter, sprue_angle);

  if (!makeHollow)
    difference() {
      cuboid([face_edge, body_length, face_edge]);
      if (add_sprue) {
        echo("add_sprue", -face_edge/4, body_length/4, 0, sprue_diameter, sprue_angle);
        make_sprue_hole(-3, sprue_on_high ? 3.5 : -3.5, sprue_on_high ? -3: 3, sprue_diameter);
      }
    }

  translate([0, -body_length / 2, 0])
    rotate([90, 90, 0]) {
      if (makeHollow) {
        difference() {
          prismoid([face_edge, face_edge], [0, 0], h=end_height);
          translate([0, 0, -.0025])
            prismoid([face_edge, face_edge], [0, 0], h=end_height);
        }
      } else
        difference() {
          prismoid([face_edge, face_edge], [0, 0], h=end_height);
        }
    }

  if (!makeHollow) 
    mirror([0, 1, 0])
      translate([0, -body_length / 2, 0])
        rotate([90, 90, 0])
          prismoid([face_edge, face_edge], [0, 0], h=end_height);
}

module trigonal_trapezohedron(face_edge, angle=33, makeHollow = false, add_sprue, sprue_diameter = 2, sprue_angle = 0) {
  echo("trigonal_trapezohedron", face_edge, makeHollow, add_sprue, sprue_diameter, sprue_angle);

  if (makeHollow)
    difference() {
      draw_shape();
      translate([0, 0, -.0025])
        draw_shape();
    }
  else
   draw_shape();

  module draw_shape() {
    regular_polyhedron("trapezohedron",faces=6, d=face_edge, h=face_edge, anchor=BOTTOM);
  }

}

//------------------------------------------------------------------------------------
//                                    SPRUE
//------------------------------------------------------------------------------------

module make_sprue_hole(x_offset, y_offset, z_offset, diameter, angle = 0, height = 8) {
  echo("make_sprue_hole", x_offset, y_offset, z_offset, diameter, angle, height);
  color("blue")
    translate([x_offset, y_offset, z_offset])
      rotate([angle, 0, 0])
        cylinder(h = height, r1 = diameter * 0.5, r2 = diameter * 0.5, center = true, $fn = diameter * 25);
}

module generate_sprue(hole_diameter) {
  height_tip = 2;
  height_trans = 20;
  height_body = 6;
  width_body = hole_diameter / 2 * 3;

  scale([0.95, 0.95, 1]) { // wiggle room
    translate([0, 0, height_body + height_trans])
      cylinder(h = height_tip, r1 = hole_diameter * 0.5, r2 = hole_diameter * 0.5, center = false, $fn = hole_diameter * 25);

    translate([0, 0, height_body])
      cylinder(h = height_trans, r1 = width_body, r2 = hole_diameter * 0.5, center = false, $fn = hole_diameter * 25);

    translate([0, 0, 0])
      cylinder(h = height_body, r1 = width_body, r2 = width_body, center = false, $fn = hole_diameter * 25);
  }
}

//------------------------------------------------------------------------------------
//                               BASES FOR MOLDING
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
module render_base(length, height, width, support_offset = 0) {
  
  midpoint = triangle_midpoint(length);
  size = length / 2;
  
  base_length = midpoint;
  points = [
      [0, 0],         
      [0, base_height],         
      [base_length, base_height], 
      [base_length, 0]
  ];

  color(support_color) 
    rotate([90, 0, 0]) 
      linear_extrude(height = size, center = true) 
        polygon(points = points);
}

//------------------------------------------------------------------------------------
//                                SUPPORTS FOR PRINTING
//------------------------------------------------------------------------------------
base_height = 2;
support_color = "LightSlateGray";

module render_supports(width, height, support_offset, num = 3) {
  rotate_by = 360 / num;

  depth = .1;
  num_steps = 5;
  steps_height = support_offset / num_steps;

  color("white") 
    for (i = [0 : num])
      rotate([0, 0, i * rotate_by]) 
        translate([-depth, 0, 0])
          render_support(width + depth, height + depth, supports_connecting_width, support_offset);

  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) {
      for (j = [1 : num_steps])
        translate([0, 0, -1])
          render_support(width, height-j, supports_connecting_width*(j+1), support_offset - j * .5);
    }      
}

//------------------------------------------------------------------------------------
module render_support(length, height, depth, support_offset = 0) {
  midpoint = triangle_midpoint(length);

  triangle_points = [
      [0, 0],                               // lower left
      [0, support_offset],             // upper left
      [midpoint, height + support_offset],  // upper right 
      [midpoint, 0]                         // lower right
  ];

  rotate([90, 0, 0]) 
    linear_extrude(height=depth, center = true)
        polygon(points = triangle_points);

}

module render_raft(length, support_offset, num) {
  rotate_by = 360 / num;
  raft_width = 3;
  raft_length = length * .6;

  // short, fat fin that touches the plate
  color(support_color) 
    for (i = [0 : num])
      rotate([0, 0, i * rotate_by]) 
        translate([0, -raft_width/2, 0])
          cube(size = [raft_length, raft_width, supports_raft_height], center = false);
}

function triangle_height(edge_length) = edge_length * sqrt(3) / 2;
function triangle_edge(height) = height / sqrt(3) * 2;
function triangle_midpoint(edge_length) = edge_length * sqrt(3) / 3;
