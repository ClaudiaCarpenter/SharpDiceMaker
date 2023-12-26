// mirrorPoints example

include <Round-Anything/polyround.scad>

centerRadius=7;
points=[[0,0,0],[2,8,0],[5,4,3],[15,10,0.5],[10,2,centerRadius]];
mirroredPoints=mirrorPoints(points,0,[0,0]);
linear_extrude(1)
    translate([0,-20,0])
    polygon(polyRound(mirroredPoints,20));
