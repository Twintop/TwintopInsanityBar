-- lua implementation of markdown originally from https://github.com/mpeterv/markdown

local  MARKDOWN10 = "LibMarkdown-1.0";
local  MARKDOWN10_MINOR = 5;
if not LibStub then error(MARKDOWN10 .. " requires LibStub."); end;
local  LibMarkdown = LibStub:NewLibrary(MARKDOWN10, MARKDOWN10_MINOR);

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
  [ 'ul'              ] = '<p>',
  ['/ul'              ] = '</p><br />',  -- it's almost always the right right choice to put <br /> after a block level tag
  [ 'ol'              ] = '<p>',
  ['/ol'              ] = '</p><br />',
  [ 'li'              ] = '',
  ['/li'              ] = '<br />',
  -- ['list_marker'      ] = '|TInterface\\MINIMAP\\TempleofKotmogu_ball_purple.PNG:0|t',
  ['list_marker'     ] = '*',
  [ 'pre'             ] = '<p>|cff66bbbb',
  ['/pre'             ] = '|r</p><br />',
  [ 'code'            ] = '|cff66bbbb',
  ['/code'            ] = '|r',
  [ 'blockquote'      ] = '<hr width="100"/><p align="center">|cffbbbb00"',
  ['/blockquote'      ] = '"|r</p><br /><hr width="100"/><br />',
  [ 'blockquote_quot' ] = '',
  [ 'h1'              ] = '<h1>',
  ['/h1'              ] = '</h1><br />',
  [ 'h2'              ] = '<h2>',
  ['/h2'              ] = '</h2><br />',
  [ 'h3'              ] = '<h3>',
  ['/h3'              ] = '</h3><br />',
  [ 'p'               ] = '<p>',
  ['/p'               ] = '</p><br />',
  [ 'html'            ] = '<html>',
  ['/html'            ] = '</html>',
  [ 'body'            ] = '<body>',
  ['/body'            ] = '</body>',
  [ 'figcaption'      ] = 'Caption: |cffbbbb00',
  ['/figcaption'      ] = '|r',
}; -- beep

LibMarkdown.entities_list = { "emsp", "ensp", "em13", "nbsp", "em14", "thinsp", };

LibMarkdown.rt_list = { 
  rt1 = { "Star",           },
  rt2 = { "Circle", "Coin", },
  rt3 = { "Diamond",        },
  rt4 = { "Triangle",       },
  rt5 = { "Moon",           },
  rt6 = { "Square",         },
  rt7 = { "Cross", "X",     },
  rt8 = { "Skull",          }, 
};

-- returns the result of mapping the values in table t through the function f
function LibMarkdown.map(t, f, self)
   local out = {}
   for k,v in pairs(t) 
   do if   self 
      then out[k] = f(self, v, k) 
      else out[k] = f(k, v);
      end;
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
end;

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

-- protects blocklevel tags in the specified text
function LibMarkdown.protect(self, text)
   -- first protect potentially nested block tags
   text = self:protect_matches(text, LibMarkdown.map(self.pd.tags, self.block_pattern))
   -- then protect block tags at the line level.
   text = self:protect_matches(text, LibMarkdown.map(self.pd.tags, self.line_pattern))
   -- protect <hr> and comment tags
   text = self:protect_matches(text, {"\n<hr[^>]->[ \t]*\n"})
   text = self:protect_matches(text, {"\n<!%-%-.-%-%->[ \t]*\n"})
   return text
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

