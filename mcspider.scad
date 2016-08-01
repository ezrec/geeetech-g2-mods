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

// Standard airline tubing ID/OD in mm
airline_od = 6;     // 6mm
airline_id = 4;     // 4mm

// hotend_model==0: E3D v6
e3dv6_hotend_nozzle_height = 20;
e3dv6_hotend_diameter = 22;
e3dv6_hotend_height = 33;
e3dv6_hotend_groove_diameter = 12;
e3dv6_hotend_groove_height = 6;
e3dv6_hotend_inlet_diameter = 16;
e3dv6_hotend_shoulder_diameter = 16;
e3dv6_hotend_shoulder_height = 6;

// hotend_model==1: J-Head
jhead_hotend_nozzle_height = 12;
jhead_hotend_diameter = 16;
jhead_hotend_height = 29;
jhead_hotend_groove_diameter = 12;
jhead_hotend_groove_height = 4.5;
jhead_hotend_inlet_diameter = 16;
jhead_hotend_shoulder_diameter = 16;

// hotend_model==2: Hotend bulk diameter
custom_hotend_nozzle_height = 12;
custom_hotend_diameter = 20;
custom_hotend_height = 30;
custom_hotend_groove_diameter = 12;
custom_hotend_groove_height = 3;
custom_hotend_inlet_diameter = 16;
custom_hotend_shoulder_diameter = 16;
custom_hotend_shoulder_height = 6;


jhead_hotend_shoulder_height = 0;

hotend_nozzle_height = (hotend_model == 0 ? e3dv6_hotend_nozzle_height :
                  (hotend_model == 1 ? jhead_hotend_nozzle_height :
                   custom_hotend_nozzle_height));

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
lock_tolerance = 0.25;
// Hole tolerance
hole_tolerance = 0.125;

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

module hotend_cut(tolerance = lock_tolerance, snip = false)
{
    intersection() {
        rotate_extrude(angle = 360, $fn = fn) {
            intersection() {
                offset(delta = tolerance, chamfer = true) {
                    /* Build radius profile of hotend from bottom up */

                    /* Body */
                    square([hotend_radius, hotend_height-hotend_shoulder_height]);
                    translate([0, hotend_height-hotend_shoulder_height]) {
                        square([hotend_shoulder_diameter/2, hotend_shoulder_height]);
                        translate([0, hotend_shoulder_height]) {
                            square([hotend_groove_diameter/2, hotend_groove_height + 0.1]);
                        }
                    }
                }
                translate([0, -1]) square([100, 100]);
            }
        }
        if (snip)
            cylinder(r = hotend_radius + tolerance + 0.1, h = hotend_height + hotend_groove_height);
    }
}

module mcspider_lock_fitting(r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance)
{
    radius = hotend_lock_distance/2 + hotend_lock_radius + lock_tolerance;
    lock_radius = radius + brim;

    translate([0, 0, effector_height/2 - h/2]) for (a = [0:60:120]) {
        render() rotate([0, 0, 20 + a]) difference() {
            cylinder(r = lock_radius, h = h, $fn = fn);
            translate([0, 0, -0.1]) {
                translate([-lock_radius, radius/5, 0])
                    cube([2*lock_radius, 2*lock_radius, h + 0.2]);
                translate([-lock_radius, -(radius/5 + 2*lock_radius), 0])
                    cube([2*lock_radius, 2*lock_radius, h + 0.2]);
            }
        }
    }
    
    cylinder(r = radius, h = effector_height, $fn = fn);
}

module mcspider_lock_base(r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance, fan= true)
{
    mcspider_lock_fitting(r = r, d = d, h = h, height = height, wall = wall, brim = brim, lock_tolerance = lock_tolerance);

    for (n = [-1:2:1]) {
        i = d/2 * n;
        translate([i, 0, effector_height-hotend_groove_height- hotend_height - hotend_nozzle_height]) {
            translate([0, 0, hotend_nozzle_height])
                hotend_cut(tolerance = hotend_wall, snip = true);

            // Fan mount
            rotate([0, 0, i > 0 ? 180 : 0])
                translate([-fan_width/2,-(r + screw_depth),hotend_nozzle_height])
                    cube([fan_width, r + screw_depth + r*1/2, hotend_height - (effector_height - hotend_groove_height)+0.1 ]);
            
            // Airline holder
            rotate([0, 0, i > 0 ? 180 : 0])
                translate([0, r + airline_od/2 + wall, hotend_nozzle_height])
                    cylinder(d = airline_od+wall*2, h = 5, $fn = 6);
        }
    }
}

