
module geeetech_rostock_g2_pulley_guide()
{
    difference() {
        cylinder(d1=18, d2=5, h=15, $fn=24);
        translate([0,0,-0.1]) cylinder(d=13.5, h=15.2, $fn=24);
        translate([-9, -9, 1.8]) cube([18, 18, 10]);
    }
}

if (true) {
    for (x = [0:2] )
        for (y = [0:2]) 
            translate([x*25, y*25, 0]) geeetech_rostock_g2_pulley_guide();
    
}
