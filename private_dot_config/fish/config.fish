# Setup $SHELL
set -gx SHELL (which fish)

# Setup ASDF
source ~/.asdf/asdf.fish

# Setup 1Password completion
op completion fish | source
