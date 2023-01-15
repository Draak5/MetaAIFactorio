--data.lua

-- require("mod-gui");


--[[script.on_init(global_init)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.get_player(event.player_index)
	
	ui_util.toggle_mod_gui(player)


end)]]