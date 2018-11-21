

bottom_plate=[150, 55, 1.6];

top_plate = [98.2, 60, 1.6];

fn=30;

function geeetech_lcd2004a_size() = [150, 63, 10];

module plate_drills(size=[10,20, 30], offset=2, drill=3)
{
    translate([offset, offset]) circle(d=drill, $fn=fn);
    translate([size[0]-offset, offset]) circle(d=drill, $fn=fn);
    translate([offset, size[1]-offset]) circle(d=drill, $fn=fn);
    translate([size[0]-offset, size[1]-offset]) circle(d=drill, $fn=fn);
}

module plate_mounts(size=[10,20, 30], offset=2, drill=3, height=10, wall=2)
{
    translate([0, 0, size[2]]) difference()
    {
        union()
        {
            translate([offset, offset])
                cylinder(d1=drill+wall*2, d2=drill+wall*4, h=height, $fn=fn);
            translate([size[0]-offset, offset])
                cylinder(d1=drill+wall*2, d2=drill+wall*4, h=height, $fn=fn);
            translate([offset, size[1]-offset])
                cylinder(d1=drill+wall*2, d2=drill+wall*4, h=height, $fn=fn);
            translate([size[0]-offset, size[1]-offset])
                cylinder(d1=drill+wall*2, d2=drill+wall*4, h=height, $fn=fn);
        }
        translate([0, 0, -0.1]) linear_extrude(height=height+0.2) plate_drills(size, offset, drill);
    }
}

module plate(size=[10,20, 30], offset=2, drill=3)
{
    linear_extrude(height=size[2]) difference()
    {
        square([size[0], size[1]]);
        plate_drills(size, offset, drill);
    }
}

module geeetech_lcd2004a()
{
    translate([-bottom_plate[0]/2, 0, 0])
    {
        plate(bottom_plate, offset=3, drill=4);
        // SD card
        translate([-10, 9, -2.4])
            cube([35, 25, 2.5]); 
        translate([0, 0, bottom_plate[2]]) {
            translate([bottom_plate[0]-16.5, 5.5, 0]) {
                cube([6.3, 6.3, 3.5]);
                translate([6.3/2, 6.3/2, 0]) {
                    cylinder(d=3.5, h=14.5, $fn=fn);
                    translate([0, 16, 0]) {
                        translate([0, 0, 6.8/2]) cube([12, 12, 6.8], center=true);
                        cylinder(d=7, h=26.5, $fn=fn);
                    }
                }
            }
        }
        
        // LCD2004A
        translate([13.5, bottom_plate[1] - top_plate[1] - 3, bottom_plate[2]+3]) {
            plate(top_plate, offset=2.5, drill=3.5);
            translate([0, 10, top_plate[2]])
                cube([top_plate[0], 40, 9.5]);
        }
        
    }
}

module geeetech_lcd2004a_mounts(wall=4)
{
    translate([-bottom_plate[0]/2, 0, 0])
    {
        plate_mounts(bottom_plate, offset=3, drill=4, height=3+top_plate[2]+9.5-wall);
        translate([13.5, bottom_plate[1] - top_plate[1] - 3, bottom_plate[2]+3])
        {
            plate_mounts(top_plate, offset=2.5, drill=3.5, height=9.5-wall);
        }
    }
}

module geeetech_lcd2004a_holder(angle=40, width=80, height=10, wall=3)
{
    old_size=geeetech_lcd2004a_size();
    size = [old_size[0], old_size[1] + 10, old_size[2]];
        
    // Polyline 
    difference()
    {
        translate([-size[0]/2-wall, 0, 0]) rotate([0, 0, 90]) rotate([90, 0, 0]) difference()
        {
             linear_extrude(height=size[0]+wall*2) polygon([[0, 0], [0, -height], [width, -height], [width, sin(angle)*(size[1]+wall*2)], [cos(angle)*(size[1]+wall*2), sin(angle)*(size[1]+wall*2)]]);
             translate([0, -0.01, wall]) linear_extrude(height=size[0]) polygon([[wall+cos(angle)*wall, 0], [wall+cos(angle)*wall, -height], [width-wall, -height], [width-wall,sin(angle)*size[1]], [cos(angle)*size[1]+wall+cos(angle)*wall, sin(angle)*size[1]]]);
        }
        
        translate([0, wall+wall*cos(angle)+size[2]+size[2]*cos(angle) - 0.5, 0]) rotate([angle, 0, 0]) 
            geeetech_lcd2004a();
    }

    translate([0, wall+wall*cos(angle)+size[2]+size[2]*cos(angle) - 0.5, 0]) rotate([angle, 0, 0]) 
    {
        geeetech_lcd2004a_mounts();
        % geeetech_lcd2004a();
    }
}


geeetech_lcd2004a_holder(wall=3);
