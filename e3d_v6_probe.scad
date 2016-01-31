//
// Copyright (C) 2015, Jason S. McMullan <jason.mcmullan@gmail.com>
// All right reserved.
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

use <universal_spider.scad>
use <E3D/v6_lite.scad>
use <mini_height_sensor.scad>

module e3d_v6_probe_post(height = 30, post_clearnace = 3, width = 4, thickness = 2)
{
    radius = 29;
    difference() {
        union() {
            translate([-width/2, -radius, -4]) cube([width, radius - 21, 4]);
            translate([-width/2, -radius, -height + post_clearance]) cube([width, thickness, height-1-post_clearance]);
            translate([-width*0.1, -radius, -height+post_clearance]) {
                translate([-width * 0.4, 0, 0]) cube([width, 8, 6]);
                cube([width * 0.6, 15, 6]); 
                translate([width * 0.3, 0, 0]) cube([width * 0.3, 30, 6]);
            }
            
        }
        translate([0, -25, -4.1]) cylinder(d=3.9, h=10, $fn=10);
    }
}

module e3d_v6_probe(height = 50, width = 8, bed_clearance = 3.25, post_clearance = 3)
{
    difference() {
        union() {
            e3d_v6_probe_post(height = height - bed_clearance, width = width, post_clearance = post_clearance);
            mirror([0, 1, 0]) e3d_v6_probe_post(height = height - bed_clearance, width = width, post_clearance = post_clearance);
            translate([3, 0, -height + bed_clearance]) rotate([0, 0, -90]) {
                mini_height_sensor_mount(post=4, base=5.5);
                translate([-23/2, 0, 0]) cube([23, width * 0.2, 17]);
            }
        }

        translate([5.2, 0, -height+ bed_clearance]) rotate([0, 0, -90]) mini_height_sensor_drill(post=6);
    }
}

 union() {
    # universal_spider() {
        union () {
            rotate([0, 0, 0]) e3d_v6_lite();
            translate([0, 0, -7]) rotate([-90, 0, -90]) import("E3D/V6.6_Duct.stl", convexity=4);
        }
        union () {
            rotate([0, 0, 180]) e3d_v6_lite();
            translate([0, 0, -7]) rotate([-90, 0, -90]) import("E3D/V6.6_Duct.stl", convexity=4);
        }
    }
    translate([0, 0, 3]) e3d_v6_lock_x2();
}

 rotate([0, 0, 180]) e3d_v6_probe();
// vim: set shiftwidth=4 expandtab: //
