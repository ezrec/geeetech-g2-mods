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
// All units are in mm

use <utility.scad>

module geeetech_jhead_peek_nozzle()
{
    cylinder(d1=1, d2=8, h=1.5);
    translate([0, 0, 1.5]) {
        cylinder(d=8, h=3);
        translate([0, 0, 3]) {
            translate([-5, -8])
                cube([16, 18, 9.5]);
            translate([0, 0, 9.5])
                children();
        }
    }
}

// Origin is bottom center of J-Head lock ring
module geeetech_jhead_peek()
{
    translate([0, 0, -45])
        difference() {
            geeetech_jhead_peek_nozzle()
            utility_hanoi(d=11, h=2)
            utility_hanoi(d=16, h=29)
            utility_hanoi(d=12, h=4.6)
            utility_hanoi(d=16, h=4.8)
            utility_hanoi(d=9.75, h=0.5)
            utility_hanoi(d=11, h=7, fn=6)
            utility_hanoi(d=9.75, h=2)
            utility_hanoi(d=8, h=1+2/3)
            utility_hanoi(d=11.2, h=1+1/3);

            translate([0, 0, 2])
                cylinder(d=4.25, h=67.2, $fn=24);
        }
}

geeetech_jhead_peek();
// vim: set shiftwidth=4 expandtab: //
