require("util")

local colours = {}
colours[defines.train_state.on_the_path]    = {g = 1, a=0.75} --green
colours[defines.train_state.arrive_signal]  = {r = 1, g = 0.5, a=0.75} --orange
colours[defines.train_state.wait_signal]    = {r = 1, a=0.75} --red
colours[defines.train_state.arrive_station] = {g = 1, b = 1, a=0.75} --teal
colours[defines.train_state.wait_station]   = {b = 1, a=0.75} --blue

--paint a train
local function colour_train(train, colour)
	for _,loco in pairs(train.locomotives.front_movers) do
		loco.color = colour
	end
	for _,loco in pairs(train.locomotives.back_movers) do
		loco.color = colour
	end
end

local function handle_event(event)
	local trigger = event.train

	--is train garbage?
	if trigger == nil or not trigger.valid then
		return
	end

	--special colour?
	if colours[trigger.state] ~= nil  then
		colour_train(trigger, colours[trigger.state])
	else 
		colour_train(trigger, {}) --paint it black
	end
end

--paint all existing trains
script.on_init(function()
	for _,surface in pairs(game.surfaces) do
		for _,force in pairs(game.forces) do
			for _,train in pairs(surface.get_trains(force)) do
				handle_event({train=train})
			end
		end
	end
end)

--the trigger to do stuff
script.on_event(defines.events.on_train_changed_state, handle_event)
script.on_event(defines.events.on_train_created, handle_event)