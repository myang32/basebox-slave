#!/bin/bash
if [ ! -d resources/ ]; then
  mkdir -p resources
fi
if [ ! -f resources/Vagrantfile-global ]; then
  if [ -f /vagrant/resources/basebox-slave/Vagrantfile-global ]; then
    echo "Deploying Vagrantfile-global from Host to vApp sync folder"
    cp /vagrant/resources/basebox-slave/Vagrantfile-global resources/Vagrantfile-global
  fi
fi
if [ ! -f resources/test-box-vcloud-credentials.bat ]; then
  if [ -f /vagrant/resources/basebox-slave/test-box-vcloud-credentials.bat ]; then
    echo "Deploying test-box-vcloud-credentials.bat from Host to vApp sync folder"
    cp /vagrant/resources/basebox-slave/test-box-vcloud-credentials.bat resources/test-box-vcloud-credentials.bat
  fi
fi
if [ ! -f resources/upload-vcloud-credentials.bat ]; then
  if [ -f /vagrant/resources/basebox-slave/upload-vcloud-credentials.bat ]; then
    echo "Deploying upload-vcloud-credentials.bat from Host to vApp sync folder"
    cp /vagrant/resources/basebox-slave/upload-vcloud-credentials.bat resources/upload-vcloud-credentials.bat
  fi
fi
if [ ! -f resources/hosts ]; then
  if [ -f /vagrant/resources/basebox-slave/hosts ]; then
    echo "Deploying additional hosts entries"
    cp /vagrant/resources/basebox-slave/hosts resources/hosts
  fi
fi
if [ ! -f resources/license.lic ]; then
  if [ -f /vagrant/resources/basebox-slave/license.lic ]; then
    echo "Deploying Vagrant VMware Workstation license.lic"
    cp /vagrant/resources/basebox-slave/license.lic resources/license.lic
  fi
fi
if [ ! -f resources/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml ]; then
  if [ -f /vagrant/resources/basebox-slave/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml ]; then
    echo "Deploying Publish Over SSH Configuration jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml"
    cp /vagrant/resources/basebox-slave/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml resources/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml
  fi
fi
