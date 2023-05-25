return {
  {
    "nvim-lua/plenary.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim"
    },
  },
  {
    "vimwiki/vimwiki",
    init = function(_)
      vim.cmd [[
      let g:vimwiki_list = [{
        \ 'automatic_nested_syntaxes': 1,
        \ 'auto_export': 1,
        \ 'path_html': '/var/www/my.vimwiki.net',
        \ 'path': '~/vimwiki/',
        \ 'syntax': 'markdown',
        \ 'ext': '.md',
        \ 'links_space_char': '-',
        \ 'css_name': 'style.css',
        \ 'template_path': '~/vimwiki/templates',
        \ 'template_default': 'default',
        \ 'template_ext': '.tmpl',
        \ 'custom_wiki2html': 'vw2html',
        \ 'custom_wiki2html_args': '-chroma-tab-width=2 -chroma-with-classes=t',
        \ }]

      let g:vimwiki_global_ext = 0
      let g:vimwiki_toc_header_level = 2
      let g:vimwiki_toc_link_format = 1
      ]]
    end,
  },
}
