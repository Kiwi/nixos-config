{ pkgs, ... }:

let
  learningMode = ''
    " learning: {{{
    " no arrow keys
    "noremap  <Up> ""
    "noremap! <Up> <Esc>
    "noremap  <Down> ""
    "noremap! <Down> <Esc>
    "noremap  <Left> ""
    "noremap! <Left> <Esc>
    "noremap  <Right> ""
    "noremap! <Right> <Esc>
    " }}}
  '';
  setupUI =''
    " UI: {{{
    set number            " show line numbers
    set showcmd           " show cmd in bottom bar
    set cursorline                " highlight current line
    set autoindent                " auto indenting
    filetype indent on    " load filetype-specific indent files
    set wildmenu          " visual autocompletion for command menu
    set lazyredraw                " redraw only when we need to
    set showmatch         " highlight matching [{()}] parentheses
    set mouse=r
    set cc=80,120
    " }}}
  '';
  setupColor = ''
    " Color: {{{
    colorscheme koehler
    syntax enable
    set t_Co=256
    " }}}
  '';
  setupBuffer = ''
    " Buffer {{{
    " easy split navigation
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
    " }}}
    '';
  setupFold = ''
    " Fold: {{{
    set foldmethod=syntax
    nnoremap <space> za     " space open/closes folds
    set foldenable                " enable folding
    set foldlevelstart=10 " open most folds by default
    set foldnestmax=5     " 5 nested fold max
    " }}}
  '';
  setupSyntax =''
    " Syntax {{{
    let perl_fold=1
    let perl_extended_vars=1
    let javaScript_fold=1
    let sh_fold_enable=1
    let php_folding=1
    let ruby_fold=1
    let xml_syntax_folding=1
    " }}}
  '';
  setupSpacing = ''
    " Spacing {{{
    set shiftwidth=4                      " indentation level spaces
    set tabstop=8                         " number of visual spaces for tabs in read files
    set listchars=tab:>-,nbsp:_,trail:•   " set display mode of unwanted characters
    set list                              " set on for the unwanted characters
    " }}}
  '';
  setupSearch = ''
    " Search {{{
    set incsearch " search as characters entered
    set hlsearch  " highlight matches
    set ic                " set ignore case
    " }}}
  '';

    in
    {
      environment.systemPackages = with pkgs; [
        (
          with import <nixpkgs> {};

          vim_configurable.customize {
            name = "vim";
          # .vimrc:
          vimrcConfig.customRC = ''
            ${setupUI}
            ${setupColor}
            ${setupFold}
            ${setupSyntax}
            ${setupSpacing}
            ${setupSearch}
          '';
          vimrcConfig.vam.knownPlugins = pkgs.vimPlugins; # optional
          vimrcConfig.vam.pluginDictionaries = [
            # vim basics
            { names = ["vim-tmux-navigator" "vim-autoformat" ]; }
            # coding
            { names = ["ale" "vim-go" ]; }

        ];
      }
      )
    ];
  }
#  vim:foldmethod=marker:foldlevel=0