module mcspider_lock_cut(offset = 0, r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance)
{
    // Hotend bulk cut
    translate([offset, 0, effector_height-hotend_groove_height-hotend_height-hotend_nozzle_height]) {
        translate([0, 0, hotend_nozzle_height])
            hotend_cut(tolerance = lock_tolerance);

        rotate([0, 0, offset > 0 ? 180 : 0]) {
        // Airline cut
            translate([0, r + airline_od/2 + wall, 0])
                    cylinder(d = airline_od, h = hotend_height + hotend_nozzle_height + effector_height + 0.1, $fn = fn);

            // Fan cut
            translate([0, 0, hotend_nozzle_height]) hull() {
                translate([0, -(r + wall + screw_depth + 0.1), hotend_height/2])
                    rotate([90, 0, 0]) cylinder(r = fan_radius, h = 0.2);
                translate([-r, -0.1, 0])
                    cube([2*r, 0.2, fan_radius]);
                translate([0, (r + wall), hotend_height/2])
                    rotate([90, 0, 0]) cylinder(r = r, h = 0.2);
            }

            translate([0, 0, hotend_nozzle_height + fan_width/2]) {
                rotate([0, 0, 180]) {
                    // Drill screw holes
                    translate([-screw_gap/2, r + wall, -screw_gap/2]) {
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
    }
}

module mcspider_lock_x2(r = hotend_radius, d = hotend_lock_distance, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance, fan = true)
{
    difference() {
        mcspider_lock_base(r = r, d = d, h = h, wall = wall, brim = brim, lock_tolerance = -lock_tolerance, fan = fan);

        for (i=[-d/2:d:d/2]) {
            // Hotend bulk cut
            mcspider_lock_cut(offset = i, r = r, d = d, h = h, wall = wall, brim = brim, lock_tolerance = lock_tolerance);
        }

        // Slice in half
        translate([-100,-100,-100]) cube([200, 100 + lock_tolerance, 200]);
    }
}

module mcspider_lock_x1(r = hotend_radius, h = hotend_lock_height, height = hotend_height, wall = hotend_wall, brim = hotend_lock_brim, lock_tolerance = lock_tolerance, fan = false)
{
    difference() {
        rotate([0, 0, fan ? 180 : 0])
            mcspider_lock_base(r = r, d = 0, h = h, wall = wall, brim = brim, lock_tolerance = -lock_tolerance);

            // Hotend bulk cut
        rotate([0, 0, fan ? 180 : 0])
            mcspider_lock_cut(offset = 0, r = r, d = 0, h = h, wall = wall, brim = brim, lock_tolerance = lock_tolerance);

        // Slice in half
        translate([-100,-100,-100]) cube([200, 100 + lock_tolerance, 200]);
    }
}

module mcspider_lock_x1_fan()
{
    mcspider_lock_x1(fan = true);
}

module mcspider_lock_x1_foot()
{
    mcspider_lock_x1(fan = false);
}

module shear_y_z(z = 5, y = 10)
{
     M = [ [ 1, 0, 0, 0 ],
       [ 0, 1, y/z, 0 ],
       [ 0, 0, 1, 0 ],
       [ 0, 0, 0, 1 ] ] ;
    multmatrix(M) children();
}

module mcspider_foot()
{
    translate([0, 0, hotend_wall + lock_tolerance -hotend_height - hotend_nozzle_height]) {
        translate([0, hotend_radius + airline_od/2 + hotend_wall, 0]) {
            // Interlock
            translate([0, 0, hotend_nozzle_height]) difference() {
                translate([0, 0, -hotend_nozzle_height * 1/3])
                    cylinder(r = airline_od/2 + hotend_wall + lock_tolerance + hotend_wall, h = 5 + hotend_nozzle_height * 1/3, $fn = 6);
                cylinder(r = airline_od/2 + hotend_wall + lock_tolerance, h = 5.1, $fn = 6);
                translate([0, -(hotend_radius + hotend_wall + airline_od/2), 0])
                    cylinder(r = hotend_radius + hotend_wall + lock_tolerance, h = 5.2);
                translate([0, 0, 2.5]) rotate([90, 0, 180])
                    cylinder(d = 3, h = airline_od/2 + hotend_wall*2 + lock_tolerance + 0.1, $fn = fn);
                translate([0, 0, -hotend_nozzle_height * 1/3 -0.1])
                    cylinder(d1 = airline_id, d2 = airline_od + hotend_wall*2, h = hotend_nozzle_height * 1/3 + 0.2, $fn = fn);
            }
            // Airline adapter
            translate([0, -hotend_wall, hotend_nozzle_height * 1/3]) shear_y_z(z=hotend_nozzle_height * 1/3, y = hotend_wall) difference() {
                rotate([0, 0, 45]) cylinder(r = hotend_wall + airline_id/2, h = hotend_nozzle_height * 1/3, $fn = fn);
                translate([0, 0, -0.1]) cylinder(d = airline_id, h = hotend_nozzle_height * 1/3 + 0.2, $fn = fn);
            }
        }
        difference() {
            // Nozzle
            shear_y_z(z = hotend_nozzle_height * 1/3, y = hotend_radius + airline_od/2) {
                difference() {
                    cylinder(d = airline_id + hotend_wall*2, h = hotend_nozzle_height * 1/3, $fn = fn);
                    translate([0, 0, -0.1])
                        cylinder(d = airline_id, h = hotend_nozzle_height * 1/3 + 0.2, $fn = fn);
                }
            }
            rotate([0, 0, 45]) cylinder(r = hotend_nozzle_height * 1/3, h = hotend_nozzle_height, $fn = 4);
            cylinder(r = 20, h = 1);
        }
    }
}


// Effector 'skeleton' - the minimal geometry needed for the effector
module mcspider_effector(radius = effector_radius,
                       width = effector_width,
                       height = effector_height,
                       mount_hex = effector_mount_hex,
                       holder = effector_holder_diameter,
                       holder_wall = effector_holder_wall,
                       holder_hole = effector_holder_hole,
                       lock_wall = hotend_wall)
{
    if (height == 0) {
        mcspider_effector(radius, width, holder + holder_wall*2, mount_hex, holder, holder_wall, holder_hole);
    } else {

        hex_radius = radius;

        difference() {
            union() {
                // Effector bulk and lock

                 // Bulk of the effector
                 cylinder(r = hex_radius - holder_wall/2, h = height, $fn = fn);

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
                                            translate([-holder - holder_wall*2, -holder/2 - holder_wall-0.1, -width/2 + holder_hole])
                                                cube([holder*2 + holder_wall*3+0.2, holder + holder_wall*2+0.2, width - holder_hole*2]);
                                    }



                        }
                    }
                }
            }

            // Carve out twist lock
            lock_angle = 20;
            rotate([0, 0, lock_angle]) {
                translate([0, 0, -lock_tolerance]) mcspider_lock_fitting();
                translate([0, 0, -lock_wall-lock_tolerance]) mcspider_lock_fitting();
                translate([0, 0, lock_wall+lock_tolerance])
                    mcspider_lock_fitting();
                rotate([0, 0, -lock_angle])
                    mcspider_lock_fitting();
            }

        }
    }
}

