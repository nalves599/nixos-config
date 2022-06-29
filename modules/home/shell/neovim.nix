{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.neovim;
in
{
  options.modules.shell.neovim.enable = mkEnableOption "neovim";

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
        " Change leader key to space bar
        let mapleader = ' '

        " tabs config
        set shiftwidth=2
        set softtabstop=2
        set tabstop=2
        set expandtab

        " misc configs
        syntax on
        set showmatch
        set ignorecase
        set mouse=a
        set nohlsearch
        set hidden
        set incsearch
        set noerrorbells
        set number
        set nowrap
        set signcolumn=yes
        set colorcolumn=80
        set scrolloff=8
        set wildmode=longest,list,full
        set foldmethod=indent
        set clipboard=unnamedplus

        " window
        vnoremap K :m '<-2<CR>gv=gv
        vnoremap J :m '>+1<CR>gv=gv
        nnoremap Y yg$
        nnoremap J mzJ`z
        nmap <leader>wv <C-w>v
        nmap <leader>ws <C-w>s
        nmap <leader>wl <C-w>l
        nmap <leader>wh <C-w>h
        nmap <leader>wk <C-w>k
        nmap <leader>wj <C-w>j

        " buffer
        nmap <leader>bc <cmd>bw<CR>
        nmap <leader>bn <cmd>bn<CR>
        nmap <leader>bp <cmd>bn<CR>

        " git
        nmap <leader>ga   :Git add %<CR>
        nmap <leader>gcc  :G commit<CR>
        nmap <leader>gg   :G<CR>
        nmap <leader>gd   :G diff %<CR>
        nmap <leader>gB   :G blame<CR>
        nmap <leader>gcw  :lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>
        nmap <leader>gb   :G checkout<Space>
        nmap <leader>gcb  :G branch<Space>

        " harpoon
        nnoremap <silent><leader>a :lua require('harpoon.mark').add_file()<CR>
        nnoremap <silent><C-e> :lua require('harpoon.ui').toggle_quick_menu()<CR>
        nnoremap <silent><leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
        nnoremap <silent><leader>2 :lua require("harpoon.ui").nav_file(2)<CR>
        nnoremap <silent><leader>3 :lua require("harpoon.ui").nav_file(3)<CR>
        nnoremap <silent><leader>4 :lua require("harpoon.ui").nav_file(4)<CR>:

        " lsp
        nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
        nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
        nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
        nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
        nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
        nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
        nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
        nnoremap <leader>vsd :lua vim.diagnostic.show_flost()<CR>
        nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
        nnoremap <leader>vll :call LspLocationList()<CR>

        " telescope
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,-S,--hidden,--files,-g,!.git<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
        nnoremap <leader>fw <cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>
        nnoremap <leader>fe <cmd>Ex<cr>


        " delete trailing whitespace
        autocmd BufWritePre * %s/\s\+$//e

        " Easy bind to leave terminal mode
        tnoremap <Esc> <C-\><C-n>

        " Keeps undo history over different sessions
        set undofile
        set undodir=/tmp//

        " Saves cursor position to be used next time the file is edited
        autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif

        set termguicolors
        colorscheme gruvbox
        highlight Normal guibg=none
      '';
      plugins = with pkgs.vimPlugins; [

        {
          plugin = lualine-nvim;
          config = ''
            lua << EOF
            require('lualine').setup {
              options = {
                theme = 'auto',
                section_separators = {left='', right=''},
                component_separators = {left='', right=''},
                icons_enabled = true
              },
              sections = {
                 lualine_b = { 'diff' },
                 lualine_c = {
                   {'diagnostics', {
                     sources = {nvim_diagnostic, ale},
                     symbols = {error = ':', warn =':', info = ':', hint = ':'}
                    }}, {'filename', file_status = true, path = 1}
                  },
                 lualine_x = { 'encoding', {'filetype', colored = false} },
               },
              inactive_sections = {
                 lualine_c = {
                   {'filename', file_status = true, path = 1}
                 },
                 lualine_x = { 'encoding', {'filetype', colored = false} },
               },
              tabline = {
                lualine_a = { 'hostname' },
                lualine_b = { 'branch' },
                lualine_z = { {'tabs', tabs_color = { inactive = "TermCursor", active = "ColorColumn" } } }
               },
              extensions = { fzf, fugitive },
            }
            EOF
          '';
        }

        vim-numbertoggle
        vim-devicons
        nerdcommenter
        neoformat

        gruvbox-nvim

        {
          plugin = nvim-lspconfig;
          config = ''
            lua << EOF
              local cmp = require('cmp')

              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities.textDocument.completion.completionItem.snippetSupport = true

              cmp.setup({
                snippet = {
                  expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                  end,
                },
                mapping = {
                  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-d>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  ["<Up>"] = cmp.mapping.select_prev_item(),
                  ["<Down>"] = cmp.mapping.select_next_item(),
                },
                sources = {
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'buffer' },
                  { name = 'path' },
                },
              })

              local function config(_config)
                return vim.tbl_deep_extend('force', {
                  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
                }, _config or {})
              end

              require('lspconfig').tsserver.setup(config());
              require('lspconfig').ccls.setup(config());
              require('lspconfig').jedi_language_server.setup(config());
              require('lspconfig').rust_analyzer.setup(config());
              require('lspconfig').gopls.setup(config());
              require('lspconfig').emmet_ls.setup(config());
              require('lspconfig').html.setup(config({ cmd = {"html-languageserver", "--stdio"}, filetypes = {'html', 'htmldjango'} }));
            EOF
          '';
        }
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        nvim-cmp

        luasnip
        friendly-snippets

        plenary-nvim
        popup-nvim
        harpoon

        git-worktree-nvim
        vim-fugitive

        gv-vim
        telescope-fzy-native-nvim
        {
          plugin = telescope-nvim;
          config = ''
            lua << EOF
            require('telescope').setup({
              defaults = {
                prompt_prefix = '> ',
                color_devicons = true,

                file_sorter = require("telescope.sorters").get_fzy_sorter,

                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
              },
              extensions = {
                fzy_native = {
                  override_generic_sorter = false,
                  override_file_sorter = true,
                },
              },
            });

            require("telescope").load_extension("fzy_native");
            require("telescope").load_extension("git_worktree");
            EOF
          '';
        }

        {
          plugin = (nvim-treesitter.withPlugins (plugins: [
            pkgs.tree-sitter-grammars.tree-sitter-nix
            pkgs.tree-sitter-grammars.tree-sitter-c
            pkgs.tree-sitter-grammars.tree-sitter-comment
            pkgs.tree-sitter-grammars.tree-sitter-lua
            pkgs.tree-sitter-grammars.tree-sitter-markdown
            pkgs.tree-sitter-grammars.tree-sitter-ocaml
            pkgs.tree-sitter-grammars.tree-sitter-rust
            pkgs.tree-sitter-grammars.tree-sitter-vim
            pkgs.tree-sitter-grammars.tree-sitter-html
          ]));
          config = "lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }";
        }

      ];
    };

    home.packages = with pkgs; [
      tree-sitter
      rust-analyzer
      python39Packages.jedi-language-server
      ccls
      nodePackages.typescript-language-server
      nodePackages.vscode-html-languageserver-bin
      #nodePackages.emmet-ls
      gopls
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
