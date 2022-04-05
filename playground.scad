render_supports(20, 10, 5, 3);

module render_supports(length, height, support_offset, num = 3, add_tall_supports = false) {
  rotate_by = 360 / num;
  
  intersection() {
    union() {
      // thin fin that touches the die
      for (i = [0 : num])
        rotate([0, 0, i * rotate_by]) 
          render_support(length, height, 0.2, support_offset);

      // step-wise taper for stability
      for (i = [0 : num])
        rotate([0, 0, i * rotate_by]) {
          for (j = [0 : 5])
            translate([0, 0, -.25*j])
              render_support(length, height-j, .2*j, support_offset);
        }
          
      // support raft that sits on the bed
      for (i = [0 : num])
        rotate([0, 0, i * rotate_by]) 
          render_base(length, height, support_offset, support_offset, add_tall_supports);
    }
    cylinder(height + 10, length + 10, length + 10);
  }
}

//------------------------------------------------------------------------------------
support_color = "#EFEFEF";
module render_support(length, height, depth, support_offset = 0) {
  midpoint = triangle_midpoint(length);
  clip_by = .5;
  
  triangle_points = [
      [0, 0],                               // lower left
      [0, support_offset],                  // upper left
      [midpoint, height + support_offset],  // upper right 
      [midpoint, 0]                         // lower right
  ];

  clipping_points = [
      [clip_by, 0],                                   // lower left
      [clip_by, height + support_offset],             // upper left
      [midpoint - clip_by, height + support_offset],  // upper right 
      [midpoint - clip_by, 0]                         // lower right
  ];

  color(support_color, .8) 
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
  size = 2;
  
  base_length = add_tall_supports ? midpoint * 1.5 : midpoint;
  points = [
      [0, 0],         
      [0, 2],         
      [base_length, 2], 
      [base_length, 0]
  ];

  color(support_color) 
    rotate([90, 0, 0]) 
      linear_extrude(height = size, center = true) 
        polygon(points = points);

  if (add_tall_supports) {
    render_tall_support(length, height, width);
  }
}

//------------------------------------------------------------------------------------
module render_tall_support(length, height, width, support_offset = 0) {
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