use <E3D/v6_lite.scad>

module mcspider_assembly(hotend_duplex = false)
{
     % translate([0, 0, 2 + lock_tolerance]) {
        if (hotend_duplex) {
            translate([-hotend_lock_distance/2, 0, 0]) rotate([0, 0, 0]) e3d_v6_lite();
            translate([hotend_lock_distance/2, 0, 0]) rotate([0, 0, 180]) e3d_v6_lite();
        } else {
            e3d_v6_lite();
        }
    }

    % translate([0, 0, hotend_wall + lock_tolerance -hotend_height - hotend_nozzle_height])
        translate([-20, -20, -0.1]) cube([40, 40, 0.1]);

    if (hotend_duplex) {
          mcspider_lock_x2();
    } else {
          mcspider_lock_x1_foot();
    }

    rotate([0, 0, 180])
    if (hotend_duplex)
        mcspider_lock_x2();
    else
        mcspider_lock_x1_fan();

    mcspider_effector();

    if (hotend_duplex) {
        translate([-hotend_lock_distance/2, 0, 0])
            mcspider_foot();
        rotate([0, 0, 180])
            translate([-hotend_lock_distance/2, 0, 0])
                mcspider_foot();
    } else {
        mcspider_foot();
    }
}

module mcspider_plate()
{
    translate([0, 0, -hotend_wall])
          rotate([90, 0, 0]) mcspider_lock_x2();

    translate([0, 60, -hotend_wall])
          rotate([90, 0, 0]) mcspider_lock_x2();

    translate([60, 0, -hotend_wall])
          rotate([90, 0, 0]) mcspider_lock_x1_fan();

    translate([60, 60, -hotend_wall])
          rotate([90, 0, 0]) mcspider_lock_x1_foot();

    translate([0, -60, 0])
        mcspider_effector();

    translate([0, 0, hotend_radius + hotend_wall*3 - lock_tolerance*2 + airline_od]) {
        translate([40, 0, 0])
            rotate([-90, 0, 0]) mcspider_foot();

        translate([60, 0, 0])
            rotate([-90, 0, 0]) mcspider_foot();
    }

}

mcspider_assembly();

// vim: set shiftwidth=4 expandtab: //
