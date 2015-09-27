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

module blower(height=40.5, width=40.0, depth=19.5, spacing=49.0) {
    difference() {
        translate([-width/2, -height/2, 0])
            cube([width, height, depth]);
        translate([0, 0, -0.1]) {
            translate([-width/2-0.1, -height/2-0.1, 0]) cube([width*0.75+0.1, height*0.01+0.1, depth+0.2]);
            translate([-width/2+5.25, -height/2-0.1, 0.5+0.1])
                cube([width*0.75-6.25, height/2, depth-1]);
            translate([0, 0, 0.5 + 0.1]) cylinder(d=width*0.7, h=depth+0.2);
            translate([spacing/2*sin(45), spacing/2*cos(45), 0])
                cylinder(d=3.3, h=depth+0.2, $fn=24);
            translate([-spacing/2*sin(45), spacing/2*cos(45), 0])
                cylinder(d=3.3, h=depth+0.2, $fn=24);
            translate([spacing/2*sin(45), -spacing/2*cos(45), 0])
                cylinder(d=3.3, h=depth+0.2, $fn=24);
            translate([-spacing/2*sin(45), -spacing/2*cos(45), 0])
                cylinder(d=3.3, h=depth+0.2, $fn=24);
        }
    }
    cylinder(d=width*0.6, h=depth*0.8, $fn=5);
}

# blower();

// vim: set shiftwidth=4 expandtab: //
