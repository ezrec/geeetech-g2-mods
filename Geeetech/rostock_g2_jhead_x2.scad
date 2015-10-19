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
use <utility.scad>;

module geeetech_rostock_g2_jhead_x2_drill_bolt()
{
    translate([7.5, 13, -3.1]) {
        cylinder(d=3.6, h=9.2, $fn=12);
        translate([0, 0, 6]) {
            cylinder(r=6/sqrt(3), h=4, $fn=6);
        }
    }
    translate([7.5, -13, -3.1]) {
        cylinder(d=3.6, h=9.2, $fn=12);
        translate([0, 0, 6]) {
            cylinder(r=6/sqrt(3), h=4, $fn=6);
        }
    }
}

module geeetech_rostock_g2_jhead_x2_drill(spread=0)
{
    translate([10+spread/2, 0, -0.1])
        cylinder(d=17, h=6.2, $fn=60);

    translate([25, 0, -0.1]) {
        cylinder(d=4.6, h=6.2, $fn=12);
        translate([0, 0, 3.6]) {
            cylinder(r=7/sqrt(3), h=4, $fn=6);
        }
    }

    geeetech_rostock_g2_jhead_x2_drill_bolt();
}

module geeetech_rostock_g2_jhead_x2_upper(spread=0)
{
    difference() {
        union() {
            cylinder(r=20, h=6, $fn=120);
            utility_plate_mitred_edge([63, 25, 6], radius=6);
        }

        // J-head drills
        geeetech_rostock_g2_jhead_x2_drill(spread=spread);
        mirror([1, 0, 0])
            geeetech_rostock_g2_jhead_x2_drill(spread=spread);
    }
}

module geeetech_rostock_g2_jhead_x2_lower(spread=0, groovemount = 5)
{
    difference() {
        union() {
            minkowski() {
                difference() {
                    cylinder(r=18.5, h=groovemount-1, $fn=30);
                    translate([(9.75+spread/2), 0, 0])
                        cylinder(r=7, h=9, $fn=30);
                    translate([(9.75+spread/2), -7, 0])
                        cube([10, 14, 9]);
                    translate([-(9.75+spread/2), 0, 0])
                        cylinder(r=7, h=9, $fn=30);
                    translate([-(19.75+spread/2), -7, 0])
                        cube([10, 14, 9]);
                }
                cylinder(d=2, h=0.5, $fn=24);
            }

            translate([0, 0, groovemount-0.5]) minkowski() {
                difference() {
                    cylinder(r=18.5, h=(9-groovemount), $fn=30);
                    translate([(9.75+spread/2), 0, 0])
                        cylinder(r=9.25, h=6, $fn=30);
                    translate([(9.75+spread/2), -9.25, 0])
                        cube([10, 18.5, 6]);
                    translate([-(9.75+spread/2), 0, 0])
                        cylinder(r=9.25, h=6, $fn=30);
                    translate([-(19.75+spread/2), -9.25, 0])
                        cube([10, 18.5, 6]);
                }
                cylinder(d=2, h=0.5, $fn=24);
            }
        }

        translate([0, 0, 3]) {
            geeetech_rostock_g2_jhead_x2_drill_bolt();
            mirror([1, 0, 0])
                geeetech_rostock_g2_jhead_x2_drill_bolt();
        }
    }
}

module geeetech_rostock_g2_jhead_x2_mount(spread=0)
{
    geeetech_rostock_g2_jhead_x2_upper(spread=spread);
    rotate([0, 180, 0]) geeetech_rostock_g2_jhead_x2_lower(spread=spread);
    translate([-(10+spread/2), 0, -5]) children(0);
    translate([ (10+spread/2), 0, -5]) children(1);
}


// Debug interference model
union() {
    # translate([-31.5, -20, 0]) import("G2s/GTH3-B02-01-Mount.STL");
    geeetech_rostock_g2_jhead_x2_upper();
}

rotate([0, 180, 0]) {
    # translate([-18.12, -19.5, 0]) import("G2s/GTH3-B02-02-Mount.STL");
    geeetech_rostock_g2_jhead_x2_lower();
}
