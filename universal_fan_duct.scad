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

use <Geeetech/jhead_peek.scad>
use <Geeetech/rostock_g2_spider.scad>
use <Geeetech/rostock_g2_jhead_x2.scad>
use <E3D/v6_lite.scad>
use <blower_40mm.scad>
use <mini_height_sensor.scad>

// Optimize part for quickest printing - use an integer multiple of the printer's nozzle size
machine_nozzle = 0.3;   // Your part printing machine's nozzle width
wall_width = machine_nozzle*2;    // Wall thickness - should be a multiple of machine_nozzle;

// Size of the output of the blower
blower_out= [16.3, 26, 4];

duct_twist = 30; // Twist from mounting area to parallel with the nozzles

neck_width = 20; // Distance between head bolts for the neck

probe_mount = [1, 25, 18];

duct_z = 34; // Height from base to next
duct_height = duct_z - probe_mount[2];

head_gap = 36; // Distance between J-heads
duct_gap = 15; // Distance from J-heads

blower_shift_extra = 10;

neck_height = 33;

// Calculated parameters

neck_size = [blower_out[0]+2*wall_width, neck_width];
duct_slice = 0.1;


blower_shift = ((blower_out[1]+2*wall_width)-neck_width)/2;

module universal_fan_duct_slice(size=[blower_out[0]+2*wall_width, neck_width], cutout=false, guides=false)
{
       difference() {
        square([size[0], size[1]]);
        translate([wall_width, wall_width]) square([size[0]-wall_width*2, size[1]-wall_width*2]);
        if (cutout)
            translate([0, wall_width]) square([wall_width, size[1]-wall_width*2]);
    }
    if (guides) for (i = [1:3]) {
        translate([0,(size[1]-wall_width)/4*i+wall_width/2, 0])
        square([size[0], wall_width]);
    }
}

module universal_fan_duct_zip_tie_slice(od=6, id=4)
{
    difference() {
        rotate([0, 0, 30]) circle(r=od/2, $fn=6);
        rotate([0, 0, 30]) circle(r=id/2, $fn=6);
        translate([0, -od/2-0.1]) square([od+0.2, od+0.2]);
    }
}

module universal_fan_duct_zip_tie_mount(size=[10, 6], thickness=1)
{
    
    rotate([-90, 0, 0]) difference() {
        linear_extrude(height=size[0]) universal_fan_duct_zip_tie_slice(od=size[1], id=size[1]-thickness*2);
        translate([0, 0, 2*thickness]) linear_extrude(height=size[0]-4*thickness, convexity=3)
                translate([-size[1]/2*thickness-0.1, -size[1]/2*thickness - 0.1]) square([size[1]*thickness+0.2, size[1]*thickness+0.2]);
    }
}

module universal_fan_duct_blower_adapter(height=7, size)
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

      translate([0, 0, height/2]) universal_fan_duct_zip_tie_mount(size=[size[1]+2*wall_width, height]);

     % translate([-1.6, 18, height+20])
        rotate([-90, 180, -90]) blower();
}

module universal_fan_duct_mount_slice(height=10, radius=3)
{
    hull() {
     translate([-(height-radius), 0]) circle(r=radius, $fn=24);
     translate([(height-radius), 0]) circle(r=radius, $fn=24);
    }
}

module universal_fan_duct_outlet(size=[10, 20, 4])
{
    linear_extrude(height=4) universal_fan_duct_slice(size=size, cutout=true, guides=true);
                    translate([0, 0, -1]) cube([size[0], size[1], 1]);

                    // Final flow angling
                    difference() {
                        translate([0, 0, 4]) rotate([0, 150, 0]) {
                            cube([size[2]/sin(180-150), size[1], 1]);
                            linear_extrude(height=size[2]+1) universal_fan_duct_slice(size=size, cutout=true, guides=true);
                        }
                        translate([-50, -50, size[2]]) cube([100, 100, 100]);
                        translate([-50, -50, -100-1]) cube([100, 100, 100]);
                        translate([-11, -50, -1.1]) cube([size[2]+1, 100, 10]);
                    }
}

