require 'util'
local builderport = table.deepcopy(data.raw["item"]["roboport"])
builderport.name = "builderport";
builderport.place_result = "builderport";

local builderportEntity = table.deepcopy(data.raw["roboport"]["roboport"])
builderportEntity.name = "builderport"
builderportEntity.minable.result = "builderport";
builderportEntity.energy_usage = "150kW"
builderportEntity.logistics_radius = 0
builderportEntity.construction_radius = 500

data:extend({ builderport, builderportEntity })
