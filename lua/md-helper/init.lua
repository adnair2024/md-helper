local M = {}

-- INTERNAL UTILITY: Insert text at the current cursor position
-- This is cleaner than using native 'i' commands as it uses the API directly.
local function insert_text(text)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- row is 1-indexed for the cursor, but 0-indexed for the buffer API
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, {text})
end

-- FUNCTION: Generate Table of Contents
-- Scans the buffer for # Headings and creates a nested list
M.generate_toc = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local toc = { "## Table of Contents", "" }
    local found_header = false

    for _, line in ipairs(lines) do
        -- Match lines starting with 1 to 6 '#' characters
        local level, title = line:match("^(#+)%s+(.*)$")
        if level then
            found_header = true
            local depth = #level
            -- Ignore the TOC header itself if it already exists
            if title ~= "Table of Contents" then
                -- Strip markdown links from title: [Name](URL) -> Name
                local clean_title = title:gsub("%[([^%]]+)%]%s*%b()", "%1")
                
                -- Convert clean title to a slug (e.g., "My Heading" -> "my-heading")
                local slug = clean_title:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")
                
                -- Indent based on heading level (2 spaces per level)
                local indent = string.rep("  ", depth - 1)
                table.insert(toc, string.format("%s* [%s](#%s)", indent, clean_title, slug))
            end
        end
    end

    if not found_header then
        print("No headers found to create a TOC!")
        return
    end

    -- Insert the TOC at the current cursor position
    vim.api.nvim_put(toc, "l", true, true)
end

-- FUNCTION: Create a Markdown Table
-- Uses dual-input prompts to calculate grid dimensions
M.create_table = function()
    vim.ui.input({ prompt = "Number of Rows: " }, function(rows)
        if not rows or rows == "" then return end
        vim.ui.input({ prompt = "Number of Columns: " }, function(cols)
            if not cols or cols == "" then return end
            
            local r, c = tonumber(rows), tonumber(cols)
            if not r or not c then 
                print("Error: Rows and Columns must be numbers")
                return 
            end

            local lines = {}
            -- Build Header: |   |   |
            table.insert(lines, "| " .. string.rep("  | ", c))
            -- Build Separator: |---|---|
            table.insert(lines, "| " .. string.rep("--- | ", c))
            -- Build Rows
            for _ = 1, r do
                table.insert(lines, "| " .. string.rep("  | ", c))
            end

            vim.api.nvim_put(lines, "l", true, true)
        end)
    end)
end

-- FUNCTION: Hyperlink Wrapper
M.create_link = function()
    vim.ui.input({ prompt = "Display Text: " }, function(text)
        if not text then return end
        vim.ui.input({ prompt = "URL: " }, function(url)
            if url then
                insert_text(string.format("[%s](%s)", text, url))
            end
        end)
    end)
end

-- FUNCTION: Image Wrapper
M.create_image = function()
    vim.ui.input({ prompt = "Alt Description: " }, function(alt)
        if not alt then return end
        vim.ui.input({ prompt = "Image URL/Path: " }, function(path)
            if path then
                insert_text(string.format("![%s](%s)", alt, path))
            end
        end)
    end)
end

return M
