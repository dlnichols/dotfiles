-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

-- Random seed
local dev_random = io.open("/dev/urandom", "rb")
if dev_random then
  local a,b,c,d = dev_random:read(4):byte(1,4)
  math.randomseed(bit32.lshift(a, 24) + bit32.lshift(b, 16) + bit32.lshift(c, 8) + d)
  dev_random:close()
end

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(awful.util.get_themes_dir().."zenburn/theme.lua")
beautiful.init("/usr/share/awesome/themes/nichols/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "urxvt"
local editor = os.getenv("EDITOR") or "vim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
  awful.layout.suit.tile,
  --  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  --  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  --  awful.layout.suit.fair.horizontal,
  --  awful.layout.suit.spiral,
  --  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.floating
  --  awful.layout.suit.max.fullscreen,
  --  awful.layout.suit.magnifier
}
-- }}}

-- {{{ System
-- local msysinfo = function()
--  naughty.notify({ text = "PATH: "..os.getenv("PATH") })
--  naughty.notify({ text = "USER: "..os.getenv("USER") })
--  naughty.notify({ text = "SHLL: "..os.getenv("SHELL") })
-- end
-- msysinfo()
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

local randomize_wallpapers = function()
  for s = 1, screen.count() do
    -- Obtain screen geometry
    local geometry = get_geometry(screen[s])

    -- Check for wallpapers for this geometry
    local wp_list = wallpapers[geometry]
    if wp_list == nil then
      wallpapers[geometry] = scan_wallpapers(geometry)
      wp_list = wallpapers[geometry]
    end

    -- Select random wallpaper
    if next(wp_list) ~= nil then
      local random_wallpaper = wp_list[math.random(1, #wp_list)]
      gears.wallpaper.maximized(random_wallpaper, s, true)
        naughty.notify({ text = "Setting "..s.." to "..random_wallpaper })
    else
      -- No wallpapers for this geometry, use the default
      if beautiful.wallpaper then
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
      else
        naughty.notify({ text = "Error: No default wallpaper set." })
      end
    end
  end
end

wallpapers = {}
randomize_wallpapers(wallpapers)
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
local tags = {
  names   = {   "main",    "www",   "junk",    "dev",    "ide",   "gimp",    "vlc",     "im",  "music" },
  layouts = { layouts[1], layouts[1], layouts[3], layouts[1], layouts[1], layouts[4], layouts[1], layouts[5], layouts[4] }
}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag(tags.names, s, tags.layouts)
  awful.tag.incmwfact(0.25, tags[s][2])
end
-- }}}

-- {{{ Wibox
-- Create a volume widget
local myvolume = wibox.widget.textbox()
function update_volume()
  local fd = io.popen("amixer sget Master")
  local status = fd:read("*all")
  fd:close()

  local volume = string.match(status, "(%d?%d?%d)%%")

  status = string.match(status, "%[(o[^%]]*)%]")

  if string.find(status, "on", 1, true) then
    volume = volume.."%"
  else
    volume = volume.."M"
  end
  myvolume:set_markup(" V:"..volume)
end
update_volume()

-- Create a battery widget
local mybattery = awful.widget.progressbar()
mybattery:set_width(8)
mybattery:set_vertical(true)
mybattery:set_border_color(nil)
mybattery:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 },
  stops = {{ 0, "#70CE2B" }, { 0.5, "#88A175" }, { 1, "#FF5656" }}})
vicious.register(mybattery, vicious.widgets.bat, "$2", 61, "BAT0")

-- Create a WiFi widget

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
awful.button({        }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({        }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag),
awful.button({        }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
awful.button({        }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
  if c == client.focus then
    c.minimized = true
  else
    -- Without this, the following
    -- :isvisible() makes no sense
    c.minimized = false
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end
    -- This will also un-minimize
    -- the client, if needed
    client.focus = c
    c:raise()
  end
end),
awful.button({ }, 3, function ()
  if instance then
    instance:hide()
    instance = nil
  else
    instance = awful.menu.clients({
      theme = { width = 250 }
    })
  end
end),
awful.button({ }, 4, function ()
  awful.client.focus.byidx(1)
  if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
  awful.client.focus.byidx(-1)
  if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  mypromptbox[s] = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
  awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
  ))
  -- Create a taglist widget
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then right_layout:add(wibox.widget.systray()) end
  right_layout:add(myvolume)
  -- right_layout:add(mywifi)
  right_layout:add(mytextclock)
  right_layout:add(mybattery)
  right_layout:add(mylayoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)

  mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  -- Change volume
  awful.key({                   }, "XF86AudioRaiseVolume", function()
    awful.util.spawn("amixer set Master 2%+", false)
    update_volume()
  end),
  awful.key({                   }, "XF86AudioLowerVolume", function()
    awful.util.spawn("amixer set Master 2%-", false)
    update_volume()
  end),
  awful.key({                   }, "XF86AudioMute",        function()
    awful.util.spawn("amixer set Master toggle", false)
    update_volume()
  end),

  -- Change the wallpaper
  awful.key({ modkey            }, "p", randomize_wallpapers),
  awful.key({ modkey            }, "s", mysysinfo),

  -- Default key mappings
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

  awful.key({ modkey,           }, "j", function()
    awful.client.focus.byidx( 1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey,           }, "k", function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function() awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function() awful.client.swap.byidx( -1)    end),
  awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey,           }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end),

  -- Standard program
  awful.key({ modkey,           }, "Return", function() awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),
  awful.key({ modkey, "Shift", "Control" }, "q", function() awful.util.spawn("systemctl poweroff") end),

  awful.key({ modkey,           }, "l", function() awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h", function() awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h", function() awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l", function() awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1)         end),
  awful.key({ modkey,           }, "/", function() awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "/", function() awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, "Control" }, "n", awful.client.restore),

  -- Prompt
  awful.key({ modkey            }, "r", function() mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey            }, "x", function()
    awful.prompt.run({ prompt = "Run Lua code: " },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir("cache").."/history_eval")
  end)
)

