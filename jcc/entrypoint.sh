#!/bin/bash
set -o nounset -o errexit -o xtrace;

cd "/opt/main";

export JAVA_HOME="/opt/lib/openlogic_openjdk__v_8u382_b05_linux_x64";
"/opt/lib/apache_ant__v_1_10_14/bin/ant";
