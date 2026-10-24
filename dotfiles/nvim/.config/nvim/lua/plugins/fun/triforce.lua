return {
    "gisketch/triforce.nvim",
    dependencies = { "nvzone/volt" },
    -- Loads at startup rather than on the keymap: triforce.tracker registers
    -- the autocmds that accumulate XP, so deferring it until the profile is
    -- opened would mean nothing ever gets tracked. VeryLazy is late enough to
    -- stay off the startup path.
    event = "VeryLazy",
    keys = {
        -- Was <leader>tp, which collided with precognition's toggle in
        -- util/precognition.lua -- the two specs set the same lhs, so one of
        -- them was unreachable. Plugin-owned UI lives under <leader>p now.
        --
        -- <Plug>(TriforceProfile) is the mapping target the plugin exposes for
        -- exactly this; see triforce/init.lua:37.
        { "<leader>pt", "<Plug>(TriforceProfile)", desc = "Triforce profile" },
    },
    opts = {
        -- `keymap = { show_profile = ... }` used to be set here. It is
        -- deprecated: triforce/config.lua:117 fires a vim.notify WARN at setup
        -- time when it is present, and that notification during startup is what
        -- produced the E565 this file used to work around -- by replacing
        -- vim.notify globally and permanently with a vim.schedule wrapper.
        --
        -- That workaround was worse than the problem. It leaked out of setup
        -- (the "reset it afterwards" step was never written), so *every*
        -- vim.notify in the session got deferred by one event-loop tick. That
        -- reorders notifications against the surrounding output and fights
        -- snacks.nvim, which installs its own vim.notify -- whichever of the
        -- two loaded second wrapped the other. Dropping the deprecated option
        -- removes the warning, so there is nothing left to defer.
    },
}
