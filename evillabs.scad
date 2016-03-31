
module evillabs_logo(fn = 120)
{
    angle = 130;
    length = 6;
    
    translate([-0.5, 0, 0]) 
    scale([1/(length*2), 1/(length*2), 1/(length*2)]) 
        translate([1 + length, 0, 0]) {
        for (r = [0, angle, -angle]) {
            rotate([0, 0, r]) hull() {
                circle(r = 1, $fn = fn);
                translate([-length, 0])
                    circle(r = 1, $fn = fn);
            }
        }
        translate([0, -length * sin(angle)])
            circle(r = 1, $fn = fn);
    }
}

 evillabs_logo();