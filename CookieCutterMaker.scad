one_inch = 25.4;
half_inch = one_inch / 2;
quarter_inch = one_inch / 4;
eighth_inch = one_inch / 8;

image_scale = 0.5;
step_scale = 0.01;

show_grid = true;
grid_size = 200;
offset_grid_x = 0;
offset_grid_y = 0;

show_handle = true;
offset_foreground_x = 0;
offset_foreground_y = 0;

if (show_grid)
  intersection() {
    render_svg("./background.svg", image_scale - step_scale, one_inch + half_inch, quarter_inch);
      translate([offset_grid_x, offset_grid_y, 0])
        render_grid(grid_size, 1, 4, 1);
  }

difference() {
  union() {
    for (i = [0:3])
      render_svg("./background.svg", image_scale + i * step_scale, one_inch - i * quarter_inch);
    
    if (show_handle)
      render_svg("./background.svg", image_scale + 0.1, eighth_inch);
  }
  render_svg("./background.svg", image_scale - step_scale, one_inch + half_inch, quarter_inch);
}

translate([offset_foreground_x, offset_foreground_y, 0])
  render_svg("./foreground.svg", image_scale, one_inch);
  
//------------------------------------------------------------------------------------
//                               Text / Image Utils
//------------------------------------------------------------------------------------
show_bounding_box = false;

module render_svg(image_file, image_scale, extrude_depth, z_offset = 0) {
  if (show_bounding_box) {
    extrude_it();
    %bounding_box() extrude_it();
  } else
    extrude_it();

  module extrude_it() {
    scale([image_scale, image_scale, 1])
      translate([0, 0, -z_offset])  
        linear_extrude(height = extrude_depth + 1)
          import(image_file, center = true);
  }
}

module render_grid(length, thickness, separation, depth) {
  num_across = floor(length / (thickness + separation));
  
  render_it();
  rotate([0, 0, 90])
    render_it();
  
  module render_it() {
    offset_origin = length / 2;
    translate([-offset_origin, 0, 0])
    for (i = [0 : num_across]) { 
      x = i * (thickness + separation);
      translate([x, 0, 0]) {
        cube(size = [thickness, length, depth], center = true);
      }
    }
  }
}

module extrude_text(some_text, height, multiplier, potential_font ="") {
  if (show_bounding_box) {
    extrude_it();
    %bounding_box() extrude_it();
  } else
      extrude_it();

  module extrude_it() {
    translate([0, vertical_offset*multiplier, -extrude_depth + 1])
      linear_extrude(height = extrude_depth + 1)
        text(some_text, size = height * multiplier * font_scale / 100, valign="center", halign="center", font=(len(potential_font) > 0 ? potential_font : font));
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

module ruler(length, ruler_color)
{
    mark_width = 0.125;
    mark_depth = .5;

    difference()
    {
        color(ruler_color) cube( [.5, length, 8 ] );
      
        for ( i = [1:length-1] )
        {
            translate( [mark_depth, i, 0] ) color("white") cube( [1, mark_width, 3 ] );
            translate( [-mark_depth, i, 0] ) color("white") cube( [1, mark_width, 3 ] );
            if (i % 5 == 0)
            {
                translate( [mark_depth, i, 0] ) color("white") cube( [5, mark_width, 5 ] );
                translate( [-mark_depth, i, 0] ) color("white") cube( [5, mark_width, 5 ] );
            }
            if (i % 10 == 0)
            {
                translate( [mark_depth, i, 0] ) color("white") cube( [10, mark_width, 7 ] );
                translate( [-mark_depth, i, 0] ) color("white") cube( [10, mark_width, 7 ] );
            }
        }
    }
}