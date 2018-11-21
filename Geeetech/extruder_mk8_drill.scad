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

module geeetech_extruder_mk8()
{
    // L-bracket
    translate([-(50/2), -(50/2), 0]) {
        difference() {
            cube([50, 50, 5]);
            translate([20, 10, -0.1]) cylinder(d=5, h=5.2, $fn=24);
            translate([20, 10+30, -0.1]) cylinder(d=5, h=5.2, $fn=24);
            translate([20+24, 10, -0.1]) cylinder(d=5, h=5.2, $fn=24);
            translate([20+24, 10+30, -0.1]) cylinder(d=5, h=5.2, $fn=24);
        }
        cube([5, 50, 50]);
    }
    // Filament area
    translate([-(50/2+20), -(50-8)/2, 8]) {
        difference() {
            cube([20, 42, 42]);
            translate([8, 15, -0.1]) cylinder(d=4, h=42.2, $fn=24);
        } 
    }
}

projection(cut = false) {
    geeetech_extruder_mk8();
    translate([0, 60, 0]) geeetech_extruder_mk8();
}

// vim: set shiftwidth=4 expandtab: //
