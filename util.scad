//------------------------------------------------------------------------------------
//                               Text / Image Utils
//------------------------------------------------------------------------------------
module render_svg(svg_file, svg_rotation, svg_scale, svg_offset, do_draw_text = true) {
 if (do_draw_text) {
     if (show_bounding_box) {
      extrude_it();
      %bounding_box() extrude_it();
    } else 
      extrude_it();
  }

  module extrude_it() {
    echo("rendering", svg_file);
    translate([0, svg_offset, -extrude_depth + 1])
      rotate([0, 0, svg_rotation])
        scale([svg_scale, svg_scale, 1])
          linear_extrude(height = extrude_depth + 1)
            import(svg_file, center = true);
    echo("rendered", svg_file);
  }
}

// concatenate multiple strings
function join( arr, sp="", _ret="", _i=0)= (
  _i<len(arr)?
      join( arr, sp=sp
          , _ret= str(_ret,_i==0?"":sp,arr[_i])
          , _i=_i+1 )
  :_ret
);

module extrude_text(some_text, font_scale, vertical_offset, height, multiplier, do_draw_text, offset_four, extrude_multiplier = 1) {
  if (svg_overlay) {
    render_svg(svg_overlay, 0, 1, svg_path_offset, do_draw_text);
  }

  if (svg_path) {
    extension = len(search(".", some_text)) == 0 ? ".svg" : "svg";
    svg_file = join([svg_path, "/", some_text, extension]);
    render_svg(svg_file, 0, 1, svg_path_offset, do_draw_text);
  } else {
    if (do_draw_text) {
      if (show_bounding_box) {
        extrude_it();
        %bounding_box() extrude_it();
      } else
        extrude_it();
    } else echo("Skipping text");
  }

  module extrude_it() {
    depth = make_face_text_deeper ? extrude_depth * extrude_multiplier : extrude_depth;
    size = height * multiplier * font_scale / 100;
    has_period = len(search(".", some_text)) > 0;
    two_digits = len(some_text) == 2 && !has_period;
    is_twenty = some_text == "20";
    spacing = two_digits && !has_period && !is_twenty? double_digit_spacing : two_digits && is_twenty ? double_digit_spacing_20 : 1;

    x = (some_text == "4") ? offset_four : (has_period ? period_spacing / 3: (two_digits ? 2*(spacing - 1) : 0));

    // echo("rendering text: ", some_text, size, height, multiplier);
    translate([x, vertical_offset * multiplier, -depth + 1])
      linear_extrude(height = depth + 1)
        text(text = some_text, size = size, valign = "center", halign = "center", spacing = spacing, font = font);
  }
}

module add_face_border() {
  linear_extrude(5, convexity = 2)
    difference() {
        pHeart(xy = 78, off = 2);
        pHeart(xy = 78, off = 0.4);
    }
}
//------------------------------------------------------------------------------------
//                              Bases
//------------------------------------------------------------------------------------
module render_base() {
  color("gray")
    rotate([0, 0, 90])
      //translate([0, 11.5, -2])
         import("bases/round_base.stl");
}

module render_shape_from_stl(stl_file, offset_x, offset_y, offset_z = 0) {
  render_base();

  color("white")
    translate([offset_x, offset_y, offset_z])
    rotate([1.5, 5, 45])
        import(stl_file);
}

module render_shape(num, width, height, offset_x = 0, offset_y = 0, is_crystal = -1) {
  // render_base();

  if (num == 3)
    render_polygon([[0, height/2], [width/2, -height/2], [-width/2, -height/2], [0, height/2]], offset_x, offset_y);

  else if (num == 4) {
    if (is_crystal != -1) {
      y_top = (is_crystal ? .26 : .221) * width;
      y_bottom = (is_crystal ? 1.02 : .88) * width;
      x_side = (is_crystal ? .37 : .44) * width;
      render_polygon([[0, -y_top], [x_side, 0], [0, y_bottom], [-x_side, 0], [0, -y_top]], offset_x, offset_y);

    } else
      render_polygon([[-width/2, height/2], [width/2, height/2], [width/2, -height/2], [-width/2, -height/2], [-width/2, height/2]], offset_x, offset_y);

  } else
    render_polygon(pentagon(width), offset_x, offset_y);

  module render_polygon(points, offset_x = 0, offset_y = 0) {
    if (generate_base_shape) {
            polygon(points = points);
    } else {
      color("white")
        translate([offset_x, offset_y, 0])
          chamfer_extrude(height = 5, angle = 30, center = true) 
            polygon(points = points);
    }
  }
}

//------------------------------------------------------------------------------------
//                               Debug
//------------------------------------------------------------------------------------
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

// http://scruss.com/blog/2019/02/24/symmetric-chamfered-extrusion-in-openscad/

module chamfer_extrude(height = 2, angle = 10, center = true) {
    /*
       chamfer_extrude - OpenSCAD operator module to approximate
        chamfered/tapered extrusion of a 2D path
    
       (C) 2019-02, Stewart Russell (scruss) - CC-BY-SA
    
       NOTE: generates _lots_ of facets, as many as
    
            6 * path_points + 4 * $fn - 4
    
       Consequently, use with care or lots of memory.
    
       Example:
            chamfer_extrude(height=5,angle=15,$fn=8)square(10);
    
       generates a 3D object 5 units high with top surface a
        10 x 10 square with sides flaring down and out at 15
        degrees with roughly rounded corners.
    
       Usage:
       
        chamfer_extrude (
            height  =   object height: should be positive
                            for reliable results               ,
            
            angle   =   chamfer angle: degrees                 ,
            
            center  =   false|true: centres object on z-axis [ ,
            
            $fn     =   smoothness of chamfer: higher => smoother
            ]
        ) ... 2D path(s) to extrude ... ;
        
       $fn in the argument list should be set between 6 .. 16:
            <  6 can result in striking/unwanted results
            > 12 is likely a waste of resources.
            
       Lower values of $fn can result in steeper sides than expected.
        
       Extrusion is not truly trapezoidal, but has a very thin
        (0.001 unit) parallel section at the base. This is a 
        limitation of OpenSCAD operators available at the time.
        
    */
    
    // shift base of 3d object to origin or
    //  centre at half height if center == true
    translate([ 0, 
                0, 
                (center == false) ? (height - 0.001) :
                                    (height - 0.002) / 2 ]) {
        minkowski() {
            // convert 2D path to very thin 3D extrusion
            linear_extrude(height = 0.001) {
                children();
            }
            // generate $fn-sided pyramid with apex at origin,
            // rotated "point-up" along the y-axis
            rotate(270) {
                rotate_extrude() {
                    polygon([
                        [ 0,                    0.001 - height  ],
                        [ height * tan(angle),  0.001 - height  ],
                        [ 0,                    0               ]
                    ]);
                }
            }
        }
    }
}

/*
div.ct-subsection.ct-subsection--primary-box
    background: white;
    border-radius: 20px;
    border: 2px solid red;
}
*/