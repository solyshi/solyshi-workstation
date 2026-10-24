-- Debugger.
--
-- This was the largest capability gap in the config: gdb and lldb are in
-- install/pkg/03-dev-core.txt, clangd and jdtls are both configured, and there
-- was no way to set a breakpoint from inside Neovim.
--
-- C and C++ go through codelldb (mason, see dev/lsp/mason-tool-installer.lua).
-- Java needs nothing here -- nvim-java bundles java-debug-adapter and registers
-- its own dap configurations as soon as nvim-dap is loadable, so <leader>dc in
-- a Java buffer picks them up.
--
-- Python is deliberately not wired up: debugpy is in the mason registry but
-- wants a per-project virtualenv to be useful, which is a decision per repo
-- rather than a global default.
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                -- nvim-dap-ui hard-depends on nvim-nio and errors on setup
                -- without it.
                dependencies = { "nvim-neotest/nvim-nio" },
            },
        },
        keys = {
            -- Start / stop
            { "<leader>dc", function() require("dap").continue() end,          desc = "Continue / start debugging" },
            { "<leader>dt", function() require("dap").terminate() end,         desc = "Terminate session" },
            { "<leader>dl", function() require("dap").run_last() end,          desc = "Re-run last session" },

            -- Breakpoints
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
            {
                "<leader>dB",
                function()
                    vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
                        if cond and cond ~= "" then
                            require("dap").set_breakpoint(cond)
                        end
                    end)
                end,
                desc = "Conditional breakpoint",
            },
            {
                "<leader>dX",
                function() require("dap").clear_breakpoints() end,
                desc = "Clear all breakpoints",
            },

            -- Stepping
            { "<leader>di", function() require("dap").step_into() end,         desc = "Step into" },
            { "<leader>do", function() require("dap").step_over() end,         desc = "Step over" },
            { "<leader>dO", function() require("dap").step_out() end,          desc = "Step out" },

            -- Inspect
            { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle debugger UI" },
            { "<leader>dr", function() require("dap").repl.toggle() end,       desc = "Toggle debug REPL" },
            {
                "<leader>de",
                function() require("dapui").eval() end,
                mode = { "n", "x" },
                desc = "Evaluate expression",
            },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            -- Open the UI automatically with the session and close it when the
            -- session ends, so there is no stale panel layout lying around.
            dap.listeners.before.attach.dapui = function() dapui.open() end
            dap.listeners.before.launch.dapui = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui = function() dapui.close() end
            dap.listeners.before.event_exited.dapui = function() dapui.close() end

            -- codelldb speaks DAP over a TCP port it is told to listen on;
            -- ${port} is substituted by nvim-dap. exepath rather than a
            -- hardcoded mason path so a system codelldb also works.
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.exepath("codelldb"),
                    args = { "--port", "${port}" },
                },
            }

            local codelldb_config = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    -- Prompts for the binary rather than guessing a build dir,
                    -- since the projects here use cmake, meson and plain make.
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            dap.configurations.c = codelldb_config
            dap.configurations.cpp = codelldb_config

            -- Breakpoint signs. Uses the same nerd-font glyph style as the
            -- diagnostic signs in config/lsp-settings.lua.
            local signs = {
                DapBreakpoint = { text = "󰏃 ", texthl = "DiagnosticError" },
                DapBreakpointCondition = { text = "󰘥 ", texthl = "DiagnosticWarn" },
                DapLogPoint = { text = "󰍩 ", texthl = "DiagnosticInfo" },
                DapStopped = { text = "󰁕 ", texthl = "DiagnosticOk", linehl = "Visual" },
                DapBreakpointRejected = { text = "󰅚 ", texthl = "DiagnosticHint" },
            }
            for name, opts in pairs(signs) do
                vim.fn.sign_define(name, opts)
            end
        end,
    },
}
