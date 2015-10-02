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

// Like the towers of hanoi, this adds a cylinder, then calls
// children() to stack another on top. Useful for modelling J-Heads
module utility_hanoi(d=1, h=1, fn=24)
{
    cylinder(d=d, h=h, $fn=fn);
    translate([0, 0, h])
        children();
}


// make a plate with mitred edges
module utility_plate_mitred_edge(size=[20, 30, 4], radius=4)
{
    hull() {
        translate([-(size[0]/2-radius), (size[1]/2-radius)])
            cylinder(r=radius, h=size[2], $fn=24);
        translate([-(size[0]/2-radius), -(size[1]/2-radius)])
            cylinder(r=radius, h=size[2], $fn=24);
        translate([(size[0]/2-radius), (size[1]/2-radius)])
            cylinder(r=radius, h=size[2], $fn=24);
        translate([(size[0]/2-radius), -(size[1]/2-radius)])
            cylinder(r=radius, h=size[2], $fn=24);
    }
}

module utility_plate_mitred_top(size=[20, 30, 20], radius=4)
{
    translate([-size[0]/2, -size[1]/2, 0])
    hull() {
        cube([size[0], size[1], size[2] - radius]);
        translate([radius, 0, size[2] - radius])
            rotate([-90, 0, 0]) {
                cylinder(r=radius, h=size[1]);
                translate([size[0]-radius*2, 0, 0])
                    cylinder(r=radius, h=size[1]);
        }
    }
}

// make a torus a mitred top
module utility_torus_mitred_top(id=10, od=40, height=8, radius=2)
{
    rotate_extrude() {
       hull() {
            translate([id/2+radius, height-radius]) circle(r=radius,$fn=24);
            translate([od/2-radius, height-radius]) circle(r=radius,$fn=24);
            translate([id/2,0]) square([(od-id)/2, height-radius]);
        }
    }
}

// vim: set shiftwidth=4 expandtab: //
