//
// Copyright (C) 2016, Jason S. McMullan <jason.mcmullan@gmail.com>
// All rights reserved.
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

module ptfe_splicer(barrel = 3, aim = 4, hexnut = 10, thread = 6)
{
    h = barrel*2 + aim;
    difference() {
        cylinder(d=hexnut/sqrt(3)*2, h=h, $fn=6);
        translate([0, 0, barrel + aim]) cylinder(d=thread, h=barrel+0.1, $fn = 60);
        translate([0, 0, barrel + aim/2 -0.1]) cylinder(d1 = 2, d2 = thread, h = aim/2 + 0.1, $fn = 60);
        translate([0, 0, barrel - 0.1]) cylinder(d = 2, h = aim/2 + 0.1, $fn = 60);
        translate([0, 0, -0.1]) cylinder(d = thread, h = barrel + 0.2, $fn = 60);
        // Direction of flow arrow
        for (a = [0:5]) rotate([0, 0, a*60]) {
            translate([0, hexnut/2, barrel - 0.1]) cylinder(d = 1, h = barrel/2 + aim + 0.1, $fn=6);
            translate([0, hexnut/2, barrel/2]) cylinder(d1 = 0, d2 = 2, h = barrel/2, $fn = 6);
        }
    }
}


ptfe_splicer();
// vim: set shiftwidth=4 expandtab: //
