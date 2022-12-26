// /**************************************************************************\
// * This is a customizable core for twisty puzzles.                          *
// *                                                                          *
// * Feel free to adjust it at your needs.                                    *
// * ======================================================================== *
 
///****************************************************************************
//*  GNU © 2016 Tourdetour, thing 1676041.                                              **
//*  Sept 2016:  Added a few things, Mixomycetes                             **
//* Remixed by Mixomycetes  to a n-arm core, thing  http://www.thingiverse.com/thing:17808387                                 **
//*****************************************************************************/
 
/* [Major parametes] */
//Number of arms & Name of the corresponding cornerturning, Archimedean solid.
Number_of_Arms = 8.2; // [1:1-lollipop, 2:2:Bead, 3:3-Triangle, 4:4-Tetrahedron,6:6-Octahedron, 7.1:7-elongated triangular pyramid, 7.2:7-unit equilateral pentagonal prism,7.3:7-Szilassi polyhedron, 7.4:7-pentagonal prism, 8.1:8-Cuboctahedron,8.2:8-Acute golden rombohedron, 12.1:12-rhombic dodecahedron, 20.2:20-Icosahedron, 14:14-Cuboctahedron, 20.1:NOTYET20-dodecahedron, 20.2:20-rhombic dodecahedron,30.1:30-rombic triacontahedron, 99:test] 
// Outer Length of each arm. Measured from an edge to the centre, so fill in half of the total core width!
Length_of_Arm=15; 
//Diameter of the cylinders
Diameter_of_arms=12;
//Diameter of the holes in the cylinders for the screws threads. 
Diameter_of_screwhole=3;
// Outer spherical diameter of the arm endings. If larger than than length_of_arm => ignored. If smaller than length_of_arm, DOUBLE of length of arm, it removes the tips
Diameter_Outer_curvature = 30.1; 
//Inner spherical diameter. This creates an additonal central sphere around the arms (for strength).
Diameter_Inner_Sphere=20; 
/* [Minor parameters] */
//Number of sides to the cylinders (more sides means a higher precision)
set_fn_value = 40; // [20:200]
$fn=set_fn_value; 
/* [Counter-screw?] */
//Make a Counterscrew hole? When 1, This will add holes for a screwhead coming through the centre), only available for 4-arm (tetrahedal) core.
Use_counterscrew=true; // [false:No,true:Yes]
//Make a Counterscrew hole pass through the center, to the other side too? When 'Yes', this will add holes for a screwhead coming through the centre). Only logical for 4-arm (tetrahedal) core. Otherwise use Halve core.
Make_all_through_b=0; // [0:No,1:Yes]
Make_all_through=(Make_all_through_b==1)?true:false; // [false:No,true:Yes]
//Diameter counter screw opening, mm
Diameter_of_ScrewHead_holes=6; 
//Depth of counterscrew hole (beyond the centre into the arm), mm. Note: HALVE of typical diameter values.
Depth_of_ScrewHead_Holes=12; 
/* [Hollow?] */
//Make hollow centre? When 1, This will hollow out the central sphere, with diameter (De)
Make_hollow_b=1; // [0:No,1:Yes]
Make_hollow=(Make_hollow_b==1)?true:false; 
//Diameter of hollow centre, mm. Note. Make this SMALLER than iD...
Diameter_Hollowed_Inner_Shpere=10;
//If Yes, print only halve the part. cut over X-y plane, needs to be glued together. (screw mech will be added later.)
Make_two_halve_spheres_b=1; // [0:No,1:Yes]
Make_two_halve_spheres=(Make_two_halve_spheres_b==1)?true:false;
/* [Development] */
// preview[view:south, tilt:top diagonal]
Make_orientation_blobs_b =1; // [1:Yes,0:No] DEV option. Add dots to show orientation of the arms. (for debugging). Not included in STL.
Make_orientation_blobs =(Make_orientation_blobs_b==1)?true:false;
//xyshrink: Lower the diameter of x and y when it's too loose as it overhangs (change it to 0 if you don't print it with the default rotation). This highly depends on your printer, lower this setting if the x and y holes are too tight and increase it if they are too loose). 
xyshrink=999*1; // Obsolete parameter
// Positioning: Rotation on x axis
xrotat=0; // [0:180]
// Positioning: Rotation on y axis
yrotat=0; // [0:180]
/*[Hidden]*/
// Should be more than Armlength*2
slice_in_two_length=999; 
// margin: A safety setting to prevent surfaces with no thickness (do not change this). min_thickness = 0.1 mm; 
m=0.1*1; 
//the Nth node to use as mirror node for node 0, to define the cutting plane.
blob_distance = Length_of_Arm*sqrt(12)/6;
blob_size = Diameter_of_screwhole;
/* Main */
 // start of program
 
