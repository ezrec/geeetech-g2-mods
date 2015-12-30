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

use <e3d_v6_mount.scad>
use <e3d_v6_probe.scad>
use <E3D/v6_lite.scad>
use <blower_40mm.scad>
use <mini_height_sensor.scad>
use <Geeetech/rostock_g2_spider.scad>

// Optimize part for quickest printing - use an integer multiple of the printer's nozzle size
machine_nozzle = 0.4;   // Your part printing machine's nozzle width
wall_width = machine_nozzle * 2;    // Wall thickness - should be a multiple of machine_nozzle;

// Size of the output of the blower
blower_out= [16.3, 25.5, 3];

neck_width = 20; // Distance between head bolts for the neck
nozzle_width = 15;
blower_volume = blower_out[0]*blower_out[1];

duct_z = 36; // Height from base to next
duct_height = duct_z;

head_gap = 30; // Distance between J-heads
duct_gap = 9; // Distance from J-heads

blower_shift_extra = 10;

neck_height = 35;

// Calculated parameters

neck_size = [blower_out[0]+2*wall_width, neck_width];
duct_slice = 0.1;


blower_shift = ((blower_out[1]+2*wall_width)-neck_width)/2;

module e3d_v6_fan_duct_slice(size=[blower_out[0]+2*wall_width, neck_width], cutout=false, guides=4)
{
       difference() {
        square([size[0], size[1]]);
        translate([wall_width, wall_width]) square([size[0]-wall_width*2, size[1]-wall_width*2]);
        if (cutout)
            translate([0, wall_width]) square([wall_width, size[1]-wall_width*2]);
    }
    if (guides > 0) for (i = [1:guides-1]) {
        translate([0,(size[1]-wall_width)/guides*i+wall_width/2, 0])
        square([size[0], wall_width]);
    }
}

module e3d_v6_fan_duct_blower_adapter(height=7, size)
{
     difference() {
        union() {
            translate([wall_width, wall_width, 0]) cube([size[0], size[1], height+size[2]]);
            translate([-1, -1, height-1]) cube([size[0]+2, size[1]+2, 1]);
            cube([size[0]+2*wall_width, size[1]+2*wall_width, height]);
        }
        translate([wall_width*2, wall_width*2, -0.1])
          cube([size[0]-2*wall_width, size[1]-2*wall_width, height+size[2]+0.2]);
      }
      
      linear_extrude(height=height+size[2]) e3d_v6_fan_duct_slice(size=size);

      * translate([0, 0, height/2]) e3d_v6_fan_duct_zip_tie_mount(size=[size[1]+2*wall_width, height]);

     % translate([-1.6, 18, height+20])
        rotate([-90, 180, -90]) blower();
}

module e3d_v6_fan_duct_outlet(ro=12, ri=7)
{
    rotate_extrude(convexity=4, $fn=180) {
        translate([ri, 0]) 
            difference() {
                square([ro-ri, 4]);
                translate([wall_width, 0]) square([4-wall_width*2, 4-wall_width]);
            }
        }
    difference() {
        cylinder(r=ro, h=4-wall_width*3, $fn=180);
        translate([0, 0, -0.1]) cylinder(r1=ri+2*wall_width, r2=ro-wall_width, h=4-wall_width*3 + 0.2, $fn=180);
    }
}

module e3d_v6_fan_duct_outflow()
{
    out_depth = blower_volume / (nozzle_width * 2);

    for (slice=[0:duct_slice:duct_height]) {
        scale_from = (duct_height-slice)/(duct_height);
        scale_to = slice/(duct_height);
        translate([30*scale_from+duct_gap*scale_to, -neck_width/2*scale_from + (-head_gap/2-nozzle_width/2)*scale_to, 30-slice-duct_slice])
            linear_extrude(height=duct_slice) e3d_v6_fan_duct_slice(size=[neck_size[0]*scale_from+out_depth*scale_to,nozzle_width], guides=2);
    }

    // Exit ducting & fan mount
     translate([duct_gap, -head_gap/2-nozzle_width/2, 30-duct_height-3]) {
        cube([out_depth, nozzle_width, wall_width]);
        translate([0,0, wall_width]) linear_extrude(height=3) e3d_v6_fan_duct_slice(size=[out_depth, nozzle_width], guides=2);
        difference() {
            translate([-duct_gap, nozzle_width/2, duct_z - duct_height])
                    e3d_v6_fan_duct_outlet(ro=12);
            translate([-wall_width, wall_width, wall_width+0.01]) cube([out_depth, nozzle_width-2*wall_width, 3-wall_width]);
        }
    }
}

module e3d_v6_fan_duct_attachment(height=4, spread = 30)
{
      difference() {
        translate([10, -10, -height]) union() {
            cube([neck_width, 20, height]);
            translate([-1, -15, 0]) cube([7, 50, height]);
        }
        translate([0, 0, -height]) rotate([0, 0, -90]) geeetech_rostock_g2_spider_drill(height=height);
        translate([0, spread/2, -height-0.1]) cylinder(d=23, h = height + 0.2); 
        translate([0, -spread/2, -height-0.1]) cylinder(d=23, h = height + 0.2); 
      }
}

module e3d_v6_fan_duct(height=40)
{
    translate([0, 0, -height]) {
        translate([30-blower_shift-blower_shift_extra, -blower_shift-neck_width/2, 30+neck_height + blower_shift_extra]) {
          e3d_v6_fan_duct_blower_adapter(height=7, size=blower_out);
        }
        translate([30, -neck_width/2, 30]) {
            translate([-blower_shift, -blower_shift, neck_height]) for (i = [0:0.1:blower_shift_extra])
                translate([-i, 0, i])
                linear_extrude(height=0.1) e3d_v6_fan_duct_slice(size=[blower_out[0]+2*wall_width, blower_out[1]+wall_width*2]);

            translate([-blower_shift, 0, neck_height])  for (i = [0:0.1:blower_shift]) {
                translate([i, i-blower_shift, -i-0.1]) {
                    linear_extrude(height=0.1) e3d_v6_fan_duct_slice(size=[blower_out[0]+2*wall_width, blower_out[1]+2*wall_width-i*2]);

                }
            }
            linear_extrude(height=neck_height-blower_shift, convexity=4) e3d_v6_fan_duct_slice(size=neck_size);
        }
 
        e3d_v6_fan_duct_outflow();
        mirror([0, 1, 0]) e3d_v6_fan_duct_outflow();
        
    }
    
    e3d_v6_fan_duct_attachment();
 
}

 % union() {
    rotate([0, 0, 90]) e3d_v6_spider() {
            rotate([0, 0, 0]) e3d_v6_lite();
            rotate([0, 0, 180]) e3d_v6_lite();
    }
    rotate([0, 0, -90]) e3d_v6_probe();
}

// 37 = Geeetech j-heads
// 47 = E3D heads
e3d_v6_fan_duct();
