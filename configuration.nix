# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
  #  <nixos-wsl/modules>
# <home-manager/nixos>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true; 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    vim
    git
    python314
    cudaPackages.cudnn
    code-cursor
    claude-code
  ];
    programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;


  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    # Your zsh config
    enable = true;
    enableAutosuggestions = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "autojump" ];
      theme = "robbyrussell";
    };
  };
  
  home-manager = {
    useUserPackages = true;
    users.nixos = {
      home.stateVersion = "24.05";  # Adjust based on your NixOS version
      programs.vim.enable = true;   # Example: enable Vim via Home Manager

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = with pkgs; [
          # LSP servers
          lua-language-server
          nodePackages.typescript-language-server
          nodePackages.vscode-langservers-extracted # HTML/CSS/JSON/ESLint
          nodePackages.svelte-language-server
          nil # Nix LSP

          # Formatters
          nodePackages.prettier
          stylua
          nixpkgs-fmt

          # Additional tools
          ripgrep
          fd
          tree-sitter
        ];

        plugins = with pkgs.vimPlugins; [
          # LSP and completion
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          luasnip
          cmp_luasnip

          # Treesitter
          nvim-treesitter.withAllGrammars
          nvim-treesitter-context

          # Telescope (fuzzy finder)
          telescope-nvim
          telescope-fzf-native-nvim

          # File explorer
          nvim-tree-lua
          nvim-web-devicons

          # Git integration
          gitsigns-nvim
          vim-fugitive

          # UI enhancements
          lualine-nvim
          bufferline-nvim
          indent-blankline-nvim

          # Color scheme
          catppuccin-nvim

          # Additional utilities
          comment-nvim
          vim-surround
          auto-pairs
          which-key-nvim
          plenary-nvim
        ];

        extraLuaConfig = ''
          -- Basic settings
          vim.opt.number = true
          vim.opt.relativenumber = true
          vim.opt.mouse = 'a'
          vim.opt.ignorecase = true
          vim.opt.smartcase = true
          vim.opt.hlsearch = false
          vim.opt.wrap = false
          vim.opt.breakindent = true
          vim.opt.tabstop = 2
          vim.opt.shiftwidth = 2
          vim.opt.expandtab = true
          vim.opt.termguicolors = true
          vim.opt.signcolumn = 'yes'
          vim.opt.updatetime = 250
          vim.opt.completeopt = 'menu,menuone,noselect'

          -- Leader key
          vim.g.mapleader = ' '
          vim.g.maplocalleader = ' '

          -- Catppuccin theme
          require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = false,
          })
          vim.cmd.colorscheme "catppuccin"

          -- Lualine
          require('lualine').setup({
            options = {
              theme = 'catppuccin',
              icons_enabled = true,
            }
          })

          -- Bufferline
          require('bufferline').setup({
            options = {
              mode = "buffers",
              separator_style = "slant",
            }
          })

          -- Nvim-tree
          require('nvim-tree').setup({
            view = {
              width = 30,
            },
          })
          vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })

          -- Telescope
          local telescope = require('telescope')
          telescope.setup({
            defaults = {
              mappings = {
                i = {
                  ['<C-u>'] = false,
                  ['<C-d>'] = false,
                },
              },
            },
          })
          pcall(telescope.load_extension, 'fzf')

          vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find files' })
          vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
          vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find buffers' })
          vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help tags' })

          -- Gitsigns
          require('gitsigns').setup({
            signs = {
              add = { text = '+' },
              change = { text = '~' },
              delete = { text = '_' },
              topdelete = { text = '‾' },
              changedelete = { text = '~' },
            },
          })

          -- Comment.nvim
          require('Comment').setup()

          -- Which-key
          require('which-key').setup()

          -- Indent blankline
          require('ibl').setup()

          -- Treesitter
          require('nvim-treesitter.configs').setup({
            highlight = { enable = true },
            indent = { enable = true },
          })

          -- LSP Configuration
          local lspconfig = require('lspconfig')
          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          -- Lua
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' }
                }
              }
            }
          })

          -- TypeScript
          lspconfig.ts_ls.setup({ capabilities = capabilities })

          -- Svelte
          lspconfig.svelte.setup({ capabilities = capabilities })

          -- HTML/CSS/JSON
          lspconfig.html.setup({ capabilities = capabilities })
          lspconfig.cssls.setup({ capabilities = capabilities })
          lspconfig.jsonls.setup({ capabilities = capabilities })

          -- Nix
          lspconfig.nil_ls.setup({ capabilities = capabilities })

          -- LSP keybindings
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })

          -- Completion setup
          local cmp = require('cmp')
          local luasnip = require('luasnip')

          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-d>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { 'i', 's' }),
            }),
            sources = {
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'buffer' },
              { name = 'path' },
            },
          })
        '';
      };

      programs.tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
        mouse = true;
        terminal = "screen-256color";
        historyLimit = 10000;
        escapeTime = 10;
        prefix = "C-a";
        baseIndex = 1;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          yank
          vim-tmux-navigator
          resurrect
          continuum
          battery
          cpu
        ];

        extraConfig = ''
          # Dual prefix support (C-a and C-b like oh-my-tmux)
          set -g prefix2 C-b
          bind C-a send-prefix -2
          bind C-b send-prefix -2

          # Activity monitoring
          setw -g monitor-activity on
          set -g visual-activity off

          # Split panes using - and _ (oh-my-tmux style)
          bind - split-window -v
          bind _ split-window -h
          unbind '"'
          unbind %

          # Pane navigation (vim-style)
          bind -r h select-pane -L
          bind -r j select-pane -D
          bind -r k select-pane -U
          bind -r l select-pane -R

          # Pane resizing
          bind -r H resize-pane -L 2
          bind -r J resize-pane -D 2
          bind -r K resize-pane -U 2
          bind -r L resize-pane -R 2

          # Window navigation
          bind -r C-h previous-window
          bind -r C-l next-window
          bind Tab last-window

          # Toggle mouse mode
          bind m set -g mouse \; display "Mouse: #{?mouse,ON,OFF}"

          # Reload config
          bind r source-file ~/.config/tmux/tmux.conf \; display "⚡ Config reloaded!"

          # Maximize pane (oh-my-tmux style)
          bind + resize-pane -Z

          # Start windows and panes at 1
          set -g base-index 1
          setw -g pane-base-index 1

          # Renumber windows
          set -g renumber-windows on

          # Enable RGB color
          set -ga terminal-overrides ",*256col*:Tc"

          # Pane borders (oh-my-tmux inspired)
          set -g pane-border-style 'fg=colour238'
          set -g pane-active-border-style 'fg=colour154'

          # Message style
          set -g message-style 'fg=colour222,bg=colour238,bold'

          # Status bar - Oh My Tmux inspired
          set -g status on
          set -g status-position bottom
          set -g status-interval 10
          set -g status-justify left

          # Status bar colors
          set -g status-style 'fg=colour244,bg=colour236'

          # Left status: session name and user
          set -g status-left-length 30
          set -g status-left '#[fg=colour232,bg=colour154,bold] ❐ #S #[fg=colour154,bg=colour238,nobold]#[fg=colour245,bg=colour238] #(whoami) #[fg=colour238,bg=colour236,nobold]'

          # Right status: battery, cpu, date, time
          set -g status-right-length 150
          set -g status-right '#[fg=colour238,bg=colour236]#[fg=colour245,bg=colour238] #{battery_icon} #{battery_percentage} | #{cpu_icon} #{cpu_percentage} #[fg=colour240,bg=colour238]#[fg=colour250,bg=colour240] %Y-%m-%d #[fg=colour245,bg=colour240]#[fg=colour232,bg=colour245,bold] %H:%M '

          # Window status
          setw -g window-status-format '#[fg=colour236,bg=colour240]#[fg=colour250,bg=colour240] #I #[fg=colour250,bg=colour240]#W #[fg=colour240,bg=colour236]'
          setw -g window-status-current-format '#[fg=colour236,bg=colour154]#[fg=colour232,bg=colour154,bold] #I #[fg=colour232,bg=colour154,bold]#W #[fg=colour154,bg=colour236,nobold]'

          # Activity in window
          setw -g window-status-activity-style 'fg=colour154,bg=colour236,none'

          # Continuum auto-restore
          set -g @continuum-restore 'on'
        '';
      };
    };
  };
}
