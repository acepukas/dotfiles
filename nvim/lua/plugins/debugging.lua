local getProgName = function()
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    require("dap-python").setup("python")
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = "/usr/share/cpptools-debug/bin/OpenDebugAD7",
    }
    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = getProgName,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
      {
        name = "Attach to gdb server :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = getProgName,
        setupCommands = {
          {
            text = "-enable-pretty-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      },
    }
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    vim.keymap.set(
      "n",
      "<leader>dt",
      dap.toggle_breakpoint,
      { desc = "Toggle Breakpoint" }
    )
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue (dap)" })
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "●", texthl = "red", linehl = "", numhl = "" }
    )
  end,
}
