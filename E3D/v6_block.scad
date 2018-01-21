//
// Copyright (C) 2015, Jason S. McMullan <jason.mcmullan@gmail.com>
// All right reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer,
//    without modification, immediately at the beginning of the file.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS\'\' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// All units are in mm

include <utility.scad>

// Origin (0,0,0) is top center of transition zone thread
// Children attached at bottom center of transition zone thread
module e3d_v6_block_standard()
{
        translate([-15.5, -8, -11.5])
        difference() {
            cube([20, 16, 11.5]);
            translate([2.5, 8, 11.5])
                drill_down(diameter=3, depth=12);
            translate([15.5, 8, 11.5])
                drill_down(diameter=6, depth=12);
            translate([-0.1, -0.1, 3])
                cube([6, 16.2, 2]);
            translate([8.5, 0, 4])
                rotate([90, 0, 0])
                drill_down(diameter=6, depth=16.1);
            translate([16.5, 0, 4.8])
                rotate([90, 0, 0])
                drill_down(diameter=3, depth=3.5);
            translate([18, 0, 2])
                rotate([90, 0, 0]) {
                    drill_down(diameter=2, depth=2);
                    drill_down(diameter=1.5, depth=4.5);
                }
        }

        translate([0, 0, -11.5])
            children();
}

module e3d_v6_block_volcano()
{
    translate([-15.5, -4.5, -20])
    difference() {
        cube([24, 11.5, 20]);
        
        // Top drills
        translate([8, 4, 20]) drill_down(diameter=6, depth=20.1);
        translate([15.5, 4.5, 20]) drill_down(diameter=6, depth=20.1);
        translate([21.2, 5.75, 20]) drill_down(diameter=3.1, depth=20.1);
        
        // Side cut
        translate([-0.1, 4 - 1.5/2, -0.1]) cube([8, 1.5, 20.2]);
        
        // Chamfer
        translate([-0.1, -0.1, 19]) cube([8-0.5, 11.5+0.2, 1.2]);
        translate([8-0.5, -0.1, 20]) rotate([-90, 0, 0]) cylinder(d=2, h=11.5+0.2, $fn=60);
        
        // Side drills
        translate([2.5, -0.1, 5.5]) rotate([-90, 0, 0]) cylinder(d=3, h=11.5+0.2, $fn=60);
        translate([2.5, -0.1, 15]) rotate([-90, 0, 0]) cylinder(d=3, h=11.5+0.2, $fn=60);
    }
    
    translate([0, 0, -20])
        children();
}

module e3d_v6_block(volcano = false)
{
    if (volcano)
    {
        e3d_v6_block_volcano() children();
    } else {
        e3d_v6_block_standard() children();
    }
}

e3d_v6_block(volcano = false);
translate([0, 30, 0]) e3d_v6_block(volcano = true);
// vim: set shiftwidth=4 expandtab: //
