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

module mini_height_sensor(width=1)
{
   scale([1, width, 1]) difference() {
        cube([24.0, 1, 17.62]);
        translate([0, -0.1, 0]) {
            translate([2.7,  0, 14.92])
                rotate([-90, 0, 0]) cylinder(d=2.8, h=1.2, $fn=24);
            translate([21.11, 0, 14.92])
                rotate([-90, 0, 0]) cylinder(d=2.8, h=1.2, $fn=24);
        }
    }
}

module mini_height_sensor_drill(post=4)
{
    translate([-24/2, 0, 0]) {
        translate([2.7, 0.1, 14.92]) rotate([90, 0, 0]) cylinder(d=2.5, h=post+0.2, $fn=24);
        translate([21.11, 0.1, 14.92]) rotate([90, 0, 0]) cylinder(d=2.5, h=post+0.2, $fn=24);
    }
}

// Origin is bottom middle of the sensor itself
module mini_height_sensor_mount(post=4, base=10)
{
    difference() {
        translate([-24/2, 0, 0]) {
            union() {
                translate([2.7, 0, 14.92]) rotate([90, 0, 0]) {
                    cylinder(d1=base, d2=4, h=post, $fn=24);
                }
                translate([21.11, 0, 14.92]) rotate([90, 0, 0]) {
                    cylinder(d1=base, d2=4, h=post, $fn=24);
                }
            }
        }
        mini_height_sensor_drill(post=post);
    }

    translate([-24/2, 0, 0]) 
        % translate([0, -(post+1), 0])
            mini_height_sensor();
}

# mini_height_sensor_mount();
// vim: set shiftwidth=4 expandtab: //
