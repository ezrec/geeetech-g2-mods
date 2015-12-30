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

use <e3d_v6_mount.scad>
use <E3D/v6_lite.scad>
use <mini_height_sensor.scad>

module e3d_v6_probe(height = 48.5)
{
    difference() {
        union() {
            translate([-5, -32, -4]) cube([10, 12, 4]);
            difference() {
                translate([-5, -32, -height+4]) cube([10, 3, height+3]);
                e3d_v6_spider();
            }
            translate([-1, -32, -height+4]) {
                translate([-4, 0, 0]) cube([10, 8, 6]);
                cube([6, 15, 6]); 
                translate([3, 0, 0]) cube([3, 30, 6]);
            }
            translate([3, -11, -height+4]) cube([2, 23, 13]);
            translate([3, 0, -height]) rotate([0, 0, -90])
                mini_height_sensor_mount(post=4, base=5.5);
        }
        translate([0, -25, -4.1]) cylinder(d=3.9, h=10, $fn=10);
        translate([5.2, 0, -height]) rotate([0, 0, -90]) mini_height_sensor_drill(post=6);
    }
}

% union() {
    # e3d_v6_spider() {
        union () {
            rotate([0, 0, 0]) e3d_v6_lite();
            translate([0, 0, -7]) rotate([-90, 0, -90]) import("E3D/V6.6_Duct.stl", convexity=4);
        }
        union () {
            rotate([0, 0, 180]) e3d_v6_lite();
            translate([0, 0, -7]) rotate([-90, 0, -90]) import("E3D/V6.6_Duct.stl", convexity=4);
        }
    }
    translate([0, 0, -4]) e3d_v6_lock_x2();
}

 rotate([0, 0, 180]) e3d_v6_probe();
// vim: set shiftwidth=4 expandtab: //
