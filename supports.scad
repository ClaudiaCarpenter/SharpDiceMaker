module render_supports(width, height, support_offset, num = 3) {
  rotate_by = 360 / num;
  
  // thin support that touches the die
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) render_support(width, height, 0.2, support_offset);

  // thicker support added for stability, offset by enough space to cut cleanly
  offset_height = height - 2;
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) render_support(width, offset_height, 1, 0);
  
  // support raft that sits on the bed
  for (i = [0 : num])
    rotate([0, 0, i * rotate_by]) render_base(width, height, support_offset);
}

support_color = "#EFEFEF";
module render_support(width, height, depth, support_offset = 0) {
  midpoint = triangle_midpoint(width);
  
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

module render_base(width, height, width) {
  midpoint = triangle_midpoint(width);
  
  points = [
      [0, 0],         // lower left
      [0, 2],         // upper left
      [midpoint, 2],  // upper right 
      [midpoint, 0]   // lower right
  ];

  color(support_color) 
    rotate([90, 0, 0]) 
      linear_extrude(height = width, center = true) 
        polygon(points = points);
}

function triangle_height(edge_width) = edge_width * sqrt(3) / 2;
function triangle_midpoint(edge_width) = edge_width * sqrt(3) / 3;
