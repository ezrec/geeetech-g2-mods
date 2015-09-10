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

// Origin is bottom, center
module e3d_v6_break()
{
    difference() {
        union() {
                cylinder(r=6/sqrt(3), h=5, $fn=6);
                translate([0, 0, 5])
                    cylinder(d=2.8, h=2.1, $fn=10);
                translate([0, 0, 7.1])
                    cylinder(r=7/sqrt(3), h=10, $fn=6);
                translate([0, 0, 17.1])
                    cylinder(d=6, h=4.8);

        }
        translate([0, 0, -0.1])
                cylinder(d=2, h=15, $fn=10);
        translate([0, 0, 10+7.1])
                cylinder(d=4.2, h=5, $fn=10);
    }
}

// vim: set shiftwidth=4 expandtab: //
