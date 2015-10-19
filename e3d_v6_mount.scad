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

use <Geeetech/rostock_g2_jhead_x1.scad>
use <Geeetech/rostock_g2_jhead_x2.scad>
use <Geeetech/rostock_g2_spider.scad>
use <E3D/v6_lite.scad>

module e3d_v6_x1_mount_upper()
{
    geeetech_rostock_g2_jhead_x1_upper();
}

module e3d_v6_x1_mount_lower()
{
    geeetech_rostock_g2_jhead_x1_lower(groovemount = 6);
}

module e3d_v6_x2_mount_upper()
{
    geeetech_rostock_g2_jhead_x2_upper(spread=3);
}

module e3d_v6_x2_mount_lower()
{
    geeetech_rostock_g2_jhead_x2_lower(spread=3, groovemount = 6);
}

% union() {
    geeetech_rostock_g2_jhead_x2_mount(spread=3) {
        rotate([0, 0, 90]) e3d_v6_lite();
        rotate([0, 0, 90]) e3d_v6_lite();
    }
    rotate([0, 0, -30]) translate([0, 0, -8]) {
        geeetech_rostock_g2_spider();
    }
}


// vim: set shiftwidth=4 expandtab: //
