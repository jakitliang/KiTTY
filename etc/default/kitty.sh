#!/bin/sh

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

function getSimpleGitBranch() {
  gitDir=".git"
  [ ! -f "$gitDir/HEAD" ] && return 0

  headContent=$(cat "$gitDir/HEAD" 2>/dev/null) || return 0

  case "$headContent" in
    "ref: refs/heads/"*)
      echo " (${headContent:16})"
      ;;
    *)
      echo " (HEAD detached at ${headContent:0:7})"
      ;;
  esac
}

PS1='\[\033[01;32m\]\w'
PS1="$PS1"'\[\033[37;1m\]'
PS1="$PS1"'`getSimpleGitBranch`'
PS1="$PS1"'\n\[\033[90m\]\$\[\033[00m\] '
