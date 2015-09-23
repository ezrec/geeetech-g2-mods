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
    translate([0, 0, 2.40]) rotate([0, 0, 0]) cylinder(r=5.6/sqrt(3), h=8, $fn=6);
    cylinder(d=3.52, h=6, $fn=24);
}

module geeetech_rostock_g2_spider_bracket()
{
    difference() {
        intersection() {
            cylinder(r=30, h=4.8);
            translate([-14, -30]) cube([28, 60, 4.8]);
        }
        translate([0, 0, -0.1]) 
            cylinder(d=16.5, h=5, $fn=60);
        translate([0, -25, 0]) drill_m4();
        translate([0, 25, 0]) drill_m4();
        translate([7.5, 13, 0]) drill_m3();
        translate([-7.5, 13, 0]) drill_m3();
        translate([7.5, -13, 0]) drill_m3();
        translate([-7.5, -13, 0]) drill_m3();

    }
}

if (false) {
    translate([-14, -30, 0]) color([1, 0, 0]) import("/home/jmcmullan/private/Geeetech-G2S/stl/Geeetech/G2/GTH3-B01-01-Mount.STL");
    geeetech_rostock_g2_spider_bracket();
}

// vim: set shiftwidth=4 expandtab: //