// Generic method, for any implemented vertex layout.
  // Just fill in vertex node positions [xi,yi,zi] in the list vlist.  
 // vertex info available from:
//http://www.wolframalpha.com/input/?i=vertex+rombic+dodecahedron&rawformassumption=%7B%22DPClash%22,+%22PolyhedronP%22,+%22input%22%7D+-%3E+%7B%22VertexCoordinates%22%7D
    echo(Number_of_Arms); 
// TEMPLATE:
if (Number_of_Arms == 999.888){ // 999 = number of vertiches . //888 is number of solid.
// data can be found on http://www.wolframalpha.com/input/?i=vertex+coordinates+name_of_solid   
    // edge_turning
    solid_name = "Arch solid NAME";
    vlist = [v1,v2,v3,etc]; // USED
    nv = 999; // n_vertiches, USED
    ne = 999; // n_edges, not used
    nf = 999;// n_faces, not used
   // actual program: 
    echo(solid_name);
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
//calculate it using nr_mirror_node, or give cutplane_vector as a parameter.
nr_mirror_node = 1; // [1:30]. 
cutplane_vector= cross(vlist.x,vlist[max(1,min(nv-1,nr_mirror_node-1))]); 
// cross product generates a vector perpendicular to two source vectors. If two plane separated vectors are given as input, this is the normal of a symmetry plane(for regular solids).
// as source vectors, node 1 and a predefined node number is used.
    };        
    
  // vertex data from http://www.wolframalpha.com/input/?i=Archimedian+solids&lk=2
    
if (Number_of_Arms == 1){ // 999 = number of vertiches . //888 is number of solid.
// data can be found on http://www.wolframalpha.com/input/?i=vertex+coordinates+name_of_solid   
    // edge_turning
    solid_name = "lollipop";
    vlist = [[0,0,1]]; // USED
    nv = 1; // n_vertiches, USED
    ne = 0; // n_edges, not used
    nf = 0;// n_faces, not used
   // actual program: 
    echo(solid_name);
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
//calculate it, or give it as a para.
nr_mirror_node = 1; // [1:30]. 
cutplane_vector= [1,1,0]; 
// cross product generates a vector perpendicular to two source vectors. If two plane separated vectors are given as input, this is the normal of a symmetry plane(for regular solids).
// as source vectors, node 1 and a predefined node number is used.
    };       
    
    
if (Number_of_Arms == 2){ // 999 = number of vertiches . //888 is number of solid.
// data can be found on http://www.wolframalpha.com/input/?i=vertex+coordinates+name_of_solid   
    // edge_turning
    solid_name = "beadball";
    vlist = [[0,-1,0],[0,1,0]]; // USED
    nv = 2; // n_vertiches, USED
    ne = 0; // n_edges, not used
    nf = 0;// n_faces, not used
   // actual program: 
    echo(solid_name);
nr_mirror_node = 1; // [1:30]. 
cutplane_vector= cross(vlist.x,vlist[max(1,min(nv-1,nr_mirror_node-1))]); 
rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
//calculate it, or give it as a para.
    };       
    
