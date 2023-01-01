# $SHELL
set -gx SHELL (which fish)

# $GIT_EDITOR
if type -sq nvim
  set -gx GIT_EDITOR (which nvim)
end

fish_add_path ~/.local/bin

# ASDF
source ~/.asdf/asdf.fish

# 1Password completion
if type -sq op
  op completion fish | source
end

# Deno
set -gx DENO_NO_UPDATE_CHECK 1
