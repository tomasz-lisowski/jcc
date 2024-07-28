#!/bin/bash
set -o nounset -o errexit -o xtrace;

cd "/opt/main";

export JAVA_HOME="/opt/lib/amazon_corretto_8_x64_linux_jdk";
"/opt/lib/apache_ant__v_1_10_14/bin/ant";
