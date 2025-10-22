# tmux-sessionator
With ```tmux-sessionator```, creating session layouts is as simple as arranging
your panes and windows as you like and hitting ```prefix + S```. Session
layouts can be loaded using the built-in ```prefix + R```. Better yet, integrate
session loading with another tool using the provided script.
```tmux-sessionator``` is built purely in ```bash```with no extra dependencies
allowing you to run the plugin practically anywhere with zero fuss.

### Why another tmux session manager?

Other session managers require you to write a JSON, YAML or some other config
file for every session layout. This did not fit with my desired workflow.
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) can work as a
session manager without config files by allowing you to save/restore your tmux
environment. This only works if you are willing to keep every session you want
to save open in perpetuity. I prefer to use tmux-resurrect to preserve my tmux
environment between shutdowns. I'd also like to launch my session layouts in a
fresh state, but tmux-resurrect saves everything, everywhere, all at once which
would overwrite my carefully constructed session layout. The ```freeze```
command from [tmuxp](https://github.com/tmux-python/tmuxp) works similarly to
tmux-sessionator, but I did not like its dependency on python, and I figured I
could write something similar in bash.

### Installation with Tmux Plugin Manager (recommended)

First, make sure [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) is
installed.

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'ctkerns/tmux-sessionator'

Hitting `prefix + I` in tmux will now fetch the plugin.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/ctkerns/tmux-sessionator ~/INSTALL_PATH

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/INSTALL_PATH/sessionator.tmux

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`.
You should now be able to use the plugin.

### Getting started.

To save a session, first arrange it how you would expect it to be restored.
tmux-sessionator will save your windows, pane layouts, and active commands when
pressing ```prefix + S```. Session layouts are stored in
```~/.tmux/plugins/sessionator/```.

The built-in ```prefix + R``` allows you to type the name of a session to
switch to. ```prefix + R``` will prompt you to enter a session name (and
optionally a directory). If the session is already open, tmux-sessionator will
switch to it. Otherwise, it will find the layout file to load the session from.
If no layout file exists, a new session with the provided name can be created.
If the optional directory was specified, the newly created session will begin
in this directory.

If the session is not open, but a layout file already exists, the session
will be initialized from the layout file. 

### Integrating with other tools.
```prefix + R``` is just a shortcut for running the script
```INSTALL_PATH/sessionator/scripts/load-layout.sh```. You can run this script
directly with the same arguments accepted by ```prefix + R```. The session
layouts are stored at ```~/.local/share/tmux/sessionator/```. You could
fuzzy-find this directory and pipe the output to load-layout.sh to create a
simple session loader. Personally, I fuzzy-find directories likely to contain
projects and pipe the selected basename and directory into load-layout.sh.

Beyond writing session manageement scripts, I'm not sure how to integrate
tmux-sessionator with other plugins. If you have managed to do this, let me
know your approach so that it can be added here for the reference of others.

### Goals and Anti-Goals
For now, this plugin accomplishes what I want it to do: automatically create
layouts as a helpful starting point when launching a session. The goal is not
to pick up where tmux last left off, so many elements of the session state
should not be serialized into the layout file.

If you have a suggestion for a feature that would make this plugin more useful
inline with this plugin's goals, please feel free to share it or contribute a
pull request.

### Acknowledgements.
tmux-resurrect is an invaluable reference in the creation of this plugin.
