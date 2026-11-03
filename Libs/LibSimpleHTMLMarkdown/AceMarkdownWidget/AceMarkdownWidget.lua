-- 
--     _            __  __            _       _                  __        ___     _            _   
--    / \   ___ ___|  \/  | __ _ _ __| | ____| | _____      ___ _\ \      / (_) __| | __ _  ___| |_ 
--   / _ \ / __/ _ \ |\/| |/ _` | '__| |/ / _` |/ _ \ \ /\ / / '_ \ \ /\ / /| |/ _` |/ _` |/ _ \ __|
--  / ___ \ (_|  __/ |  | | (_| | |  |   < (_| | (_) \ V  V /| | | \ V  V / | | (_| | (_| |  __/ |_ 
-- /_/   \_\___\___|_|  |_|\__,_|_|  |_|\_\__,_|\___/ \_/\_/ |_| |_|\_/\_/  |_|\__,_|\__, |\___|\__|
--                                                                                   |___/          

local AceGUI         = LibStub("AceGUI-3.0", true);
if not AceGUI then return; end;
local widget_type    = "SimpleHTMLMarkdown_Description";
local widget_version = 1;

if not LibStub("LibSimpleHTMLMarkdown-1.0", true) then error("[|cffff0000AceMarkdownWidget|r] Missing LibSimpleHTMLMarkdown-1.0"); end;

local gameFont = {};
  gameFont.FontFile, gameFont.FontSize, gameFont.FontFlags = GameFontNormal:GetFont();
  gameFont.red, gameFont.green, gameFont.blue = GameFontNormal:GetTextColor();
  gameFont.Spacing = GameFontNormal:GetSpacing();

local function CopyTable(t) local copy = {} for k, v in pairs(t) do copy[k] = v end return copy end;

--           _     _            _    ____             __ _       
-- __      _(_) __| | __ _  ___| |_ / ___|___  _ __  / _(_) __ _ 
-- \ \ /\ / / |/ _` |/ _` |/ _ \ __| |   / _ \| '_ \| |_| |/ _` |
--  \ V  V /| | (_| | (_| |  __/ |_| |__| (_) | | | |  _| | (_| |
--   \_/\_/ |_|\__,_|\__, |\___|\__|\____\___/|_| |_|_| |_|\__, |
--                   |___/                                 |___/ 
--
_G["LIBSIMPLEHTMLMARKDOWN_WIDGET_CONFIG"] = 
{ ["HyperlinksEnabled"] = true,
  ["HyperlinkFormat"]   = "[" .. "|c" .. "ff00dd00" .. "|H%s|h%s|h" .. "|r" .. "]",
  ["LargeFont"] = "OptionsFontLarge",

  ["FontStep"] = 2,

  ["LibSimpleHTMLMarkdownConfig"] = 
    { ["list_marker"] = "|TInterface\\COMMON\\Indicator-Yellow.PNG:0|t",
    },
   
  ["HtmlStyles"] =
    { ["Normal"] = 
        { FontFile = gameFont.FontFile,
          FontSize = gameFont.FontSize,
          FontFlags = gameFont.FontFlags,
          JustifyH = "LEFT",
          JustifyV = "TOP",
          red      = gameFont.red,
          green    = gameFont.green,
          blue     = gameFont.blue,
          Spacing  = gameFont.Spacing,
        },
      ["Highlight"] =
        { FontFile = gameFont.FontFile,
          FontSize = gameFont.FontSize,
          FontFlags = gameFont.FontFlags,
          JustifyH = "LEFT",
          JustifyV = "TOP",
          red      = 1.000,
          green    = 1.000,
          blue     = 0.100,
          Spacing  = gameFont.Spacing,
        },
      ["Green"] = 
        { FontFile = gameFont.FontFile,
          FontSize = gameFont.FontSize,
          FontFlags = gameFont.FontFlags,
          JustifyH = "LEFT",
          JustifyV = "TOP",
          red      = 0.000,
          green    = 1.000,
          blue     = 0.100,
          Spacing  = gameFont.Spacing,
        },
      ["Heading 1"] =
        { FontFile = gameFont.FontFile,
          FontSize = gameFont.FontSize,
          FontFlags = gameFont.FontFlags,
          JustifyH = "LEFT",
          JustifyV = "TOP",
          red      = 1.000,
          green    = 1.000,
          blue     = 0.100,
          Spacing  = gameFont.Spacing + 3,
          FontStepFactor = 3,
        },
      ["Heading 2"] =
        { FontFile = gameFont.FontFile,
          FontSize = gameFont.FontSize,
          FontFlags = gameFont.FontFlags,
          JustifyH = "LEFT",
          JustifyV = "TOP",
          red      = 1.000,
          green    = 1.000,
          blue     = 0.100,
          Spacing  = gameFont.Spacing + 2,
          FontStepFactor = 2,
        },
      ["Heading 3"] =
        { FontFile = gameFont.FontFile,
          FontSize = gameFont.FontSize,
          FontFlags = gameFont.FontFlags,
          JustifyH = "LEFT",
          JustifyV = "TOP",
          red      = 1.000,
          green    = 1.000,
          blue     = 0.100,
          Spacing  = gameFont.Spacing + 1,
          FontStepFactor = 1,
        },
  
  },
  
  ["HtmlTagStyles"] =
    { ["h1"] = "Heading 1",
      ["h2"] = "Heading 2",
      ["h3"] = "Heading 3",
      ["p"]  = "Normal",
    },

  ["ImportedHtmlStyles"] = 
    { "GameFontNormal", 
      "GameFontNormalSmall", 
      "GameFontNormalLarge",
      "OptionsFontSmall", 
      "OptionsFontHighlight", 
      "OptionsFontLarge" 
    },

  ["LinkProtocols"] =
  { default         =
    { Cursor        = "Interface\\CURSOR\\Cast.PNG",
      Popup         =
      { Text        = "Copy the following, then close this window.",
        ButtonText  = "Got It",
      },
    },
    http            =
    { Cursor        = "Interface\\CURSOR\\Point.PNG",
      Popup         =
      { Text        = "Copy the following URL for {text} and paste it into your browser, then close this window.",
        ButtonText  = "Got It",
      },
    },
    https           =
    { Cursor        = "Interface\\CURSOR\\ArgusTeleporter.PNG",
      Popup         =
      { Text        = "Copy the following URL for {text} and paste it into your browser, then close this window.",
        ButtonText  = "Got It",
      },
    },
    mailto          =
    { Cursor        = "Interface\\CURSOR\\Mail.PNG",
      Popup         =
      { Text        = "Copy the following email address for {text}, then close this window",
        ButtonText  = "Got It",
      },
    },
  },
};

--                                __  __      _   _               _     
--  _ __   ___  _ __  _   _ _ __ |  \/  | ___| |_| |__   ___   __| |___ 
-- | '_ \ / _ \| '_ \| | | | '_ \| |\/| |/ _ \ __| '_ \ / _ \ / _` / __|
-- | |_) | (_) | |_) | |_| | |_) | |  | |  __/ |_| | | | (_) | (_| \__ \
-- | .__/ \___/| .__/ \__,_| .__/|_|  |_|\___|\__|_| |_|\___/ \__,_|___/
-- |_|         |_|         |_|                                          
--
local popupMethods =
{ ["GetButtonText" ] = function(self        )                          return self.ButtonText end,
  ["GetPrefixText" ] = function(self        )                          return self.PrefixText end,
  ["GetText"       ] = function(self        )                          return self.Text       end,
  ["SetButtonText" ] = function(self, value ) self.ButtonText = value; return self            end,
  ["SetPrefixText" ] = function(self, value ) self.PrefixText = value; return self            end,
  ["SetText"       ] = function(self, value ) self.Text = value;       return self            end,
  ["GetProtocol"   ] = function(self        )                          return self.protocol   end,

  ["Show"] = 
    function(self, dest, link, text, ... )
      if not link then return nil end;
      local popName = "LIBSIMPLEHTMLMARKDOWN_WIDGET_LINKHANDLER_POPUP";

      local data =
      { text = (self:GetPrefixText() or "") .. (self:GetText() or ""):gsub("{text}", text):gsub("{link}", link); 
        link = link,
      };

      StaticPopupDialogs[popName] =
      { text                   = "",
        wide                   = true,
        closeButton            = true,
        button1                = self:GetButtonText() or OKAY, -- this is Blizzard's localized "Okay"
        exclusive              = true,
        timeout                = 60,
        whileDead              = true,
        hasEditBox             = true,
        enterClicksFirstButton = true,
        hideOnEscape           = true,

        OnAccept               = function(self) self:Hide()             end ,
        EditBoxOnEnterPressed  = function(self) self:GetParent():Hide() end ,
        EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end ,

        OnShow =
          function(self, data)
            self.text:SetFormattedText(data.text);
            self.editBox:SetText(data.link);                        
            self.editBox:SetAutoFocus(true);
            self.editBox:HighlightText();                          
            self.editBox:SetWidth(300);
            self.button1:SetPoint("RIGHT", self, "RIGHT", -12, 0); 
            self.text:SetJustifyH("LEFT");
            self.text:SetSpacing(3);
        end,

      };

      StaticPopup_Show(popName, nil, nil, data);
    end,
};
    
--  _     _             _ ____  _         _      __  __      _   _               _     
-- | |__ | |_ _ __ ___ | / ___|| |_ _   _| | ___|  \/  | ___| |_| |__   ___   __| |___ 
-- | '_ \| __| '_ ` _ \| \___ \| __| | | | |/ _ \ |\/| |/ _ \ __| '_ \ / _ \ / _` / __|
-- | | | | |_| | | | | | |___) | |_| |_| | |  __/ |  | |  __/ |_| | | | (_) | (_| \__ \
-- |_| |_|\__|_| |_| |_|_|____/ \__|\__, |_|\___|_|  |_|\___|\__|_| |_|\___/ \__,_|___/
--                                  |___/                                              
local htmlStyleMethods =
{ 
  ["GetFontFile"       ] = function(self ) return self.FontFile                   end ,
  ["GetFontFlags"      ] = function(self ) return self.FontFlags                  end ,
  ["GetFontStepFactor" ] = function(self ) return self.FontStepFactor             end ,
  ["GetJustifyH"       ] = function(self ) return self.JustifyH                   end ,
  ["GetJustifyV"       ] = function(self ) return self.JustifyV                   end ,
  ["GetSpacing"        ] = function(self ) return self.Spacing                    end ,
  ["GetTextColor"      ] = function(self ) return self.red, self.green, self.blue end ,
  ["GetTextColorBlue"  ] = function(self ) return self.blue                       end ,
  ["GetTextColorGreen" ] = function(self ) return self.green                      end ,
  ["GetTextColorRed"   ] = function(self ) return self.red                        end ,
  ["GetName"           ] = function(self ) return self.name                       end ,

  ["SetFontFile"       ] = function(self, value ) self.FontFile       = value return self end ,
  ["SetFontFlags"      ] = function(self, value ) self.FontFlags      = value return self end ,
  ["SetFontSize"       ] = function(self, value ) self.FontSize       = value return self end ,
  ["SetFontStepFactor" ] = function(self, value ) self.FontStepFactor = value return self end ,
  ["SetJustifyH"       ] = function(self, value ) self.JustifyH       = value return self end ,
  ["SetJustifyV"       ] = function(self, value ) self.JustifyV       = value return self end ,
  ["SetSpacing"        ] = function(self, value ) self.Spacing        = value return self end ,
  ["SetTextColorBlue"  ] = function(self, value ) self.blue           = value return self end ,
  ["SetTextColorGreen" ] = function(self, value ) self.green          = value return self end ,
  ["SetTextColorRed"   ] = function(self, value ) self.red            = value return self end ,

  ["SetTextColor"      ] = 
    function(self, r, g, b) 
      self.red, self.green, self.blue = r, g, b 
      return self;
    end,

  ["SetFont"           ] = 
    function(self, file, size, flags) 
      self.FontFile, self.FontSize, self.FontFlags = file, size, flags; 
      return self 
    end,

  ["GetFontSize"] = 
    function(self) 
      return (self.FontSize or 10) + (self.FontStepFactor or 0) * (self.widget.FontStep or 2);
    end,

  ["GetFont"] = 
    function(self) 
      return self:GetFontFile(), self:GetFontSize(), self:GetFontFlags() 
    end,
};

--  _     _             _ _____                         _   _                 _ _               
-- | |__ | |_ _ __ ___ | |  ___| __ __ _ _ __ ___   ___| | | | __ _ _ __   __| | | ___ _ __ ___ 
-- | '_ \| __| '_ ` _ \| | |_ | '__/ _` | '_ ` _ \ / _ \ |_| |/ _` | '_ \ / _` | |/ _ \ '__/ __|
-- | | | | |_| | | | | | |  _|| | | (_| | | | | | |  __/  _  | (_| | | | | (_| | |  __/ |  \__ \
-- |_| |_|\__|_| |_| |_|_|_|  |_|  \__,_|_| |_| |_|\___|_| |_|\__,_|_| |_|\__,_|_|\___|_|  |___/
--                                                                                              
local htmlFrameHandlers = 
{ ["OnHyperlinkClick"] = 
    function(self, link, text, ...)
      ResetCursor();
      if    self.widget:GetClickHandler()
      then  return self.widget:FireClickHandler(link, text, ...)
      else  local  protocolName, dest = link:match("^(%a+)://(.+)");
            local  Protocol = self.widget:GetLinkProtocol(protocolName) 
                   or self.widget:GetLinkProtocol("default");
            if     Protocol and Protocol:GetCustomClick()
            then   Protocol:FireCustomClick(dest or text, link, text, ...)
            elseif Protocol and Protocol:GetPopup()
            then   Protocol:ShowPopup(dest or text, link, text, ...)
            else   print("[" .. text .. "]: " .. dest)
            end
      end;
    end,
    
  ["OnHyperlinkEnter"] = 
    function(self, link, text, button, ...)
      if   self.widget:GetMouseOverHandler()
      then self.widget:FireMouseOverHandler(link, text, button, ...)
      else local protocolName = link:match("^(%a+):");
           local  Protocol = self.widget:GetLinkProtocol(protocolName)
                  or self.widget:GetLinkProtocol("default");
           if     Protocol and Protocol:GetMouseOver()
           then   Protocol:FireMouseOver(link, text, button, ...)
           elseif Protocol
           then   SetCursor(Protocol:GetCursor());
           else   ResetCursor();
           end;
      end;
    end,

  ["OnHyperlinkLeave"] =
    function() 
      ResetCursor();
    end,
}
--
--  _ _       _    ____            _                  _ __  __      _   _               _     
-- | (_)_ __ | | _|  _ \ _ __ ___ | |_ ___   ___ ___ | |  \/  | ___| |_| |__   ___   __| |___ 
-- | | | '_ \| |/ / |_) | '__/ _ \| __/ _ \ / __/ _ \| | |\/| |/ _ \ __| '_ \ / _ \ / _` / __|
-- | | | | | |   <|  __/| | | (_) | || (_) | (_| (_) | | |  | |  __/ |_| | | | (_) | (_| \__ \
-- |_|_|_| |_|_|\_\_|   |_|  \___/ \__\___/ \___\___/|_|_|  |_|\___|\__|_| |_|\___/ \__,_|___/
--                                                                                            
local linkProtocolMethods =
{ ["FireCustomClick" ] = function(self, ... ) return self.CustomClick and self:CustomClick(...) or nil end,
  ["FireMouseOver"   ] = function(self, ... ) return self.MouseOver and self:MouseOver(...) or nil     end,
  ["GetCursor"       ] = function(self      ) return self.Cursor                                       end,
  ["GetCustomClick"  ] = function(self      ) return self.CustomClick                                  end,
  ["GetMouseOver"    ] = function(self      ) return self.MouseOver                                    end,
  ["GetPopup"        ] = function(self      ) return self.Popup                                        end,
  ["SetCustomClick"  ] = function(self, func) self.CustomClick = func return self                      end,
  ["SetMouseOver"    ] = function(self, func) self.MouseOver = func return self                        end,
  ["ShowPopup"       ] = function(self, ... ) return self.Popup and self.Popup:Show(...)               end,

  ["RegisterPopup"] =
    function(self)
      local popup = {};
      for method, func in pairs(popupMethods) do popup[method] = func; end;
      self.Popup             = popup;
      popup.protocol         = self;
      popup.widget           = self.widget;
      return popup;
    end,

  ["SetPopup"] =
    function(self, text, buttonText, prefix)
      local popup = self:GetPopup();
      if text then popup:SetText(text) end;
      if buttonText then popup:SetButtonText(buttonText) end;
      if prefix then popup:SetPrefixText(prefix) end;
      return self
    end,

  ["SetCursor"] = 
    function(self, cursor)
      if     cursor:match("^Interface")
      then   self.Cursor = cursor
      elseif self.Cursor:match("%.")
      then   self.Cursor = "Interface\\\\CURSOR\\\\" .. cursor
      else   self.Cursor = "Interface\\\\CURSOR\\\\" .. cursor .. ".PNG"
      end;
      return self
    end,
};
-- 
--           _     _            _   __  __      _   _               _     
-- __      _(_) __| | __ _  ___| |_|  \/  | ___| |_| |__   ___   __| |___ 
-- \ \ /\ / / |/ _` |/ _` |/ _ \ __| |\/| |/ _ \ __| '_ \ / _ \ / _` / __|
--  \ V  V /| | (_| | (_| |  __/ |_| |  | |  __/ |_| | | | (_) | (_| \__ \
--   \_/\_/ |_|\__,_|\__, |\___|\__|_|  |_|\___|\__|_| |_|\___/ \__,_|___/
--                   |___/                                                
--
local widgetMethods =
{ ["DisableHyperlinks"    ] = function(self        ) self:SetHyperlinksEnabled(false)                                    end ,
  ["EnableHyperlinks"     ] = function(self        ) self:SetHyperlinksEnabled(true)                                     end ,
  ["FireClickHandler"     ] = function(self, ...   ) return self.ClickHandler and self:ClickHandler(...) or nil          end ,
  ["FireMouseOverHandler" ] = function(self, ...   ) return self.MouseOverHandler and self:MouseOverHandler(...) or nil end ,
  ["GetAllHtmlStyles"     ] = function(self        ) return self.HtmlStyles                                              end ,
  ["GetAllLinkProtocols"  ] = function(self        ) return self.LinkProtocols                                           end ,
  ["GetClickHandler"      ] = function(self        ) return self.ClickHandler                                            end ,
  ["GetMouseOverHandler"  ] = function(self        ) return self.MouseOverHandler                                        end ,
  ["GetFontStep"          ] = function(self        ) return self.FontStep                                                end ,
  ["GetHtmlStyle"         ] = function(self, value ) return self.HtmlStyles[value or "default"]                          end ,
  ["GetHyperlinkFormat"   ] = function(self        ) return self.html:GetHyperlinkFormat()                               end ,
  ["GetLinkProtocol"      ] = function(self, value ) return self.LinkProtocols[value]                                    end ,
  ["GetMarkdown"          ] = function(self        ) return self.html.Markdown                                           end ,
  ["GetText"              ] = function(self        ) return self.html:GetText()                                          end ,
  ["SetClickHandler"      ] = function(self, func  ) self.ClickHandler = func return self                                end ,
  ["SetMouseOverHandler"  ] = function(self, func  ) self.MouseOverHandler = func return self                            end ,
  ["SetFontStep"          ] = function(self, value ) self.FontStep = value return self                                   end ,
  ["SetHyperlinkFormat"   ] = function(self, value ) self.html:SetHyperlinkFormat(value)                                 end ,
  ["SetHyperlinksEnabled" ] = function(self, value ) self.html:SetHyperlinksEnabled(value) ; return self                 end ,
  ["SetImage"             ] = function(            )                                                                     end ,
  ["SetImageSize"         ] = function(            )                                                                     end ,

  ["SetText"] = 
    function(self, markdown) 
      if   not markdown 
      then self.html.Markdown = nil;
           self.html.Html = nil;
           self.html:SetText();
      else self.html.Markdown = markdown;
           local html = self:GetLibSimpleHTMLMarkdown():ToHtml(markdown);
           self.html.Html = html;
           self.html:SetText(html);
      end;
      return self;
    end,

  ["RegisterLinkProtocol"] = 
    function(self, protocolName, protocolData)
      local protocol
      if type(protocolData) == "string" and self.LinkProtocols[protocolData]
      then protocolData = self.LinkProtocols[protocolData];
      end;
      if type(protocolData) == "table" then protocol = CopyTable(protocolData); else protocol = {}; end;
      protocol.name   = protocolName;
      protocol.widget = self;
      for method, func in pairs(linkProtocolMethods) do protocol[method] = func end;
      self.LinkProtocols = self.LinkProtocols or {};
      self.LinkProtocols[protocolName] = protocol;
      protocol:RegisterPopup();
      return protocol;
    end,

  ["GetLibSimpleHTMLMarkdown"] =
    function(self)
      self.LibSimpleHTMLMarkdown = self.LibSimpleHTMLMarkdown or LibStub("LibSimpleHTMLMarkdown-1.0");
      return self.LibSimpleHTMLMarkdown
    end,

  ["SetLibSimpleHTMLMarkdownConfig"] =
    function(self, settings)
      if not settings then return end;
      local LMD = self:GetLibSimpleHTMLMarkdown();
      for k, v in pairs(settings) do LMD.config[k] = v end;
      return LMD;
    end,

  ["SetFontStepFromFontObject"] = 
    function(self, font1, font2)
      if    not font2 then font1 = "GameFontNormal"; font2 = font1 end;
      if    type(font1) == "string" then font1 = _G[font1] end;
      if    type(font2) == "string" then font2 = _G[font2] end;
      local _, fontSize1, _ = font1:GetFont();
      local _, fontSize2, _ = font2:GetFont();
      self.step = math.abs( fontSize2 - fontSize1 );
      return self;
    end,

  ["RegisterHtmlStyle"] =
    function(self, styleName, styleData)
      local  style
      if not styleData 
      then   styleData = self.HtmlStyles.default 
      elseif type(styleData) == "string" and self.HtmlStyles[styleData]
      then   styleData = self.HtmlStyles[styleData];
      end;
      if type(styleData) == "table" then style = CopyTable(styleData); else style = {}; end;
      style.name = styleName;
      style.widget = self;
      for method, func in pairs(htmlStyleMethods) do style[method] = func end;
      self.HtmlStyles = self.HtmlStyles or {};
      self.HtmlStyles[styleName] = style;
      return style;
    end,

  ["CreateHtmlStyleFromFontObject"] =
    function(self, fontObject, styleName)
      fontObject = fontObject or "GameFontNormal";
      if type(fontObject) == "string" then fontObject = _G[fontObject] end;
      if not styleName then styleName = fontObject:GetName(); end;
      local style = {};
      style.red, style.green, style.blue              = fontObject:GetTextColor();
      style.FontFile, style.FontSize, style.FontFlags = fontObject:GetFont();
      style.JustifyH                                  = fontObject:GetJustifyH();
      style.JustifyV                                  = fontObject:GetJustifyV();
      style.Spacing                                   = fontObject:GetSpacing();

      return self:RegisterHtmlStyle(styleName, style);
    end,

  ["ApplyHtmlStyle"] = 
    function(self, tag, style)
      tag = tag or "p";
      if   type(style) == "string" and self.HtmlStyles[style]
      then style = self.HtmlStyles[style];
      end;
      self.html:SetFont(tag, unpack({ style:GetFont() }) );
      self.html:SetTextColor(tag, style:GetTextColorRed(), style:GetTextColorGreen(), style:GetTextColorBlue());
      self.html:SetSpacing(tag,   style:GetSpacing() );
      self.html:SetJustifyH(tag,  style:GetJustifyH() );
      self.html:SetJustifyV(tag,  style:GetJustifyV() );
      self.html[tag] = style:GetName();
      return self;
    end,

  ["GetHtmlStyleByTag"] =
    function(self, tag)
      tag = tag or "p";
      if   self.html[tag]
      then return self:GetHtmlStyle(self.html[tag])
      else return nil;
      end;
    end,

  ["ApplyConfiguration"] = 
    function(self, config)

      for k, v in pairs(config.LinkProtocols)      
      do  local protocol = self:RegisterLinkProtocol(k)
          _ = v.Cursor      and protocol:SetCursor(     v.Cursor);
          _ = v.MouseOver   and protocol:SetMouseOver(  v.MouseOver);
          _ = v.CustomClick and protocol:SetCustomClick(v.CustomClick);
          _ = v.Popup       and protocol:SetPopup(v.Popup.Text, v.Popup.ButtonText, v.Popup.PrefixText); 
      end ;

      for k, v    in pairs(config.HtmlStyles)         do self:RegisterHtmlStyle(k, v);                   end ;
      for _, item in pairs(config.ImportedHtmlStyles) do self:CreateHtmlStyleFromFontObject(item, item); end ;
      for k, v    in pairs(config.HtmlTagStyles)      do self:ApplyHtmlStyle(k, v)                       end ;

      self:EnableHyperlinks(          config.EnableHyperlinks   );
      self:SetHyperlinkFormat(        config.HyperlinkFormat    );
      self:SetClickHandler(           config.ClickHandler       );
      self:SetMouseOverHandler(       config.MouseOverHandler   );
      self:SetFontStepFromFontObject( config.LargeFont          );
      self:SetLibSimpleHTMLMarkdownConfig(      config.LibSimpleHTMLMarkdownConfig );

    end,

 ["SetWidth"] =
   function(self, width)
     self.frame:SetWidth(width);
     self.html:SetWidth(width - 25);
     self.html:SetText(self.html.Html);
     self.frame:SetHeight( self.html:GetContentHeight() );
   end,

 ["SetFont"] =
   function(self, font)
     self:GetHtmlStyle("Normal"):SetFont(font):ApplyHtmlStyle("p", "Normal");
   end,

 ["SetFontObject"] =
   function(self, fontObject)
     local file, size, flags = fontObject:GetFont();
     for _, tag in ipairs({ "h1", "h2", "h3", "p" })
     do  local style = self.html[tag];
         self:GetHtmlStyle(style):SetFontFile(file):SetFontSize(size):SetFontFlags(flags); 
         self:ApplyHtmlStyle(tag, style);
    end;
   end,

 ["SetJustifyH"] =
   function(self, justifyH)
     self:GetHtmlStyle("Normal"):SetJustifyH(justifyH):ApplyHtmlStyle("p", "Normal");
   end,

 ["SetJustifyV"] =
   function(self, justifyV)
     self:GetHtmlStyle("Normal"):SetJustifyV(justifyV):ApplyHtmlStyle("p", "Normal");
   end,

 ["SetColor"] =
   function(self, r, g, b)
     if   not (r and g and b)
     then r, g, b = 1, 1, 1;
     end;

     self:ApplyHtmlStyle("p", self:GetHtmlStyleByTag():SetTextColor(r, g, b));
   end,
      
 ["SetTextColor"] =
   function(self, r, g, b, extra)
     tag, r, g, b = extra and r or nil, 
                    extra and g or r, 
                    extra and b or g, 
                    extra       or b;
     -- if extra then tag, r, g, b = r, g, b, extra end;
     if not (r and g and b) then r, g, b = 1, 1, 1; end;

     style = self:GetHtmlStyleByTag(tag);

     if   style
     then self:ApplyHtmlStyle(tag, style:SetTextColor(r, g, b));
     else self:ApplyHtmlStyle("p", self:GetHtmlStyleByTag():SetTextColor(r, g, b));
     end;
   end,

 ["OnAcquire"] = 
   function(self)
     self:ApplyConfiguration(_G["LIBSIMPLEHTMLMARKDOWN_WIDGET_CONFIG"]);
     self:SetWidth(200);
     self:SetText();
  end,
};

--   ____                _                   _             
--  / ___|___  _ __  ___| |_ _ __ _   _  ___| |_ ___  _ __ 
-- | |   / _ \| '_ \/ __| __| '__| | | |/ __| __/ _ \| '__|
-- | |__| (_) | | | \__ \ |_| |  | |_| | (__| || (_) | |   
--  \____\___/|_| |_|___/\__|_|   \__,_|\___|\__\___/|_|   
--                                                         
local function Constructor()
  local frame = CreateFrame("Frame", nil, UIParent);
  frame:Hide();

  local html = CreateFrame("SimpleHTML", nil, UIParent);

  for script, func in pairs(htmlFrameHandlers)
  do html:SetScript(script, func);
  end;

  local widget = 
  { type       = widget_type,
    frame      = html,
    html       = html,
  };

  html.widget = widget;

  for method, func in pairs(widgetMethods) do widget[method] = func; end;
  return AceGUI:RegisterAsWidget(widget);
end; -- constructor

AceGUI:RegisterWidgetType(widget_type, Constructor, widget_version);

