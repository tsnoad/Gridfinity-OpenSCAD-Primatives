include <OpenSCAD-Helper-Library/common_params_and_modules.scad>;

function gridfinity_crn_array(width_u=1,height_u=1) = xyz_to_trans([width_u,height_u,0]*42/2)-outset_to_trans(4);
// function gridfinity_crn_array(width_u=1,height_u=1) = points_reg_polygon_flat(3)*(42/2-4);

function gridfinity_stackheight_mm(stackheight_u=2) = stackheight_u*7;

module gridfinity_translate_unit(width_u=1,height_u=1) {
    for(it=[for(x=[0:width_u-1]) for(y=[0:height_u-1]) -([width_u,height_u,0]-[1,1,0])/2*42+[x,y,0]*42]) translate(it) children();
}

gridfinity_base_crn_rad3 = 3.75;
gridfinity_base_crn_rad2 = gridfinity_base_crn_rad3-2.15;
gridfinity_base_crn_rad1 = gridfinity_base_crn_rad2;
gridfinity_base_crn_rad0 = gridfinity_base_crn_rad2-0.8;

gridfinity_base_crn_z0 = 0;
gridfinity_base_crn_z1 = 0.8;
gridfinity_base_crn_z2 = 4.75-2.15;
gridfinity_base_crn_z3 = 4.75;

gridfinity_stack_crn_rad3 = 4;
gridfinity_stack_crn_rad2 = gridfinity_stack_crn_rad3-2.15;
gridfinity_stack_crn_rad1 = gridfinity_stack_crn_rad2;
gridfinity_stack_crn_rad0 = gridfinity_stack_crn_rad1-0.7;

gridfinity_stack_crn_z0 = 0;
gridfinity_stack_crn_z1 = 0.7;
gridfinity_stack_crn_z2 = 4.65-2.15;
gridfinity_stack_crn_z3 = 4.65;
gridfinity_stack_crn_z4 = gridfinity_stack_crn_z3-w2-bev_s;


module gridfinity_baseplate(width_u=1,height_u=1) difference() {
    cylinder_bev(gridfinity_stack_crn_rad3,gridfinity_stack_crn_z4,bev_s,bev_s,gridfinity_crn_array(width_u,height_u));
    
    gridfinity_translate_unit(width_u,height_u) {
        gridfinity_baseneg(1,1);
        cylinder_bev_co_through(gridfinity_stack_crn_rad0+0.2,gridfinity_stack_crn_z3,0.01,0.01,0,gridfinity_crn_array(1,1));
    }
}

module gridfinity_baseneg(width_u=1,height_u=1) {
    rad_inset = gridfinity_stack_crn_rad3-gridfinity_stack_crn_rad0;
    gridfinity_stack_crn_zminus1 = -rad_inset-0.6;

    translate([0,0,gridfinity_stack_crn_zminus1]) cylinder_bev_co_through(gridfinity_stack_crn_rad0,-gridfinity_stack_crn_zminus1+gridfinity_stack_crn_z3,rad_inset,rad_inset,0,gridfinity_crn_array(width_u,height_u));

    translate([0,0,gridfinity_stack_crn_z3]) cylinder_bev_co_blind_downwards(gridfinity_stack_crn_rad2,gridfinity_stack_crn_z3,gridfinity_stack_crn_rad1-gridfinity_stack_crn_rad0,gridfinity_stack_crn_rad3-gridfinity_stack_crn_rad2,0,gridfinity_crn_array(width_u,height_u));
}

module gridfinity_block_stackinglip(stackheight_u=2,width_u=1,height_u=1) {
    height_mm = gridfinity_stackheight_mm(stackheight_u);

    rad_inset = gridfinity_stack_crn_rad3-gridfinity_stack_crn_rad0;
    gridfinity_stack_crn_zminus1 = -rad_inset-0.6;

    translate([0,0,height_mm]) difference() {
        translate([0,0,gridfinity_stack_crn_zminus1]) cylinder_bev(gridfinity_base_crn_rad3,-gridfinity_stack_crn_zminus1+gridfinity_stack_crn_z4,0,bev_s,gridfinity_crn_array(width_u,height_u));

        gridfinity_baseneg(width_u,height_u);
    }
}

