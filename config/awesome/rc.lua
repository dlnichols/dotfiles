-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

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
beautiful.init("/home/dan/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "urxvt"
local editor = os.getenv("EDITOR") or "vim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
--  awful.layout.suit.tile.bottom,
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

-- {{{ Wallpaper
local wp_path = "/home/dan/workspace/wallpapers/"

local scan_wp = function(path)
  if type(path) == nil then return end
  local papers = {}
  for file in io.popen("find " .. path .. " -type f"):lines() do
    table.insert(papers, file)
  end
  return papers
end

local scan_wpf = function()
  local folders = {}
  for folder in io.popen("find " .. wp_path .. " -mindepth 1 -maxdepth 1 -iname '.*' -prune -o -print"):lines() do
    folders[folder] = scan_wp(folder)
  end
  return folders
end

local wp_files = scan_wpf()

local randomize_wallpaper = function()
  for s = 1, screen.count() do
    local geometry = math.floor(screen[s].geometry.width) .. "x" .. math.floor(screen[s].geometry.height)
    if (geometry == "2025x3600") then
        geometry = "1080x1920"
    elseif (geometry == "2880x1620") then
        geometry = "1920x1080"
    end
    local wp_list = wp_files[wp_path .. geometry]
    if wp_list ~= nil then -- No wallpapers for this geometry
      local wp_count = #wp_list
      local wp_index = math.random(1, wp_count)
      gears.wallpaper.maximized(wp_list[wp_index], s, true)
      -- naughty.notify({ text = "Screen " .. s .. " : " .. geometry })
    end
  end
end
randomize_wallpaper()
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
local tags = {
  names   = {     "main",      "www",     "junk",      "dev",      "ide",     "gimp",      "vlc",       "im",    "music" },
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
    volume = volume .. "%"
  else
    volume = volume .. "M"
  end
  myvolume:set_markup(" V:"..volume)
end
update_volume()

-- Create a battery widget
local mybattery = wibox.widget.textbox()
function update_battery()
  local fh = io.open("/sys/class/power_supply/BAT0/present", "r")
  local status
  if fh == nil then
    status = "A/C"
  else
    local fnow    = io.open("/sys/class/power_supply/BAT0/charge_now")
    local enow    = fnow:read()
    fnow:close()

    local ffull   = io.open("/sys/class/power_supply/BAT0/charge_full")
    local efull   = ffull:read()
    ffull:close()

    local fstatus = io.open("/sys/class/power_supply/BAT0/status")
    local estatus = fstatus:read()
    fstatus:close()

    status = math.floor(enow * 100 / efull).."%"
    if estatus:match("Charging") then
      status = "⚡"..status
    elseif estatus:match("Discharging") then
      status = "-"..status
    end
  end
  mybattery:set_markup(" B:"..status)
end
update_battery()

local mybattery_timer = timer({ timeout = 3 })
mybattery_timer:connect_signal("timeout", update_battery)
mybattery_timer:start()

-- Create a WiFi widget
local mywifi = wibox.widget.textbox()
function update_wifi()
  local fh = io.popen("sudo /usr/bin/cat /proc/net/wireless | awk 'NR==3 {print $3}' | sed 's/\\.//'")
  local strength = fh:read()
  local exval = {fh:close()}
  if strength then
    mywifi:set_markup(" W:" .. strength .. "%")
  else
    mywifi:set_markup(" W:--")
  end
end
update_wifi()

local mywifi_timer = timer({ timeout = 5 })
mywifi_timer:connect_signal("timeout", update_wifi)
mywifi_timer:start()

-- Create a textclock widget
local mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
local mywibox = {}
local mypromptbox = {}
local mylayoutbox = {}
local mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({        }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({        }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({        }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
  awful.button({        }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
local mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function(c)
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
  awful.button({ }, 3, function()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({
        theme = { width = 250 }
      })
    end
  end),
  awful.button({ }, 4, function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function()
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
    awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)
  ))
  -- Create a taglist widget
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  --left_layout:add(mylauncher)
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then right_layout:add(wibox.widget.systray()) end
  right_layout:add(myvolume)
  right_layout:add(mywifi)
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
  --awful.button({ }, 3, function() mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local globalkeys = awful.util.table.join(
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
  awful.key({ modkey            }, "p", randomize_wallpaper ),

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
  --awful.key({ modkey,           }, "w", function() mymainmenu:show() end),

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

  awful.key({ modkey,           }, "l",     function() awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h",     function() awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h",     function() awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l",     function() awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h",     function() awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l",     function() awful.tag.incncol(-1)         end),
  awful.key({ modkey,           }, "space", function() awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, "Control" }, "n", awful.client.restore),

  -- Prompt
  awful.key({ modkey            }, "r",     function() mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey            }, "x", function()
    awful.prompt.run({ prompt = "Run Lua code: " },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir("cache") .. "/history_eval")
  end)
)

local clientkeys = awful.util.table.join(
  -- Change opacity level
  awful.key({ modkey,           }, "#83",    function(c) c.opacity = c.opacity - 0.05 end),
  awful.key({ modkey,           }, "#85",    function(c) c.opacity = c.opacity + 0.05 end),

  -- Default key mappings
  awful.key({ modkey,           }, "f",      function(c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey, "Shift"   }, "c",      function(c) c:kill()                         end),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                    ),
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
  awful.button({        }, 1, function(c) client.focus = c; c:raise() end),
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
    --if not c.size_hints.user_position and not c.size_hints.program_position then
    --  awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)
    --end
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

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
