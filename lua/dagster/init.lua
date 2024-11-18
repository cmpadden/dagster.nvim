local M = {}

local config = {
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

----------------------------------------------------------------------------------------------------
--                                              CORE                                              --
----------------------------------------------------------------------------------------------------

local function cli(arguments)
    local command = { config.dagster_binary }
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

    vim.api.nvim_create_user_command('Dagster', function(input)
        local arguments = _split_words(input.args)
        cli(arguments)
    end, { nargs = '+' })

    vim.api.nvim_create_user_command('Materialize', function(input)
        local select = input.args
        materialize(select)
    end, { nargs = 1, desc = ':Materialize <select> in current file' })
end

return M
