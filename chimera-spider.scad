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

include <E3D/chimera.scad>
include <Geeetech/rostock_g2_spider.scad>

module geeetech_spider_e3d_chimera(zprobe = true)
{
    difference() {
        union() {
            rotate([0, 0, 240])
            geeetech_rostock_g2_spider_blank(zprobe);
        }
        translate([-9, 0, -0.1])
            cylinder(d=10, h=10, $fn=16);
        translate([9, 0, -0.1])
            cylinder(d=10, h=10, $fn=16);
        translate([0, -3, -0.1])
            cylinder(d=3, h=10, $fn=16);
        translate([-9, 9, -0.1])
            cylinder(d=3, h=10, $fn=16);
        translate([9, 9, -0.1])
            cylinder(d=3, h=10, $fn=16);
    }

    % translate([-15, -6, 0])     e3d_v6_chimera();
}


geeetech_spider_e3d_chimera();

// vim: set shiftwidth=4 expandtab: //
