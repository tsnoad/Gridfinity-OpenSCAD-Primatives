include <../gridfinity_openscad_primatives.scad>;

$fn=36;

// Set the camera - so we can automatically render some screenshots
$vpt = [0,0,0];
$vpr = [90-7.5,0,-15];
$vpd = 300;

*/* make image 'primatives_baseplate' */ gridfinity_baseplate(2,1);
*/* make image 'primatives_baseplate_cutout' */ union() {
    translate([1,0,0]/2*42) gridfinity_baseneg(1,1);
    translate([-1,0,0]/2*42) intersection() {
        gridfinity_baseneg(1,1);
		// intersect with a cube to show a cross section
		color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
	}
}
*/* make image 'primatives_base' */ union() {
    translate([1,0,0]/2*42) gridfinity_base(1,1);
    translate([-1,0,0]/2*42) intersection() {
        gridfinity_base(1,1);
		// intersect with a cube to show a cross section
		color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
	}
}
*/* make image 'primatives_block' */ let(stackheight_u=4,width_u=1,height_u=1) translate(-[0,0,stackheight_u]*7/2) {
    translate([1,0,0]/2*42) gridfinity_block(stackheight_u,width_u,height_u);
    translate([-1,0,0]/2*42) intersection() {
        gridfinity_block(stackheight_u,width_u,height_u);
		// intersect with a cube to show a cross section
		color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
	}
}
*/* make image 'primatives_block_cutout' */ let(stackheight_u=4,width_u=1,height_u=1) {
    translate([1,0,0]/2*42) gridfinity_block_cutout(stackheight_u,width_u,height_u);
    translate([-1,0,0]/2*42) intersection() {
        gridfinity_block_cutout(stackheight_u,width_u,height_u);
		// intersect with a cube to show a cross section
		color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
	}
}
*/* make image 'primatives_stacking_lip' */ let(stackheight_u=4,width_u=1,height_u=1) translate(-[0,0,stackheight_u]*7/2) {
    translate([1,0,0]/2*42) gridfinity_block_stackinglip(stackheight_u,width_u,height_u);
    translate([-1,0,0]/2*42) intersection() {
        gridfinity_block_stackinglip(stackheight_u,width_u,height_u);
		// intersect with a cube to show a cross section
		color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
	}
}
// */* make image 'primatives_base_alt' */
*/* make image 'simple_bin' */ let(stackheight_u=4,width_u=1,height_u=1) for(ixm=[-1,1]) translate([ixm,0,0]/2*42) intersection() {
    difference() {
        gridfinity_block(stackheight_u,width_u,height_u);
        gridfinity_block_cutout(stackheight_u,width_u,height_u);
    }

    // intersect with a cube to show a cross section
    if(ixm<0) color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
}
*/* make image 'simple_bin_with_lip' */ let(stackheight_u=4,width_u=1,height_u=1) for(ixm=[-1,1]) translate([ixm,0,0]/2*42) intersection() {
    union() {
        difference() {
            gridfinity_block(stackheight_u,width_u,height_u);
            gridfinity_block_cutout(stackheight_u,width_u,height_u);
        }
        gridfinity_block_stackinglip(stackheight_u,width_u,height_u);
    }

    // intersect with a cube to show a cross section
    if(ixm<0) color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
}
*/* make image 'simple_bin_2x2' */ let(stackheight_u=4,width_u=2,height_u=2) {
    difference() {
        gridfinity_block(stackheight_u,width_u,height_u);
        gridfinity_block_cutout(stackheight_u,width_u,height_u);
    }
}


*/* make image 'bin_stacking' */ let(stackheight_u=5,width_u=1,height_u=1) for(ixm=[-1,1]) translate([ixm,0,0]/2*42) intersection() {
    for(iz=[-3:3]) translate([0,0,iz*stackheight_u*7]) union() {
        difference() {
            gridfinity_block(stackheight_u,width_u,height_u);
            gridfinity_block_cutout(stackheight_u,width_u,height_u);
        }
        gridfinity_block_stackinglip(stackheight_u,width_u,height_u);
    }

    // intersect with a cube to show a cross section
    if(ixm<0) color("blue") translate(-[1,0,1]*100) cube([2,2,2]*200);
}

// !let(stackheight_u=4,width_u=1,height_u=1) {
//     gridfinity_baseplate(width_u,height_u);

//     difference() {
//         gridfinity_block(stackheight_u,width_u,height_u);
//         gridfinity_block_cutout(stackheight_u,width_u,height_u);
//         // gridfinity_translate_unit(width_u,height_u) gridfinity_block_cutout(stackheight_u,1,1);
//     }
//     gridfinity_block_stackinglip(stackheight_u,width_u,height_u);
// }

// // !gridfinity_block_cutout(4,1,1);

// let(stackheight_u=4,width_u=2,height_u=2) {
//     // gridfinity_baseplate(width_u,height_u);

//     difference() {
//         gridfinity_block(stackheight_u,width_u,height_u);
//         // gridfinity_block_cutout(stackheight_u,width_u,height_u);
//         // gridfinity_translate_unit(width_u,height_u) gridfinity_block_cutout(stackheight_u,1,1);
//     }
//     *gridfinity_block_stackinglip(stackheight_u,width_u,height_u);
// }