module universal_fan_duct()
{
    translate([30-blower_shift-blower_shift_extra, -blower_shift-neck_width/2, 30+neck_height + blower_shift_extra]) {
      universal_fan_duct_blower_adapter(height=7, size=blower_out);
    }
    translate([30, -neck_width/2, 30]) {
        difference() {
            union() {
                translate([-blower_shift, -blower_shift, neck_height]) for (i = [0:0.1:blower_shift_extra])
                    translate([-i, 0, i])
                    linear_extrude(height=0.1) universal_fan_duct_slice(size=[blower_out[0]+2*wall_width, blower_out[1]+wall_width*2]);

                translate([-blower_shift, 0, neck_height])  for (i = [0:0.1:blower_shift]) {
                    translate([i, i-blower_shift, -i-0.1]) {
                        linear_extrude(height=0.1) universal_fan_duct_slice(size=[blower_out[0]+2*wall_width, blower_out[1]+2*wall_width-i*2]);

                    }
                }
                linear_extrude(height=neck_height-blower_shift, convexity=4) universal_fan_duct_slice(size=neck_size);

                translate([0, neck_width/2-4.5, 9]) rotate([0, 90, 0])
                    linear_extrude(height=blower_out[0]+2*wall_width) universal_fan_duct_mount_slice(height=8+wall_width, radius=3.25/2+wall_width);
                translate([0, neck_width/2+4.5, 9]) rotate([0, 90, 0])
                    linear_extrude(height=blower_out[0]+2*wall_width) universal_fan_duct_mount_slice(height=8+wall_width, radius=3.25/2+wall_width);
            }
            translate([-0.1, neck_width/2-4.5, 9]) rotate([0, 90, 0])
                    linear_extrude(height=blower_out[0]+2*wall_width+0.2) universal_fan_duct_mount_slice(height=8, radius=3.25/2);
            translate([-0.1, neck_width/2+4.5, 9]) rotate([0, 90, 0])
                    linear_extrude(height=blower_out[0]+2*wall_width+0.2) universal_fan_duct_mount_slice(height=8, radius=3.25/2);
        }
    }

    for (slice=[0:duct_slice:duct_height]) {
        scale_from = (duct_height-slice)/duct_height;
        scale_to = slice/duct_height;
        rotate([0, 0, duct_twist*scale_to]) translate([30*scale_from+duct_gap*scale_to, -neck_width/2*scale_from + -head_gap/2*scale_to, 30-slice-duct_slice])
            linear_extrude(height=duct_slice) universal_fan_duct_slice(size=[neck_size[0]*scale_from+neck_width/2*scale_to, neck_size[1]*scale_from + head_gap*scale_to]);
    }
    
    
    rotate([0, 0, duct_twist]) translate([duct_gap, -head_gap/2, 30-duct_z])
        linear_extrude(height=probe_mount[2]) universal_fan_duct_slice(size=[neck_width/2, head_gap], guides=true);

    // Exit ducting & fan mount
    rotate([0, 0, duct_twist]) translate([duct_gap, -head_gap/2, 30-(duct_z + 4)])  {
                // Z-Probe mount
                translate([neck_width/2, head_gap/2, -1]) rotate([0, 0, 90]) mini_height_sensor_mount(post_length=neck_width/2);
        
                universal_fan_duct_outlet(size=[neck_width/2, head_gap, 4]);
    }
}

% union() {
    if (false) {
        geeetech_rostock_g2_jhead_x2_mount() {
            geeetech_jhead_peek();
            geeetech_jhead_peek();
        }
    } else if (true) {
        geeetech_rostock_g2_jhead_x2_mount(spread=3) {
            rotate([0, 0, 90]) e3d_v6_lite();
            rotate([0, 0, 90]) e3d_v6_lite();
        }
    }
    rotate([0, 0, -30]) translate([0, 0, -8]) {
        geeetech_rostock_g2_spider();
    }
}

// 37 = Geeetech j-heads
// 47 = E3D heads

! rotate([0, 0, 60]) translate([0, 0, -47]) universal_fan_duct();
