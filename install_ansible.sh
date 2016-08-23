sudo apt-get install git python-pip
sudo apt-get install python-dev libffi-dev libssl-dev 
sudo pip install https://pypi.python.org/packages/3.4/s/setuptools/setuptools-11.3.1-py2.py3-none-any.whl
git clone https://github.com/ansible/ansible.git
cd ansible/
git checkout  v2.1.1.0-1
git submodule update --init --recursive
sudo make
sudo make install
cd ..

# Make sure the ansible file will be processed locally:

sudo mkdir /etc/ansible

sudo bash -c 'cat << EOF > /etc/ansible/hosts
localhost ansible_connection=local
EOF'	
