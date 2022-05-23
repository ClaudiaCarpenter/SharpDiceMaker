// supports_connecting_width = .15;

//------------------------------------------------------------------------------------
//                                SUPPORTS FOR PRINTING
//------------------------------------------------------------------------------------

module render_snap_off_supports(length, height, support_offset = 3, num = 3) {

  rotate_by = 360 / num;
  width = 1;

  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) 
      render_support(length, height, support_offset);
 }

//------------------------------------------------------------------------------------

function triangle_either_side(hypotenuse, side) = sqrt(hypotenuse * hypotenuse - side * side);

function triangle_height(hypotenuse) = hypotenuse * sqrt(3) / 2;
function triangle_midpoint(hypotenuse) = hypotenuse * sqrt(3) / 3;

function triangle_angle_from_width(hypotenuse, width) = acos(width / hypotenuse);
function triangle_angle_from_height(hypotenuse, height) = asin(height / hypotenuse);

function triangle_width_from_hypotenuse_angle(angle, hypotenuse) = cos(angle) * hypotenuse;
function triangle_width_from_angle(angle, height) = tan(angle) * height;
function triangle_height_from_angle(angle, width) = tan(angle) * width;

module render_support(hypotenuse, height, support_offset = 0) {
  width = triangle_either_side(hypotenuse, height);
  angle = triangle_angle_from_width(hypotenuse, width);

  num_supports = floor(width * 1.05);
  spacing = width / num_supports;

color("pink")
  for (i = [0 : num_supports]) {
    x = i * spacing;
    y = triangle_height_from_angle(angle, x) + .1;
    
    translate([x, 0, 0]) {
      cylinder(h = y + support_offset, r1 = .1, r2 = .1, $fn = 50, center = false);
      cylinder(h = y - 1.5 + support_offset, r1 = .30, r2 = .15, $fn = 25, center = false);
      //cylinder(h = 1, r1 = .65, r2 = .65, $fn = 25, center = false);
    }
  }
}



module render_support_square(length, height, depth, support_offset = 0, y_start = 0) {
  right_side = triangle_midpoint(length);
  num_supports = 20;
  
  triangle_points = [
      [0, y_start],                         // lower left
      [0, support_offset + .1],             // upper left
      [right_side, height + support_offset],  // upper right 
      [right_side, y_start]                   // lower right
  ];

  width = right_side / (3 * num_supports);
  clipping_points = [
    [0, 0],
    [0, support_offset + height],
    [width*2, support_offset + height],
    [width*2, 0]
  ];

  rotate([90, 0, 0]) {
    difference() {
      color("lightcyan") 
        linear_extrude(height = depth, center = true) 
          polygon(points = triangle_points);
      
    extrude_width = 2;
      color("white")
        union() 
          for (i = [0 : num_supports]) {
            translate([i * 3 * width, 0, -extrude_width/2])
              linear_extrude(height = extrude_width, center = false)
                polygon(points = clipping_points);
          }
     } 
  }
}

//------------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------------
//                                    SPRUE
//------------------------------------------------------------------------------------

module make_sprue_hole(x_offset, y_offset, z_offset, hole_diameter, angle = 0) {
  translate([x_offset, y_offset, z_offset])
    rotate([angle, 0, 0])
      cylinder(h = 5, r1 = hole_diameter * 0.5, r2 = hole_diameter * 0.5, center = true, $fn = hole_diameter * 25);
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

module render_base(length, height, width, support_offset = 0) {
  midpoint = triangle_midpoint(length);
  size = length / 2;
  base_height = 2;
  
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

