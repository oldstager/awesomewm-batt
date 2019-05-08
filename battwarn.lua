-- battery warning
-- created by bpdp

local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function bat_notification()
  
  local f_capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))

  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))

  if (bat_capacity <= 15 and bat_status == "Discharging") then
    naughty.notify({ title      = "Battery Warning"
      , text       = "Battery low! " .. bat_capacity .."%" .. " left!"
      , fg="#ff0000"
      -- optional color if you like it:
      -- , bg="#deb887"
      , bg="#ffffff"
      , timeout    = 15
      , position   = "top_middle"
    })
  end

  if (bat_capacity >= 85 and (bat_status == "Charging" or bat_status == "Full")) then
    naughty.notify({ title      = "Battery Warning"
      , text       = "Battery secured: it's already " .. bat_capacity .."%" 
      , fg="#ff0000"
      , bg="#228B22" -- forest green
      , timeout    = 15
      , position   = "top_middle"
    })
  end

end

battimer = timer({timeout = 120})
battimer:connect_signal("timeout", bat_notification)
battimer:start()

-- end here for battery warning
