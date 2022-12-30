# $SHELL
set -gx SHELL (which fish)

# $GIT_EDITOR
set -gx GIT_EDITOR (which nvim)

# ASDF
source ~/.asdf/asdf.fish

# 1Password completion
op completion fish | source

# Deno
set -gx DENO_NO_UPDATE_CHECK 1
