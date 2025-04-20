{ pkgs, config, ... }:
let
  fonts = config.style.fonts;
  colors = config.style.colors.withHash;
in
{
  config.programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      usernamehw.errorlens
      haskell.haskell
      kahole.magit
      jnoortheen.nix-ide
    ];
  };

  config.xdg.configFile."Code/User/settings-nix.json".text =
    with fonts;
    with colors;
    ''
      {
        "editor.fontFamily": "'${nerdfont}'",
        "editor.fontSize": 15,
        "editor.fontLigatures": true,
        "terminal.integrated.fontSize": 15,

        "editor.minimap.enabled": false,
        "workbench.activityBar.location": "hidden",
        "workbench.sideBar.location": "right",      
        "workbench.panel.defaultLocation": "left",
        "workbench.layoutControl.enabled": false,
        "chat.commandCenter.enabled": false,

        "editor.formatOnSave": true,

        "extensions.autoCheckUpdates": false,

        "nix.enableLanguageServer": true,
        "nix.serverSettings": {
            "nil": {
                "formatting": {
                    "command": ["nixfmt"]
                }
            }
        },

        "editor.bracketPairColorization.enabled": false,
        "workbench.colorCustomizations": {
          "sideBar.background": "${bg0}",
          "editor.background": "${bg}",
          "editor.foreground": "${fg}",
          "editor.selectionBackground": "${selection}",
          "editorGutter.background": "${bg0}",
          "editorLineNumber.foreground": "${fg1}",
          "editorLineNumber.activeForeground": "${fg}",
          "editorCursor.foreground": "${fg}",
          "editor.lineHighlightBackground": "${bg0}",
          "statusBar.background": "${bg1}",
          "statusBar.foreground": "${fg0}"
        },

        "editor.tokenColorCustomizations": {
          "textMateRules": [
              {
                  "name": "Variable and parameter name",
                  "scope": [
                      "variable",
                      "meta.definition.variable.name",
                      "support.variable"
                  ],
                  "settings": {
                      "fontStyle": "",
                      "foreground": "${fg}"
                  }
              },
              {
                  "name": "Comment",
                  "scope": [
                      "comment",
                      "punctuation.comment",
                      "punctuation.definition.comment"
                  ],
                  "settings": {
                      "fontStyle": "",
                      "foreground": "${fg1}"
                  }
              },
              {
                "name": "Operator",
                "scope": [
                    "keyword.operator"
                ],
                "settings": {
                    "fontStyle": "bold",
                    "foreground": "${fg}"
                }
              },
            {
                "name": "Punctuation",
                "scope": [
                    "punctuation",
                    "delimiter",
                    "bracket",
                    "brace",
                    "paren",
                    "delimiter.tag",
                    "punctuation.tag",
                    "tag.html",
                    "tag.xml",
                    "meta.property-value punctuation.separator.key-value",
                    "punctuation.definition.metadata.md",
                    "string.link.md",
                    "meta.brace",
                    "punctuation.section.embedded"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg1}"
                }
            },
            {
                "name": "String",
                "scope": [
                    "string",
                    "meta.property-value.string",
                    "support.constant.property-value.string",
                    "meta.structure.dictionary.value.json string.quoted.double.json",
                    "meta.structure.dictionary.json string.quoted.double.json",
                    "meta.preprocessor string"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg0}"
                }
            },
            {
                "name": "Primitive Literals",
                "scope": [
                    "constant.numeric",
                    "meta.property-value.numeric",
                    "support.constant.property-value.numeric",
                    "meta.property-value.color",
                    "support.constant.property-value.color",
                    "constant.language"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg}"
                }
            },
            {
                "name": "User names",
                "scope": [
                    "constant.character",
                    "constant.other",
                    "entity.name.function",
                    "entity.name.class",
                    "entity.other.inherited-class",
                    "entity.other.attribute-name",
                    "entity.name",
                    "entity.other.attribute-name",
                    "entity.other.attribute-name.html",
                    "support.type.property-name",
                    "entity.name.tag.table",
                    "meta.structure.dictionary.json string.quoted.double.json"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg}"
                }
            },
            {
                "name": "Keyword",
                "scope": [
                    "keyword",
                    "meta.property-value.keyword",
                    "support.constant.property-value.keyword",
                    "meta.preprocessor.keyword",
                    "keyword.other.use",
                    "keyword.other.function.use",
                    "keyword.other.namespace",
                    "keyword.other.new",
                    "keyword.other.special-method",
                    "keyword.other.unit",
                    "keyword.other.use-as",
                    "keyword.control"
                ],
                "settings": {
                    "fontStyle": "bold",
                    "foreground": "${fg}"
                }
            },
            {
                "name": "Other oddities",
                "scope": [
                    "entity.name.namespace",
                    "storage.type"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg}"
                }
            },
            {
                "name": "Preprocessor",
                "scope": "meta.preprocessor",
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg}"
                }
            },
            {
                "name": "Library",
                "scope": [
                    "support.type",
                    "support.class",
                    "support.function",
                    "support.constant"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg1}"
                }
            },
            {
                "name": "Invalid",
                "scope": "invalid",
                "settings": {
                    "foreground": "${alert}"
                }
            },
            {
                "name": "Invalid deprecated",
                "scope": [
                    "invalid.deprecated"
                ],
                "settings": {
                    "foreground": "${red-dark}"
                }
            },
            {
                "name": "Markdown Title Hash",
                "scope": [
                    "punctuation.definition.heading.md",
                    "entity.name.type.md",
                    "beginning.punctuation"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg2}"
                }
            },
            {
                "name": "Markdown titles",
                "scope": [
                    "markup.heading",
                    "entity.name.section"
                ],
                "settings": {
                    "fontStyle": "bold",
                    "foreground": "${blue}"
                }
            },
            {
                "name": "Markdown Raw",
                "scope": [
                    "markup.raw",
                    "markup.inline.raw",
                    "markup.fenced",
                    "markup.fenced_code"
                ],
                "settings": {
                    "fontStyle": "italic",
                    "foreground": "${fg}",
                    "background": "${bg0}
                }
            },
            {
                "name": "Markdown link",
                "scope": [
                    "markup.link",
                    "string.other.link.title",
                    "string.other.link.description",
                    "meta.link.inline",
                    "meta.image.inline"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${blue}"
                }
            },
            {
                "name": "Makefile Variables",
                "scope": [
                    "variable.language.makefile",
                    "variable.other.makefile"
                ],
                "settings": {
                    "fontStyle": "",
                    "foreground": "${fg}"
                }
            },
            {
                "scope": [
                    "markup.italic"
                ],
                "settings": {
                    "fontStyle": "italic"
                }
            },
            {
                "scope": [
                    "markup.bold"
                ],
                "settings": {
                    "fontStyle": "bold"
                }
            }
          ]
      }
      }
    '';
}
