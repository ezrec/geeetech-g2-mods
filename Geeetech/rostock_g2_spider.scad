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

use <utility.scad>

// Effective diameter = 68mm

module geeetech_rostock_g2_spider_leg(height=8)
{
  translate([14, 17, 0]) {
    cube([9, 13, height]);
    cube([9, 17, 3]);
  }
  translate([14, 34, 6])
    rotate([0, 90, 0]) {

        difference() {
            hull(){
                translate([0, -16, 0])
                cylinder(d=height/2, h=9, $fn=24);
                cylinder(d=12, h=9, $fn=24);
            }

            translate([0, 0, -0.1])
            cylinder(d=6.25, h=9.2, $fn=24);
        }
    }
}

module geeetech_rostock_g2_spider_bracket(height=8)
{
    geeetech_rostock_g2_spider_leg(height=height);
    mirror([1, 0, 0]) geeetech_rostock_g2_spider_leg(height=height);
}


module geeetech_rostock_g2_spider_zprobe()
{
    translate([-10, 26, 0])
        cube([20, 4, 8]);
    translate([-6, 20, 0])
        cube([12, 10, 19.2]);
}

module geeetech_rostock_g2_spider_blank(height = 8, zprobe = true, hole = false)
{
    difference() {
        union() {
            utility_torus_mitred_top(id=40.125, od=50, height=height, radius=1.5, hole=hole, $fn=180);
            rotate([0, 0, 15]) difference() {
                cylinder(d=60, h=height, $fn=12);
                translate([0, 0, -0.1]) cylinder(d=45, h=height+0.2);
            } 

            for (i = [0:2]) {
                rotate([0, 0, i*120]) geeetech_rostock_g2_spider_bracket(height=height);
            }

            if (zprobe)
                geeetech_rostock_g2_spider_zprobe(height = height);
        }
                // Z-probe drills
        if (zprobe) {
           translate([-4.7, 30.1, 5.5])
                rotate([90, 0, 0])
                    cylinder(d=3-0.2, h=height+0.2, $fn=12);
           translate([4.7, 30.1, 5.5])
                rotate([90, 0, 0])
                    cylinder(d=3-0.2, h=height+0.2, $fn=12);
            translate([0, 23.5, -0.1])
                cylinder(d=3+0.5, h=20, $fn=12);
            translate([-1.5, 24, height])
                cube([3, 8, 18]);
            translate([0, 22-0.5, 17])
                rotate([0, 0, 15]) cube([8, 3, 3]);
        }
    }
}

module geeetech_rostock_g2_spider_drill(height = 8, zprobe = false)
{
    // Drills for Geetech J-Head and fan mounts
    for (i = [(zprobe ? 1 : 0):5]) {
        rotate([0, 0, i*60]) translate([0, 25, -0.1])
            cylinder(d=4.25, h=height + 0.2, $fn=24);
    }
}

module geeetech_rostock_g2_spider(height = 8, zprobe = true, hole = true)
{
    difference() {
        geeetech_rostock_g2_spider_blank(height = height, zprobe=zprobe, hole=hole);
        geeetech_rostock_g2_spider_drill(height = height, zprobe=zprobe);
    }
}

module geeetech_rostock_g2_spider_no_probe(height=8)
{
    geeetech_rostock_g2_spider(height = height, zprobe=false);
}

module geeetech_rostock_g2_spider_z_probe(height = 8)
{
    geeetech_rostock_g2_spider(height = height, zprobe=true);
}

// Debug interference model:
union() {
    % translate([-46.125, -40+0.125, 0])
            import("RKMA-B02-platform.STL", convexity=5);
    geeetech_rostock_g2_spider(zprobe=true);
}

// vim: set shiftwidth=4 expandtab: //
