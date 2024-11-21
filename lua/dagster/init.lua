local M = {}

M.config = {
    dagster_binary = 'dagster',
}

----------------------------------------------------------------------------------------------------
--                                             UTILS                                              --
----------------------------------------------------------------------------------------------------

local function _split_words(s)
    local words = {}
    for substring in s:gmatch('%S+') do
        table.insert(words, substring)
    end
    return words
end

--
-- Find `pyproject.toml` file working upward from `cwd`
--
local function _find_pyproject_toml()
    local cwd = vim.fn.expand('%:p:h')
    while cwd ~= '/' do
        local pyproject_toml_path = cwd .. '/pyproject.toml'
        if vim.fn.filereadable(pyproject_toml_path) == 1 then
            return pyproject_toml_path
        end
        cwd = vim.fn.fnamemodify(cwd, ':h')
    end
    return nil
end

--
-- Gets current visual selection. (TODO: simplify)
--
local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  if next(lines) == nil then
    return nil
  end
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

----------------------------------------------------------------------------------------------------
--                                              CORE                                              --
----------------------------------------------------------------------------------------------------

local function cli(arguments)
    local command = { M.config.dagster_binary }
    vim.list_extend(command, arguments)
    print(table.concat(vim.fn.systemlist(command), '\n'))
end

local function materialize(select, file_name)
    -- defaults to active file assuming `:Materialize` is called while in the file containing the asset
    file_name = file_name or vim.fn.expand('%:p')
    cli({ 'asset', 'materialize', '--select', select, '--python-file', file_name })
end

----------------------------------------------------------------------------------------------------
--                                             SETUP                                              --
----------------------------------------------------------------------------------------------------

M.setup = function(opts)
    opts = opts or {}

    -- merge user options w/ default configuration, overwriting defaults
    M.config = vim.tbl_deep_extend("force", M.config, opts)

    vim.api.nvim_create_user_command('Dagster', function(input)
        local arguments = _split_words(input.args)
        cli(arguments)
    end, { nargs = '+', range = true })

    vim.api.nvim_create_user_command('Materialize', function(input)
        local select
        if input.range == 0 then
            select = input.args
        else
            select = get_visual_selection()
        end
        materialize(select)
    end, { nargs = '*', range = true, desc = ':Materialize <select> in current file' })
end

return M
