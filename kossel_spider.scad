//
// Copyright (C) 2016, Jason S. McMullan <jason.mcmullan@gmail.com>
// All rights reserved.
//
// Generic Kossel effector.
//
// Licensed under the MIT License:
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// All units are in mm

// Adjust the scaler for quick twist lock tolerance-only prints 
scaler = 1;

/* [Delta Geometry] */

// Distance from center of effector to center of diagnal rod axis
effector_radius = 34; // [10:100]

// Distance between effector rod ends
effector_width = 46; // [10:100]

// Height of the effector frame
effector_height = 8;

/* [Diagonal Rod Mount] */

// Diameter of the rod end holder
effector_holder_diameter = 6; // [1:20]

// Width of the wall of the rod end holder
effector_holder_wall = 3.5; // [1:10]

// Length of the rod end holder hole
effector_holder_hole = 9; // [1:20]

/* [Effector Mount] */

// Flat-to-flat diameter of the internal hex mount
effector_mount_hex = 40; // [0:100]

/* [Hotend Lock] */

// Hotend model
hotend_model=0; // [0:E3D v6,1:J-Head,2:Custom Groovemount]

// Minimum wall size around the hotend in mm
hotend_wall = 2; // [1:5]

// Hotend bulk diameter
custom_hotend_diameter = 20;
custom_hotend_height = 30;
custom_hotend_groove_diameter = 12;
custom_hotend_groove_height = 3;
custom_hotend_inlet_diameter = 16;
custom_hotend_shoulder_diameter = 16;
custom_hotend_shoulder_height = 6;

// E3D v6
e3dv6_hotend_diameter = 22;
e3dv6_hotend_height = 31.5;
e3dv6_hotend_groove_diameter = 12;
e3dv6_hotend_groove_height = 6;
e3dv6_hotend_inlet_diameter = 16;
e3dv6_hotend_shoulder_diameter = 16;
e3dv6_hotend_shoulder_height = 6;

// J-Head
jhead_hotend_diameter = 16;
jhead_hotend_height = 29;
jhead_hotend_groove_diameter = 12;
jhead_hotend_groove_height = 4.5;
jhead_hotend_inlet_diameter = 16;
jhead_hotend_shoulder_diameter = 16;
jhead_hotend_shoulder_height = 0;

hotend_diameter = (hotend_model == 0 ? e3dv6_hotend_diameter :
                  (hotend_model == 1 ? jhead_hotend_diameter :
                   custom_hotend_diameter));
hotend_height =  (hotend_model == 0 ? e3dv6_hotend_height :
                 (hotend_model == 1 ? jhead_hotend_height :
                  custom_hotend_height));
hotend_groove_diameter = (hotend_model == 0 ? e3dv6_hotend_groove_diameter :
                 (hotend_model == 1 ? jhead_hotend_groove_diameter :
                  custom_hotend_groove_diameter));
hotend_groove_height = (hotend_model == 0 ? e3dv6_hotend_groove_height :
                 (hotend_model == 1 ? jhead_hotend_groove_height :
                  custom_hotend_groove_height));
hotend_inlet_diameter = (hotend_model == 0 ? e3dv6_hotend_inlet_diameter :
                 (hotend_model == 1 ? jhead_hotend_inlet_diameter :
                  custom_hotend_inlet_diameter));
hotend_shoulder_diameter = (hotend_model == 0 ? e3dv6_hotend_shoulder_diameter :
                 (hotend_model == 1 ? jhead_hotend_shoulder_diameter :
                  custom_hotend_shoulder_diameter));
hotend_shoulder_height = (hotend_model == 0 ? e3dv6_hotend_shoulder_height :
                 (hotend_model == 1 ? jhead_hotend_shoulder_height :
                  custom_hotend_shoulder_height));


hotend_radius = hotend_diameter/2;

hotend_lock_brim = 1.5; // [0.25:5]
hotend_lock_height = effector_height - hotend_wall*2;

// Critical dimensions of the lock - 'maximum' lock size
hotend_lock_radius   = e3dv6_hotend_diameter/2+hotend_wall;
hotend_lock_distance = e3dv6_hotend_diameter+hotend_wall;

/* [Fan Dimensions] */
fan_width = 30; // [10:40]

/* [ Global ] */

// Screw size
screw_width = 2.6;
screw_depth = 5.75;
screw_gap = 24.5;

