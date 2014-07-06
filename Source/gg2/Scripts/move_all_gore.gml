wallSetSolid();
with(BloodDrop)
{
    if(!stick)
    {
        if(!place_meeting(x, y+1, Obstacle))
            vspeed += 0.4 * global.delta_factor;
        if(speed > 11)
            speed = 11;
    }
    image_alpha -= (2/lifetime) * global.delta_factor;
    
    if (speed > 0)
    {
        if (place_meeting(x, y, Obstacle))
        {
            if(!stick)
            {
                move_contact_solid(point_direction(x,y,x+hspeed,y+vspeed),speed)
            }
            move_outside_solid(180+point_direction(x,y,x+hspeed,y+vspeed),speed)
            
            speed *= delta_mult(0.5);
            speed -= 0.1*global.delta_factor;
            stick = true;
        }
    }
    else
        stick = true;
}
with(Gib)
{
    if (fadeout)
        image_alpha -= 2/10 * global.delta_factor;
    
    if (global.run_virtual_ticks)
    {
        if (global.gibLevel > 0)
        {
            if(abs(speed/bloodchance)*bloodiness/maxBloodiness > random(16/global.gibLevel))
            {
                var blood;
                blood = instance_create(x,y-1,BloodDrop);
                blood.ogib=self;
                blood.odir=point_direction(x,y,x+hspeed,y+vspeed);
                if (object_index == PumpkinGib)
                    blood.sprite_index = PumpkinJuiceS;
                
                bloodiness -= 0.5;
                
                with(blood)
                {
                    motion_add(odir, ogib.speed*0.9);
                    hspeed += random(3)-1;
                    vspeed += random(3)-1;
                }
            }
        }
    }
    
    if (place_free(x, y+1))
        vspeed += my_gravity;
    else
    {
        vspeed = min(vspeed, 0);
        hspeed = hspeed * delta_mult(0.9);
    }
    if (vspeed > 11)
        vspeed = 11;
        
    if (speed < 0.2)
        speed = 0;
    if (abs(rotspeed) < 0.2)
        rotspeed = 0;
    
    rotspeed *= air_friction;
    
    vis_angle += rotspeed * global.delta_factor;
    
    if(!place_free(x+hspeed, y+vspeed))
        event_user(0);
    
    if (speed > 0)
        if (point_distance(x,y,view_xview[0],view_yview[0]) > 2000)
            instance_destroy();
    
    x += hspeed * global.delta_factor;
    y += vspeed * global.delta_factor;
    x -= hspeed;
    y -= vspeed;
}
wallUnsetSolid();
