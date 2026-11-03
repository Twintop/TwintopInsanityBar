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

The library implements only one function, `:ToHTML()` (also available as `:ToHtml()`),
which takes an argument of either a single string or a table of strings (joined as lines),
and returns a string with HTML formatting, appropriate for the `:SetText()` function on a
`SimpleHTML` frame.

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
Level 4 headings and above will be converted down to `&lt;h3&gt;`.

```
[Link Name](http://LinkURL)

[Link Name](1)
[Link Name](2)

[1]: http://LinkURL
[2]: mailto:user@example.org
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
end of the current list.


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
one and a lowercase I, use a square bracket for `i]`.)

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
`&lt;b&gt;`, `&lt;i&gt;`, `&lt;em&gt;`, or `&lt;strong&lt;` HTML tags.

See below under "Configuration", however.


    ```
    local hello = { world = "This is a code block." }
    print(hello.world)
    ```

```
    print("Code blocks can also be created by starting a line with 4 spaces.")
```

## Configuration

LibSimpleHTMLMarkdown requires no specific configuration to use, and usually the default options
will work just fine. However, you are able to change the appearance of certain unsupported
tags -- specificially the colors -- by embedding UI escape codes.

You do this by setting properties in the library object's `config` table.

``` 
local LSHM = LibStub("LibSimpleHTMLMarkdown-1.0");

LSHM.config["em"]          = "|cffbbbb00"; -- emphasized text in yellow
LSHM.config["/em"]         = "|r"; -- this ends the yellow text; close your tags!
LSHM.config["blockquote"]  = "|cff00dddd"; -- blockquotes in cyan
LSHM.config["/blockquote"] = "|r";

LSHM.config["list_marker"] = "|TInterface\\MINIMAP\\TempleofKotmogu_ball_purple.PNG:0|t";
                             -- a purple ball for the list marker
```

To see what you can change, see the source or type `/script LibStub("LibSimpleHTMLMarkdown-1.0"):ShowConfig()`

## Demo Frames

Included in this package is a `Demo.lua` file that you can enable in `LibSimpleHTMLMarkdown.xml`.
It has some sample code; to view it once it's loaded, type `/script LSHMDemoFrame:Show()`.

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
- The AceGUI widget only registers when `AceGUI-3.0` is loaded, keeps its library reference
  (it was overwritten with `false`), and its default list marker uses the `list_marker` key
  the library actually reads.