if (Number_of_Arms == 3){ // 999 = number of vertiches . //888 is number of solid.
// data can be found on http://www.wolframalpha.com/input/?i=vertex+coordinates+name_of_solid   
    // edge_turning
    solid_name = "triangle";
    vlist = [[0,0,1],[0,-sqrt(3)/2,-1/2],[0,sqrt(3)/2,-1/2]]; // USED
    nv = 3; // n_vertiches, USED
    ne = 0; // n_edges, not used
    nf = 0;// n_faces, not used
   // actual program: 
//calculate it, or give it as a para.
cutplane_vector= [1,0,0]; 
// cross product generates a vector perpendicular to two source vectors. If two plane separated vectors are given as input, this is the normal of a symmetry plane(for regular solids).
// as source vectors, node 1 and a predefined node number is used.
    echo(solid_name);
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    };       
if (Number_of_Arms == 4){
    // corner turning octahedron
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+octahedron
     a = 1/sqrt(2);
    v1 = [0,0,sqrt(2/3)-1/2/sqrt(6)];     v2 = [-1/2/sqrt(3),-1/2,-1/2/sqrt(6)];    v3 = [-1/2/sqrt(3),1/2,-1/2/sqrt(6)];        v4 = [1/sqrt(3),0,-1/2/sqrt(6)];
   // peak v1 on Z-axis in XY plane. one node (v4) is on Y-axis.
    //plane in between those nodes goes through 0, and (v1-v4) perpend on XY plane, thus with angles 
    cutplane_vector = v1-v4;
    // thus cutplane is on:
    vlist = [v1,v2,v3,v4];
    nv = 4; // 12;   
        
        solid_name = "corner turning tetrahedron";
    echo(solid_name);
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
};
if (Number_of_Arms == 6){
    // corner turning octahedron, face turning cube
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+octahedron
 
    vlist = [[-1/sqrt(2), 0, 0] , [0, 1/sqrt(2), 0] , [0, 0, -1/sqrt(2)] , [0, 0, 1/sqrt(2)] , [0, -1/sqrt(2), 0] , [1/sqrt(2), 0, 0]];
    nv = 6; // 12;   
        
        solid_name = "corner turning cuboctahedron";
    echo(solid_name);
nr_mirror_node = 1; // [1:30]. 
cutplane_vector= vlist[0]-vlist[6]; 
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    }    
    
    
    
if (Number_of_Arms == 7.1){
    // corner turning octahedron, face turning cube
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+heptahedron
    
    vlist =  [[0, 0, 1/3 *(3+sqrt(6))], [-1/(2 *sqrt(3)), -1/2, 0], [-1/(2 *sqrt(3)), -1/2, 1] ,[-1/(2 *sqrt(3)), 1/2, 0] ,[-1/(2 *sqrt(3)), 1/2, 1], [1/sqrt(3), 0, 0], [1/sqrt(3), 0, 1]];
    nv = 7; // 12;   
        
        solid_name = "elongated triangular pyramid ";
    echo(solid_name);
nr_mirror_node = 1; // [1:30]. 
cutplane_vector= cross(vlist.x,vlist[max(1,min(nv-1,nr_mirror_node-1))]); 
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    }    ;
    
