###########################################
# Load aliases from bash_aliases if exists
###########################################
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export PATH=$HOME/.rbenv/shims:$PATH`
source 