local clientkeys = awful.util.table.join(
  -- Change opacity level
  awful.key({ modkey,           }, "#83",    function(c) c.opacity = c.opacity - 0.05 end),
  awful.key({ modkey,           }, "#85",    function(c) c.opacity = c.opacity + 0.05 end),

  -- Default key mappings
  awful.key({ modkey,           }, "f",      function(c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey, "Shift"   }, "c",      function(c) c:kill()                         end),
  awful.key({ modkey, "Control" }, "/",      awful.client.floating.toggle                    ),
  awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey,           }, "o",      awful.client.movetoscreen                       ),
  awful.key({ modkey,           }, "t",      function(c) c.ontop = not c.ontop            end),
  awful.key({ modkey,           }, "n",      function(c) c.minimized = true               end),
  awful.key({ modkey,           }, "m",      function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
  end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
  -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local screen = mouse.screen
      local tag = awful.tag.gettags(screen)[i]
      if tag then
        awful.tag.viewonly(tag)
      end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = mouse.screen
      local tag = awful.tag.gettags(screen)[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if tag then
          awful.client.movetotag(tag)
        end
      end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if tag then
          awful.client.toggletag(tag)
        end
      end
    end)
  )
end

local clientbuttons = awful.util.table.join(
  awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   border_color = beautiful.border_normal,
                   focus        = awful.client.focus.filter,
                   raise        = true,
                   keys         = clientkeys,
                   buttons      = clientbuttons,
                   floating     = false
                 },
    callback   =   awful.client.setslave
  },
  { rule = { instance = "crx_icppfcnhkcmnfdhfhphakoifcfokfdhg" },
    properties = { tag = tags[1][9] }
  },
  -- Disable hinting for URxvt (so it doesn't leave weird borders) and opacify it
  { rule = { class = "URxvt" },
    properties = { opacity = 0.85,
                   size_hints_honor = false
                 }
  },
  -- Moves vlc to its tab
  { rule = { class = "Vlc" },
    properties = { tag = tags[1][7],
                   switchtotag = true
                 }
  },
  -- Float dialog, splash, and notification windows
  { rule_any = { type = { "dialog", "splash", "notification" } },
    properties = { floating = true }
  }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c, startup)
  -- Enable sloppy focus
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end

  local titlebars_enabled = false
  if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
      awful.button({ }, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
      end)
    )

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(awful.titlebar.widget.iconwidget(c))
    left_layout:buttons(buttons)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- The title goes in the middle
    local middle_layout = wibox.layout.flex.horizontal()
    local title = awful.titlebar.widget.titlewidget(c)
    title:set_align("center")
    middle_layout:add(title)
    middle_layout:buttons(buttons)

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)

    awful.titlebar(c):set_widget(layout)
  end
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
