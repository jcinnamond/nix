{ config, ... }:
let
  colors = config.style.colors.scheme;
  fonts = config.style.fonts;
in
{
  config.services.wired = {
    enable = true;
  };
  config.xdg.configFile."wired/wired.ron".text =
    with colors;
    with fonts;
    ''
      (
      	max_notifications: 10,
      	timeout: 7000,
      	poll_interval: 16,
      	shortcuts: (
      		notification_interact: 3,
      		notification_close: 1,
      		notification_closeall: 2,
      	),
      	history_length: 10,
      	replacing_resets_timeout: true,
      	min_window_width: 400,
      	layout_blocks: [
              (
                  name: "root",
                  parent: "",
                  hook: Hook(parent_anchor: TR, self_anchor: TR),
                  offset: Vec2(x: 5.0, y: 30.0),
                  render_anti_criteria: [ Or([AppName("Spotify"), AppName("YouTube Music Desktop App"), Tag("volume")]) ],
                  params: NotificationBlock((
                      monitor: 0,
                      border_width: 2,
                      border_rounding: 12.0,
                      background_color: Color(hex: "#e0${bg}"),
                      border_color: Color(hex: "#00000000"),
                      padding: Padding(Left: 30, Right: 30, Top: 24, Bottom: 24),

                      gap: Vec2(x: 0.0, y: 0.0),
                      notification_hook: Hook(parent_anchor: BL, self_anchor: TL),
                  )),
              ),

              (
                  name: "image",
                  parent: "root",
                  hook: Hook(parent_anchor: TL, self_anchor: TL),
                  offset: Vec2(x: 0.0, y: 0.0),
                  // https://github.com/Toqozz/wired-notify/wiki/ImageBlock
                  params: ImageBlock((
                      image_type: Hint,
                      // We actually want 4px padding, but the border is 3px.
                      padding: Padding(left: 7.0, right: 0.0, top: 7.0, bottom: 7.0),
                      rounding: 3.0,
                      scale_width: 48,
                      scale_height: 48,
                      filter_mode: Lanczos3,
                  )),
              ),

              (
                  name: "summary",
                   parent: "image",
                  hook: Hook(parent_anchor: MR, self_anchor: BL),
                  offset: Vec2(x: 0.0, y: 0.0),
                  // https://github.com/Toqozz/wired-notify/wiki/TextBlock
                  params: TextBlock((
                      text: "%s",
                      font: "${heading} 13",
                      ellipsize: Middle,
                      color: Color(hex: "#${colors.fg}"),
                      padding: Padding(left: 15, right: 15, top: 15, bottom: 0),
                      dimensions: (width: (min: 50, max: 150), height: (min: 0, max: 0)),
                  )),
              ),

              (
                  name: "body",
                  parent: "summary",
                  hook: Hook(parent_anchor: BL, self_anchor: TL),
                  offset: Vec2(x: 0.0, y: -3.0),
                  params: ScrollingTextBlock((
                      text: "%b",
                      font: "${withSize variableWidth}",
                      color: Color(hex: "${colors.fg0}"),
                      color_hovered: Color(hex: "#fbf1c7"),
                      padding: Padding(left: 15, right: 15, top: 10, bottom: 15),
                      width: (min: 150, max: 250),
                      scroll_speed: 0.1,
                      lhs_dist: 35.0,
                      rhs_dist: 35.0,
                      scroll_t: 1.0,
                  )),
              ),

      		(
      			name: "music",
      			parent: "",
      			offset: (x: 0, y: -40),
      			hook: Hook(parent_anchor: BM, self_anchor: BM),
      			render_criteria: [ Or([AppName("Spotify"), AppName("YouTube Music Desktop App")]) ],
      			params: NotificationBlock((
      				monitor: 0,
                      border_width: 0.0,
                      border_rounding: 16.0,
                      background_color: Color(hex: "#e0${bg2}"),
                      border_color: Color(hex: "#00000000"),
                      padding: Padding(Left: 20, Right: 20, Top: 12, Bottom: 12),
                      gap: Vec2(x: 0.0, y: 0.0),
                      notification_hook: Hook(parent_anchor: BL, self_anchor: TL),
      			)),
      		),
      		(
      			name: "music-image",
      			parent: "music",
                  hook: Hook(parent_anchor: TL, self_anchor: TL),
                  offset: Vec2(x: 0, y: 0),
                  params: ImageBlock((
                      image_type: Hint,
                      // We actually want 4px padding, but the border is 3px.
                      padding: Padding(left: 7.0, right: 0.0, top: 7.0, bottom: 7.0),
                      rounding: 3.0,
                      scale_width: 128,
                      scale_height: 128,
                      filter_mode: Lanczos3,
                  )),
      		),
              (
                  name: "music-summary",
                  parent: "music-image",
                  hook: Hook(parent_anchor: MR, self_anchor: BL),
                  offset: Vec2(x: 0.0, y: 0.0),
                  params: TextBlock((
                      text: "%s",
                      font: "${withSize variableWidth}",
                      ellipsize: NoEllipsize,
                      color: Color(hex: "#${fg}"),
                      color_hovered: Color(hex: "#fbf1c7"),
                      padding: Padding(left: 7.0, right: 7.0, top: 7.0, bottom: 7.0),
                      dimensions: (width: (min: 50, max: 250), height: (min: 0, max: 0)),
                  )),
              ),
              (
                  name: "music-body",
                  parent: "music-summary",
                  hook: Hook(parent_anchor: BL, self_anchor: TL),
                  offset: Vec2(x: 0.0, y: 12.0),
                  params: ScrollingTextBlock((
                      text: "%b",
                      font: "${withSize variableWidth}",
                      color: Color(hex: "#${fg1}"),
                      color_hovered: Color(hex: "#fbf1c7"),
                      padding: Padding(left: 7.0, right: 7.0, top: 3.0, bottom: 7.0),
                      width: (min: 150, max: 250),
                      scroll_speed: 0.1,
                      lhs_dist: 35.0,
                      rhs_dist: 35.0,
                      scroll_t: 1.0,
                  )),
              ),

              
              (
              	name: "volume-root",
          			parent: "",
          			offset: (x: 0, y: -70),
          			hook: Hook(parent_anchor: BM, self_anchor: BM),
          			render_criteria: [ Tag("volume") ],
          			params: NotificationBlock((
          				monitor: 0,	
                          border_width: 1,
                          border_rounding: 0,
                          background_color: Color(hex: "#e0${bg2}"),
                          border_color: Color(hex: "#${fg}"),
                          padding: Padding(Left: 0, Right: 0, Top: 0, Bottom: 0),
                          gap: Vec2(x: 0, y: 0),
                          notification_hook: Hook(parent_anchor: BL, self_anchor: TL),
          			)),
          	),

            
      		(
      			name: "volume",
      			parent: "volume-root",
      			offset: (x: 0, y: 0),
      			hook: (parent_anchor: MM, self_anchor: MM),
      			render_criteria: [ Progress ],
      			params: ProgressBlock((
      				padding: (left: 25, right: 25, top: 25, bottom: 25),
      				border_width: 0,
      				border_rounding: 0,
      				fill_rounding: 0,
      				border_color: (hex: "#00000000"),
      				background_color: (hex: "#${bg}"),
      				fill_color: (hex: "#${fg}"),
      				width: -1,
      				height: 15,
      			)),
      		),
      	],
      )
    '';
}
