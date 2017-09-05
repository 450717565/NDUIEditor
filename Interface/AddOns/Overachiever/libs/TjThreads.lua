
--[[
-------------------------------------------------------------------------------------------------------------------------------------------

TjThreads.lua
  by Tuhljin

A library to manage coroutines, more easily letting addons use "threaded" tasks. It lets your addon accomplish time-intensive tasks
without disrupting gameplay or other scripts - provided the task function divides its work up into parts in an effective manner (using
coroutine.yield()).

Note that this library uses a frame with an OnUpdate handler. Although the frame is automatically hidden when there are no active threads,
it might be better (rather than using this library) to use one of the C_Timer functions, depending on what your function is doing. (A
Blizzard rep said C_Timer is generally more efficient than using OnUpdate but an exception is "when you have a ticker with a very short
period - something that's going to fire every couple frames.")

The library is quite simple. Future features might include things like balancing time spent between threads but that's overkill at the
moment. All it does now is, every other tick, run one task (but some tasks might be more intensive than others; we don't account for that
by running two smaller ones or any such thing).

ok = TjThreads.AddTask( func )
  Add a task to the list.
  Arguments:
    func (function)		The function to call. This is not a coroutine (the library creates and manages the coroutine for the function) but
                        should make proper use of coroutine.yield().
  Returns:
    ok (boolean)		True if the task was added. False if that function is already on the list.

ok = TjThreads.RemoveTask( func )
  Remove a task from the list.
  Arguments:
    func (function)		The function to call.
  Returns:
    ok (boolean)		True if the task was removed. False if that function wasn't on the list.

TjThreads.RushTask( func )
  Force a task to finish. The coroutine will be resumed repeatedly until the thread is dead (when the function is exited without using
  coroutine.yield()). Careful not to use this with a function that will not naturally end when called repeatedly in this manner! The task
  is automatically removed afterward.

Example usage:

  TjThreads.AddTask(
    function()
	  local yieldIn = 50 -- Change this to another number to adjust how much work is done each time the thread is resumed
	  for x,id in ipairs(list) do
	    yieldIn = yieldIn - 1
	    if (yieldIn < 1) then
	      coroutine.yield()
	      yieldIn = 50
	    end
	    -- Do main work here
	  end
    end
  )

-------------------------------------------------------------------------------------------------------------------------------------------
--]]


local THIS_VERSION = "0.02"

if (TjThreads and TjThreads.Version >= THIS_VERSION) then  return;  end  -- Lua's pretty good at this. It even knows that "1.0.10" > "1.0.9". However, be aware that it thinks "1.0" < "1.0b" so putting a "b" on the end for Beta, nothing for release, doesn't work.

TjThreads = TjThreads or {}
local TjThreads = TjThreads
TjThreads.Version = THIS_VERSION


local coroutine = coroutine

local INTERVAL = 4 --2
local waitLeft = INTERVAL

local tasks, threads
local nextTask = 1

local frame = CreateFrame("Frame")
frame:Hide() -- Just in case it doesn't start hidden, which it should


--[[
local function doTask(func)
	local ok, ret2 = pcall(func)
	if (ok) then  return ret2;  end
	C_Timer.After(0, function()  -- Use a timer so as to not interrupt what we're doing.
		error("TjThreads library encountered an error while running a task. To prevent further errors, the task was terminated. Check the task function for problems. The original error message follows:|n" .. ret2)
	end)
	return true  -- End the task as if it was complete (ret2 true) so it will be removed.
end
--]]

local function resumeThread(thread)
	if (coroutine.status(thread) == "dead") then  return true;  end
	local noerrors, ret2 = coroutine.resume(thread)
	if (not noerrors) then
		C_Timer.After(0, function()  -- Use a timer so as to not interrupt what we're doing.
			error("TjThreads library encountered an error while running a task. To prevent further errors, the task was terminated. Check the task function for problems. The original error message follows:|n" .. ret2)
		end)
		return true  -- End the task as if it was complete
	end
	if (coroutine.status(thread) == "dead") then  return true;  end
end

frame:SetScript("OnUpdate", function(self, elapsed)
	waitLeft = waitLeft - 1
	if (waitLeft > 0) then  return;  end
	waitLeft = INTERVAL

	local task = tasks[nextTask]
	if (task) then
		nextTask = nextTask + 1
	else
		task = tasks[1]
		if (not task) then
			tasks = nil
			nextTask = 1
			frame:Hide()
			return;
		end
		nextTask = 2
	end

	if (resumeThread(threads[task])) then  -- If the task is complete
		TjThreads.RemoveTask(task)
	end
end)


function TjThreads.AddTask(func)
	if (tasks) then
		for i,v in ipairs(tasks) do
			if (v == func) then  return false;  end
		end
	else
		tasks = {}
		threads = {}
		frame:Show()
	end
	tasks[#tasks + 1] = func
	threads[func] = coroutine.create(func)
	return true
end

function TjThreads.RemoveTask(func)
	if (tasks) then
		threads[func] = nil
		for i,v in ipairs(tasks) do
			if (v == func) then
				table.remove(tasks, i)
				if (#tasks < 1) then
					tasks = nil
					threads = nil
					nextTask = 1
					frame:Hide()
				end
				return true
			end
		end
	end
	return false
end

function TjThreads.RushTask(func)
	local thread = threads and threads[func] or nil
	if (not thread) then
		TjThreads.AddTask(func)
		thread = threads[func]
		assert(thread)
	end
	while (not resumeThread(thread)) do  -- Run until it reports it is finished (returning true).
		-- This space intentionally left blank.
	end
	TjThreads.RemoveTask(func)
end