-- identifies the block level formatting present in the line
function LibMarkdown.classify(self, line)
   local info = {line = line, text = line}

   if line:match("^%^$") then
      info.type = "eob"
      info.text = ""
      return info
   end

   if line:match("^```") then
      info.type = "backticks"
      info.outdented = ""
      self.inACodeblock = not(self.inACodeblock or false);
      return info
   end;


   if self.inACodeblock then
      info.type = "indented"
      info.outdented = line
      return info;
   end;

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

   if line:match("^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$") then
      local m1, m2 = line:match("^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$")
      info.type = "header"
      info.level = math.min(m1:len(), 3);
      info.text = m2
      return info
   end

   if                      line:match("^ ? ? ?(%d+)[%.%)][ \t]+(.+)") then
      local number, text = line:match("^ ? ? ?(%d+)[%.%)][ \t]+(.+)")
      info.type = "list_item"
      info.list_type = "numeric"
      info.number = number
      info.text = text
      return info
   end

   if                      line:match("^ ? ? ?([ivxIVX]+)[%.%]][ \t]+(.*)") then
      local number, text = line:match("^ ? ? ?([ixvIVX]+)[%.%]][ \t]*(.*)")
      info.type = "list_item"
      info.list_type = "roman_numeric"
      info.number = number
      info.text = text
      return info
   end;

   if                      line:match("^ ? ? ?(%a)[%.%)][ \t]+(.*)") then
      local number, text = line:match("^ ? ? ?(%a)[%.%)][ \t]*(.*)")
      info.type = "list_item"
      info.list_type = "alphanumeric"
      info.number = number 
      info.text = text
       return info
    end;

   if line:match("^ ? ? ?([%*%+%-])[ \t]+(.+)") then
      local bullet, text = line:match("^ ? ? ?([%*%+%-])[ \t]+(.+)")
      info.type = "list_item"
      info.list_type = "bullet"
      info.bullet = bullet
      info.text= text
      return info
   end

   if line:match("^>%s*(.*)") then
      info.type = "blockquote"
      info.text = line:match("^>%s*(.*)")
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

-- find headers constisting of a normal line followed by a ruler and converts them to
-- header entries.
function LibMarkdown.headers(self, array)
   local i = 1
   while i <= #array - 1 do
      if array[i].type  == "normal" and array[i+1].type == "ruler" and
         (array[i+1].ruler_char == "-" or array[i+1].ruler_char == "=") then
         local info = {line = array[i].line}
         info.text = info.line
         info.type = "header"
         info.level = LibMarkdown.iff(array[i+1].ruler_char == "=", 1, 2)
         table.remove(array, i+1)
         array[i] = info
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
      else
         table.insert(out, line.line)
      end
      i = i + 1
   end
   return out
end

