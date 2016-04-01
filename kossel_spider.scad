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

// Distance between effector rod centers
effector_width = 46; // [10:100]

/* [Diagonal Rod Mount] */

// Diameter of the rod end holder
effector_holder_diameter = 6; // [1:20]

// Width of the wall of the rod end holder
effector_holder_wall = 3; // [1:10]

// Length of the rod end holder hole
effector_holder_hole = 9; // [1:20]

/* [Effector Mount] */

// Flat-to-flat diameter of the internal hex mount
effector_mount_hex = 40; // [0:100]

/* [ Global ] */

// Faces for cylinders
fn = 60; // [6:60]

module round_hole(r = 1, h = 1, centered = false, fn = fn)
{
    if (centered) {
        translate([0, 0, -h/2-0.1])
            cylinder(r = r, h = h + 0.2, $fn = fn);
    } else {
        translate([0, 0, -0.1])
            cylinder(r = r, h = h + 0.2, $fn = fn);
    }
}

// 2D Measurement graphic
module measure(distance = 5, vertical = false)
{
    thickness = 0.2;
    length = 2;
    text_height = 1;
    text_length = 3;

    if (vertical) {
        translate([-thickness/2, text_height])
                square([thickness, length/2]);
        translate([-length/2, text_height + length/2 - thickness/2])
                square([length, thickness]);
        translate([-thickness/2, -length/2 - thickness/2])
                square([thickness, length/2]);
        translate([-length/2, - length/2 - thickness])
                square([length, thickness]);
    } else translate([0, -text_height/2]) {
        translate([-text_length/2 - length/2 - thickness/2, 0])
            square([thickness, length]);
        translate([-text_length/2 - length/2, length/2 - thickness/2])
            square([length/2, thickness]);
        translate([text_length/2 + length/2 - thickness/2, 0])
            square([thickness, length]);
        translate([text_length/2, length/2 - thickness/2])
            square([length/2, thickness]);
    }

    text(str(distance), halign = "center", valign = "bottom", size = text_height);
}


// Effector 'skeleton' - the minimal geometry needed for the effector
module kossel_effector(radius = effector_radius,
                       width = effector_width,
                       height = 4,
                       mount_hex = effector_mount_hex,
                       holder = effector_holder_diameter,
                       holder_wall = effector_holder_wall,
                       holder_hole = effector_holder_hole)
{
    if (height == 0) {
        kossel_effector(radius, width, holder + holder_wall*2, mount_hex, holder, holder_wall, holder_hole);
    } else {
        hex_radius = (radius - height) * 2/sqrt(3);

        difference() {
            union() {
                // Bulk of the effector
                cylinder(r = hex_radius,
                         h = height, $fn = 6);

                for (i = [0:2]) {
                    rotate([0, 0, 30 + 120 * i]) 
                        translate([0, -width/2, 0]) {
                            translate([radius, 0, holder/2 + holder_wall]) rotate([-90, 0, 0])  cylinder(r = holder/2 + holder_wall, h = width, $fn = fn);
                            cube([radius, width, height]);
                        }
                }
            }
                        
            // Carve out internal hole
            round_hole(r = mount_hex / sqrt(3), h = height, centered = false, fn=6);
            // Carve out rod end holder axes
            for (i = [0:2]) {
                rotate([0, 0, 30 + 120 * i]) {
                    translate([radius, 0, holder/2 + holder_wall])
                            rotate([90, 0, 0]) {
                                    round_hole(r = holder/2, h = radius*2, centered= true);
                                    translate([-holder/2 - holder_wall, -holder/2 - holder_wall-0.1, -width/2 + holder_hole]) cube([holder + holder_wall*2+0.2, holder + holder_wall*2+0.2, width - holder_hole*2]);
                            }
                    translate([radius - holder - holder_wall - 2.5, 0, height - 0.5])
                        linear_extrude(h = holder_wall, convexity=3) scale([2,2]) measure(radius);
                    translate([radius - holder - 0.5, 0, height/2 - 1]) rotate([90, 0, 90])
                        linear_extrude(h = holder_wall, convexity=3) scale([2,2]) measure(width);
                            
                }
            }
        }
    }
}

kossel_effector();

// vim: set shiftwidth=4 expandtab: //
