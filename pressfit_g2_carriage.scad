
use <Geeetech/utility.scad>

mm = 1;
in = 25.4 * mm;

// Critical dimensions
bearing_radius = 19 * mm / 2;
rod_radius = 10 * mm / 2;
rod_distance = 60 * mm; // rod-center to rod-center
belt_offset = -rod_radius; // distance from rod center to belt
belt_width = 6 * mm;
belt_clearance = 10 * mm;

// Bulk thickness (LM10UU circlip-to-circlip distance)
lm10uu_height = (22 - (2 * 1.5)) * mm;
lm10luu_height = (44 - (2 * 1.5)) * mm;

bulk_height = 10*mm;
bulk_wall = 4 * mm;

module metal()
{
    color([0.5, 0.5, 0.8]) children();
}

module lmNuu(cut = false, dr=10, D=19, D1=18, L=29, B=22, W=1.3)
{
    if (!cut)
    {
        cylinder(d=D, h=L, $fn=60);
    } else {
        translate([0, 0, -0.1]) cylinder(d=dr, h=L+0.1, $fn=60);
        translate([0, 0, (L-B)/2]) difference()
        {
            cylinder(d=D+1, h=W, $fn=60);
            translate([0, 0, -1]) cylinder(d=D1, h=W+2, $fn=60);
        }
        translate([0, 0, (L-B)/2 + B - W]) difference()
        {
            cylinder(d=D+1, h=W, $fn=60);
            translate([0, 0, -1]) cylinder(d=D1, h=W+2, $fn=60);
        }
    }
}

module lm10uu(cut = false)
{
    lmNuu(cut=cut, dr=10, D=19, D1=18, L=29, B=22, W=1.3);
}

module lm10luu(cut = false)
{
    lmNuu(cut=cut, dr=10, D=19, D1=18, L=55, B=44, W=1.3);
}

belt_clip_offset = 7 * mm;
belt_clip_scale = 2.0;
belt_clip_clamp = 2.2 * mm;
m3_nut_flat = 5.5 * mm;
m3_nut_height = 2.25 * mm;


module belt_clip(depth=6)
{
       translate([belt_clip_offset, -3.5, -0.1]) {
           linear_extrude(height=depth+0.1) rotate([0, 0, 90]) {
               translate([-20, -belt_clip_clamp/2]) square([20, belt_clip_clamp]);
               loop = 3+1.6*2;
               hull() {
                    circle(d=loop, $fn=60);
                    translate([-loop/2, 0]) square([0.5, belt_clip_clamp], center=true);
               }
           }
           drill(d=3, h= 20);
           translate([0, 0, 10 - m3_nut_height - 0.1 ]) {
                drill(d=2*m3_nut_flat/sqrt(3) + 0.15, h = m3_nut_height + 0.2, fn=6);
           }
       }
}

module _bearing_mount(press_thick=10, bearing_radius=20/2, press_width=4, cut = false)
{
    if (!cut)
    {
        rotate([90, 0, 0]) cylinder(r=bearing_radius + press_width, h=press_thick, $fn=60);
    } else {
        rotate([90, 0, 0]) {
                   translate([0, 0, -0.1]) cylinder(r1=bearing_radius+1, r2=bearing_radius, h=2.1, $fn=60);
                   cylinder(r=bearing_radius, h=press_thick, $fn=60);
                   translate([0, 0, press_thick-2]) cylinder(r2=bearing_radius+1, r1=bearing_radius, h=2.1, $fn=60);
               }

    }
}

module _rod_mount(press_thick=16, press_width=4, bulk_gap=30, cut=false, bulk=true)
{
    press_thick = bulk_height;
    press_width = bulk_wall;