module gridfinity_block_cutout(stackheight_u=2,width_u=1,height_u=1,wall_thk=w6,base_thk=5*layer_hgt) {
    // crn_array = gridfinity_crn_array(width_u,height_u);
    height_mm = gridfinity_stackheight_mm(stackheight_u);

    // intersection() {
        union() {
            echo(gridfinity_base_crn_rad1-gridfinity_base_crn_rad0);
            translate([0,0,height_mm]) cylinder_bev_co_blind_downwards(gridfinity_base_crn_rad3-wall_thk,height_mm,0,bev_s,0,gridfinity_crn_array(width_u,height_u));
            translate([0,0,gridfinity_base_crn_z3]) gridfinity_translate_unit(width_u,height_u) cylinder_bev_co_blind_downwards(max(0.8,gridfinity_base_crn_rad2-wall_thk),gridfinity_base_crn_z3,0.8,2.15,0,gridfinity_crn_array(1,1));
        }

        // translate(-[width_u,height_u,0]/2*42+[0,0,gridfinity_base_crn_z3+base_thk]) cube([width_u,height_u,0]*42+[0,0,height_mm]);
    // }
}

module gridfinity_block(stackheight_u=2,width_u=1,height_u=1,prevent_uninterrupted_bridges=true) {
    crn_array = gridfinity_crn_array(width_u,height_u);
    
    height_mm = gridfinity_stackheight_mm(stackheight_u);
    
    body_height_mm = -gridfinity_base_crn_z3+height_mm;

    translate([0,0,gridfinity_base_crn_z3+(prevent_uninterrupted_bridges?layer_hgt:0)]) cylinder_bev(gridfinity_base_crn_rad3,body_height_mm-(prevent_uninterrupted_bridges?layer_hgt:0),0,bev_s,crn_array);

    // printing bridges requires aligning the bridge direction to the shorest distance
    // but when there's a huge grid-shaped bridge, the slicer can't choose a good bridge direction, so...
    // option to interrupt the bridge layer, so each bridge section can have it's best direction
    if(prevent_uninterrupted_bridges) {
        translate([0,0,gridfinity_base_crn_z3]) gridfinity_translate_unit(width_u,height_u) cylinder_bev(gridfinity_base_crn_rad3,body_height_mm-(prevent_uninterrupted_bridges?layer_hgt:0),0,bev_s,gridfinity_crn_array(1,1));

        for(x=[0:width_u-1]) for(y=[0:height_u-1]) for(it=[-([width_u,height_u,0]-[1,1,0])/2*42+[x,y,0]*42]) translate(it-[1,1,0]*gridfinity_base_crn_rad3*0+[0,0,gridfinity_base_crn_z3]) {
            if(x!=width_u-1) translate([1,-1,0]*42/2+[-1,1,0]*gridfinity_base_crn_rad3) cube([0,1,0]*42+[2,-2,0]*gridfinity_base_crn_rad3+[0,0,layer_hgt+0.01]);
            if(y!=height_u-1) translate([-1,1,0]*42/2+[1,-1,0]*gridfinity_base_crn_rad3) cube([1,0,0]*42+[-2,2,0]*gridfinity_base_crn_rad3+[0,0,layer_hgt+0.01]);
        }
    }
        
    gridfinity_translate_unit(width_u,height_u) gridfinity_base(1,1);
}

module gridfinity_base(width_u=1,height_u=1,prevent_sharp_corners_on_first_layer=true) {
    bin_unit_crn_trans = xyz_to_trans([1,1,0]*41.5/2)-outset_to_trans(3.75);
    bin_crn_trans = bin_unit_crn_trans+xyz_to_trans([width_u-1,height_u-1,0]/2*42);

    crn_array = gridfinity_crn_array(width_u,height_u);

    intersection() {
        translate([0,0,gridfinity_base_crn_z3]) {
            mirror([0,0,1]) cylinder_bev_stud(gridfinity_base_crn_rad2,gridfinity_base_crn_z3,gridfinity_base_crn_z3-gridfinity_base_crn_z2,gridfinity_base_crn_z1,crn_array);
        }
        
        // sharp corners on the first layer can lead to peeling, so...
        // option to prevent sharp corners
        if(prevent_sharp_corners_on_first_layer) {
            crn_rad_min = max(4,gridfinity_base_crn_rad0);
            cylinder_bev(crn_rad_min+20,50,20,0,crn_array-outset_to_trans(crn_rad_min-gridfinity_base_crn_rad0));
        }
    }
}