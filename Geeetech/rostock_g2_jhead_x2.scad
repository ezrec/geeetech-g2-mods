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


module geeetech_rostock_g2_spider_jhead_x2_drill()
{
    translate([10, 0, -0.1])
        cylinder(d=17, h=6.2);
    translate([7.5, 13, -0.1]) {
        cylinder(d=3.6, h=6.2, $fn=12);
        translate([0, 0, 3]) {
            cylinder(r=6/sqrt(3), h=4, $fn=6);
        }
    }
    translate([7.5, -13, -0.1]) {
        cylinder(d=3.6, h=6.2, $fn=12);
        translate([0, 0, 3]) {
            cylinder(r=6/sqrt(3), h=4, $fn=6);
        }
    }

    translate([25, 0, -0.1]) {
        cylinder(d=4.6, h=6.2, $fn=12);
        translate([0, 0, 3.6]) {
            cylinder(r=7/sqrt(3), h=4, $fn=6);
        }
    }
}

module geeetech_rostock_g2_spider_jhead_x2()
{
    difference() {
        union() {
            cylinder(r=20, h=6, $fn=120);
            translate([-31.5, -12.5, 0])
                cube([63, 25, 6]);
        }

        // J-head drills
        geeetech_rostock_g2_spider_jhead_x2_drill();
        mirror([1, 0, 0])
            geeetech_rostock_g2_spider_jhead_x2_drill();
    }

}

// Debug interference model
if (false) {
    color([1,0,0]) translate([-31.5, -20, 0])
        import("GTH3-B02-01-Mount.STL");
    geeetech_rostock_g2_spider_jhead_x2();
}
