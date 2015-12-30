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

use <Geeetech/rostock_g2_jhead_x1.scad>
use <Geeetech/rostock_g2_jhead_x2.scad>
use <Geeetech/rostock_g2_spider.scad>
use <E3D/v6_lite.scad>
use <mini_height_sensor.scad>

module e3d_v6_lock(spread = 30, tolerance = 0.1, duplex = false)
{
    translate([0, 0, 10]) rotate([180, 0, 0]) difference() {
        union() {
            hull() {
                translate([-spread/2, 0, 0]) cylinder(d=18-tolerance*2, h=10, $fn=180);
                translate([spread/2, 0, 0]) cylinder(d=18-tolerance*2, h=10, $fn=180);
            }
        }
        if (duplex) {
            translate([-spread/2, 0, -0.1]) cylinder(d=12+tolerance*2, h=10, $fn=180);
            translate([spread/2, 0, -0.1]) cylinder(d=12+tolerance*2, h=10, $fn=180);
        } else {
            translate([0, 0, -0.1]) cylinder(d=12+tolerance*2, h=10, $fn=180);
        }
        translate([0, 0, 6-tolerance]) {
            if (duplex) {
                translate([-spread/2, 0, -0.1]) cylinder(d=16+tolerance*2, h=10, $fn=180);
                translate([spread/2, 0, -0.1]) cylinder(d=16+tolerance*2, h=10, $fn=180);
            } else {
                translate([0, 0, -0.1]) cylinder(d=16+tolerance*2, h=10, $fn=180);
            }
        }
        translate([-spread/2-18-tolerance*4, -tolerance*2, -0.1]) 
            cube([spread+18*2+tolerance*5, tolerance*4, 10.2]);
    }
}

module e3d_v6_lock_x1(tolerance = 0.1)
{
    e3d_v6_lock(duplex = false, tolerance = tolerance);
}

module e3d_v6_lock_x2(tolerance = 0.1)
{
    e3d_v6_lock(duplex = true, tolerance = tolerance);
}

module e3d_v6_spider(spread = 30, tolerance = 0.1)
{
     difference() {
        geeetech_rostock_g2_spider(height = 6, zprobe = false, hole = false);
        hull() {
            translate([-spread/2, 0, -0.1]) cylinder(d=16+tolerance*2, h=10, $fn=180);
            translate([spread/2, 0, -0.1]) cylinder(d=16+tolerance*2, h=10, $fn=180);
        }
        translate([0, 0, 3-tolerance]) e3d_v6_lock(spread=spread, tolerance = -tolerance);
    }
    if ($children == 1) {
        translate([0, 0, 3]) children(0);
    } else if ($children == 2) {
        translate([-spread/2, 0, 3]) children(0);
        translate([spread/2, 0, 3]) children(1);
    }

} 

// Debug - 1x Mode
 * union() {
     % e3d_v6_spider() {
        # union() {
            e3d_v6_lite();
            translate([0, 0, -7]) rotate([-90, 0, 90]) import("E3D/V6.6_Duct.stl", convexity=4);
        }
    }
   % translate([0, 0, 3]) e3d_v6_lock(duplex = false);
}

// Debug - 2x Mode
 * union() {
      % e3d_v6_spider() {
        # union() {
            e3d_v6_lite();
            translate([0, 0, -7]) rotate([-90, 0, 90]) import("E3D/V6.6_Duct.stl", convexity=4);
        }
        # union() {
            rotate([0, 0, 180]) e3d_v6_lite();
            translate([0, 0, -7]) rotate([-90, 0, 90]) import("E3D/V6.6_Duct.stl", convexity=4);
        }
    }
    % translate([0, 0, 3]) e3d_v6_lock(duplex = true);
}

// Plated
rotate([180, 0, 0]) {
    rotate([180, 0, 0]) e3d_v6_spider();
    rotate([0, 0, -60]) translate([0, 50, -10]) e3d_v6_lock_x1();
    rotate([0, 0, 60]) translate([0, 50, -10]) e3d_v6_lock_x2();
}
        
// vim: set shiftwidth=4 expandtab: //
