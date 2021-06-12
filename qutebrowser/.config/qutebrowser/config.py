# Load settings configured via GUI
config.load_autoconfig()

# c.auto_save.session = True
c.scrolling.smooth = True
c.session.lazy_restore = True
c.content.autoplay = False

c.fonts.default_size = "14pt"

# Scale pages and UI better for hidpi
c.zoom.default = "120%"
c.fonts.hints = "bold 16pt monospace"

# Better default fonts
c.fonts.web.family.standard = "Bitstream Vera Sans"
c.fonts.web.family.serif = "Bitstream Vera Serif"
c.fonts.web.family.sans_serif = "Bitstream Vera Sans"
c.fonts.web.family.fixed = "Fira Mono"
c.fonts.statusbar = "14pt Cantarell"

# Use dark mode where possible
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.bg = "black"

# Automatically turn on insert mode when a loaded page focuses a text field
c.input.insert_mode.auto_load = True

# Make Ctrl+g quit everything like in Emacs
config.bind('<Ctrl-g>', 'mode-leave', mode='insert')
config.bind('<Ctrl-g>', 'mode-leave', mode='command')
config.bind('<Ctrl-g>', 'mode-leave', mode='prompt')
config.bind('<Ctrl-g>', 'mode-leave', mode='hint')

# Some other bindings
config.bind(',m', 'hint links spawn mpv {hint-url}')
