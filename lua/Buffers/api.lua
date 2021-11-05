local M = {}
local A = vim.api

---@class Opts
---@field non_modifiable boolean: Whether to delete non-modifiable buffers

local function notify(dels, mods)
	vim.notify("BufOnly: " .. dels .. " deleted buffer(s), " .. mods .. " modified buffer(s)")
end

---Remove all buffers except the current one
---@param opts Opts
function M.only(opts)
	opts = opts or {}
	local option = A.nvim_buf_get_option

	local cur = A.nvim_get_current_buf()

	local deleted, modified = 0, 0

	for _, n in ipairs(A.nvim_list_bufs()) do
		-- If the iter buffer is modified one, then don't do anything
		if option(n, "modified") then
			-- iter is not equal to current buffer
			-- iter is modifiable or del_non_modifiable == true
			-- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
			modified = modified + 1
		elseif n ~= cur and (option(n, "modifiable") or opts.non_modifiable) then
			A.nvim_buf_delete(n, {})
			deleted = deleted + 1
		end
	end

	notify(deleted, modified)
end

---Remove all the buffers
---@param opts Opts
function M.nuke(opts)
	opts = opts or {}
	local option = A.nvim_buf_get_option

	local deleted, modified = 0, 0

	for _, n in ipairs(A.nvim_list_bufs()) do
		-- If the iter buffer is modified one, then don't do anything
		if option(n, "modified") then
			-- iter is not equal to current buffer
			-- iter is modifiable or del_non_modifiable == true
			-- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
			modified = modified + 1
		elseif option(n, "modifiable") or opts.non_modifiable then
			A.nvim_buf_delete(n, {})
			deleted = deleted + 1
		end
	end

	notify(deleted, modified)
end

return M
