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

module geeetech_rostock_g2_jhead_x1_drill_m4()
{
    translate([0, 0, 2.40]) rotate([0, 0, 30]) cylinder(r=6.81/sqrt(3), h=8, $fn=6);
    cylinder(d=4.52, h=6, $fn=24);
}

module geeetech_rostock_g2_jhead_x1_drill_m3()
{
    translate([0, 0, 2.40]) cylinder(r=5.9/sqrt(3), h=8, $fn=6);
    translate([0, 0, -4])
    cylinder(d=3.52, h=10, $fn=24);
}

module geeetech_rostock_g2_jhead_x1_bolts()
{
    translate([7.5, 13, 0]) geeetech_rostock_g2_jhead_x1_drill_m3();
    translate([-7.5, 13, 0]) geeetech_rostock_g2_jhead_x1_drill_m3();
    translate([7.5, -13, 0]) geeetech_rostock_g2_jhead_x1_drill_m3();
    translate([-7.5, -13, 0]) geeetech_rostock_g2_jhead_x1_drill_m3();
}

module geeetech_rostock_g2_jhead_x1_upper()
{
    difference() {
        minkowski() {
            intersection() {
                cylinder(r=26, h=4, $fn=90);
                translate([-10, -30]) cube([20, 60, 4]);
            }
            cylinder(r=4,h=0.8, $fn=24);
        }
        translate([0, 0, -0.1]) 
            cylinder(d=16.5, h=5, $fn=60);
        translate([0, -25, 0]) geeetech_rostock_g2_jhead_x1_drill_m4();
        translate([0, 25, 0]) geeetech_rostock_g2_jhead_x1_drill_m4();

        geeetech_rostock_g2_jhead_x1_bolts();
    }
}

/* Use groovemount = 5mm for Geeetech J-Heads, groovemount = 6mm for E3D hotends
 */
module geeetech_rostock_g2_jhead_x1_lower(groovemount = 5)
{
    difference() {
        cylinder(d=38.75, h=9, $fn=64);
        translate([-1, 0, -0.1]) cylinder(d=12.025, h=9.2, $fn=48);
        translate([-1, -12.025/2, -0.1]) cube([39/2 + 1 + 0.1, 12.025, 9.2]);
        translate([-1, 0, groovemount - 0.05]) cylinder(d=16.5, h=9, $fn=48);
        translate([-1, -16.25/2,groovemount - 0.05 ]) cube([39/2 + 1 + 0.1, 16.5, 9.2]);
        translate([0, 0, 3.6]) geeetech_rostock_g2_jhead_x1_bolts();
    }
}

union() {
    union() {
        # translate([-14, -30, 0]) import("G2/GTH3-B01-01-Mount.STL");
        geeetech_rostock_g2_jhead_x1_upper();
    }
    rotate([0, 180, 0]) {
        # rotate([0, 0, 180]) translate([-18.55, -19.5]) import("G2/GTH3-B01-02-Mount.STL");
        geeetech_rostock_g2_jhead_x1_lower();
    }
}

// vim: set shiftwidth=4 expandtab: //