if (Number_of_Arms == 7.2){
    // corner turning octahedron, face turning cube
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+heptahedron
    
    vlist =    [[1/(2 *sqrt(5/8-sqrt(5)/8)), 0, -1/2], [1/(2 *sqrt(5/8-sqrt(5)/8)), 0, 1/2], [(-1-sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), -1/2, -1/2], [(-1-sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), -1/2, 1/2], [(-1-sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), 1/2, -1/2], [(-1-sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), 1/2, 1/2], [(-1+sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), -1/2 *sqrt((5/8+sqrt(5)/8)/(5/8-sqrt(5)/8)), -1/2], [(-1+sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), -1/2 *sqrt((5/8+sqrt(5)/8)/(5/8-sqrt(5)/8)), 1/2], [(-1+sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), 1/2 *sqrt((5/8+sqrt(5)/8)/(5/8-sqrt(5)/8)), -1/2], [(-1+sqrt(5))/(8 *sqrt(5/8-sqrt(5)/8)), 1/2 *sqrt((5/8+sqrt(5)/8)/(5/8-sqrt(5)/8)), 1/2]];
    nv = 7; // 12;   
        
        solid_name = "unit equilateral pentagonal prism  ";
    echo(solid_name);
nr_mirror_node = 1; // [1:30]. 
cutplane_vector= cross(vlist.x,vlist[max(1,min(nv-1,nr_mirror_node-1))]); 
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    } ;   
    
    if (Number_of_Arms == 7.3){
    // corner turning octahedron, face turning cube
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+heptahedron
    
    vlist =    
 [[-4.8, 0., 4.8], [-2.8, -1., 0.8], [-2.8, 0., 0.8], [-1.8, 1., 0.8], [-1.5, -1.5, -1.2], [-0.8, 2., -3.2], [0., -5.04, -4.8], [0., 5.04, -4.8], [0.8, -2., -3.2], [1.5, 1.5, -1.2], [1.8, -1., 0.8], [2.8, 0., 0.8], [2.8, 1., 0.8], [4.8, 0., 4.8]];
    nv = 7; // 12;   
        
        solid_name = "Szilassi polyhedron ";
    echo(solid_name);
nr_mirror_node = 1; // [1:30]. 
cutplane_vector= cross(vlist.x,vlist[max(1,min(nv-1,nr_mirror_node-1))]); 
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    } ;  
    if (Number_of_Arms == 7.4){
    // pentagonal prism
        //manual coordinates 
    a = 90-72;
    b = a-72;
            
        vlist =    
 [[0, 0., 1],[ 0,0,-1], //Z-axis
   [1,0,0],
        [sin(a),cos(a),0],[sin(a),-cos(a),0],
        [sin(b),cos(b),0],[sin(b),-cos(b),0]
        ];
    nv = 7; // 12;   
    nf = 7; // 12;   
    ne = 15; // 12;   
        
        solid_name = "face turning pentagonal prism";
    echo(solid_name);
nr_mirror_node = 2; // [1:30]. 
cutplane_vector= [0,0,1]; 
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    } ;  
 
    if (Number_of_Arms == 8.1)
    {
        // corner turning cube, octahedron.
    // http://www.wolframalpha.com/input/?i=vertex+cube&rawformassumption=%7B%22C%22,+%22vertex%22%7D+-%3E+%7B%22PolyhedronProperty%22%7D&rawformassumption=%7B%22DPClash%22,+%22PolyhedronP%22,+%22input%22%7D+-%3E+%7B%22VertexCoordinates%22%7D
    a = 1/2;
    
     v1 = [-a,-a,-a];     v2 = [-a,-a,a];    v3 = [-a,a,-a];  v4 = [-a,a,a];  
    v5 = [a,a,-a];    v6 = [a,-a,-a];  v7 = [a,-a,a];    v8 = [a,a,a];  
    vlist = [v1,v2,v3,v4,v5,v6,v7,v8];
    nv = 8; //8;
   solid_name = "Corner Turning cube";
   rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    };
    
   if (Number_of_Arms == 8.2)
    {
        
        
        // acute golden rhombohedron.
    // Source: http://www.wolframalpha.com/input/?i=6+sided+polyhedron++vertex+coordinates
        
        // acute golden rhombohedron | (-1/2-1/sqrt(5), 1/20 (-5-3 sqrt(5)), root of 1-20 x^2+80 x^4 near x = -0.425325) | (-1/2, 1/4 (1-sqrt(5)), 1/2 sqrt(1/10 (5+sqrt(5)))) | (-1/2, 1/4 (-1+sqrt(5)), root of 1-20 x^2+80 x^4 near x = -0.425325) | (-1/2+1/sqrt(5), 1/20 (5+3 sqrt(5)), 1/2 sqrt(1/10 (5+sqrt(5)))) | (1/2-1/sqrt(5), 1/20 (-5-3 sqrt(5)), root of 1-20 x^2+80 x^4 near x = -0.425325) | (1/2, 1/4 (1-sqrt(5)), 1/2 sqrt(1/10 (5+sqrt(5)))) | (1/2, 1/4 (-1+sqrt(5)), root of 1-20 x^2+80 x^4 near x = -0.425325) | (1/2+1/sqrt(5), 1/20 (5+3 sqrt(5)), 1/2 sqrt(1/10 (5+sqrt(5))))
        
        
    vlist  =  [[-1/2-1/sqrt(5), 1/20 * (-5-3 * sqrt(5)),  -0.425325],[-1/2, 1/4 *(1-sqrt(5)), 1/2 * sqrt(1/10 * (5+sqrt(5)))],[-1/2, 1/4* (-1+sqrt(5)), -0.425325],[-1/2+1/sqrt(5), 1/20 * (5+3 * sqrt(5)), 1/2 * sqrt(1/10 * (5+sqrt(5)))],[1/2-1/sqrt(5), 1/20 * (-5-3 * sqrt(5)), -0.425325],[1/2, 1/4 *(1-sqrt(5)), 1/2 * sqrt(1/10 * (5+sqrt(5)))],[1/2, 1/4 *(-1+sqrt(5)), -0.425325],[1/2+1/sqrt(5), 1/20 * (5+3 * sqrt(5)), 1/2 * sqrt(1/10 * (5+sqrt(5)))]];
        echo(len(vlist));
    nv = 8; //8;
   solid_name = "Acute golden rhombohedron";
rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
  
};
   
