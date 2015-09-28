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


use <Geeetech/jhead_peek.scad>
use <Geeetech/rostock_g2_spider.scad>
use <Geeetech/rostock_g2_jhead_x2.scad>
use <E3D/utility.scad>
use <blower_40mm.scad>

blower_out= [16.3, 26, 1];

duct_twist = -30;

duct_width = 20; // Distance between head bolts

duct_height = 34;

skew = [ [ 1, 0, -0.3, 0 ],
          [ 0, 1, 0.1, 0 ],
          [ 0, 0, 1, 0 ],
          [ 0, 0, 0, 1 ] ];
          
module jhead_x2_fan_duct_slice(cutout=false)
{
       difference() {
        square([blower_out[0]+1, duct_width]);
        translate([1.6, 1.6]) square([blower_out[0]+1-1.6*2, duct_width-3]);
        if (cutout)
            translate([0, 1.6]) square([1.6, duct_width-3]);
    }
    for (i = [1:3]) {
        translate([0,(duct_width-1.6)/4*i+0.5, 0])
        square([blower_out[0]+1, 1]);
    }               
}

module jhead_x2_fan_duct_blower_adapter()
{
     difference() {
        union() {
            cube([blower_out[0], blower_out[1], 8]);
            translate([0, -1, 0]) cube([blower_out[0]+1, blower_out[1]+2, 5-1]);
        }
        translate([1, 1, -0.1])
          cube([blower_out[0]-2, blower_out[1]-2, 8.2]);
      }

     % translate([-1.66, 18, 24])
        rotate([-90, 180, -90]) blower();
 }
  
module jhead_x2_fan_duct()
{
    translate([30, -blower_out[1]/2, 42]) {
      jhead_x2_fan_duct_blower_adapter();
    }
    translate([30, -duct_width/2, 30]) {
      difference() {
        union() {
            for (i = [0:0.1:((blower_out[1]+2)-duct_width)/2]) {
                translate([0, i-((blower_out[1]+2-duct_width)/2), 12-i-0.1]) {
                    difference() {
                        cube([blower_out[0]+1, blower_out[1]+2-i*2, 0.1]);
                        translate([1, 1, -0.1])
                            cube([blower_out[0]-2, blower_out[1]-i*2, 0.3]);
                    }
                }
            }
            cube([blower_out[0]+1, duct_width, 12-((blower_out[1]+2)-duct_width)/2]);
        }
        translate([1, 1, -0.1])
          cube([blower_out[0]-2, duct_width-2, 12.2]);
                  translate([-0.1, duct_width/2-4.5, 4.5])
            rotate([0, 90, 0])
                cylinder(d=3, h=blower_out[1]*2, $fn=24);
         translate([-0.1, duct_width/2+4.5, 4.5])
            rotate([0, 90, 0])
                cylinder(d=3, h=blower_out[1]*2, $fn=24);
    }
 
    mirror([0, 0, 1]) {
        multmatrix(skew) {
            linear_extrude(slices=duct_height, height=duct_height, twist=duct_twist, scale=20/blower_out[0])
                jhead_x2_fan_duct_slice();

        }
    }

    translate([-10.5, 3.2, -(duct_height + 4)]) rotate([0, 0, -duct_twist]) {
                linear_extrude(height=4) scale(20/blower_out[0]) jhead_x2_fan_duct_slice(cutout=true);
                translate([0, 0, -1]) cube([21.2, 24.4, 1]);
       
    }
}
}

* rotate([0, 0, -60]) translate([0, 0, 37]) {
    geeetech_rostock_g2_jhead_x2_mount()
        { geeetech_jhead_peek();
        geeetech_jhead_peek(); }
    rotate([0, 0, -30]) translate([0, 0, -8]) geeetech_rostock_g2_spider();
}

jhead_x2_fan_duct();
