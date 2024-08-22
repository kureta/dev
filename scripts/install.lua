vim.cmd("Lazy! install all")
vim.cmd("Lazy load all")
vim.cmd("Mason")
vim.cmd("MasonUpdate")

local lazy = require("lazy.core.config")

local nvim_lsp = lazy.plugins["nvim-lspconfig"]
local mason = lazy.plugins["mason.nvim"]

-- Stuff below is for converting package aliases to names
local registry = require("mason-registry")

local all_package_names = registry.get_all_package_names()
local alias_to_name = {}

for _, package_name in pairs(all_package_names) do
	local aliases = registry.get_package_aliases(package_name)
	if aliases then
		for _, alias in pairs(aliases) do
			alias_to_name[alias] = package_name
		end
		alias_to_name[package_name] = package_name
	end
end

-- Load all packages into a list
local mason_stuff = {}

-- lsp packages installed via nvim-lspconfig
local servers = nvim_lsp._.cache.opts.servers
for server_name, _ in pairs(servers) do
	table.insert(mason_stuff, alias_to_name[server_name])
end

-- mason apps installed
local mason_apps = mason._.cache.opts.ensure_installed
for _, mason_app in pairs(mason_apps) do
	table.insert(mason_stuff, alias_to_name[mason_app])
end

local function install_mason_package(package_name)
	local job_id = vim.fn.jobstart(vim.cmd("MasonInstall " .. package_name), {
		on_exit = function(_, code)
			if code == 0 then
				print("Installed " .. package_name)
			else
				print("Failed to install " .. package_name)
			end
		end,
	})

	if job_id > 0 then
		vim.fn.jobwait({ job_id }, -1)
	else
		print("Failed to start job for " .. package_name)
	end
end

-- install them one by one
for _, v in ipairs(mason_stuff) do
	install_mason_package(v)
end