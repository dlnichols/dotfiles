----------------------------------------
--  Modified "Zenburn" awesome theme  --
--    By Dan Nichols                  --
--    Based on the "Zenburn" theme    --
--    By Adrian C. (anrxc)            --
----------------------------------------

-- Notification library
local naughty = require("naughty")

-- {{{ Random
-- Without seeding the lua math lib, its randomness is lacking
local dev_random = io.open("/dev/urandom", "rb")
if dev_random then
  local a,b,c,d = dev_random:read(4):byte(1,4)
  math.randomseed(bit32.lshift(a, 24) + bit32.lshift(b, 16) + bit32.lshift(c, 8) + d)
  dev_random:close()
end
-- }}}

-- {{{ Main
theme = {}
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#1E2320"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 2
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/usr/share/awesome/themes/nichols/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/nichols/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/usr/share/awesome/themes/nichols/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/usr/share/awesome/themes/nichols/layouts/tilew.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/nichols/layouts/tileleftw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/nichols/layouts/tilebottomw.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/nichols/layouts/tiletopw.png"
theme.layout_fairv      = "/usr/share/awesome/themes/nichols/layouts/fairvw.png"
theme.layout_fairh      = "/usr/share/awesome/themes/nichols/layouts/fairhw.png"
theme.layout_spiral     = "/usr/share/awesome/themes/nichols/layouts/spiralw.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/nichols/layouts/dwindlew.png"
theme.layout_max        = "/usr/share/awesome/themes/nichols/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/nichols/layouts/fullscreenw.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/nichols/layouts/magnifierw.png"
theme.layout_floating   = "/usr/share/awesome/themes/nichols/layouts/floatingw.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/nichols/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/nichols/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/nichols/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/nichols/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/nichols/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/nichols/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/nichols/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/nichols/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/nichols/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/nichols/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/nichols/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/nichols/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/nichols/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/nichols/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/nichols/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/nichols/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/nichols/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/nichols/titlebar/maximized_normal_inactive.png"
-- }}}

-- {{{ Wallpaper
local scan_wallpapers = function(geometry)
  local wallpapers_root = "/home/dan/projects/wallpapers/"
  local papers = {}

  -- Scan for wallpapers in this geometry
  local find_cmd = io.popen("find '"..wallpapers_root..geometry.."' -type f")
  for file in find_cmd:lines() do
    table.insert(papers, file)
  end
  local retval = {find_cmd:close()}
  if retval[3] > 0 then
    naughty.notify({ text = "No wallpapers found for geometry: "..geometry })
    return {}
  end
  return papers
end

local get_geometry = function(screen)
  local geometry = math.floor(screen.geometry.width).."x"..math.floor(screen.geometry.height)
  -- Lazy hack - didn't want to make new wallpapers for macbook retina display
  if (geometry == "1620x2880") then
      geometry = "1080x1920"
  elseif (geometry == "2880x1620") then
      geometry = "1920x1080"
  end
  return geometry
end

local wallpapers = {}

local random_wallpaper = function(screen)
  -- Obtain screen geometry
  local geometry = get_geometry(screen)

  -- Check for wallpapers for this geometry
  local wp_list = wallpapers[geometry]
  if wp_list == nil then
    wallpapers[geometry] = scan_wallpapers(geometry)
    wp_list = wallpapers[geometry]
  end

  -- Select random wallpaper
  if next(wp_list) ~= nil then
    local random = wp_list[math.random(1, #wp_list)]
    -- naughty.notify({ text = "Setting "..screen.index.." to "..random })
    return random
  else
    -- naughty.notify({ text = "Setting "..screen.index.." to default" })
    return "/usr/share/awesome/themes/nichols/zenburn-background.png"
  end
end

theme.wallpaper = random_wallpaper
-- }}}
-- }}}

return theme
