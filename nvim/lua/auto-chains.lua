-- lua require('auto-chains').goto_job()
local M = {}

---@return string
function M.ingest()
    local filepath = vim.api.nvim_buf_get_name(0)
    local filename = vim.fn.fnamemodify(filepath, ':t')  -- :t gets basename, :r removes extension
    return filename
end

function M.export(filename)
    local filepath = vim.fn.expand('%:p')

    vim.cmd('e ' .. 'torchweb/services/barry/jobs/' .. filename)
end

function M.goto_job()
    local filename = M.ingest()
    M.export(filename)
end

-- Instead of setting marks we should just provide a way to go to prompt, job, schema
-- lua require('auto-chains').set_marks()
function M.set_marks()
    local filename = M.ingest()
    local ns_id = 0

    local job_buf_id = vim.fn.bufadd('torchweb/services/barry/jobs/' .. filename)
    vim.api.nvim_buf_set_mark(job_buf_id, 'Z', 1, 5, {})

    local schema_buf_id = vim.fn.bufadd('torchweb/services/barry/schemas/' .. filename)
    vim.api.nvim_buf_set_mark(schema_buf_id, 'X', 1, 5, {})

    local prompt_buf_id = vim.fn.bufadd('torchweb/services/barry/prompts/' .. filename)
    vim.api.nvim_buf_set_mark(prompt_buf_id, 'C', 1, 5, {})
end

return M
