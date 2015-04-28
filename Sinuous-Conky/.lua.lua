    --[[

    Sinuous Conky by John Persano (2015)

    Licensed under the Apache License, Version 2.0 (the "License");
  	    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
  
    http://www.apache.org/licenses/LICENSE-2.0
  
  	Unless required by applicable law or agreed to in writing, software
  	distributed under the License is distributed on an "AS IS" BASIS,
  	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  	See the License for the specific language governing permissions and
  	limitations under the License.

    This work is derived from the work of 'clanlordus89' whose work may be found at http://clanlordus89.deviantart.com/art/Circles-of-imagination-192930609
    This work is modelled after the work of 'londonali1010' whose work may be found at http://londonali1010.deviantart.com/art/Conky-Widgets-Script-141963883
     
    IMPORTANT: If you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 145 uses a delay to make sure that this doesn't happen. 
               It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num > 5 in that if statement (the default). 
               If you only update Conky every 2s, you should change it to update_num > 3; conversely if you update Conky every 0.5s, you should use update_num > 10.
               Also, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.
     
    To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
            lua_load ~/scripts/rings-v1.2.1.lua
            lua_draw_hook_pre ring_stats
     
    Changelog:
        + v1.0 -- Original release (28.09.2009)

    ]]
     
    settings_table = {
            --CPU
            {
                    command='cpu cpu0',
                    max=100,
                    background_color=0x000000,
                    background_alpha=0.15,
                    foreground_color=0xFFFFFF,
                    foreground_alpha=1.0,
                    x=275, y=275,
                    radius=78,
                    thickness=22,
                    start_angle=0,
                    end_angle=180
            },
            --RAM
            {
                    command='memperc',
                    max=100,
                    background_color=0x000000,
                    background_alpha=0.15,
                    foreground_color=0xFFFFFF,
                    foreground_alpha=1.0,
                    x=275, y=431,
                    radius=78,
                    thickness=22,
                    start_angle=180,
                    end_angle=0
            },
            -- CPU TEMP
            {
                    command='hwmon 1 temp 1',
                    max=84, --84°C is considered 'high' for a processor
                    background_color=0x000000,
                    background_alpha=0.15,
                    foreground_color=0xFFFFFF,
                    foreground_alpha=1.0,
                    x=275, y=588,
                    radius=78,
                    thickness=22,
                    start_angle=0,
                    end_angle=180
            },
            --BATTERY
            {
                    command='battery_percent BAT0',
                    max=100,
                    background_color=0x000000,
                    background_alpha=0.15,
                    foreground_color=0xffffff,
                    foreground_alpha=1.0,
                    x=275, y=745,
                    radius=78,
                    thickness=22,
                    start_angle=180,
                    end_angle=0
            }

    }
     
    require 'cairo'
     
    function rgb_to_r_g_b(colour,alpha)

            return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha

    end
     
    function draw_ring(context, percent, pt)
     
            local x, y, radius, thickness, start_angle_degrees, end_angle_degrees = pt['x'], pt['y'], pt['radius'], pt['thickness'], pt['start_angle'], pt['end_angle']
            local background_color, background_alpha, foreground_color, foreground_alpha = pt['background_color'], pt['background_alpha'], pt['foreground_color'], pt['foreground_alpha']
     
            local start_angle_radians = start_angle_degrees * (math.pi / 180) - (math.pi / 2)
            local end_angle_radians = end_angle_degrees * (math.pi / 180) - (math.pi / 2)

            local arc = percent * (end_angle_radians - start_angle_radians)

            -- Draw background ring
            cairo_arc(context, x, y, radius, start_angle_radians, end_angle_radians)
            cairo_set_source_rgba(context, rgb_to_r_g_b(background_color, background_alpha))
            cairo_set_line_width(context, thickness)
            cairo_stroke(context)

            -- Draw indicator ring
            if start_angle_degrees > end_angle_degrees then
                cairo_arc(context, x, y, radius, end_angle_radians + arc, end_angle_radians)
            else
                cairo_arc(context, x, y, radius, start_angle_radians, start_angle_radians + arc)
            end
            cairo_set_source_rgba(context, rgb_to_r_g_b(foreground_color, foreground_alpha))
            cairo_stroke(context)               

    end
     
    cs, cr = nil -- initialize our cairo surface and context to nil
    function conky_ring_stats()

            local function setup_rings(cr, pt)

                    local output = ''
                    local output_value = 0
                    local output_percent = 0.00
     
                    output = string.format('${%s}',pt['command'])
                    output = conky_parse(output)
     
                    output_value = tonumber(output)

                    if output_value == nil then 
                        output_value = 0 
                    end

                    output_percent = output_value / pt['max']
     
                    draw_ring(cr, output_percent, pt)

            end
     
            if conky_window == nil then return end

            if cs == nil or cairo_xlib_surface_get_width(cs) ~= conky_window.width or cairo_xlib_surface_get_height(cs) ~= conky_window.height then
                    if cs then cairo_surface_destroy(cs) end
                    cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
            end

            if cr then cairo_destroy(cr) end
            cr = cairo_create(cs)
     
            local updates=conky_parse('${updates}')
            update_num=tonumber(updates)
     
            if update_num>5 then

                for i in pairs(settings_table) do

                    setup_rings(cr,settings_table[i])

                end

            end
           
            cairo_destroy(cr)
            cr = nil

    end
