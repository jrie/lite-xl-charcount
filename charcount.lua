-- mod-version:3
local core = require "core"
local style = require "core.style"
local StatusView = require "core.statusview"
local CommandView = require "core.commandview"
local DocView = require "core.docview"
local Doc = require "core.doc"

local cached_document_characters = setmetatable({}, { __mode = "k" })

local function compute_document_characters(doc)
  local amount_characters = -1
  local amount_lines_in_doc = #doc.lines
  local amount_newlines = amount_lines_in_doc - 1

  for i = 1, amount_lines_in_doc do
    if #doc.lines[i] ~= " \n" then
      amount_characters = amount_characters + #doc.lines[i]
    end
  end
  
  return amount_characters - amount_newlines, amount_newlines
end


local function compute_text_selection_length(doc)
  local amount_characters = 0
  local amount_newlines = 0

  for idx, line1, col1, line2, col2 in doc:get_selections(true) do
    amount_newlines = amount_newlines + (line2 - line1)

    local text = doc:get_text(line1, col1, line2, col2)

    for line in (text):gmatch("(.-)\n") do
      if #line == 0 then
        amount_characters = amount_characters - 1
      else
        -- TODO: Chech for complete selection
        if idx > 0 then
          amount_characters = amount_characters - 1
        end
      end
   end

    if line1 ~= line2 or col1 ~= col2 then
      if text ~= "" then
        amount_characters = amount_characters + #text
      end
    end
  end

  return amount_characters, amount_newlines
end


local old_raw_insert = Doc.raw_insert
function Doc:raw_insert(line, col, text, undo_stack, time)
  old_raw_insert(self, line, col, text, undo_stack, time)

  local active_doc = core.active_view.doc
  if cached_document_characters[self] then
    local old_count = cached_document_characters[self]
    cached_document_characters[self] = old_count + #text
  end
end


local old_raw_remove = Doc.raw_remove
function Doc:raw_remove(line1, col1, line2, col2, undo_stack, time)
  old_raw_remove(self, line1, col1, line2, col2, undo_stack, time)

  local active_doc = core.active_view.doc
  if cached_document_characters[self] and active_doc then
    if active_doc.has_selection then
      local selection_text_length, new_lines = compute_text_selection_length(active_doc)
      
      if selection_text_length > 0 or new_lines > 0 then
        local old_count = cached_document_characters[active_doc]
        cached_document_characters[self] = old_count - selection_text_length
      end
    else
      cached_document_characters[self] = compute_document_characters(active_doc)
    end
  end
end


local old_doc_new = Doc.new
function Doc:new(...)
  old_doc_new(self, ...)
  cached_document_characters[self] = compute_document_characters(self)
end


core.status_view:add_item({
  predicate = function() return core.active_view:is(DocView) and not core.active_view:is(CommandView) and cached_document_characters[core.active_view.doc] end,
  name = "status:character-count",
  alignment = StatusView.Item.RIGHT,
  get_item = function()
    local active_doc = core.active_view.doc
    if active_doc then
      if active_doc.has_selection then
        local selection_text_length, new_lines = compute_text_selection_length(active_doc)

        if selection_text_length > 0 or new_lines > 0 then
          return { style.text, selection_text_length .. " characters ( + new lines: " .. new_lines  .. " )" }
        end
      end

      -- return { style.text, compute_document_characters(active_doc) .. " characters" }
      local count_characters, new_lines = compute_document_characters(active_doc)
      return { style.text, count_characters .. " characters ( + new lines: " .. new_lines .. " )" }
    end
  end
})
