return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
    {
      "microsoft/vscode-js-debug",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    },
  },
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    -- import nvim-dap plugin
    local dap = require("dap")

    -- import nvim-dap-ui plugin
    local dapui = require("dapui")

    -- import nvim-notify plugin
    local notify = require("notify")

    local keymap = vim.keymap -- for conciseness

    dap.set_log_level("INFO") -- Helps when configuring DAP, see logs with :DapShowLog

    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    dap.configurations = {
      go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
      },
      java = {
        {
          type = "java",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
      },
    }

    for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (pwa-node)",
          cwd = vim.fn.getcwd(),
          args = { "${file}" },
          sourceMaps = true,
          protocol = "inspector",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (pwa-node with ts-node)",
          cwd = vim.fn.getcwd(),
          runtimeArgs = { "--loader", "ts-node/esm" },
          runtimeExecutable = "node",
          args = { "${file}" },
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (pwa-node with jest)",
          cwd = vim.fn.getcwd(),
          runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
          runtimeExecutable = "node",
          args = { "${file}", "--coverage", "false" },
          rootPath = "${workspaceFolder}",
          sourceMaps = true,
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
          type = "pwa-chrome",
          request = "attach",
          name = "Attach Program (pwa-chrome = { port: 9222 })",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          port = 9222,
          webRoot = "${workspaceFolder}",
        },
        {
          type = "node2",
          request = "attach",
          name = "Attach Program (Node2)",
          processId = require("dap.utils").pick_process,
        },
        {
          type = "node2",
          request = "attach",
          name = "Attach Program (Node2 with ts-node)",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
          port = 9229,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach program (pwa-node)",
          cwd = vim.fn.getcwd(),
          processId = require("dap.utils").pick_process,
          skipFiles = { "<node_internals>/**" },
        },
      }
    end

    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({ reset = true })
    end

    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

    -- Start debuggin sessions
    keymap.set("n", "<leader>ds", function()
      dap.continue()
      dapui.toggle({})
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
    end, { desc = "Start debugging session" })

    keymap.set("n", "<leader>dl", require("dap.ui.widgets").hover, { desc = "" })
    keymap.set("n", "<leader>dc", dap.continue, { desc = "Debugging Continue" })
    keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint on a Line" })
    keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
    keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
    keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
    keymap.set("n", "<leader>dC", function()
      dap.clear_breakpoints()
      notify("Breakpoints cleared", "warn")
    end, { desc = "Clear all Breakpoints" })

    -- Close debugger and clear breakpoints
    keymap.set("n", "<leader>de", function()
      dap.clear_breakpoints()
      dapui.toggle({})
      dap.terminate()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) --
      notify("Debug session ended", "warn")
    end, { desc = "Close debugger and end debugging session" })

    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      expand_lines = vim.fn.has("nvim-0.7"),
      layouts = {
        {
          elements = {
            "scopes",
          },
          size = 0.3,
          position = "right",
        },
        {
          elements = {
            "repl",
            "breakpoints",
          },
          size = 0.3,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
      },
    })
  end,
}
