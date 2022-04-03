module dodecahedron(height,slope,cutoff) {
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
    slope = 132;
    cut_modifier = 1.43;
    
    rotate([48, 0, 0])
    intersection() {
        dodecahedron(height,slope,2);
        
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

module tetrahedron(height) {
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

module render_supports(length, height, support_offset, num = 3, add_tall_supports = false) {
  rotate_by = 360 / num;
  
  // thin support that touches the die
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) render_support(length, height, 0.2, support_offset);

  // thicker support added for stability, offset by enough space to cut cleanly
  offset_height = height - 2;
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) render_support(length, offset_height, 1, 0);
  
  // support raft that sits on the bed
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) render_base(length, height, support_offset, add_tall_supports);
}

support_color = "#EFEFEF";
module render_support(length, height, depth, support_offset = 0) {
  midpoint = triangle_midpoint(length);
  
  points = [
      [0, 0],                               // lower left
      [0, support_offset],                  // upper left
      [midpoint, height + support_offset],  // upper right 
      [midpoint, 0]                         // lower right
  ];

  color(support_color, .8) 
    rotate([90, 0, 0]) 
      linear_extrude(height=depth, center = true) 
        polygon(points = points);
}

module render_base(length, height, width, add_tall_supports = false) {
  midpoint = triangle_midpoint(length);
  
  base_length = add_tall_supports ? midpoint * 1.5 : midpoint;
  points = [
      [0, 0],         
      [0, 2],         
      [base_length, 2], 
      [base_length, 0]
  ];

  color(support_color) 
    rotate([90, 0, 0]) 
      linear_extrude(height = width, center = true) 
        polygon(points = points);

  if (add_tall_supports) {
    render_tall_support(length, height, width);
  }
}

module render_tall_support(length, height, width) {
  midpoint = length / 2;
  
  points = [
      [-midpoint / 2, 0],
      [-midpoint / 2, 2],
      [midpoint / 2, 2],
      [midpoint / 2, 0]
  ];

  tall_top = 1.545*(height + support_offset);
  color(support_color) 
    rotate([0, 0, 90]) 
      translate([0, -length*.9, tall_top])
        linear_extrude(height = .2, center = true) 
          polygon(points = points);

  color(support_color) 
    rotate([0, 0, 90]) 
      translate([0, -.9*length, 0])
        linear_extrude(height = (tall_top + .1)) 
        scale([1, .25, 1])
          polygon(points = points);
}

function triangle_height(edge_length) = edge_length * sqrt(3) / 2;
function triangle_midpoint(edge_length) = edge_length * sqrt(3) / 3;

