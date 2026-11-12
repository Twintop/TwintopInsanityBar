---@diagnostic disable: inject-field
-- LibSimpleHTMLMarkdown: a fork of LibMarkdown-1.0 (Oraibi-MoonGuard, https://github.com/endurantgames/WoW-LibMarkdown)
-- lua implementation of markdown originally from https://github.com/mpeterv/markdown

local  MARKDOWN10 = "LibSimpleHTMLMarkdown-1.0"
local  MARKDOWN10_MINOR = 3
if not LibStub then error(MARKDOWN10 .. " requires LibStub.") end
local  LibMarkdown = LibStub:NewLibrary(MARKDOWN10, MARKDOWN10_MINOR)
if not LibMarkdown then return end

LibMarkdown.name = MARKDOWN10
LibMarkdown.minor = MARKDOWN10_MINOR

-- an older copy's config, kept so the settings AddOns changed in it survive this upgrade
local previous_config, previous_defaults = LibMarkdown.config, LibMarkdown.config_defaults

LibMarkdown.config = {
  [ 'rt1'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_1.PNG:0|t',
  [ 'rt2'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_2.PNG:0|t',
  [ 'rt3'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_3.PNG:0|t',
  [ 'rt4'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_4.PNG:0|t',
  [ 'rt5'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_5.PNG:0|t',
  [ 'rt6'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_6.PNG:0|t',
  [ 'rt7'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_7.PNG:0|t',
  [ 'rt8'             ] = '|TInterface\\TARGETINGFRAME\\UI-RAIDTARGETINGICON_8.PNG:0:|t',
  [ 'emsp'            ] = '|TInterface\\Store\\ServicesAtlas:0:0.75:0:0:1024:1024:1023:1024:1023:1024|t ',
  [ 'ensp'            ] = '|TInterface\\Store\\ServicesAtlas:0:0.25:0:0:1024:1024:1023:1024:1023:1024|t ',
  [ 'em13'            ] = '|TInterface\\Store\\ServicesAtlas:0:0.08:0:0:1024:1024:1023:1024:1023:1024|t ',
  [ 'em14'            ] = " ",
  [ 'nbsp'            ] = '|TInterface\\Store\\ServicesAtlas:0:0.175:0:0:1024:1024:1023:1024:1023:1024|t',
  [ 'thinsp'          ] = '|TInterface\\Store\\ServicesAtlas:0:0.100:0:0:1024:1024:1023:1024:1023:1024|t',
  [ 'strong'          ] = '|cff00dddd',
  ['/strong'          ] = '|r',
  [ 'em'              ] = '|cff00dd00',
  ['/em'              ] = '|r',
  [ 'del'             ] = '|cff808080', -- ~~strikethrough~~; SimpleHTML can't strike text, so it's dimmed
  ['/del'             ] = '|r',
  [ 'ul'              ] = '<p>',
  ['/ul'              ] = '</p><br />',  -- it's almost always the right right choice to put <br /> after a block level tag
  [ 'ol'              ] = '<p>',
  ['/ol'              ] = '</p><br />',
  [ 'li'              ] = '',
  ['/li'              ] = '<br />',
  -- ['list_marker'      ] = '|TInterface\\MINIMAP\\TempleofKotmogu_ball_purple.PNG:0|t',
  ['list_marker'      ] = '*',
  -- list_marker_2, list_marker_3, ... set the marker for each nesting depth; unset ones use list_marker
  ['list_indent'      ] = '|TInterface\\Store\\ServicesAtlas:0:1.5:0:0:1024:1024:1023:1024:1023:1024|t', -- per depth
  ['task_open'        ] = '|TInterface\\Buttons\\UI-CheckBox-Up:0|t',     -- - [ ] item
  ['task_done'        ] = '|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t', -- - [x] item
  [ 'table'           ] = '<p>', -- an align attribute is added when every column has the same alignment
  ['/table'           ] = '</p><br />',
  [ 'tr'              ] = '',
  ['/tr'              ] = '<br />',
  [ 'th'              ] = '|cff00dddd',
  ['/th'              ] = '|r',
  [ 'td'              ] = '',
  ['/td'              ] = '',
  ['table_sep'        ] = '  |cff808080|||r  ',
  [ 'footnote_ref'    ] = '|cff00dddd[', -- around a footnote's number, in the text and in the notes
  ['/footnote_ref'    ] = ']|r',
  [ 'footnotes'       ] = '<hr />',      -- before the notes, at the end of the document
  [ 'footnote'        ] = '<p>',
  ['/footnote'        ] = '</p>',
  [ 'pre'             ] = '<p>|cff66bbbb',
  ['/pre'             ] = '|r</p><br />',
  [ 'code'            ] = '|cff66bbbb',
  ['/code'            ] = '|r',
  ['br'               ] = '<br />',
  [ 'blockquote'      ] = '<hr width="100"/><p align="center">|cffbbbb00"',
  ['/blockquote'      ] = '"|r</p><br /><hr width="100"/><br />',
  [ 'blockquote_quot' ] = '',
  [ 'blockquote_nested'] = '<br />|cffd8d8a0', -- a quote inside a quote
  ['/blockquote_nested'] = '|r<br />',
  [ 'h1'              ] = '<h1>',
  ['/h1'              ] = '</h1><br />',
  [ 'h2'              ] = '<h2>',
  ['/h2'              ] = '</h2><br />',
  [ 'h3'              ] = '<h3>',
  ['/h3'              ] = '</h3><br />',
  [ 'p'               ] = '<p>',
  ['/p'               ] = '</p>',
  [ 'html'            ] = '<html>',
  ['/html'            ] = '</html>',
  [ 'body'            ] = '<body>',
  ['/body'            ] = '</body>',
  [ 'figcaption'      ] = 'Caption: |cffbbbb00',
  ['/figcaption'      ] = '|r',
} -- beep

-- A newer copy replaces the config table, which would drop every change AddOns made to the
-- older one. Keep a copy of the defaults, and carry over each key whose value an AddOn changed.
-- Minor 2 and earlier kept no copy; their defaults are the same as this version's for every
-- key they had, so a value that differs from this version's default was changed by an AddOn.
LibMarkdown.config_defaults = {}
for k, v in pairs(LibMarkdown.config) do LibMarkdown.config_defaults[k] = v end
if previous_config then
   for k, v in pairs(previous_config) do
      local default
      if previous_defaults then default = previous_defaults[k] else default = LibMarkdown.config[k] end
      if v ~= default then LibMarkdown.config[k] = v end
   end
end

LibMarkdown.entities_list = { "emsp", "ensp", "em13", "nbsp", "em14", "thinsp", }

LibMarkdown.rt_list = { 
  rt1 = { "Star",           },
  rt2 = { "Circle", "Coin", },
  rt3 = { "Diamond",        },
  rt4 = { "Triangle",       },
  rt5 = { "Moon",           },
  rt6 = { "Square",         },
  rt7 = { "Cross", "X",     },
  rt8 = { "Skull",          }, 
}

-- returns the result of mapping the values in table t through the function f
function LibMarkdown.map(t, f, self)
   local out = {}
   for k,v in pairs(t)
   do if   self
      then out[k] = f(self, v, k)
      else out[k] = f(v, k)
      end
   end
   return out
end

-- functional style if statement. (note: no short circuit evaluation)
function LibMarkdown.iff(t, a, b) if t then return a else return b end end

-- splits the text into an array of separate lines.
function LibMarkdown.split(text, sep)
   sep = sep or "\n"
   local lines = {}
   local pos = 1
   while true do
      local b,e = text:find(sep, pos)
      if not b then table.insert(lines, text:sub(pos)) break end
      table.insert(lines, text:sub(pos, b-1))
      pos = e + 1
   end
   return lines end

-- converts tabs to spaces
function LibMarkdown.detab(text)
   if text ~= nil then
      local tab_width = 4
      local function rep(match)
         local spaces = -match:len()
         while spaces<1 do spaces = spaces + tab_width end
         return match .. string.rep(" ", spaces)
      end
      text = text:gsub("([^\n]-)\t", rep)
   end
   return text or ""
end

-- applies string.find for every pattern in the list and returns the first match
function LibMarkdown.find_first(s, patterns, index)
   local res = {}
   for _,p in ipairs(patterns) do
      local match = {s:find(p, index)}
      if #match>0 and (#res==0 or match[1] < res[1]) then res = match end
   end
   return unpack(res)
end

-- if a replacement array is specified, the range [start, stop] in the array is replaced
-- with the replacement array and the resulting array is returned. without a replacement
-- array the section of the array between start and stop is returned.
function LibMarkdown.splice(array, start, stop, replacement)
   if replacement then
      local n = stop - start + 1
      while n > 0 do
         table.remove(array, start)
         n = n - 1
      end
      for _,v in ipairs(replacement) do
         table.insert(array, start, v)
      end
      return array
   else
      local res = {}
      for i = start,stop do
         table.insert(res, array[i])
      end
      return res
   end
end

function LibMarkdown.strip_paragraph_tags(s)
  return s:gsub("</?p.->",""):gsub("<br />%s*$", ""):gsub("^%s*<br />","")
end

-- outdents the text one step.
function LibMarkdown.outdent(text)
   -- text = "\n" .. text
   -- text = text:gsub("\n  ? ? ?", "\n")
   -- text = text:sub(2)
   return text
end

-- indents the text one step.
function LibMarkdown.indent(text)
   -- text = text:gsub("\n", "\n    ")
   text = text:gsub("\n", "\n    ")
   return text
end

-- does a simple tokenization of html data. returns the data as a list of tokens.
-- each token is a table with a type field (which is either "tag" or "text") and
-- a text field (which contains the original token data).
function LibMarkdown.tokenize_html(html)
   local tokens = {}
   local pos = 1
   while true do
      local start = LibMarkdown.find_first(html, {"<!%-%-", "<[a-z/!$]", "<%?"}, pos)
      if not start then
         table.insert(tokens, {type="text", text=html:sub(pos)})
         break
      end
      if start ~= pos then table.insert(tokens, {type="text", text = html:sub(pos, start-1)}) end

      local _, stop
      if html:match("^<!%-%-", start) then
         _,stop = html:find("%-%->", start)
      elseif html:match("^<%?", start) then
         _,stop = html:find("?>", start)
      else
         _,stop = html:find("%b<>", start)
      end
      if not stop then
         -- error("could not match html tag " .. html:sub(start,start+30))
         table.insert(tokens, {type="text", text=html:sub(start, start)})
         pos = start + 1
      else
         table.insert(tokens, {type="tag", text=html:sub(start, stop)})
         pos = stop + 1
      end
   end
   return tokens
end

----------------------------------------------------------------------
-- hash
----------------------------------------------------------------------

-- this is used to "hash" data into alphanumeric strings that are unique
-- in the document. (note that this is not cryptographic hash, the hash
-- function is not one-way.) the hash procedure is used to protect parts
-- of the document from further processing.

LibMarkdown.hash = {
   -- has the hash been inited.
   inited = false,

   -- the unique string prepended to all hash values. this is to ensure
   -- that hash values do not accidently coincide with an actual existing
   -- string in the document.
   identifier = "",

   -- counter that counts up for each new hash instance.
   counter = 0,

   -- hash table.
   table = {}
}

-- inits hashing. creates a hash_identifier that doesn't occur anywhere
-- in the text.
function LibMarkdown.init_hash(self, text)
   self.hash.inited = true
   self.hash.identifier = ""
   self.hash.counter = 0
   self.hash.table = {}

   local s = "hash"
   local counter = 0
   local id
   while true do
      id  = s .. counter
      if not text:find(id, 1, true) then break end
      counter = counter + 1
   end
   self.hash.identifier = id
end

-- returns the hashed value for s.
function LibMarkdown.hash_func(self, s)
   assert(self.hash.inited)
   if not self.hash.table[s] then
      self.hash.counter = self.hash.counter + 1
      local id = self.hash.identifier .. self.hash.counter .. "x"
      self.hash.table[s] = id
   end
   return self.hash.table[s]
end

----------------------------------------------------------------------
-- protection
----------------------------------------------------------------------

-- the protection module is used to "protect" parts of a document
-- so that they are not modified by subsequent processing steps.
-- protected parts are saved in a table for later unprotection

-- protection data
LibMarkdown.pd = {
   -- saved blocks that have been converted
   blocks = {},

   -- block level tags that will be protected
   tags = {"p", "div", "h1", "h2", "h3", "h4", "h5", "h6", "blockquote",
   "pre", "table", "dl", "ol", "ul", "script", "noscript", "form", "fieldset",
   "iframe", "math", "ins", "del"}
}

-- pattern for matching a block tag that begins and ends in the leftmost
-- column and may contain indented subtags, i.e.
-- <div>
--    a nested block.
--    <div>
--        nested data.
--     </div>
-- </div>
function LibMarkdown.block_pattern(tag)
   return "\n<" .. tag .. ".-\n</" .. tag .. ">[ \t]*\n"
end

-- pattern for matching a block tag that begins and ends with a newline
function LibMarkdown.line_pattern(tag)
   return "\n<" .. tag .. ".-</" .. tag .. ">[ \t]*\n"
end

-- protects the range of characters from start to stop in the text and
-- returns the protected string.
function LibMarkdown.protect_range(self, text, start, stop)
   local s = text:sub(start, stop)
   local h = self:hash_func(s)
   self.pd.blocks[h] = s
   text = text:sub(1,start) .. h .. text:sub(stop)
   return text
end

-- protect every part of the text that matches any of the patterns. the first
-- matching pattern is protected first, etc.
function LibMarkdown.protect_matches(self, text, patterns)
   while true do
      local start, stop = LibMarkdown.find_first(text, patterns)
      if not start then break end
      text = self:protect_range(text, start, stop)
   end
   return text
end

-- protects blocklevel tags in a run of text that has no code fences
function LibMarkdown.protect_html(self, text)
   -- first protect potentially nested block tags
   text = self:protect_matches(text, LibMarkdown.map(self.pd.tags, self.block_pattern))
   -- then protect block tags at the line level.
   text = self:protect_matches(text, LibMarkdown.map(self.pd.tags, self.line_pattern))
   -- protect <hr> and comment tags
   text = self:protect_matches(text, {"\n<hr[^>]->[ \t]*\n"})
   text = self:protect_matches(text, {"\n<!%-%-.-%-%->[ \t]*\n"})
   return text
end

-- protects blocklevel tags in the specified text. html inside ``` fences is code, so each
-- run of lines between fences is protected on its own and the fenced lines are left alone.
function LibMarkdown.protect(self, text)
   local out, run, fence = {}, {}, nil
   local function flush()
      if #run > 0 then
         -- the block patterns need a newline before and after each block
         local s = self:protect_html("\n" .. table.concat(run, "\n") .. "\n")
         table.insert(out, s:sub(2, -2))
         run = {}
      end
   end
   for _, line in ipairs(LibMarkdown.split(text)) do
      local opens = not fence and LibMarkdown.fence_open(line)
      if fence or opens then
         flush()
         table.insert(out, line)
         if opens then fence = opens
         elseif LibMarkdown.fence_closes(line, fence) then fence = nil end
      else
         table.insert(run, line)
      end
   end
   flush()
   return table.concat(out, "\n")
end

-- returns true if the string s is a hash resulting from protection
function LibMarkdown.is_protected(self, s)
   return self.pd.blocks[s]
end

-- unprotects the specified text by expanding all the nonces
function LibMarkdown.unprotect(self, text)
   for k,v in pairs(self.pd.blocks) do
      v = v:gsub("%%", "%%%%")
      text = text:gsub(k, v)
   end
   return text
end


----------------------------------------------------------------------
-- block transform
----------------------------------------------------------------------

-- the block transform functions transform the text on the block level.
-- they work with the text as an array of lines rather than as individual
-- characters.

-- returns true if the line is a ruler of (char) characters.
-- the line must contain at least three char characters and contain only spaces and
-- char characters.
function LibMarkdown.is_ruler_of(line, char)
   if not line:match("^[ %" .. char .. "]*$") then return false end
   if not line:match("%" .. char .. ".*%" .. char .. ".*%" .. char) then return false end
   return true
end

-- returns the fence (its run of ``` or ~~~) if line opens a fenced code block. A backtick
-- fence's info string can't contain a backtick, so ```code``` on one line isn't a fence.
function LibMarkdown.fence_open(line)
   return line:match("^ ? ? ?(```+)[^`]*$") or line:match("^ ? ? ?(~~~+)")
end

-- true if line closes the block that fence opened: the same character, at least as many times
function LibMarkdown.fence_closes(line, fence)
   local run = line:match("^ ? ? ?(" .. fence:sub(1, 1) .. "+)[ \t]*$")
   return run ~= nil and #run >= #fence
end

-- identifies the block level formatting present in the line. Fenced code is tracked in
-- self.fence, the open fence, between calls.
function LibMarkdown.classify(self, line)
   local info = {line = line, text = line}

   if self.fence then
      if LibMarkdown.fence_closes(line, self.fence) then
         info.type = "backticks"
         info.outdented = ""
         self.fence = nil
      else
         info.type = "indented"
         info.outdented = line
      end
      return info
   end

   local fence = LibMarkdown.fence_open(line)
   if fence then
      info.type = "backticks"
      info.outdented = ""
      self.fence = fence
      return info
   end

   if line:match("^%^$") then
      info.type = "eob"
      info.text = ""
      return info
   end

   if line:match("^    ") then
      info.type = "indented"
      info.outdented = line:gsub("^    ","")
      return info
   end

   for _,c in ipairs({'*', '-', '_', '='}) do
      if LibMarkdown.is_ruler_of(line, c) then
         info.type = "ruler"
         info.ruler_char = c
         return info
      end
   end

   if line == "" then
      info.type = "blank"
      return info
   end

   -- an ATX heading needs a space after its #s, so #hashtag stays text. A closing run of #s
   -- needs one before it, so "# C#" keeps its #.
   local hashes, rest = line:match("^(#+)(.*)$")
   if hashes and (rest == "" or rest:match("^[ \t]")) then
      local text = rest:gsub("^[ \t]+", ""):gsub("[ \t]+#+[ \t]*$", ""):gsub("[ \t]+$", "")
      if text:match("^#+$") then text = "" end
      info.type = "header"
      info.level = math.min(hashes:len(), 3)
      info.text = text
      return info
   end

   -- ordered items keep the delimiter typed after their number, "." or ")". "i]" marks a
   -- Roman numeral (to tell it from the letter i), and is shown as "i."
   if                      line:match("^ ? ? ?(%d+)[%.%)][ \t]+(.+)") then
      local number, delim, text = line:match("^ ? ? ?(%d+)([%.%)])[ \t]+(.+)")
      info.type = "list_item"
      info.list_type = "numeric"
      info.number = number
      info.delim = delim
      info.text = text
      return info
   end

   if                      line:match("^ ? ? ?([ivxIVX]+)[%.%]][ \t]+(.*)") then
      local number, text = line:match("^ ? ? ?([ixvIVX]+)[%.%]][ \t]*(.*)")
      info.type = "list_item"
      info.list_type = "roman_numeric"
      info.number = number
      info.delim = "."
      info.text = text
      return info
   end

   if                      line:match("^ ? ? ?(%a)[%.%)][ \t]+(.*)") then
      local number, delim, text = line:match("^ ? ? ?(%a)([%.%)])[ \t]*(.*)")
      info.type = "list_item"
      info.list_type = "alphanumeric"
      info.number = number
      info.delim = delim
      info.text = text
      return info
   end

   if line:match("^ ? ? ?([%*%+%-])[ \t]+(.+)") then
      local bullet, text = line:match("^ ? ? ?([%*%+%-])[ \t]+(.+)")
      info.type = "list_item"
      info.list_type = "bullet"
      info.bullet = bullet
      info.text= text
      return info
   end

   -- > and one space are the marker; more spaces belong to the quote (">     code" is code)
   if line:match("^ ? ? ?>") then
      info.type = "blockquote"
      info.text = line:match("^ ? ? ?> ?(.*)")
      return info
   end

   if self:is_protected(line) then
      info.type = "raw"
      info.html = self:unprotect(line)
      return info
   end

   info.type = "normal"
   return info
end

-- classifies each line in order. classify tracks code fences in self.fence, and self is
-- the library object every AddOn shares, so each pass starts with no fence open and clears
-- it after: an unclosed ``` can't turn the next document into a code block.
function LibMarkdown.classify_lines(self, lines)
   local out = {}
   self.fence = nil
   for i, line in ipairs(lines) do
      local info = self:classify(line)
      if info.type == "list_item" then
         -- the marker's indent, and the column its text starts at, place nested items
         info.indent = #line:match("^ *")
         info.content_indent = #(line:match("^ *%S+[ \t]+") or line)
      end
      out[i] = info
   end
   self.fence = nil
   return out
end

-- find headers consisting of a paragraph followed by a ruler of - or = and converts them to
-- header entries. every line of the paragraph is part of the heading.
function LibMarkdown.headers(self, array)
   local i = 1
   while i <= #array - 1 do
      if array[i].type  == "normal" and array[i+1].type == "ruler" and
         (array[i+1].ruler_char == "-" or array[i+1].ruler_char == "=") then
         local first = i
         while first > 1 and array[first-1].type == "normal" do first = first - 1 end
         local text = {}
         for k = first, i do table.insert(text, array[k].line) end
         local info = { type = "header", line = table.concat(text, "\n") }
         info.text = info.line
         info.level = LibMarkdown.iff(array[i+1].ruler_char == "=", 1, 2)
         array = LibMarkdown.splice(array, first, i+1, {info})
         i = first
      end
      i = i + 1
   end
   return array
end

-- forward declarations
-- local self.block_transform, self.span_transform, self.encode_code

-- convert lines to html code
function LibMarkdown.blocks_to_html(self, lines, no_paragraphs)
   local out = {}
   local i = 1
   while i <= #lines do
      local line = lines[i]
      if line.type == "ruler" then
         table.insert(out, "<hr />")
      elseif line.type == "raw" then
         table.insert(out, line.html)
      elseif line.type == "normal" then
         local s = line.line

         while i+1 <= #lines and lines[i+1].type == "normal" do
            i = i + 1
            s = s .. "\n" .. lines[i].line
         end

         if no_paragraphs then
            table.insert(out, self:span_transform(s))
         else
            table.insert(out, self.config["p"] .. self:span_transform(s) .. self.config["/p"])
         end
      elseif line.type == "header" then
         local s = self.config["h" .. line.level] .. self:span_transform(line.text) .. self.config["/h" .. line.level]
         table.insert(out, s)
      elseif line.type == "eob" then
         -- the ^ that ends a list isn't shown
      else
         table.insert(out, line.line)
      end
      i = i + 1
   end
   return out
end

-- find list blocks and convert them to protected data blocks
-- returns the value of a Roman numeral of i, v, and x, or nil
function LibMarkdown.roman_value(s)
   local values = { i = 1, v = 5, x = 10 }
   local total, prev = 0, 0
   for k = #s, 1, -1 do
      local v = values[s:sub(k, k)]
      if not v then return nil end
      if v < prev then total = total - v else total = total + v; prev = v end
   end
   return total
end

-- true if the items are a letter or Roman numeral list, and not text such as "A. Lincoln was
-- president." or "I. M. Pei": there are at least two items, and each one's letter or numeral
-- follows the one before (a, b, c or i, ii, iii, in either case). Other lists are always lists.
function LibMarkdown.plausible_list(items)
   local list_type = items[1][1].list_type
   if list_type ~= "alphanumeric" and list_type ~= "roman_numeric" then return true end
   if #items < 2 then return false end
   for k = 2, #items do
      local a, b = items[k-1][1].number, items[k][1].number
      if not (a and b) then return false end
      a, b = a:lower(), b:lower()
      local ra, rb = LibMarkdown.roman_value(a), LibMarkdown.roman_value(b)
      local letters = #a == 1 and #b == 1 and b:byte() == a:byte() + 1
      if not (letters or (ra and rb and rb == ra + 1)) then return false end
   end
   return true
end

-- splits a list's lines into one array per item. an item indented at least two spaces past the
-- current item's marker is nested in it.
function LibMarkdown.split_list_items(arr)
   local acc = {arr[1]}
   local res = {}
   local parent = arr[1]
   for i=2,#arr do
      if arr[i].type == "list_item" and arr[i].indent < parent.indent + 2 then
         table.insert(res, acc)
         acc = {arr[i]}
         parent = arr[i]
      else
         table.insert(acc, arr[i])
      end
   end
   table.insert(res, acc)
   return res
end

function LibMarkdown.lists(self, array, sublist)
   local function process_list(arr)
      local function any_blanks(arr)
         for i = 1, #arr do
            if arr[i].type == "blank" then return true end
         end
         return false
      end

      local depth = self.list_depth or 0

      local function process_list_item(lines, block)
         while lines[#lines].type == "blank" do
            table.remove(lines)
         end
         local first = lines[1]
         local number = first.number

         -- continuation lines lose the indent up to the item's text, so a nested list or an
         -- indented code block is read relative to the item
         local itemtext = first.text
         for i=2,#lines do
            local line = lines[i].line
            local strip = math.min(#line:match("^ *"), first.content_indent)
            itemtext = itemtext .. "\n" .. line:sub(strip + 1)
         end

         -- - [ ] and - [x] are task list items
         local task
         local box, rest = itemtext:match("^%[([ xX])%][ \t]+(.*)$")
         if box then
            task = self.config[box == " " and "task_open" or "task_done"]
            itemtext = rest
         end

         local function format_item(text)
            local marker = number and (number .. (first.delim or ".")) or
                           self.config["list_marker_" .. (depth + 1)] or self.config["list_marker"]
            if task then marker = number and (marker .. self.config["ensp"] .. task) or task end
            return '    ' ..
                   string.rep(self.config["list_indent"], depth) ..
                   self.config[number and "emsp" or "ensp"] ..
                   self.config.li ..
                   marker ..
                   self.config["ensp"]  ..
                   text ..
                   self.config["/li"]
         end

         self.list_depth = depth + 1
         if block then
            itemtext = self:block_transform(itemtext, true)
         else
            local sub = LibMarkdown.split(itemtext)
            sub = self:classify_lines(sub)
            sub = self:lists(sub, true)
            sub = self:blocks_to_html(sub, true)
            itemtext = table.concat(sub, "\n")
         end
         self.list_depth = depth
         return format_item(itemtext)
      end

      local block_list = any_blanks(arr)
      local items = LibMarkdown.split_list_items(arr)
      local out = ""

      for _, item in ipairs(items) do
         out = out .. process_list_item(item, block_list) .. "\n"
      end
      -- a nested list starts on the line after its parent item's text
      if depth > 0 then out = self.config.br .. "\n" .. out end

      if arr[1].list_type == "numeric" or arr[1].list_type == "alphanumeric" or
         arr[1].list_type == "roman_numeric" 
          then
         -- return "<ol>\n" .. out .. "</ol>"
         return self.config.ol .. "\n" .. out .. "\n" .. self.config["/ol"]
      else
         -- return "<ul>\n" .. out .. "</ul>"
         return self.config.ul .. "\n" .. out .. "\n" .. self.config["/ul"] .. "\n"
      end

   end

   -- finds the range of lines composing the first list in the array. a list
   -- starts with (^ list_item) or (blank list_item) and ends with
   -- (blank* $) or (blank normal).
   --
   -- a sublist can start with just (list_item) does not need a blank...
  --
   local function find_list(array, sublist)
      local function find_list_start(array, sublist)
         if array[1].type == "list_item" then return 1 end
         if sublist then
            for i = 1,#array do
               if array[i].type == "list_item" then return i end
            end
         else
            -- a list starts after a blank line, a ^, a heading, a rule, or an html block. As in
            -- CommonMark, it can also start right after a paragraph line if it's a bullet list or
            -- starts at 1, so a line like "2. is the answer" stays part of its paragraph.
            local after = { blank = true, eob = true, header = true, ruler = true, raw = true }
            for i = 1, #array-1 do
               local cur, nxt = array[i], array[i+1]
               if nxt.type == "list_item" and (after[cur.type] or (cur.type == "normal" and
                  (nxt.list_type == "bullet" or (nxt.list_type == "numeric" and nxt.number == "1")))) then
                  return i+1
               end
            end
         end
         return nil
      end
      -- the list goes on through its items and the lines indented under them. After a blank line,
      -- it goes on with another item, or a line indented as far as the last item's text (a
      -- paragraph, code, or rule that belongs to that item). An unindented rule or heading ends it.
      local function find_list_end(array, start)
         local pos = #array
         local content_indent = array[start].content_indent or 2
         for i = start, #array-1 do
            local cur, nxt = array[i], array[i+1]
            if cur.type == "list_item" and cur.indent < array[start].indent + 2 then
               content_indent = cur.content_indent
            end
            local nxt_indent = #nxt.line:match("^ *")
            if cur.type == "eob"
               then return i-1
            elseif (nxt.type == "ruler" or nxt.type == "header") and nxt_indent < content_indent then
               pos = i
               break
            elseif
               cur.type == "blank" and nxt.type ~= "list_item"
               and nxt.type ~= "indented" and nxt.type ~= "blank"
               and nxt_indent < content_indent then
               pos = i-1
               break
            end
         end
         while pos > start and array[pos].type == "blank" do
            pos = pos - 1
         end
         return pos
      end

      local start = find_list_start(array, sublist)
      if not start then return nil end
      return start, find_list_end(array, start)
   end

   while true do
      local start, stop = find_list(array, sublist)
      if not start then break end
      local lines = LibMarkdown.splice(array, start, stop)
      if LibMarkdown.plausible_list(LibMarkdown.split_list_items(lines)) then
         local text = process_list(lines)
         local info = {
            line = text,
            type = "raw",
            html = text
         }
         array = LibMarkdown.splice(array, start, stop, {info})
      else
         -- not a list after all: its first line is text, and the search goes on after it
         array[start].type = "normal"
      end
   end

   -- convert any remaining list items to normal
   for _,line in ipairs(array) do
      if line.type == "list_item" then line.type = "normal" end
   end

   return array
end

-- find and convert blockquote markers.
function LibMarkdown.blockquotes(self, lines)
   local function find_blockquote(lines)
      local start
      for i,line in ipairs(lines) do
         if line.type == "blockquote" then
            start = i
            break
         end
      end
      if not start then return nil end

      local stop = #lines
      for i = start+1, #lines do
         if lines[i].type == "blank" or lines[i].type == "blockquote" then
         elseif lines[i].type == "normal" then
            if lines[i-1].type == "blank" then stop = i-1 break end
         else
            stop = i-1 break
         end
      end
      while lines[stop].type == "blank" do stop = stop - 1 end
      return start, stop
   end

   local function process_blockquote(lines)
      -- the quote's lines are markdown of their own, one per line, so a "> " line can hold a
      -- list or heading and consecutive lines join with a space
      local texts = {}
      for i, line in ipairs(lines) do texts[i] = self:escape_special_chars(line.text) end
      local depth = self.quote_depth or 0
      self.quote_depth = depth + 1
      local bt = self:block_transform(table.concat(texts, "\n"))
      self.quote_depth = depth

      -- the quote is one block: a heading in it is a line in the strong color, and its
      -- paragraphs are kept apart by an empty line
      bt = bt:gsub("<h%d[^>]*>(.-)</h%d>", function(heading)
         return self.config.strong .. heading .. self.config["/strong"]
      end)
      bt = bt:gsub("</p>%s*<p[^>]*>", "<br />" .. self.config.nbsp .. "<br />")
      bt = LibMarkdown.strip_paragraph_tags(bt)

      -- a quote inside a quote is part of the outer one, in its own lines and color
      if depth > 0 then
         return self.config.blockquote_nested .. bt .. self.config["/blockquote_nested"]
      end
      return self.config.blockquote .. bt .. self.config["/blockquote"]
   end

   while true do
      local start, stop = find_blockquote(lines)
      if not start then break end
      local text = process_blockquote(LibMarkdown.splice(lines, start, stop))
      local info = {
         line = text,
         type = "raw",
         html = text
      }
      lines = LibMarkdown.splice(lines, start, stop, {info})
   end
   return lines
end

-- find and convert codeblocks.
function LibMarkdown.codeblocks(self, lines)
   local function find_codeblock(lines)
      local start
      for i,line in ipairs(lines) do
         if line.type == "backticks" then start = i break
         elseif line.type == "indented" then start = i
         break end
      end
      if not start then return nil end

      -- a fenced block runs to its closing fence, or to the end if it's never closed
      if lines[start].type == "backticks" then
         for i = start+1, #lines do
            if lines[i].type == "backticks" then return start, i end
         end
         return start, #lines
      end

      -- an indented block runs to the last indented line before a line that isn't blank
      local stop = start
      for i = start+1, #lines do
         if lines[i].type == "indented" then stop = i
         elseif lines[i].type ~= "blank" then break end
      end
      return start, stop
   end

   local function process_codeblock(lines)
      local raw = LibMarkdown.detab(self:encode_code(LibMarkdown.outdent(lines[1].outdented))) 
      for i = 2,#lines do
         raw = raw .. "\n<br />" .. LibMarkdown.detab(self:encode_code(LibMarkdown.outdent(lines[i].outdented)))
      end
      --- return "<pre><code>" .. raw .. "\n</code></pre>"
      return raw
   end

   while true do
      local start, stop = find_codeblock(lines)
      if not start then break end
      local text = process_codeblock(LibMarkdown.splice(lines, start, stop))
      -- the fence lines themselves are empty; their line breaks are stripped
      text = LibMarkdown.strip_paragraph_tags(text):gsub("  ", self.config.emsp)
      text = self.config.pre .. text .. self.config["/pre"]
      local info = {
         line = text,
         type = "raw",
         html = text
      }
      lines = LibMarkdown.splice(lines, start, stop, {info})
   end
   return lines
end

-- splits a table row into its trimmed cells. Outer pipes are optional; \| is a pipe in a cell,
-- and so is a | inside a `code span`.
function LibMarkdown.split_table_row(line)
   local s = line:gsub("\\|", "\1")
   -- code spans show a | as itself (encode_code doubles it), other text needs || for one
   s = s:gsub("(`+)(.-)%1", function(ticks, code) return ticks .. code:gsub("[|\1]", "\2") .. ticks end)
   s = s:match("^%s*(.-)%s*$")
   if s:sub(1, 1) == "|" then s = s:sub(2) end
   if s:sub(-1) == "|" then s = s:sub(1, -2) end
   local cells = {}
   for cell in (s .. "|"):gmatch("([^|]*)|") do
      cells[#cells + 1] = (cell:match("^%s*(.-)%s*$"):gsub("\1", "||"):gsub("\2", "|"))
   end
   return cells
end

-- returns each column's alignment ("left", "center", "right", or false) if line is a table's
-- delimiter row, such as |---|:---:|
function LibMarkdown.table_alignments(line)
   if not line:find("|", 1, true) or not line:find("-", 1, true) then return nil end
   local aligns = {}
   for i, cell in ipairs(LibMarkdown.split_table_row(line)) do
      if not cell:match("^:?%-+:?$") then return nil end
      local left, right = cell:sub(1, 1) == ":", cell:sub(-1) == ":"
      aligns[i] = (left and right and "center") or (right and "right") or (left and "left") or false
   end
   return aligns
end

-- find GFM tables (a header row, a delimiter row, then rows up to a blank line) and convert
-- them to raw html. SimpleHTML can't lay out columns, so each row is a line of cells between
-- separators, and the header row is colored.
function LibMarkdown.tables(self, lines)
   local i = 1
   while i < #lines do
      local aligns = lines[i].type == "normal" and lines[i].line:find("|", 1, true) and
                     lines[i+1].type ~= "indented" and LibMarkdown.table_alignments(lines[i+1].line)
      local head = aligns and LibMarkdown.split_table_row(lines[i].line)
      if head and #head == #aligns then
         local stop = i + 1
         while lines[stop+1] and lines[stop+1].type == "normal" do stop = stop + 1 end

         local function row(cells, open, close)
            local out = {}
            for c = 1, #head do
               out[c] = self.config[open] .. self:span_transform(cells[c] or "") .. self.config[close]
            end
            return self.config.tr .. table.concat(out, self.config.table_sep) .. self.config["/tr"]
         end

         local rows = { row(head, "th", "/th") }
         for r = i + 2, stop do
            table.insert(rows, row(LibMarkdown.split_table_row(lines[r].line), "td", "/td"))
         end

         local align = aligns[1]
         for c = 2, #aligns do if aligns[c] ~= align then align = false end end
         local open = self.config.table
         if align then open = open:gsub("^<p>", '<p align="' .. align .. '">') end

         local text = open .. "\n" .. table.concat(rows, "\n") .. "\n" .. self.config["/table"]
         lines = LibMarkdown.splice(lines, i, stop, { { line = text, type = "raw", html = text } })
      end
      i = i + 1
   end
   return lines
end

-- perform all the block level transforms
function LibMarkdown.block_transform(self, text, sublist)
   local lines = LibMarkdown.split(text)
   lines = self:classify_lines(lines)
   lines = self:tables(lines)
   lines = self:headers(lines)
   lines = self:lists(lines, sublist)
   lines = self:codeblocks(lines)
   lines = self:blockquotes(lines)
   lines = self:blocks_to_html(lines)

   local text = table.concat(lines, "\n")

   return text
end

function LibMarkdown.last_minute_lmd_fixes(text) --
   text = text:gsub("([^<>\n]+)(<img[^>]*>)","<p>%1</p>\n%2")
   text = text:gsub("(<img[^>]*>)([^<>]+)","%1<p>%2</p>")
   text = text:gsub("<p>(<img[^>]*>)</p>", "%1")
   text = text:gsub("<p([^>]*)>%s*<p>(.-)</p>%s*</p>", "<p%1>%2</p>")
   text = text:gsub("<p[^>]*>%s*</p>", "")
   -- a block that reopens after a rule or image would start with an empty line
   text = text:gsub("(<p[^>]*>)%s*<br />", "%1")
   local n
   repeat text, n = text:gsub("<br />%s*<br />", "<br />") until n == 0

   return text
end

LibMarkdown.flow_blocks = { p = true, h1 = true, h2 = true, h3 = true }
LibMarkdown.void_blocks = { img = true, hr = true }

-- SimpleHTML lays out a flat run of blocks: <p> and <h1>-<h3> can't hold another block,
-- and <img> and <hr> can't sit inside one. Loose lists, code in list items, and headings
-- in blockquotes nest them, so flatten the html:
--   * a <p> opened inside a block that already has text merges into it, and its close
--     becomes a line break, so a loose list item stays on its marker's line;
--   * any other nested block closes the open one, and the open one reopens after it.
-- A block close that doesn't match the open block is dropped, and blocks still open at the
-- end are closed, since SimpleHTML shows a whole document as raw text if it's malformed.
-- Inline tags (<a>, or ones SimpleHTML ignores, like <b>) get the same care: a close with no
-- open tag is dropped, and tags still open when their block ends are closed with it.
-- <br>, <img>, and <hr> are written self-closed.
function LibMarkdown.flatten_blocks(text)
   local out, stack, pos = {}, {}, 1
   local root_inlines = {} -- inline tags open outside any block

   -- the innermost block whose tags are actually in the output
   local function enclosing()
      for i = #stack, 1, -1 do
         if not stack[i].merged then return stack[i] end
      end
   end

   local function inlines()
      local block = enclosing()
      return block and block.inlines or root_inlines
   end

   local function close_inlines(list)
      for i = #list, 1, -1 do table.insert(out, "</" .. list[i] .. ">") end
      for i = #list, 1, -1 do list[i] = nil end
   end

   local function close_block(block)
      close_inlines(block.inlines)
      table.insert(out, "</" .. block.name .. ">")
   end

   local function reopen(block)
      if block then
         table.insert(out, block.open)
         block.has_text = false
      end
   end

   local void_inlines = { br = true, img = true, hr = true }

   while pos <= #text do
      local lt = text:find("<", pos, true)
      local chunk = text:sub(pos, (lt or #text + 1) - 1)
      if chunk ~= "" then
         table.insert(out, chunk)
         local block = enclosing()
         if block and chunk:find("%S") then block.has_text = true end
      end
      if not lt then break end

      local stop = LibMarkdown.tag_end(text, lt) or lt
      local tag = text:sub(lt, stop)
      local closing, name = tag:match("^<(/?)(%a%w*)")
      local key = name and name:lower()
      local block = enclosing()
      pos = stop + 1

      if key and void_inlines[key] and closing == "" and not tag:find("/>$") then
         tag = tag:sub(1, -2):gsub("%s*$", "") .. " />"
      end

      if key and LibMarkdown.flow_blocks[key] and closing == "" and not tag:find("/>$") then
         if block and key == "p" and block.has_text then
            table.insert(stack, { name = name, merged = true })
         else
            if block then close_block(block) end
            table.insert(out, tag)
            table.insert(stack, { name = name, open = tag, has_text = false, inlines = {} })
         end
      elseif key and LibMarkdown.flow_blocks[key] and closing == "/" then
         if #stack > 0 and stack[#stack].name:lower() == key then
            local top = table.remove(stack)
            if top.merged then
               table.insert(out, "<br />")
            else
               close_block(top)
               reopen(enclosing())
            end
         end
      elseif key and LibMarkdown.void_blocks[key] and closing == "" and block then
         close_block(block)
         table.insert(out, tag)
         reopen(block)
      elseif key and void_inlines[key] and closing == "/" then
         -- </br>, </img>, </hr>: the tag was already closed
      elseif key and closing == "/" then
         -- an inline close: closes the matching open tag and any opened after it, or is dropped
         local list = inlines()
         for i = #list, 1, -1 do
            if list[i]:lower() == key then
               for j = #list, i, -1 do table.insert(out, "</" .. list[j] .. ">") list[j] = nil end
               break
            end
         end
      else
         if key and not void_inlines[key] and not tag:find("/>$") and closing == "" then
            table.insert(inlines(), name)
         end
         table.insert(out, tag)
         if block and key and key ~= "br" then block.has_text = true end
      end
   end
   local block = enclosing()
   if block then close_block(block) end
   close_inlines(root_inlines)
   return table.concat(out)
end

----------------------------------------------------------------------
-- span transform
----------------------------------------------------------------------

-- functions for transforming the text at the span level.

-- these characters may need to be escaped because they have a special
-- meaning in markdown.
LibMarkdown.escape_chars = "'\\`*_{}[]()>#+-.!~'"
LibMarkdown.escape_table = {}

function LibMarkdown.init_escape_table(self)
   self.escape_table = {}
   for i = 1,#self.escape_chars do
      local c = self.escape_chars:sub(i,i)
      self.escape_table[c] = self:hash_func(c)
   end
end

-- adds a new escape to the escape table.
function LibMarkdown.add_escape(self, text)
   if not self.escape_table[text] then
      self.escape_table[text] = self:hash_func(text)
   end
   return self.escape_table[text]
end

-- encode backspace-escaped characters in the markdown source.
function LibMarkdown.encode_backslash_escapes(self, t)
   for i=1, self.escape_chars:len() do
      local c = self.escape_chars:sub(i,i)
      t = t:gsub("\\%" .. c, self.escape_table[c])
   end
   return t
end

-- escape characters that should not be disturbed by markdown.
function LibMarkdown.escape_special_chars(self, text)
   local tokens = LibMarkdown.tokenize_html(text)

   local out = ""
   for _, token in ipairs(tokens) do
      local t = token.text
      if token.type == "tag" then
         -- in tags, encode * and _ so they don't conflict with their use in markdown.
         t = t:gsub("%*", self.escape_table["*"])
         t = t:gsub("%_", self.escape_table["_"])
      else
         t = self:encode_backslash_escapes(t)
      end
      out = out .. t
   end
   return out
end

-- unescape characters that have been encoded.
function LibMarkdown.unescape_special_chars(self, t)
   local tin = t
   for k,v in pairs(self.escape_table) do
      k = k:gsub("%%", "%%%%")
      t = t:gsub(v,k)
   end
   if t ~= tin then t = self:unescape_special_chars(t) end
   return t
end

-- encode/escape certain characters inside markdown code runs.
-- the point is that in code, these characters are literals,
-- and lose their special markdown meanings.
function LibMarkdown.encode_code(self, s)
   if s ~= nil then
      s = s:gsub("%&", "&amp;")
      s = s:gsub("<", "&lt;")
      s = s:gsub(">", "&gt;")
      -- | starts a WoW escape sequence (|c, |T, ...); || shows one | instead
      s = s:gsub("|", "||")
      -- for k,v in pairs(self.escape_table) do
      --    s = s:gsub("%"..k, v)
      -- end
   end
   return s or ""
end

-- handle backtick blocks.
function LibMarkdown.code_spans(self, s)
   s = s:gsub("\\\\", self.escape_table["\\"])
   s = s:gsub("\\`", self.escape_table["`"])

   local pos = 1
   while true do
      local start, stop = s:find("`+", pos)
      if not start then return s end
      local count = stop - start + 1
      -- find a matching numbert of backticks
      local estart, estop = s:find(string.rep("`", count), stop+1)
      local brstart = s:find("\n", stop+1)
      if estart and (not brstart or estart < brstart) then
         local code = s:sub(stop+1, estart-1)
         code = code:gsub("^[ \t]+", "")
         code = code:gsub("[ \t]+$", "")
         code = code:gsub(self.escape_table["\\"], self.escape_table["\\"] .. self.escape_table["\\"])
         code = code:gsub(self.escape_table["`"], self.escape_table["\\"] .. self.escape_table["`"])
         code = self.config.code .. self:encode_code(code) .. self.config["/code"]
         code = self:add_escape(code)
         s = s:sub(1, start-1) .. code .. s:sub(estop+1)
         pos = start + code:len()
      else
         pos = stop + 1
      end
   end
   return s
end

-- encode alt text... enodes &, and ".
function LibMarkdown.encode_alt(self, s)
   if not s then return s end
   s = s:gsub('&', '&amp;')
   s = s:gsub('"', '&quot;')
   s = s:gsub('<', '&lt;')
   return s
end

-- forward declaration for link_db as returned by strip_link_definitions.
LibMarkdown.link_database = {}

-- handle image references
-- the url and title in a link's "(url "title")". The url can hold balanced parentheses, as
-- in (https://en.wikipedia.org/wiki/Lua_(programming_language)), or be written as <url>.
function LibMarkdown.link_destination(link)
   local inner = link:sub(2, -2):match("^%s*(.-)%s*$")
   local url, title = inner:match("^<(.-)>%s*[\"'](.*)[\"']$")
   if not url then url, title = inner:match("^(%S+)%s+[\"'](.*)[\"']$") end
   if not url then url = inner:match("^<(.-)>$") or inner end
   return url, title
end

function LibMarkdown.images(self, text)
   local function image(label, id)
      id = (id or ""):lower()
      if id == "" then id = label:lower() end
      local link = self.link_database[id]
      if not (link and link.url) then return nil end
      -- lmd: simplehtml doesn't support alt text or titles
      return self:add_escape('<img src="' .. self:encode_alt(link.url) ..  '" />')
   end

   -- ![alt][id], and ![alt][] for ![alt][alt]
   local function reference_link(alt, id)
      return image(alt:sub(2, -2), id:sub(2, -2))
   end

   -- ![alt] for ![alt][alt]
   local function shortcut_link(alt)
      return image(alt:sub(2, -2))
   end

   -- ![alt](path "caption" 64x64 right): the path is the first word, and the caption, size,
   -- and alignment can come in any order after it
   local function inline_link(alt, link)
      local inner = link:sub(2, -2):match("^%s*(.-)%s*$")
      local url = inner:match("^<(.-)>") or inner:match("^(%S+)")
      local title = inner:match('%s"(.-)"') or inner:match("%s'(.-)'")
      url = self:encode_alt(url)

      local attrs = {}
      title = self:encode_alt(title)

      attrs.src   = url or nil
      attrs.align = link:match(" (left)") or link:match(" (right)") or link:match(" (center)") or nil
      attrs.width, attrs.height = link:match(' (%d+)[x,./: -]+(%d+)')
      attrs.alt    = nil -- alt or nil

      title = title and ('<p' .. (attrs.align and ' align="' .. attrs.align .. '">' or ">") .. 
              self.config.figcaption .. title .. self.config["/figcaption"] .. '</p>\n') or ""

      local tag = "<img"

      for _, k in ipairs({ "src", "width", "height", "align" }) do
         if attrs[k] then tag = tag .. ' ' .. k .. '="' .. attrs[k] .. '"' end
      end

      tag = tag .. ' />'

      return self:add_escape(tag) .. title
   end

   text = text:gsub("!(%b[])[ \t]*\n?[ \t]*(%b[])", reference_link)
   text = text:gsub("!(%b[])(%b())", inline_link)
   text = text:gsub("!(%b[])", shortcut_link)

   return text
end

-- a link's text can show a url without it becoming a second, nested link
function LibMarkdown.guard_link_text(self, text)
   return (text:gsub("://", self:add_escape("://")):gsub("www%.", self:add_escape("www.")))
end

-- handle anchor references
function LibMarkdown.anchors(self, text)
   -- lmd: simplehtml doesn't support title attributes
   local function anchor(url, label)
      return self:add_escape("<a href=\"" .. self:encode_alt(url) .. "\">") ..
             self:guard_link_text(label) .. self:add_escape("</a>")
   end

   local function lookup(label, id)
      id = (id or ""):lower()
      if id == "" then id = label:lower() end
      local link = self.link_database[id]
      if link and link.url then return anchor(link.url, label) end
   end

   -- [text][id], and [text][] for [text][text]
   local function reference_link(label, id)
      return lookup(label:sub(2, -2), id:sub(2, -2))
   end

   -- [text] for [text][text], when text is a defined link
   local function shortcut_link(label)
      return lookup(label:sub(2, -2))
   end

   local function inline_link(label, link)
      local url = LibMarkdown.link_destination(link)
      return anchor(url, label:sub(2, -2))
   end

   text = text:gsub("(%b[])[ \t]*\n?[ \t]*(%b[])", reference_link)
   text = text:gsub("(%b[])(%b())", inline_link)
   text = text:gsub("(%b[])", shortcut_link)
   return text
end

-- handle auto links, i.e. <http://www.google.com/>.
function LibMarkdown.auto_links(self, text)
   -- the whole link is protected, so the bare url pass doesn't link its text again
   local function link(s)
      return self:add_escape("<a href=\"" .. s .. "\">" .. s .. "</a>")
   end
   local function mail(s)
      s = self:unescape_special_chars(s)
      local address = "mailto:" .. s
      return self:add_escape("<a href=\"" .. address .. "\">" .. s .. "</a>")
   end
   -- links
   text = text:gsub("<(https?:[^'\">%s]+)>", link)
   text = text:gsub("<(ftp:[^'\">%s]+)>", link)

   -- mail
   text = text:gsub("<mailto:([^'\">%s]+)>", mail)
   text = text:gsub("<([-.%w]+%@[-.%w]+)>", mail)
   return text
end

-- links bare urls (GFM autolinks): http:// and https:// urls, and www. ones (linked as http://).
-- Trailing punctuation, and a ) that doesn't close a ( in the url, stay outside the link.
-- Urls inside html tags or raw <a> elements are left alone.
LibMarkdown.bare_url_patterns = { "%f[%w]https?://[^%s<>\"']+", "%f[%w]www%.[%w%-][^%s<>\"']*" }

function LibMarkdown.bare_links(self, text)
   local function linkify(s)
      local out, pos = {}, 1
      while true do
         local start, stop = LibMarkdown.find_first(s, LibMarkdown.bare_url_patterns, pos)
         if not start then break end
         local url = s:sub(start, stop)
         while true do
            local trimmed = url:gsub("[%.,:;!%?%*_~'\"]+$", "")
            local _, opens = trimmed:gsub("%(", "")
            local _, closes = trimmed:gsub("%)", "")
            if trimmed:sub(-1) == ")" and closes > opens then trimmed = trimmed:sub(1, -2) end
            if trimmed == url then break end
            url = trimmed
         end
         local href = url:match("^www%.") and ("http://" .. url) or url
         table.insert(out, s:sub(pos, start - 1))
         table.insert(out, self:add_escape('<a href="' .. href .. '">' .. url .. "</a>"))
         pos = start + #url
      end
      table.insert(out, s:sub(pos))
      return table.concat(out)
   end

   local out, in_a = {}, false
   for _, token in ipairs(LibMarkdown.tokenize_html(text)) do
      local t = token.text
      if token.type == "tag" then
         local closing, name = t:match("^<(/?)(%a%w*)")
         if name and name:lower() == "a" then in_a = closing == "" end
      elseif not in_a then
         t = linkify(t)
      end
      table.insert(out, t)
   end
   return table.concat(out)
end

-- returns the position of the ">" that ends the tag or comment starting at the "<" at
-- pos, or nil if that "<" doesn't start one SimpleHTML could parse. SimpleHTML shows a
-- whole document as raw text when any of it is malformed, and it needs quoted attributes.
function LibMarkdown.tag_end(s, pos)
   if s:sub(pos, pos + 3) == "<!--" then
      local _, stop = s:find("-->", pos + 4, true)
      return stop
   end
   local _, stop = s:find("^</%a%w*%s*>", pos)
   if stop then return stop end
   _, stop = s:find("^<%a%w*", pos)
   if not stop then return nil end
   local i = stop + 1
   while true do
      local _, close = s:find("^%s*/?>", i)
      if close then return close end
      local _, eq = s:find("^%s+[%a_:][%w_:%.%-]*%s*=%s*", i)
      if not eq then return nil end
      local quote = s:sub(eq + 1, eq + 1)
      if quote ~= '"' and quote ~= "'" then return nil end
      local endquote = s:find(quote, eq + 2, true)
      if not endquote then return nil end
      i = endquote + 1
   end
end

-- encodes every "<" that doesn't start a tag or comment (e.g. "x<y", "<3").
function LibMarkdown.escape_naked_angles(s)
   local out, pos = {}, 1
   while true do
      local lt = s:find("<", pos, true)
      if not lt then break end
      table.insert(out, s:sub(pos, lt - 1))
      local stop = LibMarkdown.tag_end(s, lt)
      if stop then
         table.insert(out, s:sub(lt, stop))
         pos = stop + 1
      else
         table.insert(out, "&lt;")
         pos = lt + 1
      end
   end
   table.insert(out, s:sub(pos))
   return table.concat(out)
end

-- encode free standing amps (&) and angles (<)... note that this does not
-- encode free >.
function LibMarkdown.amps_and_angles(self, s)
   -- encode amps that don't start a &name; &#123; or &#x7B; reference
   local pos = 1
   while true do
      local amp = s:find("&", pos, true)
      if not amp then break end
      if not (s:find("^&%a%w*;", amp) or s:find("^&#%d+;", amp) or s:find("^&#[xX]%x+;", amp)) then
         s = s:sub(1, amp - 1) .. "&amp;" .. s:sub(amp + 1)
      end
      pos = amp + 1
   end

   -- encode naked <'s
   s = LibMarkdown.escape_naked_angles(s)

   -- what about >, nothing done in the original markdown source to handle them
   return s
end

-- handles emphasis markers (* and _) in the text.
function LibMarkdown.emphasis(self, text)
   -- _ between two letters or digits is literal, so snake_case_names stay as they are
   text = text:gsub("([%w\128-\255])(_+)(%f[%w\128-\255])", function(before, run)
      return before .. self.escape_table["_"]:rep(#run)
   end)

   -- ~~strikethrough~~; the text inside can't start or end with a space
   text = text:gsub("~~([^%s~].-)~~", function(inner)
      if inner:find("%s$") then return nil end
      return self.config.del .. inner .. self.config["/del"]
   end)

   for _, s in ipairs {"%*%*", "%_%_"} do
      text = text:gsub(s .. "([^%s%*%_])" .. s, self.config.strong .. "%1" .. self.config["/strong"])
      text = text:gsub(s .. "([^%s][^<>]-[^%s][%*%_]?)" .. s, self.config.strong .. "%1" .. self.config["/strong"])
      text = text:gsub(s .. "([^%s][^<>]-[^%s][%*%_]?)" .. s, self.config.strong .. "%1" .. self.config["/strong"])
   end
   for _, s in ipairs {"%*", "%_"} do
      text = text:gsub(s .. "([^%s_])" .. s, self.config.em .. "%1" .. self.config["/em"])
      text = text:gsub(s .. "(<strong>[^%s_]</strong>)" .. s, self.config.strong .. "%1" .. self.config["/strong"])
      text = text:gsub(s .. "([^%s_][^<>_]-[^%s_])" .. s, self.config.em .. "%1" .. self.config["/em"])
      text = text:gsub(s .. "([^<>_]-<strong>[^<>_]-</strong>[^<>_]-)" .. s, self.config.strong .. "%1" .. self.config["/strong"])
   end
   return text
end

-- SimpleHTML decodes only &amp; &lt; &gt; and &quot;, so other character references are
-- decoded to UTF-8 here. Latin-1 runs from U+00A0 to U+00FF in this order.
LibMarkdown.latin1_entities = {
   "nbsp", "iexcl", "cent", "pound", "curren", "yen", "brvbar", "sect", "uml", "copy", "ordf", "laquo",
   "not", "shy", "reg", "macr", "deg", "plusmn", "sup2", "sup3", "acute", "micro", "para", "middot",
   "cedil", "sup1", "ordm", "raquo", "frac14", "frac12", "frac34", "iquest",
   "Agrave", "Aacute", "Acirc", "Atilde", "Auml", "Aring", "AElig", "Ccedil", "Egrave", "Eacute", "Ecirc", "Euml",
   "Igrave", "Iacute", "Icirc", "Iuml", "ETH", "Ntilde", "Ograve", "Oacute", "Ocirc", "Otilde", "Ouml", "times",
   "Oslash", "Ugrave", "Uacute", "Ucirc", "Uuml", "Yacute", "THORN", "szlig",
   "agrave", "aacute", "acirc", "atilde", "auml", "aring", "aelig", "ccedil", "egrave", "eacute", "ecirc", "euml",
   "igrave", "iacute", "icirc", "iuml", "eth", "ntilde", "ograve", "oacute", "ocirc", "otilde", "ouml", "divide",
   "oslash", "ugrave", "uacute", "ucirc", "uuml", "yacute", "thorn", "yuml",
}

LibMarkdown.named_entities = {
   apos   = 0x0027, OElig  = 0x0152, oelig  = 0x0153, Scaron = 0x0160, scaron = 0x0161, Yuml   = 0x0178,
   fnof   = 0x0192, circ   = 0x02C6, tilde  = 0x02DC, ndash  = 0x2013, mdash  = 0x2014, lsquo  = 0x2018,
   rsquo  = 0x2019, sbquo  = 0x201A, ldquo  = 0x201C, rdquo  = 0x201D, bdquo  = 0x201E, dagger = 0x2020,
   Dagger = 0x2021, bull   = 0x2022, hellip = 0x2026, permil = 0x2030, prime  = 0x2032, Prime  = 0x2033,
   lsaquo = 0x2039, rsaquo = 0x203A, euro   = 0x20AC, trade  = 0x2122, larr   = 0x2190, uarr   = 0x2191,
   rarr   = 0x2192, darr   = 0x2193, harr   = 0x2194, minus  = 0x2212, infin  = 0x221E, ne     = 0x2260,
   le     = 0x2264, ge     = 0x2265, spades = 0x2660, clubs  = 0x2663, hearts = 0x2665, diams  = 0x2666,
}
for i, name in ipairs(LibMarkdown.latin1_entities) do LibMarkdown.named_entities[name] = 0x9F + i end

-- characters that are markup to SimpleHTML or WoW (| starts an escape sequence)
LibMarkdown.entity_markup = { [34] = "&quot;", [38] = "&amp;", [60] = "&lt;", [62] = "&gt;", [124] = "||" }

-- returns the text for code point cp, or nil for one that isn't a valid character.
function LibMarkdown.entity_char(cp)
   if not cp or cp < 1 or cp > 0x10FFFF or (cp >= 0xD800 and cp <= 0xDFFF) then return nil end
   if LibMarkdown.entity_markup[cp] then return LibMarkdown.entity_markup[cp] end
   local floor = math.floor
   if cp < 0x80 then
      return string.char(cp)
   elseif cp < 0x800 then
      return string.char(0xC0 + floor(cp / 0x40), 0x80 + cp % 0x40)
   elseif cp < 0x10000 then
      return string.char(0xE0 + floor(cp / 0x1000), 0x80 + floor(cp / 0x40) % 0x40, 0x80 + cp % 0x40)
   end
   return string.char(0xF0 + floor(cp / 0x40000), 0x80 + floor(cp / 0x1000) % 0x40,
                      0x80 + floor(cp / 0x40) % 0x40, 0x80 + cp % 0x40)
end

-- entities and raid targeting icons
function LibMarkdown.entities(self, text)
   -- LMD: added this
   for _, k in ipairs(self.entities_list)
   do text = text:gsub("&" .. k .. ";", self.config[k])
   end

   for rt, aliases in pairs(self.rt_list)
   do text = text:gsub('{' .. rt .. '}', self.config[rt])
      text = text:gsub('{' .. rt:upper() .. '}', self.config[rt])
      for _, aka in ipairs(aliases)
      do  text = text:gsub('{' .. aka .. '}', self.config[rt])
          text = text:gsub('{' .. aka:lower() .. '}', self.config[rt])
          text = text:gsub('{' .. aka:upper() .. '}', self.config[rt])
      end
   end

   text = text:gsub("&#[xX](%x+);", function(hex) return self.entity_char(tonumber(hex, 16)) end)
   text = text:gsub("&#(%d+);", function(dec) return self.entity_char(tonumber(dec)) end)
   text = text:gsub("&(%w+);", function(name)
      local cp = self.named_entities[name]
      return cp and self.entity_char(cp)
   end)

   -- any & left over would be an entity SimpleHTML can't parse, so show it literally
   text = text:gsub("&(%a*;?)", function(rest)
      if rest == "amp;" or rest == "lt;" or rest == "gt;" or rest == "quot;" then return nil end
      return "&amp;" .. rest
   end)

   return text
end

-- handles line break markers in the text.
-- a line ending in two spaces, or in a backslash, breaks there
function LibMarkdown.line_breaks(self, text)
   return (text:gsub("  +\n", " <br/>\n"):gsub("\\\n", "<br/>\n"))
end

-- perform all span level transforms.
function LibMarkdown.span_transform(self, text)
   text = self:code_spans(text)
   text = self:escape_special_chars(text)
   text = self:footnote_refs(text)
   text = self:images(text)
   text = self:anchors(text)
   text = self:auto_links(text)
   text = self:bare_links(text)
   text = self:amps_and_angles(text)
   text = self:emphasis(text)
   text = self:line_breaks(text)
   return text
end

----------------------------------------------------------------------
-- markdown
----------------------------------------------------------------------

-- cleanup the text by normalizing some possible variations to make further
-- processing easier.
function LibMarkdown.cleanup(self, text)
   -- standardize line endings
   text = text:gsub("\r\n", "\n")  -- dos to unix
   text = text:gsub("\r", "\n")    -- mac to unix

   -- convert all tabs to spaces
   text = LibMarkdown.detab(text) -- lmd: are tabs even a thing in wow?

   -- strip lines with only spaces and tabs
   while true do
      local subs
      text, subs = text:gsub("\n[ \t]+\n", "\n\n")
      if subs == 0 then break end
   end

   return "\n" .. text .. "\n"
end

-- strips link definitions from the text and stores the data in a lookup table.
function LibMarkdown.strip_link_definitions(text)
   local linkdb = {}

   local function link_def(id, url, title)
      id = id:match("%[(.+)%]"):lower()
      linkdb[id] = linkdb[id] or {}
      -- backslash escapes apply in the url, as in an inline link: Interface\\ICONS is Interface\ICONS
      if url then url = url:gsub("\\(%p)", "%1") end
      linkdb[id].url = url or linkdb[id].url
      linkdb[id].title = title or linkdb[id].title
      return ""
   end

   local def_no_title = "\n ? ? ?(%b[]):[ \t]*\n?[ \t]*<?([^%s>]+)>?[ \t]*"
   local def_title1 = def_no_title .. "[ \t]+\n?[ \t]*[\"'(]([^\n]+)[\"')][ \t]*"
   local def_title2 = def_no_title .. "[ \t]*\n[ \t]*[\"'(]([^\n]+)[\"')][ \t]*"
   local def_title3 = def_no_title .. "[ \t]*\n?[ \t]+[\"'(]([^\n]+)[\"')][ \t]*"

   text = text:gsub(def_title1, link_def)
   text = text:gsub(def_title2, link_def)
   text = text:gsub(def_title3, link_def)
   text = text:gsub(def_no_title, link_def)
   return text, linkdb
end

----------------------------------------------------------------------
-- footnotes
----------------------------------------------------------------------

-- Footnotes: "[^id]: note" defines one, and [^id] refers to it. Each referenced note gets a
-- number, in the order the text first refers to it; the reference shows as [1], and the notes
-- are listed after a rule at the end of the document. A definition's text can go on in lines
-- indented under it. Ids aren't case-sensitive.

-- removes the footnote definitions from text (outside fenced code) into self.footnotes
function LibMarkdown.strip_footnote_definitions(self, text)
   local notes = { defs = {}, numbers = {}, order = {} }
   self.footnotes = notes
   local out, fence, current = {}, nil, nil
   for _, line in ipairs(LibMarkdown.split(text)) do
      local id, note = nil, nil
      if fence then
         if LibMarkdown.fence_closes(line, fence) then fence = nil end
      elseif LibMarkdown.fence_open(line) then
         fence = LibMarkdown.fence_open(line)
      else
         id, note = line:match("^ ? ? ?%[%^([^%]]+)%]:[ \t]*(.*)$")
      end
      if id then
         current = id:lower()
         notes.defs[current] = note
      elseif current and line:match("^  +%S") then
         notes.defs[current] = notes.defs[current] .. "\n" .. line:match("^%s*(.-)%s*$")
      else
         current = nil
         table.insert(out, line)
      end
   end
   return table.concat(out, "\n")
end

-- numbers the defined footnotes in the order text refers to them, skipping fenced code
function LibMarkdown.number_footnotes(self, text)
   local notes, fence = self.footnotes, nil
   if not next(notes.defs) then return end
   for _, line in ipairs(LibMarkdown.split(text)) do
      if fence then
         if LibMarkdown.fence_closes(line, fence) then fence = nil end
      elseif LibMarkdown.fence_open(line) then
         fence = LibMarkdown.fence_open(line)
      else
         for id in line:gmatch("%[%^([^%]]+)%]") do
            id = id:lower()
            if notes.defs[id] and not notes.numbers[id] then
               table.insert(notes.order, id)
               notes.numbers[id] = #notes.order
            end
         end
      end
   end
end

function LibMarkdown.footnote_marker(self, n)
   return self.config.footnote_ref .. n .. self.config["/footnote_ref"]
end

-- replaces each reference to a defined footnote with its number
function LibMarkdown.footnote_refs(self, text)
   local notes = self.footnotes
   if not (notes and notes.order[1]) then return text end
   return (text:gsub("%[%^([^%]]+)%]", function(id)
      local n = notes.numbers[id:lower()]
      if n then return self:add_escape(self:footnote_marker(n)) end
   end))
end

-- the notes, for the end of the document
function LibMarkdown.footnote_section(self)
   local notes = self.footnotes
   if not (notes and notes.order[1]) then return "" end
   local out = { self.config.footnotes }
   for n, id in ipairs(notes.order) do
      table.insert(out, self.config.footnote .. self:footnote_marker(n) .. self.config.ensp ..
                        self:span_transform(notes.defs[id]) .. self.config["/footnote"])
   end
   return "\n\n" .. table.concat(out, "\n") .. "\n"
end

-- main markdown processing function
function LibMarkdown.markdown(self, text)
   self:init_hash(text)
   self:init_escape_table()
   self.pd.blocks = {}
   self.fence = nil
   self.list_depth = 0

   text = self:cleanup(text)
   text = self:protect(text)
   text = self:strip_footnote_definitions(text)
   text, self.link_database = self.strip_link_definitions(text)
   self:number_footnotes(text)
   text = self:block_transform(text)
   text = text .. self:footnote_section()
   text = self:unescape_special_chars(text)
   text = self:entities(text)
   text = self.escape_naked_angles(text) -- raw html blocks skip the span transforms
   text = self.flatten_blocks(text)
   text = self.last_minute_lmd_fixes(text) -- LMD: added
   return text
end

-- returns a config table holding settings, that falls back to the table get_base() returns
local function overlay_config(get_base, settings)
   local config = setmetatable({}, { __index = function(_, k) return get_base()[k] end })
   for k, v in pairs(settings or {}) do config[k] = v end
   return config
end

-- returns a renderer with its own config: settings, then the library's config for anything
-- settings leaves out. Use it instead of changing LibStub(...).config, which every AddOn shares.
--   local md = LibStub("LibSimpleHTMLMarkdown-1.0"):New({ em = "|cffff9966", ["/em"] = "|r" })
--   frame:SetText(md:ToHTML(text))
-- The renderer keeps working, and picks up new defaults, when a newer copy of the library loads.
function LibMarkdown.New(_, settings)
   local instance = setmetatable({}, { __index = LibMarkdown })
   instance.config = overlay_config(function() return LibMarkdown.config end, settings)
   return instance
end

function LibMarkdown.ToHTML(self, param, options)
     local ERRMESSAGE = "[" .. MARKDOWN10 .. "]: " .. ":ToHTML() requires a string or list of strings."
     local param_type = type(param)

     -- options apply to this call only, over the renderer's own config
     if type(options) == "table" then
        local base = self.config
        self = setmetatable({ config = overlay_config(function() return base end, options) }, { __index = self })
     end

     if     param_type == "string" 
     then   return self.config.html .. 
                     self.config.body .. 
                       self:markdown(param) ..
                     self.config["/body"] .. 
                   self.config["/html"]
     elseif param_type == "table"
            then local all_strings = true

                 for _, item in ipairs(param)
                 do if type(item) ~= "string" then all_strings = false break end
                 end

                 if all_strings 
                 then return self.config.html .. 
                               self.config.body .. 
                                 self:markdown(table.concat(param, "\n")) ..
                               self.config["/body"] .. 
                             self.config["/html"]
                 else print(ERRMESSAGE)
                      return ""
                 end
     else print(ERRMESSAGE)
          return ""
     end
  end

function LibMarkdown.ShowConfig(self)
    -- a renderer from :New() lists the library's keys as well as its own
    local keys, seen = {}, {}
    for _, t in ipairs({ LibMarkdown.config, self.config }) do
       for k in pairs(t) do if not seen[k] then seen[k] = true table.insert(keys, k) end end
    end
    table.sort(keys)
    print("config = {")
    for _, k in ipairs(keys)
    do print(self.config.nbsp .. "['" .. k .. "'] = '" .. tostring(self.config[k]) .. "',")
    end
    print("}")
  end

LibMarkdown.ToHtml = LibMarkdown.ToHTML
