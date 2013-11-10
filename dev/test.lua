-- Load Pile
shell.run('pile.lua init')

local utils = require('peak-utils')

local peak = require('peak')
local kernel = peak(_G)

local test = peak.threads.clone(kernel, {
	namespace = 'new',
	process = 'new',
	files = 'new',
	env = 'clone',
	fs = 'clone'
}, function()
	print('in thread')

	print(utils.filterProp('type:test', 'type', 'test'))

	kernel.alive = false

	while true do
		local ev = {coroutine.yield()}
		-- print(ev[1])
	end
end)

test.paused = false

local timeout = 0.5
local timeoutTimer = os.startTimer(timeout)

while kernel.alive do
	local ev = {os.pullEvent()}

	print('event: ' .. ev[1])

	if ev[1] == 'timer' and ev[2] == timeoutTimer then
		kernel.run()
		timeoutTimer = os.startTimer(timeout)
	else
		kernel.interupt(unpack(ev))
	end
end