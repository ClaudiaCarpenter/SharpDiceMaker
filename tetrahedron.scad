die_color = "purple";
support_color = "#EFEFEF";

tetrahedron(50, 5);

module tetrahedron(length, support_offset = 0) {
 height = triangle_height(length);

 color(die_color) 
   translate([0, 0, height + support_offset]) 
    rotate([0, 180, 30]) 
      translate([-length/2, -height/3, 0])
        polyhedron(
          points = [
            [0, 0, 0], // base
            [length, 0, 0],
            [length/2, height, 0],
            [length/2, height/3, height]
          ],
          faces = [
            [0, 1, 2], // base
            [0, 2, 3], // left face
            [1, 3, 2], // right face
            [0, 3, 1]  // front face
          ]
        );
  
  if (support_offset > 0)
    tetrahedron_supports(length, height, support_offset);
}

module tetrahedron_support(length, height, depth, support_offset = 0) {
  
  midpoint = triangle_midpoint(length);
  
  points = [
      [0, 0],                               // lower left
      [0, support_offset],                  // upper left
      [midpoint, height + support_offset],  // upper right 
      [midpoint, 0]                         // lower right
  ];

  color(support_color) 
    rotate([90, 0, 0]) 
      linear_extrude(height=depth, center = true) 
        polygon(points = points);
}


module tetrahedron_base(length, height, width) {
  
  midpoint = triangle_midpoint(length);
  
  points = [
      [0, 0],         // lower left
      [0, 1],         // upper left
      [midpoint, 1],  // upper right 
      [midpoint, 0]   // lower right
  ];

  color(support_color) 
    rotate([90, 0, 0]) 
      linear_extrude(height = width, center = true) 
        polygon(points = points);
}


module tetrahedron_supports(length, height, support_offset) {
  // thin support that touches the die
  rotate([0, 0, 0]) tetrahedron_support(length, height, 0.2, support_offset);
  rotate([0, 0, 120]) tetrahedron_support(length, height, 0.2, support_offset);
  rotate([0, 0, 240]) tetrahedron_support(length, height, 0.2, support_offset);

  // thicker support added for stability
  offset_height = height - 2 * support_offset / 3;
  rotate([0, 0, 0]) tetrahedron_support(length, offset_height, 1, 0);
  rotate([0, 0, 120]) tetrahedron_support(length, offset_height, 1, 0);
  rotate([0, 0, 240]) tetrahedron_support(length, offset_height, 1, 0);
  
  // support raft that sits on the bed
  rotate([0, 0, 0]) tetrahedron_base(length, height, support_offset);
  rotate([0, 0, 120]) tetrahedron_base(length, height, support_offset);
  rotate([0, 0, 240]) tetrahedron_base(length, height, support_offset);  
}

function triangle_height(edge_length) = edge_length * sqrt(3) / 2;
function triangle_midpoint(edge_length) = edge_length * sqrt(3) / 3;