// Twist-lock lock_tolerance
lock_tolerance = 0.25 / scaler;
// Hole tolerance
hole_tolerance = 0.125 / scaler;

// Faces for cylinders
fn = 60; // [6:60]

fan_radius = fan_width/2-hotend_wall;

// WhosaWhatsis Hull Chain
module hull_chain()
{
    for (i = [0 : $children - 2]) hull() for(j = [i, i+1]) children(j);
}


module round_hole(r = 1, h = 1, centered = false, fn = fn)
{
    if (centered) {
        translate([0, 0, -h/2-0.1])
            cylinder(r = r + hole_tolerance, h = h + 0.2, $fn = fn);
    } else {
        translate([0, 0, -0.1])
            cylinder(r = r + hole_tolerance, h = h + 0.2, $fn = fn);
    }
}

// 2D Measurement graphic
module measure(distance = 5, unit = "n")
{
    thickness = 0.2;
    length = 2;
    text_height = 1;
    text_length = 3;

    text(str(distance,unit), halign = "center", valign = "bottom", size = text_height);
}

module hotend_cut(tolerance = lock_tolerance)
{
    rotate_extrude(angle = 360, $fn = fn) {
        intersection() {
            offset(delta = tolerance, chamfer = true) {
                /* Build radius profile of hotend from bottom up */
                
                /* Body */
                square([hotend_radius, hotend_height-hotend_shoulder_height]);
                translate([0, hotend_height-hotend_shoulder_height]) {
                    square([hotend_shoulder_diameter/2, hotend_shoulder_height]);
                    translate([0, hotend_shoulder_height]) {
                        square([hotend_groove_diameter/2, hotend_groove_height]);
                        translate([0, hotend_groove_height])
                            square([hotend_inlet_diameter/2, hotend_wall*2]);
                    }
                }
            }
            translate([0, -1]) square([100, 100]);
        }
    }
}

module twist_lock_base(r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance)
{
    hull() {
        for (i=[-d/2:d:d/2])
            translate([i, 0, 0]) cylinder(r = hotend_lock_radius + brim + lock_tolerance, h = h, $fn = fn);
    }
    
    hull() {
        for (i=[-d/2:d:d/2])
            translate([i, 0, 0]) cylinder(r = hotend_lock_radius + lock_tolerance, h = height + hotend_groove_height, $fn = fn);
    }
}

module twist_fan_sketch(delta = 0)
{
    r = hotend_radius;
    d = hotend_lock_distance;
    wall = hotend_wall;
    
    offset(delta = delta, chamfer = true) {
        hull() {
            for (i=[-d/2:d:d/2])
                translate([i, 0])
                    circle(r = r + wall + lock_tolerance + wall, $fn = fn);
        }
        if (delta >= 0) {
            width = r+wall+lock_tolerance+screw_depth;
            translate([-fan_width/2,-width])
                square([fan_width, width]);
        }
    }
}

module twist_fan_x1(r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance)
{
    difference() 
    {
        union() {
            translate([0, 0, h + wall*2 + lock_tolerance])
                linear_extrude(height = height - h + hotend_groove_height + lock_tolerance)
                    twist_fan_sketch(delta = 0);
        }
        
        // Interior cut
        translate([0, 0, -0.1])
            linear_extrude(height =  height-wall + h + hotend_groove_height+lock_tolerance*2 + 0.1)
                twist_fan_sketch(delta = - wall);
        
        // Top cut
        hull() {
            for (i=[-d/2:d:d/2]) {
                translate([i, 0, h + lock_tolerance + height-wall + hotend_groove_height])
                    round_hole(r = hotend_inlet_diameter/2, h = wall + lock_tolerance*2);
            }
        }

        // Fan cut
        twist_lock_cut();
        translate([0, -r-wall-screw_depth-lock_tolerance, h + wall*2 + lock_tolerance + height/2]) {
            //rotate([-90, 0, 0]) cylinder(r = fan_radius, h = r*2 + wall*2 + screw_depth+lock_tolerance*2, $fn = fn);
        
            // Drill screw holes
            translate([-screw_gap/2, 0, -screw_gap/2]) {
                rotate([-90, 0, 0])
                    round_hole(r=screw_width/2, h = screw_depth);
                translate([screw_gap, 0, 0]) rotate([-90, 0, 0])
                    round_hole(r=screw_width/2, h = screw_depth);
                translate([0, 0, screw_gap]) rotate([-90, 0, 0])
                    round_hole(r=screw_width/2, h = screw_depth);
                translate([screw_gap, 0, screw_gap]) rotate([-90, 0, 0])
                    round_hole(r=screw_width/2, h = screw_depth);
            }
        
        }
    }
}
        

