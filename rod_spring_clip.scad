$fn=200;

difference() {
    union() {
        hull() {
            translate([-3.2, 0, 5])
               cube([2, 3, 10], center=true);
            translate([-7, 0, 5])
                cube([1,1,2], center = true);
        }
        cylinder(h=10,d=9, center=false);
    }
    translate([0,0,5]) {
       translate([3, 0, 0]) cube([3,4,10.2], center=true);
        cylinder(h=10.2,d=6, center=true);
       translate([-5.6, 0, 0]) rotate([90, 0, 0])
            cylinder(h=20, d=2, center=true);
    }
}
