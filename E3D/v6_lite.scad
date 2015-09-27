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

include <utility.scad>

include <v6_block.scad>
include <v6_nozzle.scad>

// Cold side of the hot end, origin at center of filament feed, bottom of sink
// Children are attached at the bottom center of the groove mount
module e3d_v6_lite_sink() {
    difference() {
        union() {
            // M6x1 threaded connector
            translate([0, 0, -5.1]) {
                cylinder(d=5.8, h=0.1, $fn=24);
                translate([0, 0, 0.1]);
                cylinder(d=6, h=5, $fn=24);
            }
            // And up the stack we go...
            hanoi(d=5.5, h=2)
            hanoi(d=22.3, h=1)
            hanoi(d=7.3, h=2)
            hanoi(d=20, h=1)
            hanoi(d=6.1, h=2.25)
            hanoi(d=20, h=1)
            hanoi(d=6.1, h=2.25)
            hanoi(d=20, h=1)
            hanoi(d=7, h=2)
            hanoi(d=22, h=1)
            hanoi(d=14, h=1.5)
            hanoi(d=22, h=1)
            hanoi(d=7, h=2)
            hanoi(d=20, h=1)
            hanoi(d=6.1, h=3)
            hanoi(d=20, h=1)
            hanoi(d=7, h=2)
            hanoi(d=22, h=1)
            hanoi(d=9, h=1.5)
            hanoi(d=16, h=1)
            hanoi(d=9, h=1.5)
            hanoi(d=16, h=3)
            hanoi(d=12, h=6)
            hanoi(d=16, h=3.7);
        }
        // Central bore
        translate([0, 0, -5.2])
                cylinder(d=4, h=0.1+7.1+42.7+0.1, $fn=24);
        // Bowden coupler bore
        translate([0, 0, 2.1+42.7-6.5-1.5]) {
                cylinder(d1=4, d2=8, h=1.5, $fn=24);
                translate([0, 0, 1.5])
                cylinder(d=8, h=6.5, $fn=24);
        }
    }

    children();
}

// Origin is bottom center of the groove mount
module e3d_v6_lite()
{
    translate([0, 0, -53])
        e3d_v6_nozzle()
        e3d_v6_block()
        e3d_v6_lite_sink();
}

e3d_v6_lite();


// vim: set shiftwidth=4 expandtab: //
