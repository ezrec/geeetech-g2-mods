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
bed_screw_inset = -5;

// Fan size
fan_size = 40;
fan_depth = 11;

// Fan screw 
fan_screw_diameter = 3.5;
fan_screw_inset = [-4, -4 ];
fan_screw_length = 50;
fan_nut_face = 5.5;
fan_nut_head = 5;
fan_nut_wall = 1.5;

// Clip face
clip_face = 10;

// Tolerance
tolerance = 0.3;

fn = 30;

module fan_void_bolt()
{
    rotate([-90, 0, 0]) {
        cylinder(d = fan_screw_diameter + tolerance*2, h = fan_screw_length, $fn = 60);
        translate([0, 0, fan_screw_length/2 - fan_nut_head - fan_nut_wall])
            cylinder(r = fan_nut_face/sqrt(3) + tolerance*2, h = fan_nut_head, $fn = 6);
        translate([0, 0, fan_screw_length/2 + fan_depth + fan_nut_head + fan_nut_wall])
            cylinder(r = fan_nut_face/sqrt(3) + tolerance*2, h = fan_nut_head, $fn = 6);
    }
}
        

module fan_void()
{ 
    translate([-fan_size/2 - tolerance, 0, -tolerance])
        cube([fan_size+tolerance*2, fan_depth + 5, fan_size + tolerance*2]);
    
    translate([0, -fan_screw_length/2, fan_size/2])
        rotate([-90, 0, 0]) cylinder(r = fan_size/2 - 1, h = fan_screw_length);
    
    translate([-fan_size/2 - fan_screw_inset[0], -fan_screw_length/2, -fan_screw_inset[1]])
        fan_void_bolt();
    translate([-fan_size/2 - fan_screw_inset[0], -fan_screw_length/2, fan_size + fan_screw_inset[1]])
        fan_void_bolt();
    translate([fan_size/2 + fan_screw_inset[0], -fan_screw_length/2, -fan_screw_inset[1]])
        fan_void_bolt();
    translate([fan_size/2 + fan_screw_inset[0], - fan_screw_length/2, fan_size + fan_screw_inset[1]])
        fan_void_bolt();
}

module bed_standoff(chuck_height = 2, cutout = false)
{ 
    difference() {
        union() {
            translate([0, -bed_diameter/2 - bed_screw_inset, 0])
                cylinder(d = bed_screw_diameter*2, h = bed_standoff_height, $fn = fn);
            translate([0, -bed_diameter/2 - clip_face/2*cos(36), 0]) {
                translate([0, 0, (cutout ? -tolerance: 0)]) rotate([0, 0, -18])
                    cylinder(r = clip_face/sqrt(3) + (cutout ? tolerance : 0), h = bed_standoff_height + chuck_height + (cutout ? tolerance*2 : 0), $fn = 5);
            translate([-clip_face/sqrt(3)/2, -clip_face/3, 0])
                cube([clip_face/sqrt(3), -bed_screw_inset + bed_screw_diameter + clip_face/3, bed_standoff_height + chuck_height]);
            }        
        }
        translate([0, -bed_diameter/2 - bed_screw_inset, -0.01])
                cylinder(d = bed_screw_diameter + tolerance*2, h = bed_standoff_height + chuck_height + 0.02, $fn = fn);
        translate([0, 0, bed_standoff_height - 0.01 + (cutout ? tolerance : 0)])
            cylinder(d = bed_diameter + tolerance*4, h = bed_total_height, $fn = fn*2);
    }
}

module fan_bed_clip()
{
    width =  tolerance + fan_depth - bed_screw_inset - bed_screw_diameter/2 - tolerance*2;
    
    difference() {
        translate([-fan_size*0.99/2, -bed_diameter/2 - width - tolerance*2, 0])
            cube([fan_size * 0.99, width, bed_total_height -fan_screw_inset[1] + fan_screw_diameter/2*3]);
                   
        translate([0, -bed_diameter/2 - fan_nut_wall - fan_size/2, bed_total_height])
            fan_void();
        
       bed_standoff(cutout = true);
        
       translate([0, -bed_diameter/2 - width/2, 0]) 
        scale([1, 1, bed_total_height/(width/2)]) {
                translate([-fan_size/2 + width/2, 0,  0]) sphere(r = width/2 - 2);
                translate([fan_size/2 - width/2, 0, 0]) sphere(r = width/2 - 2);
        }
        
    }
}

fan_bed_clip();

// vim: set shiftwidth=4 expandtab: //
