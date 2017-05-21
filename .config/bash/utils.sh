function ScriptDir {
  echo "$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

# Add the utilities in the utils/ directory to the path.
export PATH=$PATH:$(ScriptDir)/utils