module twist_lock_cut(offset = 0, r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance)
{
    // Hotend bulk cut
    translate([offset, 0, 0]) hotend_cut(tolerance = lock_tolerance);
    
    // Fan cut
    hull_chain() {
            translate([0, r+wall+lock_tolerance+screw_depth, h + wall*2 + lock_tolerance + height/2])
                rotate([-90, 0, 0]) cylinder(r = fan_radius, h = lock_tolerance, $fn = fn);
            translate([0, r+wall, h + wall*2 + height/2])
                rotate([-90, 0, 0]) cylinder(r = fan_radius, h = lock_tolerance, $fn = fn);
            translate([offset, 0, 0]) cylinder(r = r, h = lock_tolerance, $fn = fn);
            translate([0, -(r+wall+lock_tolerance), h + wall*2 + height/2])
                rotate([-90, 0, 0]) cylinder(r = fan_radius, h = lock_tolerance, $fn = fn);
            translate([0, -(r+wall+lock_tolerance+screw_depth)-lock_tolerance, h + wall*2 + lock_tolerance + height/2])
                rotate([-90, 0, 0]) cylinder(r = fan_radius, h = lock_tolerance, $fn = fn);
        }
}

module twist_lock_x2(r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance)
{
    translate([0, 0, wall + lock_tolerance]) difference() {
        twist_lock_base(r = r, d = d, h = h, wall = wall, brim = brim, lock_tolerance = -lock_tolerance);
        
        for (i=[-d/2:d:d/2]) {
            // Hotend bulk cut
            twist_lock_cut(offset = i, r = r, d = d, h = h, wall = wall, brim = brim, lock_tolerance = lock_tolerance);
        }
        
        // Slice in half
        translate([-100,-100,-100]) cube([200, 100 + lock_tolerance/2, 200]);
    }
}

module twist_lock_x1(r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance)
{
    translate([0, 0, wall + lock_tolerance]) difference() {
        twist_lock_base(r = r, d = d, h = h, wall = wall, brim = brim, lock_tolerance = -lock_tolerance);
    
        // Hotend bulk cut
        twist_lock_cut(offset = 0, r = r, d = d, h = h, wall = wall, brim = brim, lock_tolerance = lock_tolerance);
    
        
        // Slice in half
        translate([-100,-100,-100]) cube([200, 100 + lock_tolerance*2, 200]);
    }
}


