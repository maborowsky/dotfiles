-- require('fixture_picker').picker("db")


local M = {}

-- function M.picker(opts, ctx)
--   local cmd = "sg"
--   local args = {
--     "run",
--     "--pattern",
--     "@pytest.fixture\ndef $FUNC($$$ARGS):\n  $$$BODY",
--     "--json=stream"
--   }
-- end



-- Find pytest fixture by name and load into quickfix
function M.picker(fixture_name)
  local cmd = string.format(
    [[sg run -p '@pytest.fixture
def %s($$$ARGS):
  $$$BODY' tests/ --json 2>/dev/null | jq -r '.[] | "\(.file):\(.range.start.line+2):\(.range.start.column):%s"']],
    fixture_name,
    fixture_name
  )

  local results = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    print("Error running command")
    return
  end

  vim.fn.setqflist({}, 'r')
  vim.cmd('cexpr "' .. results:gsub('"', '\\"'):gsub('\n', '\\n') .. '"')
  vim.cmd('copen')
end



-- function snacks_picker(fixture_name)
--   local cmd = string.format(
--     [[sg run -p '@pytest.fixture
-- def %s($$$ARGS):
--   $$$BODY' tests/ --json 2>/dev/null | jq -r '.[] | "\(.file):\(.range.start.line+2):\(.range.start.column):%s"']],
--     fixture_name,
--     fixture_name
--   )
--
--   local results = vim.fn.system(cmd)
--
--   if vim.v.shell_error ~= 0 then
--     print("Error running command")
--     return
--   end
--
--   vim.fn.setqflist({}, 'r')
--   vim.cmd('cexpr "' .. results:gsub('"', '\\"'):gsub('\n', '\\n') .. '"')
--   vim.cmd('copen')
-- end
--
--
--
--  vim.keymap.set('n', '<Leader>w', function()
--       local items = {}
--       local longest_name = 0
--       for i, workspace in ipairs(require('workspaces').get()) do
--         table.insert(items, {
--           idx = i,
--           score = i,
--           text = workspace.path,
--           name = workspace.name,
--         })
--         longest_name = math.max(longest_name, #workspace.name)
--       end
--       longest_name = longest_name + 2
--       return Snacks.picker({
--         items = items,
--         format = function(item)
--           local ret = {}
--           ret[#ret + 1] = { ('%-' .. longest_name .. 's'):format(item.name), 'SnacksPickerLabel' }
--           ret[#ret + 1] = { item.text, 'SnacksPickerComment' }
--           return ret
--         end,
--         confirm = function(picker, item)
--           picker:close()
--           vim.cmd(('WorkspacesOpen %s'):format(item.name))
--         end,
--       })
--     end)
--   end,


return M
