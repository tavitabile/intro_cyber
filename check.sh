#!/bin/bash
# Checks whether a setup script has correctly set up directories for the project.
# THIS SCRIPT MUST BE RUN WITH SUDO.

read -rp "Enter User 1 name: " user1
read -rp "Enter User 2 name: " user2
read -rp "Enter User 3 name: " user3

usernames=($user1 $user2 $user3)

echo -e "\nChecking if users exist..."
for username in "${usernames[@]}"
do
    if id "$username" &>/dev/null; then
        echo "User '$username' exists."
    else
        echo "ERROR: User '$username' does not exist."
    fi
done

echo -e "\nChecking if home directories exist..."
for username in "${usernames[@]}"
do
    dir="/home/$username"
    if [[ -d "$dir" ]]; then
        echo "Directory '$dir' exists."
    else
        echo "ERROR: Directory '$dir' does not exist."
    fi
done

echo -e "\nChecking if homework directories exist..."
for username in "${usernames[@]}"
do
    dir="/home/$username/homework"
    if [[ -d "$dir" ]]; then
        echo "Directory '$dir' exists."
    else
        echo "ERROR: Directory '$dir' does not exist."
    fi
done

echo -e "\nChecking if projects directories exist..."
for username in "${usernames[@]}"
do
    dir="/home/$username/projects"
    if [[ -d "$dir" ]]; then
        echo "Directory '$dir' exists."
    else
        echo "ERROR: Directory '$dir' does not exist."
    fi
done

echo -e "\nChecking if homework1 file exists..."
file="/home/$user1/homework/homework1"
if [[ -f "$file" ]]; then
    echo "File $file exists."
else
    filetxt="/home/$user1/homework/homework1.txt"
    if [[ -f "$filetxt" ]]; then
        file=$filetxt
        echo "File $file exists."
    else
        echo "ERROR: File '$file' does not exist."
    fi
fi

echo -e "\nChecking homework1 file..."
if head -n 1 -- "$file" | grep -iq "My Answers"; then
    echo "$file contains 'My Answers'"
else
    echo "ERROR: $file does not contain 'My Answers'"
fi

echo -e "\nChecking if the hard link exists..."
hardlink="/home/$user2/homework/homework1"
if [[ -f "$hardlink" ]]; then
    echo "File $hardlink exists."
else
    hardlinktxt="/home/$user2/homework/homework1.txt"
    if [[ -f "$hardlinktxt" ]]; then
        hardlink=$hardlinktxt
        echo "File $hardlink exists."
    else
        echo "ERROR: File '$hardlink' does not exist."
    fi
fi

echo -e "\nChecking the hard link..."
if [[ -e "$file" && "$file" -ef "$hardlink" ]]; then
    echo "$hardlink is a hard link to $file"
else
    echo "ERROR: $hardlink is not a hard link to $file."
fi

echo -e "\nChecking if the symbolic link exists..."
symlink="/home/$user3/homework/homework1"
if [[ -f "$symlink" ]]; then
    echo "File $symlink exists."
else
    symlinktxt="/home/$user3/homework/homework1.txt"
    if [[ -f "$symlinktxt" ]]; then
        symlink=$symlinktxt
        echo "File $symlink exists."
    else
        echo "ERROR: File '$symlink' does not exist."
    fi
fi

echo -e "\nChecking the symbolic link..."
if [[ -L "$symlink" ]]; then
    echo "$symlink is a symbolic link."
    actual_target=$(readlink -f "$symlink")
    expected_resolved=$(readlink -f "$file")
    if [[ "$actual_target" == "$expected_resolved" ]]; then
        echo "'$symlink' points to '$actual_target' as expected."
    else
        echo "ERROR: '$symlink' points to '$actual_target', expected '$expected_resolved'."
    fi
else
    echo "ERROR: $symlink is not a symbolic link."
fi
