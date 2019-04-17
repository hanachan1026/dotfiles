which pip >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo "install homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "homebrew is already installed."
fi

which ansible >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo "install ansible"
  brew install ansible
else
  echo "ansible is already installed."
fi