if (Number_of_Arms == 8.3){
    // gyrobifastigium
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+octahedron
 
    vlist = [[-1/2, -1/2, 0] , [-1/2, 0, sqrt(3)/2] , [-1/2, 1/2, 0] , [0, -1/2, -sqrt(3)/2] , [0, 1/2, -sqrt(3)/2] , [1/2, -1/2, 0] , [1/2, 0, sqrt(3)/2] , [1/2, 1/2, 0]];
    nv = 8; // n_vertiches
    ne = 14; // n_edges
    nf = 8;// n_faces
  
    
        solid_name = "gyrobifastigium";
    echo(solid_name);
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    }    
if (Number_of_Arms == 12.1){
    // icosahedron
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+icosahedron
     a = 5/sqrt(50-10*sqrt(5));
    b = sqrt(2/(5-sqrt(5)));
    c = 1/(sqrt(10-2*sqrt(5)));
    d = (1+sqrt(5))/(2*sqrt(10-2*sqrt(5)));
    
    v1 = [0,0,-a];     v2 = [0,0,a];    v3 = [-b,0,-c];        v4 = [b,0,c];
    v5 = [d,-1/2,-c];    v6 = [d,1/2,-c]; 
    v7 = [-d,-1/2,c];    v8 = [-d,1/2,c];
v9 = [-(-1+sqrt(5))/(2*sqrt(10-2*sqrt(5))),-1/2*sqrt((5+sqrt(5))/(5-sqrt(5))),-c];   
v10 = [-(-1+sqrt(5))/(2*sqrt(10-2*sqrt(5))),+1/2*sqrt((5+sqrt(5))/(5-sqrt(5))),-c];  
v11 = [-(-1+sqrt(5))/(2*sqrt(10-2*sqrt(5))),-1/2*sqrt((5+sqrt(5))/(5-sqrt(5))),+c];  
v12 = [+(-1+sqrt(5))/(2*sqrt(10-2*sqrt(5))),+1/2*sqrt((5+sqrt(5))/(5-sqrt(5))),+c];      vlist = [v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12];
    nv = 12; // 12;   
        
        solid_name = "corner turning icosahedron";
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    }
    
    
if (Number_of_Arms == 12.2){
    // corner turning cuboctahedron.
    // vertiches info from   http://www.wolframalpha.com/input/?i=vertex+coordinates+cuboctahedron
     a = 1/2;
    b = sqrt(1/2);
    v1 = [-1,0,0];     v2 = [-a,-a,-b];    v3 = [-a,-a,b];        v4 = [-a,a,-b];
    v5 = [-a,a,b];    v6 = [0,-1,0];        v7 = [0,1,0];    v8 = [a,-a,-b];
    v9 = [a,-a,b];    v10 = [a,a,-b];        v11 = [a,a,b];    v12 = [1,0,0];
    vlist = [v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12];
    nv = 12; // 12;          
        solid_name = "corner turning cuboctahedron";
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    }
    
    if (Number_of_Arms == 14.1){
        
        // source of data: http://www.wolframalpha.com/input/?i=12+sided+polyhedron++vertex+coordinates
        solid_name = "rombic dodecahedron";
            nv = 14; // 14;
 vlist= 
    [[-sqrt(2/3), -sqrt(2/3), 0], [-sqrt(2/3), 0, -1/sqrt(3)], [-sqrt(2/3), 0, 1/sqrt(3)], [-sqrt(2/3), sqrt(2/3), 0], [0, -sqrt(2/3), -1/sqrt(3)], [0, -sqrt(2/3), 1/sqrt(3)], [0, 0, -2/sqrt(3)], [0, 0, 2/sqrt(3)], [0, sqrt(2/3), -1/sqrt(3)], [0, sqrt(2/3), 1/sqrt(3)], [sqrt(2/3), -sqrt(2/3), 0], [sqrt(2/3), 0, -1/sqrt(3)], [sqrt(2/3), 0, 1/sqrt(3)], [sqrt(2/3), sqrt(2/3), 0]];
           rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
 
    }
    
    
    if (Number_of_Arms == 20.1){
        // source of data: http://www.wolframalpha.com/input/?i=12+sided+polyhedron++vertex+coordinates
        solid_name = "regular dodecahedron";
            nv = 20; // 14;
 vlist= [[-sqrt(1+2/sqrt(5)), 0, 0.262866],[sqrt(1+2/sqrt(5)), 0,  -0.262866],[ -0.425325, 1/4 *(-3-sqrt(5)),  0.262866],[ -0.425325, 1/4 *(3+sqrt(5)), 0.262866],[sqrt(5/8+11/(8 * sqrt(5))), 1/4 *(-1-sqrt(5)), 0.262866],[sqrt(5/8+11/(8 * sqrt(5))), 1/4 *(1+sqrt(5)), 0.262866],[ -0.262866, 1/4 *(-1-sqrt(5)), sqrt(5/8+11/(8 * sqrt(5)))],[ -0.262866, 1/4 *(1+sqrt(5)),  sqrt(5/8+11/(8 * sqrt(5)))],[-1/2 * sqrt(1+2/sqrt(5)), -1/2,  -1.11352],[-1/2 * sqrt(1+2/sqrt(5)), 1/2, -1.11352],[sqrt(1/4+1/(2 * sqrt(5))), -1/2, sqrt(5/8+11/(8 * sqrt(5)))],[sqrt(1/4+1/(2 * sqrt(5))), 1/2,  sqrt(5/8+11/(8 * sqrt(5)))],[sqrt(1/10 *(5+sqrt(5))), 0,-1.11352],[ -1.11352, 1/4 *(-1-sqrt(5)),-0.262866],[-1.11352, 1/4* (1+sqrt(5)), -0.262866],[-0.850651, 0,  sqrt(5/8+11/(8 * sqrt(5)))],[0.262866, 1/4 *(-1-sqrt(5)), -1.11352],[0.262866, 1/4 *(1+sqrt(5)), -1.11352],[sqrt(1/8+1/(8 * sqrt(5))), 1/4 *(-3-sqrt(5)), -0.262866],[sqrt(1/8+1/(8 * sqrt(5))), 1/4* (3+sqrt(5)), -0.262866]];
           rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    };    
    if (Number_of_Arms == 15.1){
        // source of data: http://www.wolframalpha.com/input/?i=12+sided+polyhedron++vertex+coordinates
        solid_name = "12-pentagonal cupola";
            nv = 15; // 14;
        
 vlist= [[0, 1/2 *(-1-sqrt(5)), 0],[0, 1/2 *(1+sqrt(5)), 0],[sqrt(1/2+1/(2 * sqrt(5))), 0, sqrt(1/10 *(5-sqrt(5)))],[1/2 * sqrt(1/10* (5-sqrt(5))), 1/4 *(-1-sqrt(5)), sqrt(1/10* (5-sqrt(5)))],[1/2 * sqrt(1/10 *(5-sqrt(5))), 1/4 *(1+sqrt(5)),  sqrt(1/10* (5-sqrt(5)))],[-sqrt(5/8+sqrt(5)/8), 1/4 *(-3-sqrt(5)), 0],[-sqrt(5/8+sqrt(5)/8), 1/4 *(3+sqrt(5)), 0],[sqrt(5/8+sqrt(5)/8), 1/4 *(-3-sqrt(5)), 0],[sqrt(5/8+sqrt(5)/8), 1/4 *(3+sqrt(5)), 0],[-sqrt(1/4+1/(2 * sqrt(5))), -1/2, sqrt(1/10 *(5-sqrt(5)))],[-sqrt(1/4+1/(2 * sqrt(5))), 1/2,  sqrt(1/10 *(5-sqrt(5)))],[-sqrt(5/4+sqrt(5)/2), -1/2, 0],[-sqrt(5/4+sqrt(5)/2), 1/2, 0],[sqrt(5/4+sqrt(5)/2), -1/2, 0],[sqrt(5/4+sqrt(5)/2), 1/2, 0]];
           rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    };    
    if (Number_of_Arms == 30.1){
        solid_name = "rhombic triacontahedron";
            nv = 32; // 14;
 vlist= [0, 0, 1/2 *[-1-sqrt(5)] , [0, 0, 1/2 *[1+sqrt(5)]] , [1/10 *[5-sqrt(5)], -0.850651, 1/10 *[5+3 * sqrt(5)]] , [1/10 *[5-sqrt(5)], sqrt(1/10 *[5+sqrt(5)]), 1/10 *[5+3 * sqrt(5)]] , [2/sqrt(5), 0, 1/10 *[5+3 * sqrt(5)]] , [1/10 *[5+3 * sqrt(5)], -0.850651, 1/10 *[5+sqrt(5)]] , [1/10 *[5+3 * sqrt(5)],  -0.850651, 1/10 *[-5+sqrt(5)]] , [1/10 *[5+3 * sqrt(5)], sqrt(1/10 *[5+sqrt(5)]), 1/10 *[5+sqrt(5)]] , [1/10 *[5+3 * sqrt(5)], sqrt(1/10 *[5+sqrt(5)]), 1/10 *[-5+sqrt(5)]] , [-2/sqrt(5), 0, 1/10 *[-5-3 * sqrt(5)]] , [-1/sqrt(5), -sqrt(1+2/sqrt(5)), 1/10 *[5+sqrt(5)]] , [-1/sqrt(5), -sqrt(1+2/sqrt(5)), 1/10 *[-5+sqrt(5)]] , [-1/sqrt(5), sqrt(1+2/sqrt(5)), 1/10 *[5+sqrt(5)]] , [-1/sqrt(5), sqrt(1+2/sqrt(5)), 1/10 *[-5+sqrt(5)]] , [1/sqrt(5), -sqrt(1+2/sqrt(5)), 1/10 *[5-sqrt(5)]] , [1/sqrt(5), -sqrt(1+2/sqrt(5)), 1/10 *[-5-sqrt(5)]] , [1/sqrt(5), sqrt(1+2/sqrt(5)), 1/10 *[5-sqrt(5)]] , [1/sqrt(5), sqrt(1+2/sqrt(5)), 1/10 *[-5-sqrt(5)]] , [-1-1/sqrt(5), 0, 1/10 *[5+sqrt(5)]] , [-1-1/sqrt(5), 0, 1/10 *[-5+sqrt(5)]] , [1/10 *[-5-sqrt(5)], -0.525731, 1/10 *[5+3 * sqrt(5)]] , [1/10 *[-5-sqrt(5)], sqrt(2/[5+sqrt(5)]), 1/10 *[5+3 * sqrt(5)]] , [1/10 *[5+sqrt(5)], -0.525731, 1/10 *[-5-3 * sqrt(5)]] , [1/10 *[5+sqrt(5)], sqrt(2/[5+sqrt(5)]), 1/10 *[-5-3 * sqrt(5)]] , [1+1/sqrt(5), 0, 1/10 *[5-sqrt(5)]] , [1+1/sqrt(5), 0, 1/10 *[-5-sqrt(5)]] , [1/10 *[-5-3 * sqrt(5)], -0.850651, 1/10 *[5-sqrt(5)]] , [1/10 *[-5-3 * sqrt(5)], -0.850651, 1/10 *[-5-sqrt(5)]] , [1/10 *[-5-3 * sqrt(5)], sqrt(1/10 *[5+sqrt(5)]), 1/10 *[5-sqrt(5)]] , [1/10 *[-5-3 * sqrt(5)], sqrt(1/10 *[5+sqrt(5)]), 1/10 *[-5-sqrt(5)]] , [1/10 *[-5+sqrt(5)], -0.850651, 1/10 *[-5-3 * sqrt(5)]] , [1/10 *[-5+sqrt(5)], sqrt(1/10 *[5+sqrt(5)]), 1/10 *[-5-3 * sqrt(5)]]];
           rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
    };    
   if (Number_of_Arms == 99)
    {
    
    vlist = [[1,1, 0] , [0, 1,1] , [1, 0,1] ,[-1,1, 0] , [0, -1,1] , [1, 0,-1]];
    nv = 6; // 12;   
        
        solid_name = "something_weird_testing";
    echo(len(vlist));
        distance = 20;
       rotate([xrotat,yrotat,0])     n_armed_core(vlist,nv,cutplane_vector);
        for (j = [1:len(vlist)-1])
        {
};
  
};
// * All submodules are below *//
// Main sub-program
module n_armed_core(vlist,nv,cutplane_vector)
{
    
// rotate so half is half ball is on XYplane (if Make_two_halve_spheres).
    
fi = atan2(cutplane_vector.y,cutplane_vector.x);
psi = atan2(cutplane_vector.z,sqrt(cutplane_vector.y*cutplane_vector.y+cutplane_vector.x*cutplane_vector.x));
    rotate([fi,+psi,0]){
    
    difference() // This difference makes halve core (if any)
{
    intersection() // substracts large sphere to get spherical arm ends. Make Diameter_Outer_curvature large to avoid this.
    {
        sphere(d=Diameter_Outer_curvature);
difference() // The difference drilLs the holes in the core
{
    
//Cut out the core and screw hole cylinders, each of them rotated in the apropriate direction.
union()
{
    sphere(d=Diameter_Inner_Sphere);
    for( i = [0:nv-1])
    {
        // two angles calculated based on http://electron9.phys.utk.edu/vectors/3Dcoordinates.htm
        
fi = atan2(vlist[i].y,vlist[i].x); // angle between X and Z
psi =atan2(vlist[i].z, sqrt(vlist[i].y*vlist[i].y+vlist[i].x*vlist[i].x));
L= sqrt(vlist[i].x*vlist[i].x+vlist[i].y*vlist[i].y+vlist[i].z*vlist[i].z);// between new vector and Yplane.
//echo(vlist[i]);  
//echo(fi,psi,0);        
        
onearm_nohole(fi,psi+180,180,Diameter_of_arms,Length_of_Arm);
        
if(Make_orientation_blobs) %rotate([0,90,0])translate(vlist[i]/L*blob_distance) sphere(d = blob_size,center= true); // rotate over y to make [0,0,1] face Zaxis
    
    };
};
   union()  // All things below are CUT AWAY.
{
    for( i = [0:nv-1]) // loop over all Arms (vector points)
    {
fi = atan2(vlist[i].y,vlist[i].x); // angle between X and Z
psi =atan2(vlist[i].z, sqrt(vlist[i].y*vlist[i].y+vlist[i].x*vlist[i].x));
L= sqrt(vlist[i].x*vlist[i].x+vlist[i].y*vlist[i].y+vlist[i].z*vlist[i].z);
// between new vector and Yplane.
onearm_nohole(fi,psi+180,180,Diameter_of_screwhole,Length_of_Arm); 
        // make arm, centered around the Z axis and rotated twice!
     
if(Use_counterscrew) {one_hole(fi,psi+180,180,Diameter_of_ScrewHead_holes,Depth_of_ScrewHead_Holes);}; // 
 //Create the holes
if (Make_all_through) {one_hole(-fi,psi,0,Diameter_of_ScrewHead_holes,Depth_of_ScrewHead_Holes*100);}; // make holes at other side !
           
}; //end of for     
};
if (Make_hollow) // remove centre sphere
{
sphere(r=min(Diameter_Hollowed_Inner_Shpere,(Diameter_Inner_Sphere-m))/2);
    };
      }; //end diff
   
}; //intersection
if (Make_two_halve_spheres)
{
    // remove one halve of the core, 
    // ideally, symmetry plane goes through a plane symmetry vector, thus printing two halves will be the same
// uses a plane vector perpendicular to cutting plane.
fi = atan2(cutplane_vector.y,cutplane_vector.x);
psi = atan2(cutplane_vector.z,sqrt(cutplane_vector.y*cutplane_vector.y+cutplane_vector.x*cutplane_vector.x));
// angles calculated based on http://electron9.phys.utk.edu/vectors/3dcoordinates.htm
//angle =   [fi,psi,180];
 
    rotate([-fi,psi,0])translate([0,0,-slice_in_two_length/2])cube(size=[slice_in_two_length,slice_in_two_length,slice_in_two_length],center=true); // removes HALVE of the shape, below the XY plane.. Needs to be on a plane with line symmetry, thus rotated.
    // TODO: check if XZ has line symmetry for all cases?
};
 };
  
};
};
// other sub-programs
module onearm_nohole(rx,ry,rz,d,l)
{
rotate([0,0,rz]) rotate([rx,0,0])rotate([0,ry,0])  cylinder(r=d/2,h=l,center=false);
};
module one_hole(rx,ry,rz,d,l)
{
rotate([0,0,rz]) rotate([rx,0,0]) rotate([0,ry,0])cylinder(r=d/2,h=l,center=false);
};