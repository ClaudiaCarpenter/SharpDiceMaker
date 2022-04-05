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

//------------------------------------------------------------------------------------
//                                  BASES FOR MOLDING
//------------------------------------------------------------------------------------
module regular_polygon(order = 4, r = 1){
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
     polygon(coords);
 }

//------------------------------------------------------------------------------------
//                                SUPPORTS FOR PRINTING
//------------------------------------------------------------------------------------
base_height = 2;
support_color = "black";

module render_supports(length, height, support_offset, num = 3, add_tall_supports = false) {
  rotate_by = 360 / num;
  
  // thin fin that touches the die
  color(support_color, 1) 
    for (i = [0 : num])
      rotate([0, 0, i * rotate_by]) 
        render_support(length, height+.1, 0.2, support_offset);

  // step-wise, angled taper for added stability
  color(support_color, .5) 
    for (i = [0 : num])
      rotate([0, 0, i * rotate_by]) {
        for (j = [0 : 5])
          translate([0, 0, -1])
            render_support(length, height-j, 0.2*(j+1), support_offset);
      }
      
  // support raft that sits on the bed plus extension for the D12
  if (add_tall_supports)
    color(support_color, 0.5) 
      for (i = [0 : num])
        rotate([0, 0, i * rotate_by]) 
          render_base(length, height, support_offset, support_offset, add_tall_supports);
}

//------------------------------------------------------------------------------------
module render_support(length, height, depth, support_offset = 0) {
  midpoint = triangle_midpoint(length);
  clip_by = .1;
  
  triangle_points = [
      [0, 0],                               // lower left
      [0, support_offset],                  // upper left
      [midpoint, height + support_offset],  // upper right 
      [midpoint, 0]                         // lower right
  ];

  clipping_points = [
      [clip_by, 0],                                   // lower left
      [clip_by, height + support_offset],             // upper left
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

//------------------------------------------------------------------------------------
module render_base(length, height, width, support_offset = 0, add_tall_supports = false) {
  midpoint = triangle_midpoint(length);
  size = length / 2;
  
  base_length = add_tall_supports ? midpoint * 1.5 : midpoint;
  points = [
      [0, 0],         
      [0, base_height],         
      [base_length, base_height], 
      [base_length, 0]
  ];

  color(support_color, .5) 
    rotate([90, 0, 0]) 
      linear_extrude(height = size, center = true) 
        polygon(points = points);

  if (add_tall_supports) {
    render_tall_support(length, height, width, support_offset, base_length);
  }
}

//------------------------------------------------------------------------------------
module render_tall_support(length, height, width, support_offset, base_length) {
  midpoint = length / 2;

  points = [
      [-midpoint / 2, 0],
      [-midpoint / 2, length / 5],
      [midpoint / 2, length / 5],
      [midpoint / 2, 0]
  ];

  tall_top = 5.264*height + support_offset;

  color(support_color) 
    rotate([0, 0, 90]) 
      translate([0, -(base_length), tall_top])
        linear_extrude(height = .2, center = true) 
          polygon(points = points);

  color(support_color) 
    rotate([0, 0, 90]) 
      translate([0, -(base_length), 0])
        linear_extrude(height = (tall_top + .1)) 
        scale([1, .25, 1])
          polygon(points = points);
}

function triangle_height(edge_length) = edge_length * sqrt(3) / 2;
function triangle_midpoint(edge_length) = edge_length * sqrt(3) / 3;

