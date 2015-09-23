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


include <E3D/v6_lite.scad>
include <Geeetech/rostock_g2_spider.scad>


duct_depth=28;
duct_angle=52.5;

module e3d_v6_fan_duct()
{
    difference() {
        union() {
            translate([-15, 0, 4])
                cube([30, duct_depth, 26]);
            translate([-14, 1, 5])
                cube([28, duct_depth-2, 24]);
             translate([0, duct_depth-2, 9]) 
         rotate([-(90 + duct_angle), 0, 180]) scale([0.85, 0.4, 1])
                 cylinder(r1=15, r2=5, h=duct_depth/2*cos(duct_angle) + 20*sin(duct_angle));
          rotate([-(90 + duct_angle), 0, 0]);
          translate([0, 28, 16]) sphere(r=14);
          translate([0, 25, 30]) cylinder(r=4, h=2.5);
        }

        translate([0, duct_depth + 0.1, 17]) {
            rotate([90, 0, 0]) cylinder(r=11.5, h=duct_depth-5);
        }
         translate([0, duct_depth-2, 9]) 
         rotate([-(90 + duct_angle), 0, 180]) scale([0.85, 0.4, 1]) 

                        cylinder(r1=14, r2=4, h=
            duct_depth/2*cos(duct_angle) + 20*sin(duct_angle));

         translate([0, 0, -0.1]) difference() {
            cylinder(r=13, h=30.2);
            translate([0, -3, 0]) rotate([0, 0, 45]) cube([26, 26, 30.2]);
        }
        translate([0, 0, -0.1]) cylinder(r=11.2, h=30.2);

        translate([0, 28, 16]) sphere(r=13);

        translate([0, 25, 30+2.5]) drill_down(depth=6, r=2.9);
    }
}


if (false) {
    % translate([0, 0, 30]) {
        rotate([-90, 0, 90])
            import(     "V6.6_Duct.stl");
        translate([0, 0, -46]) e3d_v6_lite();
    }
    % translate([0, 0, 30+2.5]) rotate([0, 0, 120]) geeetech_rostock_g2_spider();

    e3d_v6_fan_duct();
}
