-- ~/.config/nvim/after/plugin/findandreplace.lua

local function git_root()
  local result = vim.system(
    { "git", "rev-parse", "--show-toplevel" },
    { text = true }
  ):wait()

  if result.code ~= 0 then
    vim.notify("FindAndReplace: not inside a Git repository", vim.log.levels.ERROR)
    return nil
  end

  return vim.trim(result.stdout)
end

local function git_visible_files(root)
  local result = vim.system({
    "git",
    "ls-files",
    "--cached",
    "--others",
    "--exclude-standard",
  }, {
    cwd = root,
    text = true,
  }):wait()

  if result.code ~= 0 then
    vim.notify("FindAndReplace: " .. result.stderr, vim.log.levels.ERROR)
    return {}
  end

  return vim.split(vim.trim(result.stdout), "\n", {
    plain = true,
    trimempty = true,
  })
end

local function lua_pattern_escape(text)
  return text:gsub("([^%w])", "%%%1")
end

vim.api.nvim_create_user_command("FindAndReplace", function(opts)
  local args = opts.fargs

  if #args < 2 then
    vim.notify("Usage: :FindAndReplace <find> <replace>", vim.log.levels.ERROR)
    return
  end

  local find = args[1]
  local replace = args[2]

  if find == "" then
    vim.notify("FindAndReplace: find text cannot be empty", vim.log.levels.ERROR)
    return
  end

  local root = git_root()
  if not root then
    return
  end

  local files = git_visible_files(root)
  local pattern = lua_pattern_escape(find)

  local changed_files = 0
  local replacements = 0
  local skipped = 0

  for _, relpath in ipairs(files) do
    local path = root .. "/" .. relpath

    -- Skip directories, unreadable files, etc.
    if vim.fn.filereadable(path) == 1 then
      local ok_read, lines = pcall(vim.fn.readfile, path)

      if ok_read and type(lines) == "table" then
        local changed = false
        local new_lines = {}

        for i, line in ipairs(lines) do
          local new_line, count = line:gsub(pattern, replace)

          if count > 0 then
            changed = true
            replacements = replacements + count
          end

          new_lines[i] = new_line
        end

        if changed then
          local ok_write, err = pcall(vim.fn.writefile, new_lines, path)

          if ok_write then
            changed_files = changed_files + 1
          else
            skipped = skipped + 1
            vim.notify(
              "FindAndReplace: failed to write " .. relpath .. ": " .. tostring(err),
              vim.log.levels.WARN
            )
          end
        end
      else
        skipped = skipped + 1
      end
    else
      skipped = skipped + 1
    end
  end

  -- Reload visible buffers whose files changed on disk.
  vim.cmd("checktime")

  vim.notify(
    string.format(
      "FindAndReplace: %d replacements in %d files, %d skipped",
      replacements,
      changed_files,
      skipped
    ),
    vim.log.levels.INFO
  )
end, {
  nargs = "+",
  desc = "Replace literal text in all Git-visible files without loading buffers",
})
