local M = {}

function M:peek(job)
	local output, err = Command("glow")
		:arg("-s")
		:arg("dark")
		:arg("-w")
		:arg(tostring(job.area.w))
		:arg(tostring(job.file.url))
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not output then
		return
	end

	ya.preview_widget(job, ui.Text.parse(output.stdout):area(job.area))
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h then
		local new_skip = math.max(0, job.skip + job.units)
		ya.emit("peek", { new_skip, only_if = tostring(h.url) })
	end
end

return M