-- find list blocks and convert them to protected data blocks
function LibMarkdown.lists(self, array, sublist)
   local function process_list(arr)
      local function any_blanks(arr)
         for i = 1, #arr do
            if arr[i].type == "blank" then return true end
         end
         return false
      end

      local function split_list_items(arr)
         local acc = {arr[1]}
         local res = {}
         for i=2,#arr do
            if arr[i].type == "list_item" then
               table.insert(res, acc)
               acc = {arr[i]}
            else
               table.insert(acc, arr[i])
            end
         end
         table.insert(res, acc)
         return res
      end

      -- local function process_list_item(lines, block)
      local function process_list_item(lines, block, number)
         while lines[#lines].type == "blank" do
            table.remove(lines)
         end

         local itemtext = lines[1].text
         for i=2,#lines do
            itemtext = itemtext .. "\n" .. LibMarkdown.outdent(lines[i].line)
         end

         local function format_item(number, itemtext)
            return '    ' .. 
                   self.config[number and "emsp" or "ensp"] ..  
                   self.config.li ..
                   (number and (number .. ".") or self.config["list_marker"]) ..  
                   self.config["ensp"]  ..
                   itemtext ..
                   self.config["/li"];
         end;
          
         if block then
            itemtext = self:block_transform(itemtext, true)
            -- if not itemtext:find("<pre>") then itemtext = LibMarkdown.indent(itemtext) end
            -- return "    <li>" .. itemtext .. "</li>"
            return format_item(number, itemtext);
         else
            local lines = LibMarkdown.split(itemtext)
            lines = LibMarkdown.map(lines, self.classify, self)
            lines = self:lists(lines, true)
            lines = self:blocks_to_html(lines, true)
            itemtext = table.concat(lines, "\n")
            -- if not itemtext:find("<pre>") then itemtext = LibMarkdown.indent(itemtext) end
            -- return "    <li>" .. itemtext .. "</li>"
            return format_item(number, itemtext);
         end
      end

      local block_list = any_blanks(arr)
      local items = split_list_items(arr)
      local out = ""

      -- for _, item in ipairs(items) do
      --     out = out .. process_list_item(item, block_list) .. "\n"
      -- end

      for i, item in ipairs(items) do
         out = out .. process_list_item(item, block_list, arr[i].number) .. "\n";
      end

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
            for i = 1, #array-1 do
               if array[i].type == "blank" and array[i+1].type == "list_item" then
                  return i+1
               end
            end
         end
         return nil
      end
      local function find_list_end(array, start)
         local pos = #array
         for i = start, #array-1 do
            if array[i].type == "eob"
               then return i-1;
            elseif 
               array[i].type == "blank" and array[i+1].type ~= "list_item"
               and array[i+1].type ~= "indented" and array[i+1].type ~= "blank" then
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
      local text = process_list(LibMarkdown.splice(array, start, stop))
      local info = {
         line = text,
         type = "raw",
         html = text
      }
      array = LibMarkdown.splice(array, start, stop, {info})
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
      print(lines[1].text);
      local raw = self:escape_special_chars(lines[1].text)
      for i = 2,#lines do
         print(lines[i].text);
         raw = raw .. self:escape_special_chars(lines[i].text) .. (lines[i].text == "" and "<br /> " .. self.config.nbsp .. ' <br />"' or '')
      end
      local bt = self:block_transform(raw)
      -- if not bt:find("<pre>") then bt = LibMarkdown.indent(bt) end
      -- return "<blockquote>\n    " .. bt ..  "\n</blockquote>"
      -- return self.config.blockquote .. raw .. self.config["/blockquote"];
      return self.config.blockquote .. LibMarkdown.strip_paragraph_tags(bt) .. self.config["/blockquote"];
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
         if line.type == "backticks" then start = i; break;
         elseif line.type == "indented" then start = i
         break end
      end
      if not start then return nil end

      local stop = #lines
      for i = start+1, #lines do
         if     lines[i+1] ~= nil and lines[i+1].type == "backticks" then return start, i+1;
         elseif lines[i].type ~= "indented" and lines[i].type ~= "blank" then
            stop = i-1
            break
         end
      end
      while lines[stop].type == "blank" do stop = stop - 1 end
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
      local text = process_codeblock(LibMarkdown.splice(lines, start, stop));
      text = LibMarkdown.strip_paragraph_tags(text:gsub("```","")):gsub("  ", self.config.emsp);
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

-- perform all the block level transforms
function LibMarkdown.block_transform(self, text, sublist)
   local lines = LibMarkdown.split(text)
   lines = LibMarkdown.map(lines, self.classify, self)
   lines = self:headers(lines)
   lines = self:lists(lines, sublist)
   lines = self:codeblocks(lines)
   lines = self:blockquotes(lines)
   lines = self:blocks_to_html(lines)

   local text = table.concat(lines, "\n")

   return text
end

function LibMarkdown.last_minute_lmd_fixes(text) --
   text = text:gsub("([^<>\n]+)(<img.->)","<p>%1</p>\n%2");
   text = text:gsub("(<img.->)([^<>]+)","%1<p>%2</p>");
   text = text:gsub("<p>(<img.->)</p>", "%1");
   text = text:gsub("<p([^>]*)>%s*<p>(.-)</p>%s*</p>", "<p%1>%2</p>");
   text = text:gsub("<p[^>]*>%s*</p>", "");
   text = text:gsub("<br />%s*<br />", "<br />");
      
   return text;
end;

----------------------------------------------------------------------
-- span transform
----------------------------------------------------------------------

-- functions for transforming the text at the span level.

-- these characters may need to be escaped because they have a special
-- meaning in markdown.
LibMarkdown.escape_chars = "'\\`*_{}[]()>#+-.!'"
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
         code = self.config.code .. self:encode_code(code) .. self.config["/code"];
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
function LibMarkdown.images(self, text)
   local function reference_link(alt, id)
      alt = self:encode_alt(alt:match("%b[]"):sub(2,-2))
      id = id:match("%[(.*)%]"):lower()
      if id == "" then id = text:lower() end
      self.link_database[id] = self.link_database[id] or {}
      if not self.link_database[id].url then return nil end
      local url = self.link_database[id].url or id
      url = self:encode_alt(url)
      -- local title = self:encode_alt(link_database[id].title)
      -- if title then title = " title=\"" .. title .. "\"" else title = "" end
      -- return add_escape ('<img src="' .. url .. '" alt="' .. alt .. '"' .. title .. "/>")
      -- lmd: simplehtml doesn't support alt text or titles
      return self:add_escape('<img src="' .. url ..  '" />')
   end

   local function inline_link(alt, link)
      alt = self:encode_alt(alt:match("%b[]"):sub(2,-2))
      local url, title = link:match("%(<?(.-)>?[ \t]*['\"](.+)['\"]")
      url = url or link:match("%(<?(.-)>?[%s%)]")
      url = self:encode_alt(url)

      local attrs = {};
      title = self:encode_alt(title)

      attrs.src   = url or nil;
      attrs.align = link:match(" (left)") or link:match(" (right)") or link:match(" (center)") or nil;
      attrs.width, attrs.height = link:match(' (%d+)[x,./: -]+(%d+)')
      attrs.alt    = nil; -- alt or nil;

      title = title and ('<p' .. (attrs.align and ' align="' .. attrs.align .. '">' or ">") .. 
              self.config.figcaption .. title .. self.config["/figcaption"] .. '</p>\n') or "";

      local tag = "<img";

      for k, v in pairs(attrs) do tag = tag .. ' ' .. k .. '="' .. v .. '"'; end;

      tag = tag .. ' />';

      return self:add_escape(tag) .. title;
   end

   text = text:gsub("!(%b[])[ \t]*\n?[ \t]*(%b[])", reference_link)
   text = text:gsub("!(%b[])(%b())", inline_link)

   return text
end

-- handle anchor references
function LibMarkdown.anchors(self, text)
   local function reference_link(text, id)
      text = text:match("%b[]"):sub(2,-2)
      id = id:match("%b[]"):sub(2,-2):lower()
      if id == "" then id = text:lower() end
      self.link_database[id] = self.link_database[id] or {}
      if not self.link_database[id].url then return nil end
      local url = self.link_database[id].url or id
      url = self:encode_alt(url)
      -- local title = self:encode_alt(link_database[id].title)
      -- if title then title = " title=\"" .. title .. "\"" else title = "" end
      -- return self:add_escape("<a href=\"" .. url .. "\"" .. title .. ">") .. text .. self:add_escape("</a>")
      -- lmd: simplehtml doesn't support title attributes
      return self:add_escape("<a href=\"" .. url .. "\">") .. text .. self:add_escape("</a>")
   end

   local function inline_link(text, link)
      text = text:match("%b[]"):sub(2,-2)
      local url, title = link:match("%(<?(.-)>?[ \t]*['\"](.+)['\"]")
      title = self:encode_alt(title)
      url  = url or  link:match("%(<?(.-)>?%)") or ""
      url = self:encode_alt(url)
      -- if title then
      --    return self:add_escape("<a href=\"" .. url .. "\" title=\"" .. title .. "\">") .. text .. "</a>"
      -- else
      --    return self:add_escape("<a href=\"" .. url .. "\">") .. text .. self:add_escape("</a>")
      -- end
      -- lmd: simplehtml doesn't support title attributes
      return self:add_escape("<a href=\"" .. url .. "\">") .. text .. self:add_escape("</a>")
   end

   text = text:gsub("(%b[])[ \t]*\n?[ \t]*(%b[])", reference_link)
   text = text:gsub("(%b[])(%b())", inline_link)
   return text
end

-- handle auto links, i.e. <http://www.google.com/>.
function LibMarkdown.auto_links(self, text)
   local function link(s)
      return self:add_escape("<a href=\"" .. s .. "\">") .. s .. "</a>"
   end
   local function mail(s)
      s = self:unescape_special_chars(s)
      local address = "mailto:" .. s--encode_email_address("mailto:" .. s)
      return self:add_escape("<a href=\"" .. address .. "\">") .. s .. "</a>"
   end
   -- links
   text = text:gsub("<(https?:[^'\">%s]+)>", link)
   text = text:gsub("<(ftp:[^'\">%s]+)>", link)

   -- mail
   text = text:gsub("<mailto:([^'\">%s]+)>", mail)
   text = text:gsub("<([-.%w]+%@[-.%w]+)>", mail)
   return text
end

-- encode free standing amps (&) and angles (<)... note that this does not
-- encode free >.
function LibMarkdown.amps_and_angles(self, s)
   -- encode amps not part of &..; expression
   local pos = 1
   while true do
      local amp = s:find("&", pos)
      if not amp then break end
      local semi = s:find(";", amp+1)
      local stop = s:find("[^%a%d]", amp+1)
      if not semi or (stop and stop < semi) or (semi - amp) > 15 then
         s = s:sub(1,amp-1) .. "&amp;" .. s:sub(amp+1)
         pos = amp+1
      else
         pos = amp+1
      end
   end

   -- encode naked <'s
   s = s:gsub("<([^a-za-z/?$!])", "&lt;%1")
   s = s:gsub("<$", "&lt;")

   -- what about >, nothing done in the original markdown source to handle them
   return s
end

-- handles emphasis markers (* and _) in the text.
function LibMarkdown.emphasis(self, text)
   for _, s in ipairs {"%*%*", "%_%_"} do
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

-- entities and raid targeting icons
function LibMarkdown.entities(self, text)
   -- LMD: added this
   for _, k in ipairs(self.entities_list)
   do text = text:gsub("&" .. k .. ";", self.config[k]);
   end;

   for rt, aliases in pairs(self.rt_list)
   do text = text:gsub('{' .. rt .. '}', self.config[rt]);
      text = text:gsub('{' .. rt:upper() .. '}', self.config[rt]);
      for _, aka in ipairs(aliases)
      do  text = text:gsub('{' .. aka .. '}', self.config[rt]);
          text = text:gsub('{' .. aka:lower() .. '}', self.config[rt]);
          text = text:gsub('{' .. aka:upper() .. '}', self.config[rt]);
      end;
   end;

   return text;
end;

-- handles line break markers in the text.
function LibMarkdown.line_breaks(self, text)
   return text:gsub("  +\n", " <br/>\n")
end

-- perform all span level transforms.
function LibMarkdown.span_transform(self, text)
   text = self:code_spans(text)
   text = self:escape_special_chars(text)
   text = self:images(text)
   text = self:anchors(text)
   text = self:auto_links(text)
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

-- main markdown processing function
function LibMarkdown.markdown(self, text)
   self:init_hash(text)
   self:init_escape_table()

   text = self:cleanup(text)
   text = self:protect(text)
   text, self.link_database = self.strip_link_definitions(text)
   text = self:block_transform(text)
   text = self:unescape_special_chars(text)
   text = self:entities(text)
   text = self.last_minute_lmd_fixes(text) -- LMD: added
   return text
end

function LibMarkdown.ToHTML(self, param)
     local ERRMESSAGE = "[" .. MARKDOWN10 .. "]: " .. ":ToHTML() requires a string or list of strings.";
     local param_type = type(param);

     if     param_type == "string" 
     then   return self.config.html .. 
                     self.config.body .. 
                       self:markdown(param) ..
                     self.config["/body"] .. 
                   self.config["/html"];
     elseif param_type == "list"
            then local all_strings = true;

                 for _, item in ipairs(param)
                 do if type(item) ~= "string" then all_strings = true; break; end;
                 end;

                 if all_strings 
                 then return self.config.html .. 
                               self.config.body .. 
                                 self:markdown(param) ..
                               self.config["/body"] .. 
                             self.config["/html"];
                 else print(ERRMESSAGE);
                      return "";
                 end;
     else print(ERRMESSAGE);
          return "";
     end;
  end

function LibMarkdown.ShowConfig(self)
    print("LMD.config = {");
    for k, v in pairs(self.config)
    do print(self.config.nbsp .. "['" .. k .. "'] = '" .. v .. "',");
    end;
    print("}");
  end;

