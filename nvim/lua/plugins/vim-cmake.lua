return {
  {
    "cdelledonne/vim-cmake",
    config = function(_, _)
      vim.g.cmake_link_compile_commands = 1
    end,
  },
}
