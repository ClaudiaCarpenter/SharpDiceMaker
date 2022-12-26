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

module deltohedron(height) {
    cut_modifier = 1.43;
    
    rotate([48, 0, 0])
    intersection() {
        dodecahedron(height, d10_angle, 2);
        
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

module crystal(face_edge, body_length, end_height, makeHollow = false) {
  if (!makeHollow) 
    cuboid([face_edge, body_length, face_edge]);

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

module render_snap_off_supports(length, height, support_offset, num = 3) {
  rotate_by = 360 / num;
  width = 1;

  // bar support that touches the edge  
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) {
      render_support_bar(length, height, support_offset);
    }

  // central support that touches the bottom point
  translate([0, 0, support_offset]) cylinder(h=.5, r1=.25, r2=.35, $fn=num, center = false);
  cylinder(h=support_offset + .2, r1=.1, r2=.1, $fn=num, center = false);
  cylinder(h=support_offset - .5, r1=.5, r2=.25, $fn=num, center = false);

  // thin fin that snaps off below the bar
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) 
      render_support(length, height, supports_connecting_width, support_offset);

  // step-wise, angled taper for added stability
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) {
      for (j = [1 : 5])
        translate([0, 0, -1])
          render_support(length, height-j, supports_connecting_width*(j+1), support_offset - j * .5);
    }      

  if (supports_raft) {
    render_raft(length, support_offset, num);
  }
}

//------------------------------------------------------------------------------------
module render_support_bar(length, height, support_offset = 0, center_start = 1) {
  right_side = triangle_midpoint(length);
  diameter = .5;
  clip_by = .1;
  y_offset = .1;
  
  bar_points = [
    [0, support_offset - diameter / 2],     
    [0, support_offset + diameter / 2],
    [right_side, height + support_offset + diameter / 2],
    [right_side, height + support_offset - diameter / 2]
  ];

  clipping_points = [
    [center_start, 0],
    [center_start, height + 10],
    [right_side, height + 10],
    [right_side, 0]
  ];

  rotate([90, 0, 0]) 
    linear_extrude(height = diameter, center = true)
      intersection() {
        polygon(points = bar_points);
        polygon(points = clipping_points);
      }
}

//------------------------------------------------------------------------------------
module render_support(length, height, depth, support_offset = 0, y_start = 0, center_start = 1) {
  midpoint = triangle_midpoint(length);
  clip_by = .1;
  
  triangle_points = [
      [0, y_start],                         // lower left
      [0, support_offset + .1],             // upper left
      [midpoint, height + support_offset],  // upper right 
      [midpoint, y_start]                   // lower right
  ];

  clipping_points = [
      [clip_by + center_start, 0],           // lower left
      [clip_by + center_start, height + support_offset],   // upper left
      [midpoint, height + support_offset],  // upper right 
      [midpoint, 0]                         // lower right
  ];

  rotate([90, 0, 0]) 
    linear_extrude(height=depth, center = true)
      intersection() {
        polygon(points = triangle_points);
        polygon(points = clipping_points);
      }
}

module render_raft(length, support_offset, num) {
  rotate_by = 360 / num;
  raft_width = 5;

  // short, fat fin that touches the plate
  //color(support_color, .75) 
    for (i = [0 : num])
      rotate([0, 0, i * rotate_by]) 
        translate([-raft_width/2, -raft_width/2, -1])
          cube(size = [length/2 + raft_width,  raft_width, 2], center = false);
}

function triangle_height(edge_length) = edge_length * sqrt(3) / 2;
function triangle_midpoint(edge_length) = edge_length * sqrt(3) / 3;

