#!/bin/bash

readonly operation=${1:?Argument 1 missing: Expected operation \"delete\", \"install\", or \"list\".};
readonly pcsc_reader_index=${2:?Argument 2 missing: Expected PC/SC reader index.};
readonly kic=${3:?Argument 3 missing: Expected KIC1 of the card.};
readonly kid=${4:?Argument 4 missing: Expected KID1 of the card.};

pcscd;
pcsc_scan -n -c;

case ${operation} in
    delete)
        printf "Deleting applet. Note that there is no output so the KIC and/or KID values can be silently incorrect (double check this with the \"list\" operation).\\n";
        readonly module_aid=${5:?Argument 5 missing: Expected a module AID of the cardlet that should be deleted.};
        python2.7 /opt/sim_tools/shadysim/shadysim_isim.py --pcsc="${pcsc_reader_index}" --delete-app="${module_aid}" --kic="${kic}" --kid="${kid}";
    ;;

    install)
        printf "Installing applet. Note that there is no output so the KIC and/or KID values can be silently incorrect (double check this with the \"list\" operation).\\n";
        readonly filename=${5:?Argument 5 missing: Expected filename of the CAP file.};
        readonly module_aid=${6:?Argument 6 missing: Expected a module AID of the cardlet that should be installed.};
        readonly instance_aid=${7:?Argument 7 missing: Expected an instance AID of the cardlet that should be installed.};
        readonly memory_nonvolatile=${8:?Argument 8 missing: Expected non-volatile memory required.};
        readonly memory_volatile=${9:?Argument 9 missing: Expected volatile memory required.};
        readonly menu_height=${10:?Argument 10 missing: Expected max number of menu entries.};
        readonly menu_width=${11:?Argument 11 missing: Expected max text length of menu entry.};
        readonly access_domain=${12:?Argument 12 missing: Expected access domain. If you do not know what this is for, please set it to \"FF\".};
        python2.7 /opt/sim_tools/shadysim/shadysim_isim.py --pcsc="${pcsc_reader_index}" --load-app="/opt/main/"${filename}"" --install="/opt/main/"${filename}"" --kic="${kic}" --kid="${kid}" --instance-aid="${instance_aid}" --module-aid="${module_aid}" --nonvolatile-memory-required="${memory_nonvolatile}" --volatile-memory-for-install="${memory_volatile}" --enable-sim-toolkit --max-menu-entry-text="${menu_width}" --max-menu-entries="${menu_height}" --access-domain="${access_domain}";
    ;;

    list)
        printf "Below is a list of all installed applets. Note that if there is no output, the KIC and/or KID values are most likely incorrect.\\n";
        python2.7 /opt/sim_tools/shadysim/shadysim_isim.py --pcsc="${pcsc_reader_index}" --list-applets --kic="${kic}" --kid="${kid}";
    ;;
esac
