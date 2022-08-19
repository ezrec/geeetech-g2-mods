//
// Copyright 2019 Barrett Ford <https://www.thingiverse.com/barrettford/about>
//
// https://www.thingiverse.com/thing:3052714
//

$fa=.5;
$fs=1;
$fn=60;

module switch() {
  difference() {
    union() {
      translate([0,-3.3,0]) cube([10, 6.6, 9.5]);
      translate([-10,-3.3,0]) cube([10, 6.6, 10.3]);
      
      translate([-7,-3.3,10.5]) rotate([0,70,0]) cube([7, 6.6, 21]);
    }
    translate([5, 4, 2.6]) rotate([90,0,0]) cylinder(d=3,h=8);
    translate([-5, 4, 2.6]) rotate([90,0,0]) cylinder(d=3,h=8);
  }
  hull() {
    translate([10.7 , 3.3, 15.5]) rotate([90,0,0]) cylinder(d=5,h=6.6);
    translate([10.35, 3.3, 17.0]) rotate([90,0,0]) cylinder(d=5,h=6.6);
    translate([10.0 , 3.3, 18.5]) rotate([90,0,0]) cylinder(d=5,h=6.6);
    translate([9.65 , 3.3, 19.5]) rotate([90,0,0]) cylinder(d=5,h=6.6);
  }
}


module bottom() {
  height = 9;
  tube_diameter = 4.2;
  difference() {
    union() {
      translate([1.5,0,0]) hull()
      {
        translate([-12,5.5,2.5])  rotate([90,0,0]) cylinder(d=5, h=height);
        translate([ 12,5.5,2.5])  rotate([90,0,0]) cylinder(d=5, h=height);
        translate([-18,5.5,27.5]) rotate([90,0,0]) cylinder(d=5, h=height);
        translate([ 18,5.5,27.5]) rotate([90,0,0]) cylinder(d=5, h=height);
        
      }
    }
    translate([-25,0,25]) rotate([0,90,0]) cylinder(d=tube_diameter, h=50);
    translate([-11,-6.5,-1]) cube([22, 10, 21]);
    translate([ 5,-6.5, 10]) cube([11, 10, 16]);
    
    hull() {
      translate([5, 6, 3.6]) rotate([90,0,0]) cylinder(d=3,h=20);
      translate([5, 6, 10]) rotate([90,0,0]) cylinder(d=3,h=20);
    }
    
    hull() {
      translate([-5, 6, 3.6]) rotate([90,0,0]) cylinder(d=3,h=20);
      translate([-5, 6, 10]) rotate([90,0,0]) cylinder(d=3,h=20);
    }
  }
}

// Uncomment this line to see where the switch would fit
//translate([0,0,5]) #switch();
bottom();
