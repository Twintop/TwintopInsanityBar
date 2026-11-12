# LibSimpleHTMLMarkdown

This is an implementation of Markdown that produces HTML suitable for
*World of Warcraft*'s `SimpleHTML`, which supports only a very limited 
number of HTML tags.

LibSimpleHTMLMarkdown is a fork of [LibMarkdown-1.0](https://github.com/endurantgames/WoW-LibMarkdown)
by Oraibi-MoonGuard, which is no longer maintained. It registers under its own LibStub name,
`LibSimpleHTMLMarkdown-1.0`, so it never collides with copies of LibMarkdown that other
AddOns still embed. See [Changes from LibMarkdown](#changes-from-libmarkdown).

LibMarkdown (and thus LibSimpleHTMLMarkdown) is heavily based on the [Lua markdown library](https://github.com/mpeterv/markdown)
created by Niklas Frykholm and further developed by Peter Melnichenko.

All versions of this code are released under the **MIT License**, including this library.

## Why Markdown?

Simply put, markdown is easier to read, write, and edit than HTML, and that simplicity
makes it easier to produce clean-looking HTML in `SimpleHTML` frames.

For example, documentation blocks in code can be created quickly and easily, without
having to worry that you forgot to close the right tags.

## Usage

The library's main function is `:ToHTML()` (also available as `:ToHtml()`), which takes
either a single string or a table of strings (joined as lines), and returns a string with
HTML formatting, appropriate for the `:SetText()` function on a `SimpleHTML` frame. An
optional second argument changes the [configuration](#configuration) for that call only.

```
local LSHM = LibStub("LibSimpleHTMLMarkdown-1.0");

local MyFrame = CreateFrame("SimpleHTML");

local text = { "# LibSimpleHTMLMarkdown",
               "",
               "This is an implementation of Markdown that produces HTML suitable for",
               "*World of Warcraft*'s **SimpleHTML**, which supports only a very limited",
               "number of HTML tags." };

MyFrame:SetText( LSHM:ToHTML(text) );
```

## Installation

Load this library as you normally would -- include `LibSimpleHTMLMarkdown.xml` in your AddOn's
TOC or XML file. You are probably already using `LibStub`, but if you aren't, there's a copy
included with this AddOn; load `LibStub\LibStub.lua` before the library.

The XML also loads an optional AceGUI widget (`SimpleHTMLMarkdown_Description`). It only
registers when `AceGUI-3.0` is already loaded, so AddOns that don't use Ace3 can embed the
library as-is.

## Markdown Support

LibSimpleHTMLMarkdown supports the following parts of [standard markdown](https://commonmark.org/help/),
with some extensions.

```
#   Heading 1
##  Heading 2
### Heading 3


Heading 1
=========

Heading 2
---------
```

These are rendered as `&lt;h1&gt;`, `&lt;h2&gt;`, and `&lt;h3&gt;` HTML tags.
Level 4 headings and above will be converted down to `&lt;h3&gt;`. As in CommonMark, the
`#`s must be followed by a space, so `#hashtag` stays text.

```
[Link Name](http://LinkURL)

[Link Name][1]
[Link Name][2]
[3]

[1]: http://LinkURL
[2]: mailto:user@example.org
[3]: http://LinkURL
```

Hyperlinks are rendered as you'd expect; however, please note that you need to explicitly
define handlers for hyperlinks on your `SimpleHTML` frame for the links to be anything
except cosmetic. Note that your handler can be written to process whatever type of links
you define; e.g., some of our code has links of the type `[Color Settings](setting:colors)`
or `[Color Help](help:colors)`.

```
* List One Item
+ List One Item
- List One Item
^

- List Two Item
+ List Two Item
* List Two Item
```

`SimpleHTML` does not support `&lt;ul&gt;` lists. However, LibSimpleHTMLMarkdown has 
rudimentary support for lists, presenting them as separate paragraphs with a marker
before each.

If you have consecutive lists, use a caret (`^`) alone on a line to indicate the
end of the current list. The caret isn't shown.


```
 1. List Item
 2) List Item
 3. List Item
^

 a) List Item
 B. List Item
 c) List Item
^

 i] List Item
 II. List Item
 iii] List Item
 iv. List Item
```

Likewise, LibSimpleHTMLMarkdown will generate pseudo-ordered lists, even though `SimpleHTML`
doesn't support `&lt;ol&gt;`. As an extension to standard markdown, LibSimpleHTMLMarkdown
supports letters or Roman numerals for lists. (To distinguish between Roman numeral
one and a lowercase I, use a square bracket for `i]`.) A letter or Roman numeral list needs
at least two items in sequence, so a line like "A. Lincoln was president." stays text.

```
- Fruit
  - Apple
    - Granny Smith
- [ ] Not done yet
- [x] Done
```

Indent an item at least two spaces past its parent's marker to nest it. Each level is
indented further (the `list_indent` setting), and `list_marker_2`, `list_marker_3`, and so on
can set a different marker per level. Task list items (GitHub's `[ ]` and `[x]`) show an
empty box or a check mark in place of the marker.

```
| Spell     | Cost |
|-----------|-----:|
| Fireball  |   2% |
| Frostbolt |   1% |
```

`SimpleHTML` can't lay out columns, so a table is shown one row per line, with the cells
between dim `|` separators and the header row in its own color. A table is centered or
right-aligned when every one of its columns is. Use `\|` for a pipe inside a cell.

```
~~Strikethrough~~
https://example.org and www.example.org
```

`SimpleHTML` can't draw a line through text, so strikethrough is shown dimmed. Bare
`http://`, `https://`, and `www.` addresses become links, like `<https://example.org>`.

```
Arcane Blast stacks four times.[^stacks]

[^stacks]: The stacks end 18 seconds after the first cast,
  or when you cast Arcane Barrage.
```

A footnote reference shows as a number, `[1]`, numbered in the order the text first refers
to it. The notes are listed after a rule at the end of the document. A note can go on in
lines indented under it.

```
![Alt Text](Interface\\ICONS\\ABILITY_SAP.PNG)
![Alt Text](Interface\\ICONS\\ABILITY_SAP.PNG "Sap Icon" 64x64 right)
```

This will produce an '&lt;img&gt;' tag, referencing an in-game texture. 
As an extension to standard markdown, a caption, the desired image dimensions, 
and an alignment can be specified.
These must all be separated from each other and the texture's path by spaces.

Acceptable values for alignment are `right`, `left`, and `center`. Dimensions
must be specified as a consecutive pair -- width/height -- but a number of 
formats are acceptable:

```
![Alt Text](Interface\\ICONS\\ABILITY_SAP.PNG 64x64)
![Alt Text](Interface\\ICONS\\ABILITY_SAP.PNG 64/64)
![Alt Text](Interface\\ICONS\\ABILITY_SAP.PNG 64:64)
![Alt Text](Interface\\ICONS\\ABILITY_SAP.PNG 64,64)
![Alt Text](Interface\\ICONS\\ABILITY_SAP.PNG 64 64)
```

### HTML Entities

`SimpleHTML` only recognizes the following HTML character entities:

```
&amp;   ampersand      &
&quot;  double-quote   "
&lt;    less than      <
&gt;    greater than   >
```

In addition, the following entities are implemented in LibSimpleHTMLMarkdown:

```
&nbsp;    About the the size of a normal space, but non-breaking.
&emsp;    The size of the font itself, so a square.
&ensp;    1/2 the size of the font.
&em13;    1/3 of the font size.
&em14;    1/4 of the font size.
&thinsp;  1/5 of the font size; non-breaking.
```

Numeric references (`&#169;`, `&#x2014;`) and common named ones (Latin-1 letters and symbols,
dashes, curly quotes, `&hellip;`, arrows, and so on) are converted to the character itself. Any
other entity is shown literally. WoW's fonts may not have a glyph for every character.

### WoW Raid Targeting Icons

You can use these in your markdown:

```
{Triangle}, {diamond}, {rt4}, etc
```

### Partial Support

Due to the limitations of `SimpleHTML`, these have limited support.

```
*Italicized Text*
_Italicized Text_

**Bold Text**
__Bold Text__
```

`SimpleHTML` has no ability to produce inline bolding or italics, and doesn't recognize
`&lt;b&gt;`, `&lt;i&gt;`, `&lt;em&gt;`, or `&lt;strong&lt;` HTML tags. An `_` between two
letters or digits is literal, so `snake_case_names` aren't emphasized.

See below under "Configuration", however.


    ```
    local hello = { world = "This is a code block." }
    print(hello.world)
    ```

```
    print("Code blocks can also be created by starting a line with 4 spaces.")
```

Fences can also be `~~~`, or four or more backticks to hold a line of three. A `|` in code
is shown as itself rather than starting a UI escape sequence.

## Configuration

LibSimpleHTMLMarkdown requires no specific configuration to use, and usually the default options
will work just fine. However, you are able to change the appearance of certain unsupported
tags -- specificially the colors -- by embedding UI escape codes.

The library object is shared by every AddOn that embeds it, so don't change its `config` table:
your settings would apply to every other AddOn's text too. Instead, pass your settings to
`:ToHTML()`, which applies them to that call only:

```
local LSHM = LibStub("LibSimpleHTMLMarkdown-1.0");

local settings = {
  ["em"]          = "|cffbbbb00", -- emphasized text in yellow
  ["/em"]         = "|r",         -- this ends the yellow text; close your tags!
  ["list_marker"] = "|TInterface\\MINIMAP\\TempleofKotmogu_ball_purple.PNG:0|t",
                                  -- a purple ball for the list marker
};

MyFrame:SetText( LSHM:ToHTML(text, settings) );
```

Or make a renderer of your own with `:New()`. It uses your settings, and the library's
defaults for anything you leave out, and keeps working when a newer copy of the library loads:

```
local MyMarkdown = LibStub("LibSimpleHTMLMarkdown-1.0"):New(settings);

MyFrame:SetText( MyMarkdown:ToHTML(text) );
```

AddOns that do change the shared `config` keep their changes when a newer copy of the library
loads.

To see what you can change, see the source or type `/script LibStub("LibSimpleHTMLMarkdown-1.0"):ShowConfig()`

## Demo Frames

Included in this package is a `Demo.lua` file that you can enable in `LibSimpleHTMLMarkdown.xml`.
It has some sample code; to view it once it's loaded, type `/script LSHMDemoFrame:Show()`.

`Showcase.lua`, also enabled in `LibSimpleHTMLMarkdown.xml`, is a page-by-page tour of everything
the library renders, for checking a change by eye in game. Each case shows its markdown, what you
should see, and the result. Type `/lshm` to open it.

## Tests

`tests/run_tests.py` renders the showcase cases, the demo text, a set of probes, and some real
AddOn news pages under Lua 5.1, and checks that each output is markup `SimpleHTML` can parse and
matches its golden file in `tests/golden/`. It needs [lupa](https://pypi.org/project/lupa/)
(`pip install lupa`). After an intended change to the output, run it with `--update` and review
the golden file diffs. GitHub Actions runs the tests on every push, and before each release.

## Changes from LibMarkdown

LibSimpleHTMLMarkdown 1.0 minor 1 starts from LibMarkdown-1.0 minor 9, the last version on
[GitHub](https://github.com/endurantgames/WoW-LibMarkdown) (CurseForge's last file is minor 7).

### Renamed

- The library registers as `LibSimpleHTMLMarkdown-1.0`, starting again at minor 1.
- The files are `LibSimpleHTMLMarkdown.lua`, `.xml`, and `.toc`.
- The AceGUI widget type is `SimpleHTMLMarkdown_Description`; its globals are
  `LIBSIMPLEHTMLMARKDOWN_WIDGET_CONFIG` and `LIBSIMPLEHTMLMARKDOWN_WIDGET_LINKHANDLER_POPUP`;
  its methods and config key are `GetLibSimpleHTMLMarkdown`, `SetLibSimpleHTMLMarkdownConfig`,
  and `LibSimpleHTMLMarkdownConfig`.
- The demo frame is `LSHMDemoFrame`.
- LibMarkdown's unfinished `SimpleMarkdown.lua` rewrite was never loaded and is not included.

### Fixed

- Loading a copy no newer than one already loaded no longer errors.
- `:ToHTML()` accepts a table of strings, as documented; it previously always printed an error.
  A table with a non-string item is now rejected instead of erroring inside the parser.
- Roman numeral lists (`i.`, `ii.`) are typed as roman numerals.
- A code fence on the last line no longer errors.
- `<user@example.org>` autolinks no longer call an undefined `encode_email_address`.
- Reference links and images no longer index a missing `link_database`.
- Empty text passed through tab expansion or code encoding returns `""` instead of erroring.
- Blank lines inside a blockquote put a non-breaking space between their line breaks.
- An unclosed code fence no longer turns later documents into code blocks. The fence state was
  kept on the library object, which every AddOn shares.
- A `<` that doesn't start a tag (`x<y`, `<3`) is escaped. SimpleHTML shows the whole document
  as raw text when any part of it is malformed.
- Raw HTML blocks pass through unchanged, as documented, instead of being wrapped in another
  `<p>`. HTML inside a code fence stays code.
- Blocks are never nested, since SimpleHTML can't lay them out. Loose list items, code in list
  items, and headings or images inside another block become a flat run of blocks.
- Character references SimpleHTML can't parse are decoded (see [HTML Entities](#html-entities)).
  `&#169;` was shown as `&amp;#169;`, and `&copy;` reached SimpleHTML undecoded.
- The AceGUI widget only registers when `AceGUI-3.0` is loaded, keeps its library reference
  (it was overwritten with `false`), and its default list marker uses the `list_marker` key
  the library actually reads.
- The AceGUI widget's settings apply to its own text; they were written into the library's
  shared config, changing every AddOn's text.
- A closing tag with no opening tag (`</a>`) is dropped, a tag left open is closed with its
  block, and `<br>`, `<img>`, and `<hr>` are self-closed, since SimpleHTML can't parse them otherwise.
- Blockquote lines are joined with a space instead of run together, and a blank `>` line no
  longer adds a stray `"`.
- `_` inside a word, `#hashtag`, and `**x**` (one character) are rendered as CommonMark does.
- A `|` in code no longer starts a UI escape sequence.
- The `^` that ends a list isn't shown, and a list right after it is still a list.
- Lists nest, list items are numbered from their own lines, and an item's indented paragraphs
  and code stay in the item.
- Image attributes are written in a fixed order.
- A footnote definition is no longer read as a link definition, link urls keep balanced
  parentheses, and image references (`![alt][]`) resolve.
- Fences close only with the character that opened them, at least as many times.
- An item's indented rules stay in the item, and an unindented rule or heading ends the list.
- Setext headings take every line of their paragraph.
- Blockquotes keep indented code as code, and a heading or quote inside a quote stays in it.
- Letter and Roman numeral lists need two items in sequence.
- A newer copy of the library keeps the config changes AddOns made to the older one.

### Added

- Nested lists, task lists, GFM tables, `~~strikethrough~~`, bare url links, footnotes, `~~~`
  fences, shortcut references, and backslash line breaks.
- `:ToHTML(text, settings)` and `:New(settings)`, so an AddOn's settings don't change the
  shared config.
