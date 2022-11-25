Config {
    font        = "xft:Noto Sans Mono:size=11:bold:antialias=true:hinting=true,Font Awesome 6 Free Solid:size=11:antialias=true:hinting=true:style=Solid,Font Awesome 5 Brands:size=11:antialias=true:hinting=true:style=Regular"
	, bgColor	    = "#2e3440"
	, fgColor	    = "#d8dee9"
	, position    = Top
	, hideOnStart = False
	, allDesktops	= True
	, persistent  = True
	, commands    = [

    -- Keyboard language
    Run Kbd [ ("pt", "<fn=1>\xf11c</fn> PT"), ("us", "<fn=1>\xf11c</fn> US") ]

    -- Cpu usage in percent
    , Run Cpu ["-t", "<fn=1>\xf108</fn>  cpu: (<total>%)","-H","50","--high","red"] 20

    -- Volume
    , Run Com "echo" ["<fn=1>\xf028</fn>"] "volumeicon" 3600
    , Run Com "pamixer" ["--get-volume-human"] "volume"  10

    -- Ram used memory, number and percent
    , Run Memory ["-t", "<fn=1>\xf233</fn>  mem: <used>M (<usedratio>%)"] 20

    -- Time and date
    , Run Date "<fn=1>\xf017</fn>  %b %d %Y - (%H:%M:%S) " "date" 1

    -- Print Workspace
    , Run UnsafeStdinReader
    ]

    , sepChar        = "%"
    , alignSep       = "}{"
    , template = "%UnsafeStdinReader% }{  <fc=#bf616a><action=`alacritty -e htop -s PERCENT_CPU`>%cpu%</action></fc>    <fc=#d08770><action=`alacritty -e htop -s PERCENT_MEM`>%memory%</action></fc>    <fc=#a3be8c><action=`pamixer -t`>%volumeicon% %volume%</action> | %kbd%</fc>   <fc=#b48ead> <action=`xdg-open https://calendar.google.com/`>%date%</action></fc>"
}
