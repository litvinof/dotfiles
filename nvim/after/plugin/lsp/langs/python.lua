-- require('lspconfig')['pylsp'].setup {
--   before_init = function(params)
--     params.processId = vim.NIL
--   end,
--   cmd = {
--     'docker',
--     'run',
--     '-i',
--     '--name',
--     'pylsp-empto-backend',
--     '--rm',
--     '-v',
--     '/Users/viacheslav.litvinov/projects/empto/backend:/src',
--     'empto_backend:latest',
--     'pylsp'
--   }
-- }
-- Normal mode keymap to insert `import ipdb; ipdb.set_trace()`
vim.keymap.set('n', '<leader>pd', function()
  -- Insert a new line below and add the debug line
  vim.api.nvim_feedkeys('oimport ipdb; from pprint import pprint as pp; ipdb.set_trace()', 'n', false)
  -- Exit insert mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end, { desc = "Insert ipdb breakpoint" })