// Effector 'skeleton' - the minimal geometry needed for the effector
module kossel_effector(radius = effector_radius,
                       width = effector_width,
                       height = effector_height,
                       mount_hex = effector_mount_hex,
                       holder = effector_holder_diameter,
                       holder_wall = effector_holder_wall,
                       holder_hole = effector_holder_hole,
                       lock_wall = hotend_wall)
{
    if (height == 0) {
        kossel_effector(radius, width, holder + holder_wall*2, mount_hex, holder, holder_wall, holder_hole);
    } else {
        
        hex_radius = radius;

        difference() {
            union() {
                // Effector bulk and lock
               
                 // Bulk of the effector
                 cylinder(r = hex_radius - holder_wall/2, h = height, $fn = fn);
                
                 // Locking ridge for fan cover
                 translate([0, 0, height - 0.1]) {
                    linear_extrude(height = lock_wall) difference() {
                        twist_fan_sketch(delta = lock_wall+lock_tolerance);
                        twist_fan_sketch(delta = lock_tolerance);
                        translate([-fan_width/2, -fan_width]) square([fan_width, fan_width*2]);
                    }
                }
                    
                        
                 // Effector connectors       
                 difference() {

                    union() {
                        for (i = [0:2]) {
                            rotate([0, 0, 30 + 120 * i]) 
                                translate([radius, -width/2, 0]) {
                                    translate([0, 0, holder/2 + holder_wall]) rotate([-90, 0, 0])  cylinder(r = holder/2 + holder_wall, h = width, $fn = fn);
                                    translate([-holder-holder_wall*2, 0, 0]) cube([holder + holder_wall*2, width, height]);
                                }
                                
                        }
                    }
                    

                    // Carve out rod end holder axes
                    for (i = [0:2]) {
                        rotate([0, 0, 30 + 120 * i]) {
                            translate([radius, 0, holder/2 + holder_wall])
                                    rotate([90, 0, 0]) {
                                            round_hole(r = holder/2, h = radius*2, centered= true);
                                            translate([-holder/2 - holder_wall, -holder/2 - holder_wall-0.1, -width/2 + holder_hole])
                                                cube([holder + holder_wall*2+0.2, holder + holder_wall*2+0.2, width - holder_hole*2]);
                                    }
                            
                            
                                    
                        }
                    }
                }
            } 
                                  
            // Insert twist lock
            lock_angle = 20;
            rotate([0, 0, lock_angle]) {
                translate([0, 0, -lock_tolerance]) twist_lock_base(lock_tolerance=0);
                slices=8;
                twist_lock_base();
                for (i=[0:slices]) {
                    rotate([0, 0, -i*lock_angle/slices]) {
                        translate([0, 0, lock_wall+lock_tolerance]) twist_lock_base(lock_tolerance=0);
                    }
                }
            }
            
            // Mounting bolts
            bolt_gap = 10;
            bolt_inset = 4;
            bolt_width = 3;
            translate([0, -(radius-holder-bolt_inset), -0.1]) {
                for (i = [-bolt_gap/2:bolt_gap:bolt_gap/2])
                    translate([i, 0, 0]) {
                        cylinder(d=6,h=2.5+0.1,$fn=6);
                        round_hole(r=bolt_width/2, h = height);
                        translate([0, 0, height-2.5+0.1])
                            cylinder(d=6+lock_tolerance*2,h=2.5+0.1,$fn=6);
                    }
            }
            
            rotate([0, 0, -90]) translate([radius, 0, holder/2 + holder_wall])
                                    rotate([90, 0, 0]) {
                                            round_hole(r = holder/2, h = radius*2, centered= true);
                                            translate([-holder/2 - holder_wall, -holder/2 - holder_wall-0.1, -width/2 + holder_hole])
                                                cube([holder + holder_wall*2+0.2, holder + holder_wall*2+0.2, width - holder_hole*2]);
                                    }
                                    
            // Marking cut(s)
            for (i = [2:2]) {
                rotate([0, 0, 30 + 120 * i]) translate([radius-holder/2-holder_wall-0.5, 0, height/3]) rotate([0, 90, 0]) {
                    linear_extrude(height = 2, convexity=3) scale([3,3]) {
                        translate([0, -2]) rotate([0, 0, 90]) measure(radius,"r");
                        translate([0, 2]) rotate([0, 0, 90]) measure(width,"w");
                    }
                }
            }
                    
        }
    }
}

hotend_duplex = false;

use <E3D/v6_lite.scad>
scale([scaler, scaler, scaler]) {
* translate([0, 0, 34+hotend_wall + lock_tolerance]) {
    if (hotend_duplex) {
        translate([-hotend_lock_distance/2, 0, 0]) e3d_v6_lite();
        translate([hotend_lock_distance/2, 0, 0]) e3d_v6_lite();
    } else {
        e3d_v6_lite();
    }
}

difference() {
    * translate([0, 0, hotend_wall + lock_tolerance]) if (hotend_duplex) {
        translate([hotend_lock_distance/2, 0, 0]) hotend_cut(tolerance=0);
        translate([-hotend_lock_distance/2, 0, 0]) hotend_cut(tolerance=0);
    } else {
        hotend_cut(tolerance=0);
    }

//translate([0, 100, -hotend_wall])
  * if (hotend_duplex)
      twist_lock_x2();
  else
      twist_lock_x1();

//translate([100, 0, -hotend_wall])
* rotate([0, 0, 180])
    if (hotend_duplex)
        twist_lock_x2();
    else
        twist_lock_x1();

// translate([100, 100, hotend_height + effector_height + hotend_wall]) rotate([180, 0, 0])
* rotate([0, 0, 180])
  twist_fan_x1();

  
kossel_effector();
}
}

// vim: set shiftwidth=4 expandtab: //
