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

module drill_m4()
{
    translate([0, 0, 2.40]) rotate([0, 0, 30]) cylinder(r=6.81/sqrt(3), h=8, $fn=6);
    cylinder(d=4.52, h=6, $fn=24);
}

module drill_m3()
{
    translate([0, 0, 2.40]) rotate([0, 0, 30]) cylinder(r=5.6/sqrt(3), h=8, $fn=6);
    cylinder(d=3.52, h=6, $fn=24);
}

module geeetech_rostock_g2s_spider_bracket()
{
    difference() {
        union() {
            cylinder(r=20, h=6, $fn=60);
            translate([-6.5, -25.5]) minkowski() {
                cube([13, 51, 2]);
                cylinder(r=6, h=4, $fn=24);
            }
        }
        translate([0, 0, -0.1]) {
            translate([0, -10, 0])
            cylinder(d=16.5, h=6.2, $fn=60);
            translate([0, 10, 0])
            cylinder(d=16.5, h=6.2, $fn=60);
        }
        translate([0, -25, 0]) drill_m4();
        translate([0, 25, 0]) drill_m4();
        translate([13, 7.5, 0]) drill_m3();
        translate([-13, 7.5, 0]) drill_m3();
        translate([13, -7.5, 0]) drill_m3();
        translate([-13, -7.5, 0]) drill_m3();

    }
}

if (false) {
    translate([20, -31.5, 0]) color([1, 0, 0])  rotate([0, 0, 90])
    import("GTH3-B02-01-Mount.STL");

    geeetech_rostock_g2_spider_bracket();
}

// vim: set shiftwidth=4 expandtab: //
