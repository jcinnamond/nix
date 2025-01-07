{ config, ... }:
let
  colors = config.style.colors.withHash;
  font = config.style.fonts.variableWidth;
in
{
  config.services.wired = {
    enable = true;
  };
  config.xdg.configFile."wired/wired.ron".text = ''
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
                render_anti_criteria: [ Or([AppName("Spotify"), Tag("volume")]) ],
                params: NotificationBlock((
                    monitor: 0,
                    border_width: 2,
                    border_rounding: 12.0,
                    background_color: Color(hex: "#44121212"),
                    border_color: Color(hex: "#ff000000"),
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
                    font: "${font} Bold 12",
                    ellipsize: Middle,
                    color: Color(hex: "${colors.fg}"),
                    padding: Padding(left: 7.0, right: 7.0, top: 7.0, bottom: 0.0),
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
                    font: "${font} 12",
                    color: Color(hex: "${colors.fg0}"),
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
    			name: "spotify",
    			parent: "",
    			offset: (x: 0, y: -40),
    			hook: Hook(parent_anchor: BM, self_anchor: BM),
    			render_criteria: [ AppName("Spotify") ],
    			params: NotificationBlock((
    				monitor: 0,
                    border_width: 0.0,
                    border_rounding: 16.0,
                    background_color: Color(hex: "#cc333333"),
                    border_color: Color(hex: "#ff000000"),
                    padding: Padding(Left: 20, Right: 20, Top: 12, Bottom: 12),
                    gap: Vec2(x: 0.0, y: 0.0),
                    notification_hook: Hook(parent_anchor: BL, self_anchor: TL),
    			)),
    		),
    		(
    			name: "spotify-image",
    			parent: "spotify",
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
                name: "spotify-summary",
                parent: "spotify-image",
                hook: Hook(parent_anchor: MR, self_anchor: BL),
                offset: Vec2(x: 0.0, y: 0.0),
                params: TextBlock((
                    text: "%s",
                    font: "DejaVu Sans 12",
                    ellipsize: NoEllipsize,
                    color: Color(hex: "#f7f7f7"),
                    color_hovered: Color(hex: "#fbf1c7"),
                    padding: Padding(left: 7.0, right: 7.0, top: 7.0, bottom: 7.0),
                    dimensions: (width: (min: 50, max: 250), height: (min: 0, max: 0)),
                )),
            ),
            (
                name: "spotify-body",
                parent: "spotify-summary",
                hook: Hook(parent_anchor: BL, self_anchor: TL),
                offset: Vec2(x: 0.0, y: 12.0),
                params: ScrollingTextBlock((
                    text: "%b",
                    font: "DejaVu Sans 12",
                    color: Color(hex: "#cccccc"),
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
    			offset: (x: 0, y: -100),
    			hook: Hook(parent_anchor: BM, self_anchor: BM),
    			render_criteria: [ Tag("volume") ],
    			params: NotificationBlock((
    				monitor: 0,	
                    border_width: 0.0,
                    border_rounding: 8.0,
                    background_color: Color(hex: "#dd2f2f2f"),
                    border_color: Color(hex: "#ff000000"),
                    padding: Padding(Left: 12, Right: 12, Top: 12, Bottom: 12),
                    gap: Vec2(x: 0.0, y: 0.0),
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
    				padding: (left: 7, right: 7, top: 7, bottom: 7),
    				border_width: 0.0,
    				border_rounding: 6.0,
    				fill_rounding: 6.0,
    				border_color: (hex: "#ff000000"),
    				background_color: (hex: "#171717"),
    				fill_color: (hex: "#cccccc"),
    				width: -1,
    				height: 12.0,
    			)),
    		),
    	],
    )
  '';
}
