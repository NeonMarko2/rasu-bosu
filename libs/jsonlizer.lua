---@param table_to_parse table
---@return string
local function ArrayToJson(table_to_parse)
	local json = "[ "

	local first_iteration = true
	for _, value in ipairs(table_to_parse) do
		local data_separation = ","
		if first_iteration == true then
			first_iteration = false
			data_separation = ""
		end
		if type(value) == "string" then
			value = '"' .. value .. '"'
		end
		if type(value) == "table" then
			local is_array = #value > 0
			local parsed_table = nil

			if is_array then
				parsed_table = ArrayToJson(value)
			else
				parsed_table = TableToJson(value)
			end

			value = parsed_table
		end

		json = json .. data_separation
		json = json .. '"' .. tostring(key) .. '":'
		json = json .. value
	end

	json = json .. " ]"
	return json
end

---@param table_to_parse table
---@return string
function TableToJson(table_to_parse)
	local json = "{ "

	local first_iteration = true
	for key, value in pairs(table_to_parse) do
		local data_separation = ","
		if first_iteration == true then
			first_iteration = false
			data_separation = ""
		end
		if type(value) == "string" then
			value = '"' .. value .. '"'
		end
		if type(value) == "table" then
			local is_array = #value > 0
			local parsed_table = nil

			if is_array then
				parsed_table = ArrayToJson(value)
			else
				parsed_table = TableToJson(value)
			end

			value = parsed_table
		end

		json = json .. data_separation
		json = json .. '"' .. tostring(key) .. '":'
		json = json .. value
	end

	json = json .. " }"
	return json
end

---@param string_to_lex string
local function jsonTokenizer(string_to_lex, index, tokens)
	local current_char = string_to_lex:sub(index, index)

	if current_char == " " then
		return jsonTokenizer(string_to_lex, index + 1, tokens)
	end

	if current_char == '"' then
		local sub_index = index + 1
		while string_to_lex:sub(sub_index, sub_index) ~= '"' do
			sub_index = sub_index + 1
		end
		tokens[#tokens + 1] = { type = "string", value = string_to_lex:sub(index + 1, sub_index - 1) }
		index = sub_index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end
	-- "%d filters by digits 0-9"
	if current_char:match("%d") then
		local sub_index = index + 1
		while string_to_lex:sub(sub_index, sub_index):match("%d") do
			sub_index = sub_index + 1
		end
		tokens[#tokens + 1] = { type = "number", value = tonumber(string_to_lex:sub(index, sub_index - 1)) }
		index = sub_index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end

	if current_char == "t" or current_char == "f" then
		if string_to_lex:sub(index, index + 3) == "true" then
			tokens[#tokens + 1] = { type = "boolean", value = true }
			index = index + 4
			return jsonTokenizer(string_to_lex, index, tokens)
		end
		if string_to_lex:sub(index, index + 4) == "false" then
			tokens[#tokens + 1] = { type = "boolean", value = false }
			index = index + 5
			return jsonTokenizer(string_to_lex, index, tokens)
		end
	end

	if current_char == ":" then
		tokens[#tokens + 1] = { type = "equates", value = nil }
		index = index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end

	if current_char == "{" then
		tokens[#tokens + 1] = { type = "table_open", value = nil }
		index = index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end

	if current_char == "[" then
		tokens[#tokens + 1] = { type = "array_open", value = nil }
		index = index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end

	if current_char == "}" then
		tokens[#tokens + 1] = { type = "table_close", value = nil }
		index = index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end

	if current_char == "]" then
		tokens[#tokens + 1] = { type = "array_close", value = nil }
		index = index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end

	if current_char == "," then
		index = index + 1
		return jsonTokenizer(string_to_lex, index, tokens)
	end

	if index >= string_to_lex:len() then
		return tokens
	end
	print(index, #tokens, string_to_lex:len(), string_to_lex:sub(index, index))
end

local function jsonArrayParser(tokens, start_index)
	local _table = {}
	for i = start_index, #tokens, 1 do
		if tokens[i].type == "array_close" then
			return _table, i + 1
		end

		_table[#_table + 1] = tokens[i].value
	end
end

local function jsonParser(tokens, start_index, _table)
	_table = _table or {}
	local table_key = nil
	local table_equates = nil
	for i = start_index, #tokens, 1 do
		local token = tokens[i]
		local is_valid = false

		if token.type == "table_close" then
			return _table, i + 1
		end

		if table_key == nil then
			table_key = token
		elseif table_equates == nil then
			table_equates = token
		elseif table_key and table_equates then
			if table_key.type == "string" then
				if table_equates.type == "equates" then
					is_valid = true
				else
					print(token.value)
					error("Token " .. i - 1 .. " is not : (equates)")
				end
			else
				print(token.type)
				error("Token " .. i - 2 .. " is not a string/key.")
			end
		end

		if is_valid then
			if token.type == "table_open" or token.type == "array_open" then
				local sub_table, index_to_jump_to

				if token.type == "table_open" then
					sub_table, index_to_jump_to = jsonParser(tokens, i + 1)
				else
					sub_table, index_to_jump_to = jsonArrayParser(tokens, i + 1)
				end

				_table[table_key.value] = sub_table
				return jsonParser(tokens, index_to_jump_to, _table)
			else
				_table[table_key.value] = token.value
				table_key = nil
				table_equates = nil
			end
		end
	end
	return _table
end

---@param string_to_parse string
---@return table
function JsonToTable(string_to_parse)
	local tokens = jsonTokenizer(string_to_parse, 1, {})
	local _table = jsonParser(tokens, 2)
	return _table
end
