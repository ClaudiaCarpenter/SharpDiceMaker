point_num=8;
tilt=50;
minsize=10;
maxsize=30;
random_seed = 30; // [1:1:100]

cylinder(d1=maxsize*2,d2=maxsize,h=maxsize,$fn=6,center=true);

for(i=[1:100/point_num:100]){
    seed=i-1;
    seed2=i;
    randsem=rands(minsize,maxsize,1);
    single_rand = rands(minsize,maxsize,1)[0];
    echo(single_rand=single_rand);

    random_vect=rands(-1,1,3,seed);
    random_vect2=rands(-tilt,tilt,3,seed2);
    echo(random_vect2);
    translate(random_vect)
        rotate(random_vect2)
            point(single_rand,single_rand*2.5);
}

module point(DI,HI){
    cylinder(d1=DI,d2=DI*1.5,h=HI*.65,$fn=6);
    translate([0,0,HI*.65])
        cylinder(d1=DI*1.5,d2=0,h=HI*.35,$fn=6);
}