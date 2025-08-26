return {
    { "savq/melange-nvim" }, -- The golden theme
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "sindrets/diffview.nvim", -- optional - Diff integration
        },
        config = true
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        "nvim-treesitter/playground",
        build = ":TSUpdate"
    },
    {
        "mason-org/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig",
        },
    },
    { "neovim/nvim-lspconfig" },
    { "rsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            options = {
                always_show_bufferline=false,
                mode = "tabs",
                separator_style = "thin",
                indicator = {
                    style = 'underline',
                },
            }
        }
    },
    {
        "nvim-lualine/lualine.nvim"
    },
    {
        "szw/vim-maximizer",
        keys = {
            { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/Minimize a split" },
        }
    },
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" }
    },
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
    },
    {
        "gbprod/substitute.nvim",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "theprimeagen/harpoon"
    },
    {
        "sindrets/diffview.nvim"
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "giuxtaposition/blink-cmp-copilot",
            "hrsh7th/cmp-nvim-lsp"
        },
        version = '1.*'
    },
    {
        'litvinof/nvim-http',
        branch = 'fix/macos-symlink',
    }

}
