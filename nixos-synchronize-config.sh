#!/run/current-system/sw/bin/bash

git_commit_and_push() {
  FILE="$1"

  if [ -z "$FILE" ]; then
    echo "Usage: git_commit_and_push <file>"
    return 1
  fi

  if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' does not exist."
    return 1
  fi

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This is not a Git repository."
    return 1
  fi

  git add "$FILE"
  echo "File added."

  echo "Enter commit message: "
  read -r MESSAGE

  git commit -m "$MESSAGE"
  echo "Commit created."

  git push
  echo "Pushed to remote."
}

FILE="configuration.nix"

if [ ! -f "$FILE" ]; then
  echo "$FILE not found. Creating..."
  touch "$FILE"
else
  echo "$FILE already exists."
fi

if ! cmp -s /etc/nixos/configuration.nix $FILE; then
  cp /etc/nixos/configuration.nix $FILE
  echo "$FILE updated."
else
  echo "$FILE is already synchronized."
fi

if [ -d ".git" ]; then
  git_commit_and_push $FILE
else
  echo "Not a git repository."
  echo "Creating repository..."
  git init
  echo "Repository created."
  git_commit_and_push $FILE
fi

# cat /etc/nixos/configuration.nix
