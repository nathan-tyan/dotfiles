vim.pack.add({
    { src = 'https://github.com/karb94/neoscroll.nvim' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/akinsho/bufferline.nvim' },
    { src = 'https://github.com/RRethy/vim-illuminate' },
    { src = 'https://codeberg.org/andyg/leap.nvim' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
    { src = 'https://github.com/numtostr/comment.nvim' },
    { src = 'https://github.com/stevearc/aerial.nvim' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },

    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
})

local keymap_opts = { noremap = true, silent = true }

local function try_require(plugin_name)
    local ok, plugin = pcall(require, plugin_name)
    if ok then
        return plugin
    else
        local metatable = {
            __index = function(_, key)
                local message = string.format(
                    'calling "%s" on missing plugin "%s', key, plugin_name
                )
                vim.notify(message, vim.log.levels.DEBUG)
                return function() end  -- dummy function
            end
        }
        plugin = {}
        setmetatable(plugin, metatable)
        return plugin
    end
end

try_require('neoscroll').setup({
    mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb' },
    stop_eof = false,
    easing = 'quadratic',
})

try_require('lualine').setup({
    options = {
        theme = 'nord',
        icons_enabled = false,
        section_separators = '',
        component_separators = '',
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
            {
                'filename',
                path = 3,
            },
        },
        lualine_x = {
            {
                'diagnostics',
                sources = { 'nvim_lsp', 'nvim_diagnostic' },
            },
            'lsp_status',
        },
        lualine_y = { 'filetype' },
        lualine_z = { '%c %l/%L' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { '%c %l/%L' },
        lualine_z = {}
    },
    extensions = { 'fzf', 'nvim-tree', 'quickfix' },
})

try_require('bufferline').setup({
    options = {
        style_preset = 'minimal',
        buffer_close_icon = '',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        truncate_names = false,
        diagnostics = 'nvim_lsp',
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        separator_style = 'thick',
        sort_by = 'insert_after_current',
    },
})
vim.keymap.set('n', '<C-l>', '<cmd>BufferLineCycleNext<cr>', keymap_opts)
vim.keymap.set('n', '<C-h>', '<cmd>BufferLineCyclePrev<cr>', keymap_opts)

local illuminate = try_require('illuminate')
vim.keymap.set('n', '<c-n>', illuminate.goto_next_reference, keymap_opts)
vim.keymap.set('n', '<c-p>', illuminate.goto_prev_reference, keymap_opts)
local illuminate_highlight = {
    bold = true,
    underline = true,
}
vim.api.nvim_set_hl(0, 'IlluminatedWordText', illuminate_highlight)
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', illuminate_highlight)
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', illuminate_highlight)

-- try_require('leap')
vim.keymap.set({ 'n', 'x', 'o' }, 's',  '<Plug>(leap)')

local ignore_patterns = {
    { value = '.git',         is_dir = true },
    { value = '.ruff_cache',  is_dir = true },
    { value = '.venv',        is_dir = true },
    { value = '__pycache__',  is_dir = true },
    { value = 'node_modules', is_dir = true },
}
local fzf_find_opts = { '-type', 'f' }
local fzf_rg_opts = { '--color=never', '--hidden', '--no-ignore', '--files' }
local fzf_fd_opts = { '--color=never', '--hidden', '--no-ignore', '--type="file"' }
for _, pattern in ipairs(ignore_patterns) do
    if pattern.is_dir then
        local find_opt = string.format("-not -path '*/%s/*'", pattern.value)
        table.insert(fzf_find_opts, find_opt)
    else
        local find_opt = string.format("-not -name '%s'", pattern.value)
        table.insert(fzf_find_opts, find_opt)
    end
    local rg_opt = string.format("--glob='!%s'", pattern.value)
    table.insert(fzf_rg_opts, rg_opt)
    local fd_opt = string.format("--exclude='%s'", pattern.value)
    table.insert(fzf_fd_opts, fd_opt)
end
try_require('fzf-lua').setup({
    winopts = {
        height = 0.85,
        width = 0.9,
    },
    defaults = {
        file_icons = false,
        git_icons = false,
        color_icons = false,
        find_opts = table.concat(fzf_find_opts, ' '),
        rg_opts = table.concat(fzf_rg_opts, ' '),
        fd_opts = table.concat(fzf_fd_opts, ' '),
    },
})
vim.keymap.set('n', '<leader>f', '<cmd>FzfLua files<cr>', keymap_opts)

try_require('nvim-tree').setup({
    view = {
        number = true,
        width = {
            min = 32,
            max = -1,
            padding = 1,
        },
    },
    renderer = {
        add_trailing = true,
        indent_markers = {
            enable = true,
        },
        icons = {
            show = {
                file = false,
                folder = false,
                folder_arrow = false,
                git = false,
                modified = false,
                hidden = false,
                diagnostics = false,
                bookmarks = false,
            },
        },
    },
    filters = {
        git_ignored = false,
        custom = {
            '.ruff_cache',
            '.venv',
            '__pycache__',
        },
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>', keymap_opts)

try_require('nvim-treesitter').install({
    'bash',
    'c',
    'cpp',
    'css',
    'csv',
    'dart',
    'dockerfile',
    'fish',
    'go',
    'groovy',
    'html',
    'java',
    'javascript',
    'json',
    'latex',
    'lua',
    'markdown',
    'python',
    'rust',
    'scss',
    'toml',
    'tsx',
    'typescript',
    'yaml',
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

try_require('ibl').setup({
    indent = {
        char = '│'
    },
    scope = {
        char = '┃',
        show_start = false,
        show_end = false,
    },
})

try_require('Comment').setup()

try_require('aerial').setup({
    backends = { 'lsp', 'treesitter' },
    layout = {
        default_direction = 'float',
        min_width = 24,
        max_width = { 60, 0.6 },
        win_opts = {
            number = true,
        },
    },
    float = {
        relative = 'editor',
        max_height = 0.8,
        override = function(config, _)
            config.row = 1
            config.col = 1
            return config
        end,
    },
    keymaps = {
        ['<esc>'] = 'actions.close',
    },
    nerd_font = false,
    show_guides = true,
    close_on_select = true,
})
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle<cr>', keymap_opts)

try_require('nvim-autopairs').setup()

local gitsigns = try_require('gitsigns')
gitsigns.setup()
vim.keymap.set('n', '<leader>gb', gitsigns.blame, keymap_opts)
vim.keymap.set('n', '<leader>gl', gitsigns.blame_line, keymap_opts)

local conform = try_require('conform')
conform.setup({
    default_format_opts = {
        lsp_format = 'fallback',
    },
    format_on_save = nil,
    format_after_save = nil,
    formatters_by_ft = {
        python = { 'ruff_format' },
        sh = { 'shfmt' },
    },
})
vim.keymap.set('v', '<leader>f', conform.format, keymap_opts)
vim.api.nvim_create_user_command('Format', function() conform.format() end, {})

try_require('blink.cmp').setup({
    completion = {
        trigger = {
            show_on_insert = true,
        },
        list = {
            selection = {
                preselect = false,
                auto_insert = false,
            },
        },
        accept = {
            auto_brackets = { enabled = false },
        },
    },
    fuzzy = {
        prebuilt_binaries = {
            force_version = 'v*',
        },
    },
    cmdline = {
        completion = {
            menu = {
                auto_show = true,
            },
        },
    },
})

try_require('user.lsp').setup()
