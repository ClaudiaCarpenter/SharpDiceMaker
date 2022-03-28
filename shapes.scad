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

