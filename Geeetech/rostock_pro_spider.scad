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

pro_spider_holder = 6; // mm
pro_spider_drill = 4; // mm

module geetech_rostock_pro_spider_blank_holder(height)
{
    difference() {
        translate([14, 15, 0]) cube([11, 28, height]);
        translate([12-0.1, 37, height/2]) rotate([0, 90, 0])
                cylinder(d=pro_spider_holder, h=20.2, $fn = 180);
    }
}

module geetech_rostock_pro_spider_blank(height = 10)
{
   difference() {
       cylinder(r=60/sqrt(3), h=height, $fn=6);
       translate([0, 0, -0.1]) cylinder(d=40, h=height+0.2, $fn=180);
   }
   for (i = [0:3]) {
       rotate([0, 0, 120 * i]) {
            geetech_rostock_pro_spider_blank_holder(height=height);
            mirror([1, 0, 0]) geetech_rostock_pro_spider_blank_holder(height=height);
       }
   }
}

module geetech_rostock_pro_spider_drill(height = 10.5)
{
    for (i = [0:6]) {
        rotate([0, 0, 60 * i]) translate([0, 25, -0.1]) cylinder(d=pro_spider_drill+0.2, h=height+0.2, $fn=36);
    }
}

module geetech_rostock_pro_spider()
{
    difference() {
        geetech_rostock_pro_spider_blank();
        geetech_rostock_pro_spider_drill();
    }
}

if (0) {
    pscale = 10;
    # scale([pscale, pscale, pscale]) translate([0, 4.25, -0.985]) rotate([-90, 0, 180]) import("PRO_SPIDER.stl");
}

geetech_rostock_pro_spider();

// vim: set shiftwidth=4 expandtab: //
