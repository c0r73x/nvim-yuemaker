local Vim
do
	local _class_0
	local _base_0 = {
		eval = function(vimL)
			return vim.api.nvim_eval(vimL)
		end,
		echo = function(message)
			return vim.api.nvim_out_write(message .. '\n')
		end,
		echoError = function(message)
			return vim.api.nvim_err_writeln(message)
		end,
		callFunction = function(functionName, args)
			return vim.api.nvim_call_function(functionName, args)
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Vim"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Vim = _class_0
end
local Assert
Assert = function(condition, message)
	if not condition then
		if message then
			return error("Assert hit! " .. message)
		else
			return error("Assert hit!")
		end
	end
end
local Path
do
	local _class_0
	local _base_0 = {
		join = function(left, right)
			local result = left
			local lastChar = left:sub(-1)
			if lastChar ~= '/' and lastChar ~= '\\' then
				result = result .. '/'
			end
			result = result .. right
			return result
		end,
		normalize = function(path)
			local result = string.gsub(path, "\\", "/")
			if result:sub(-1) == '/' then
				result = result:sub(0, #result - 1)
			end
			return result
		end,
		makeMissingDirectoriesInPath = function(path)
			local dirPath = Path.getDirectory(path)
			return Vim.callFunction('mkdir', {
				dirPath,
				'p'
			})
		end,
		getDirectory = function(path)
			return path:match('^(.*)[\\/][^\\/]*$')
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Path"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Path = _class_0
end
local File
do
	local _class_0
	local _base_0 = {
		exists = function(path)
			return Vim.callFunction('filereadable', {
				path
			}) ~= 0
		end,
		getModificationTime = function(path)
			return Vim.callFunction('getftime', {
				path
			})
		end,
		delete = function(path)
			return Vim.callFunction('delete', {
				path
			})
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "File"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	File = _class_0
end
local Directory
do
	local _class_0
	local _base_0 = {
		exists = function(path)
			return Vim.callFunction('isdirectory', {
				path
			}) ~= 0
		end,
		getAllFilesWithExtensionRecursive = function(path, extension)
			local _accum_0 = { }
			local _len_0 = 1
			local _list_0 = Vim.callFunction('globpath', {
				path,
				"**/*." .. tostring(extension),
				0,
				1
			})
			for _index_0 = 1, #_list_0 do
				local x = _list_0[_index_0]
				_accum_0[_len_0] = Path.normalize(x)
				_len_0 = _len_0 + 1
			end
			return _accum_0
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Directory"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Directory = _class_0
end
local tableContains
tableContains = function(table, element)
	for _index_0 = 1, #table do
		local value = table[_index_0]
		if value == element then
			return true
		end
	end
	return false
end
local deleteOrphanedLuaFiles
deleteOrphanedLuaFiles = function(validBaseNames, luaDir, verbose)
	local _list_0 = Directory.getAllFilesWithExtensionRecursive(luaDir, 'lua')
	for _index_0 = 1, #_list_0 do
		local filePath = _list_0[_index_0]
		local luaRelativePath = filePath:sub(#luaDir + 2)
		local baseName = luaRelativePath:sub(0, #luaRelativePath - 4)
		if tableContains(validBaseNames, baseName) then
			goto _continue_0
		end
		local alwaysDelete = false
		if Vim.callFunction('exists', {
			'g:YueMakerDeleteOrphanedLuaFiles'
		}) == 1 then
			alwaysDelete = vim.api.nvim_get_var('YueMakerDeleteOrphanedLuaFiles')
		end
		if not alwaysDelete then
			local choice = Vim.callFunction("confirm", {
				"Lua file at '" .. tostring(luaRelativePath) .. "' does not have a corresponding Yue file. Delete it?\nNote that this popup can be suppressed with the g:YueMakerDeleteOrphanedLuaFiles setting",
				"&Delete\n&Skip\n&Abort",
				2,
				"Question"
			})
			if choice == 2 then
				if verbose then
					Vim.echo("Skipping orphaned lua file '" .. tostring(luaRelativePath) .. "'")
				end
				goto _continue_0
			end
			if choice ~= 1 then
				if verbose then
					Vim.echo("Aborting lua file cleanup")
				end
				return
			end
		end
		File.delete(filePath)
		if verbose then
			Vim.echo("Deleted file '" .. tostring(filePath) .. "' since it had no matching yue file")
		end
		::_continue_0::
	end
end
local timeStampIsGreater
timeStampIsGreater = function(file1Path, file2Path)
	local time1 = File.getModificationTime(file1Path)
	local time2 = File.getModificationTime(file2Path)
	return time1 > time2
end
local YueMaker
do
	local _class_0
	local _base_0 = {
		getCompiler = function()
			if Vim.callFunction('exists', {
				'g:YueCompiler'
			}) == 1 then
				return vim.api.nvim_get_var('YueCompiler')
			else
				return "yue"
			end
		end,
		executeYue = function(yueText)
			local luaText = Vim.callFunction("system", {
				YueMaker.getCompiler() .. " --",
				yueText
			})
			return loadstring(luaText)()
		end,
		compileYueIfOutOfDate = function(yuePath, luaPath)
			if not File.exists(luaPath) or timeStampIsGreater(yuePath, luaPath) then
				Path.makeMissingDirectoriesInPath(luaPath)
				local output = Vim.callFunction("system", {
					YueMaker.getCompiler() .. " -o \"" .. tostring(luaPath) .. "\" \"" .. tostring(yuePath) .. "\""
				})
				if Vim.eval('v:shell_error') ~= 0 then
					Vim.echoError("Errors occurred while compiling file '" .. tostring(yuePath) .. "'")
					Vim.echoError(output)
					return false
				end
				return true
			end
			return false
		end,
		compileDir = function(yueDir, luaDir, verbose)
			local numUpdated = 0
			local yueBaseNames = { }
			local _list_0 = Directory.getAllFilesWithExtensionRecursive(yueDir, 'yue')
			for _index_0 = 1, #_list_0 do
				local filePath = _list_0[_index_0]
				local baseName = filePath:sub(#yueDir + 2)
				baseName = baseName:sub(0, #baseName - 4)
				table.insert(yueBaseNames, baseName)
			end
			if #yueBaseNames > 0 then
				deleteOrphanedLuaFiles(yueBaseNames, luaDir, verbose)
				for _index_0 = 1, #yueBaseNames do
					local baseName = yueBaseNames[_index_0]
					local luaPath = Path.join(luaDir, baseName) .. '.lua'
					local yuePath = Path.join(yueDir, baseName) .. '.yue'
					if YueMaker.compileYueIfOutOfDate(yuePath, luaPath) then
						if verbose then
							Vim.echo("Compiled file '" .. tostring(yuePath) .. "'")
						end
						local packageName = baseName:gsub("\\", "."):gsub("/", ".")
						package.loaded[packageName] = nil
						numUpdated = numUpdated + 1
					end
				end
			end
			return numUpdated
		end,
		compileAllYueFilesInDirectoryRecursive = function(rootDir)
			local numUpdated = 0
			local _list_0 = Directory.getAllFilesWithExtensionRecursive(rootDir, 'yue')
			for _index_0 = 1, #_list_0 do
				local yuePath = _list_0[_index_0]
				local luaPath = yuePath:sub(0, #yuePath - 4) .. "lua"
				if YueMaker.compileYueIfOutOfDate(yuePath, luaPath) then
					numUpdated = numUpdated + 1
				end
			end
			return numUpdated
		end,
		compileAll = function(verbose)
			local rtp = Vim.eval('globpath(&rtp, "", 0, 1)')
			local paths
			do
				local _accum_0 = { }
				local _len_0 = 1
				for _, x in ipairs(rtp) do
					_accum_0[_len_0] = Path.normalize(x)
					_len_0 = _len_0 + 1
				end
				paths = _accum_0
			end
			local numUpdated = 0
			for _index_0 = 1, #paths do
				local pluginRoot = paths[_index_0]
				local yueDir = Path.join(pluginRoot, 'yue')
				local luaDir = Path.join(pluginRoot, 'lua')
				numUpdated = numUpdated + YueMaker.compileDir(yueDir, luaDir, verbose)
				local _list_0 = {
					'ftplugin',
					'indent',
					'plugin'
				}
				for _index_1 = 1, #_list_0 do
					local dirName = _list_0[_index_1]
					numUpdated = numUpdated + YueMaker.compileAllYueFilesInDirectoryRecursive(Path.join(pluginRoot, dirName))
				end
			end
			if verbose and numUpdated == 0 then
				Vim.echo("All yue files are already up to date")
			end
			return numUpdated
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "YueMaker"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	YueMaker = _class_0
	return _class_0
end
