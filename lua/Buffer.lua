local fn = vim.fn
local api = vim.api
local cmd = vim.cmd

local function err(msg)
	api.nvim_echo({ { "Buffer.nvim: ", "ErrorMsg" }, { msg, "ErrorMsg" } }, true, {})
end

local function create_new()
	print("create_new: todo")
end

function BDelete()
	local cur_buf = api.nvim_get_current_buf()
	-- local brb = true
	if cur_buf < 0 then
		return err("No buffer is deleted")
	end

	local modified = api.nvim_buf_get_option(cur_buf, "modified")

	if modified then
		return err("No write since last change for buffer " .. cur_buf .. " (add ! to override)")
	end

	local next_buf = fn.bufnr("#")

	if fn.buflisted(next_buf) == 0 then
		return
	end

	local wins = api.nvim_list_wins()

	-- This only makes sense when there is more than 1 window open
	if #wins < 2 then
		return
	end

	for i = #wins, 1, -1 do
		local win = wins[i]

		-- If window is valid and the current window holds the current buffer
		if api.nvim_win_is_valid(win) and fn.winbufnr(win) == cur_buf then
			local winnr = fn.win_id2win(win)
			cmd(winnr .. " wincmd w")
			cmd("buffer " .. next_buf)

			if api.nvim_get_current_buf() == cur_buf then
				print("wow")
				-- print(next)
				-- create_new()
			end
		end
	end

	cmd(fn.winnr() .. " wincmd w")

	api.nvim_buf_delete(cur_buf, { force = true })

	-- local wins_again = vim.tbl_filter(function(t)
	-- 	print(t)
	-- 	return true
	-- end, api.nvim_list_wins())
end

cmd([[ command! BufDel lua BDelete() ]])
BDelete()
