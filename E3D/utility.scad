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

// Origin is top, left, front
module fan(size=20, height=5)
{
    translate([0, 0, -height]) {
        difference() {
                cube([size, size, height]);
                translate([size/2, size/2, -0.1])
                    cylinder(d=size*0.8, h=height+0.2, $fn=24);
        }
        translate([size/2, size/2, -0.1])
            cylinder(d=size*0.5, h=height+0.2, $fn=24);
    }
}

module drill_down(diameter=3, depth=5)
{
    translate([0, 0, -depth])
        cylinder(r=diameter/2, h=depth+0.01, $fn=10);
}

// vim: set shiftwidth=4 expandtab: //
