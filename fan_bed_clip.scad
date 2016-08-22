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
// All units are in mm

// Bed Diameter
bed_diameter = 215;

// Standoff height
bed_standoff_height = 10;
bed_total_height = 17;


// Screw diameter
bed_screw_diameter = 3.5;
bed_screw_inset = -6;

// Fan size
fan_size = 40;
fan_depth = 11;

// Fan screw 
fan_screw_diameter = 3.5;
fan_screw_inset = [-4, -4 ];

// Tolerance
tolerance = 0.3;

fn = 30;

module fan_void()
{
    fan_screw_length = 50;
    
    translate([-fan_size/2 - tolerance, 0, -tolerance])
        cube([fan_size+tolerance*2, fan_depth + 5, fan_size + tolerance*2]);
    
    translate([0, -fan_screw_length/2, fan_size/2])
        rotate([-90, 0, 0]) cylinder(r = fan_size/2 - 1, h = fan_screw_length);
    
    translate([-fan_size/2 - fan_screw_inset[0], -fan_screw_length/2, -fan_screw_inset[1]])
        rotate([-90, 0, 0]) cylinder(d = fan_screw_diameter + tolerance*2, h = fan_screw_length, $fn = fn);
    translate([-fan_size/2 - fan_screw_inset[0], -fan_screw_length/2, fan_size + fan_screw_inset[1]])
        rotate([-90, 0, 0]) cylinder(d = fan_screw_diameter + tolerance*2, h = fan_screw_length, $fn = fn);
    translate([fan_size/2 + fan_screw_inset[0], -fan_screw_length/2, -fan_screw_inset[1]])
        rotate([-90, 0, 0]) cylinder(d = fan_screw_diameter + tolerance*2, h = fan_screw_length, $fn = fn);
    translate([fan_size/2 + fan_screw_inset[0], - fan_screw_length/2, fan_size + fan_screw_inset[1]])
        rotate([-90, 0, 0]) cylinder(d = fan_screw_diameter + tolerance*2, h = fan_screw_length, $fn = fn);
}

module fan_bed_clip()
{
    width =  tolerance + fan_depth - bed_screw_inset - bed_screw_diameter/2 - tolerance*2;
    
    difference() {
        union() {
            translate([0, -bed_diameter/2 - bed_screw_inset, 0]) difference() {
                cylinder(d = bed_screw_diameter*2, h = bed_standoff_height, $fn = fn);
                translate([0, 0, -0.01])
                    cylinder(d = bed_screw_diameter + tolerance*2, h = bed_standoff_height + 0.02, $fn = fn);
            }
            translate([-fan_size*0.99/2, -bed_diameter/2 - fan_depth - tolerance, 0])
                cube([fan_size * 0.99, width, bed_total_height -fan_screw_inset[1] + fan_screw_diameter/2*3]);
            

        }
        
        translate([0, -bed_diameter/2 - fan_size/2, bed_total_height])
            fan_void();
        translate([0, 0, bed_standoff_height - 0.01
        ])
            cylinder(d = bed_diameter + tolerance*4, h = bed_total_height, $fn = fn*2);
        
       translate([0, -bed_diameter/2 - fan_depth - tolerance + width/2, 0]) 
        scale([1, 1, bed_total_height/(width/2)]) hull() {
                translate([-fan_size/2 + width/2, 0,  0]) sphere(r = width/2 - 2);
                translate([fan_size/2 - width/2, 0, 0]) sphere(r = width/2 - 2);
        }
        
    }
}

fan_bed_clip();

// vim: set shiftwidth=4 expandtab: //