    if (!cut)
    {
       translate([0, press_thick/2, 0]) {
           translate([-bulk_gap/2, -press_thick, -belt_clearance]) cube([bulk_gap, press_thick, belt_clearance + 20]);
           
           hull() {
               translate([rod_distance/2, 0, 0])
                    _bearing_mount(bearing_radius=bearing_radius, press_thick=press_thick, press_width=press_width, cut=cut);
               translate([bulk_gap/2, -press_thick, -belt_clearance]) cube([0.1, press_thick, belt_clearance + 20]);
           }
           hull() {
            translate([-rod_distance/2, 0, 0]) _bearing_mount(press_thick=press_thick, press_width=press_width, cut=cut);
               
            translate([-bulk_gap/2, -press_thick, -belt_clearance]) cube([0.1, press_thick, belt_clearance + 20]);
           }

       }
    } else {
      // Press fit for bearings
       translate([0, press_thick/2, 0]) {
           for (d=[-1:2:1]) {
               translate([d * rod_distance/2, 0, 0])
                    _bearing_mount(bearing_radius=bearing_radius, press_thick=press_thick, press_width=press_width, cut=cut);
           }
       }        
   }
}
   
module pressfit_g2_carriage(cut=false)
{
    press_thick = bulk_height;
    press_width = bulk_wall;
    
    bulk_gap = rod_distance - bearing_radius * 2 - bulk_wall * 2;
    
    lm10_height = [ lm10uu_height, lm10luu_height];

    // Press fit for bearings
    _rod_mount(press_thick=press_thick, press_width=press_width, bulk_gap=bulk_gap, cut=cut);
    if (!cut)
    {
       // Rod mounts
       translate([-23, -bulk_height/2+8, 26]) {
           rotate([0, 90, 0]) {
               hull() {
                   cylinder(d=12, h=46, $fn=60);
                   translate([0, 0, 2]) cylinder(d=16, h=42, $fn=60);
               }
           }
       }
       
       // Rod mount anchors
       hull() {
           translate([-21, -bulk_height/2+8, 26]) rotate([0, 90, 0]) cylinder(d=16, h=42, $fn=30);
           translate([-21, 0, 26-7]) rotate([0, 90, 0]) cylinder(d=press_thick, h=42, $fn=30);
       }

     
    } else {
       // Rod mount hole
       translate([-40, -bulk_height/2+8, 26]) rotate([0, 90, 0]) cylinder(d=6.5, h=80, $fn=30);
       // Rod mount bulk cut
       translate([0, -bulk_height/2+8, 26]) cube([28, 20, 18], center=true);
        
       // GT2 path
       translate([-7, 0, 5 - 10]) cube([4, 60, 10], center = true);
       translate([-8.5, -press_thick/2-1, -6 - 10]) cube([4, press_thick+2, 16]);
       
       // GT2 clip
       translate([belt_clip_offset, 0, -belt_clearance - 0.1]) linear_extrude(height=belt_clearance + 0.1) scale([1.0, belt_clip_scale]) circle(r=7, $fn=6);
       
        
       // Endstop detection
       translate([0, 0, 23 - 10]) rotate([90, 0, 0]) cylinder(d=3.5, h=40, $fn=20, center=true);
       translate([0, 0, 23 - 10]) rotate([-90, 0, 0]) cylinder(r=6/sqrt(3), h=40, $fn=6);
    } 
}

module pressfit_g2_carriage_metal(cut=false)
{
    translate([30, 0, 0]) {
       rotate([90, 0, 0]) lm10uu(cut);
    }
    translate([-30, 0, 0]) {
        rotate([90, 0, 0]) lm10luu(cut);
    }
    
    translate([0, 0, 13]) {
        rotate([90, 0, 0]) {
            if (!cut) {
                cylinder(d=3.5, h=40, $fn=20, center=true);
            }
        }
    }
}

* rotate([90, 0, 180]) translate([-44, -18, -10])   import("Geeetech/RKMA-B01-carriage.STL", convexity=2);


rotate([90, 0, 180]) translate([0, 0, -10]) difference()
{
      translate([belt_clip_offset, 0, 0]) linear_extrude(height=9.75) scale([1.0, belt_clip_scale]) circle(r=6.8, $fn=6);
      // GT2 belt holder
      belt_clip();
      mirror([0, 1, 0]) belt_clip();
 }

rotate([90, 0, 180]) translate([0, 0, 0]) difference()
{
  pressfit_g2_carriage(cut=false);
  pressfit_g2_carriage(cut = true);
}

if (false) metal() difference() {
  pressfit_g2_carriage_metal(cut=false);
  pressfit_g2_carriage_metal(cut=true);
}

