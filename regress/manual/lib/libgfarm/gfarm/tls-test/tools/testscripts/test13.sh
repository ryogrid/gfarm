#!/bin/sh

TOP_DIR=`dirname $0`
TOP_DIR=`cd ${TOP_DIR}; pwd`
TOP_DIR=`cd ${TOP_DIR}/../../; pwd`

source ${TOP_DIR}/tools/testscripts/lib/funcs.sh

ENV_DIR="${TOP_DIR}/test_dir/proxy_cert"
TMP_CERT=/tmp/x509up_u${UID}
debug_flag=0
fail_num=0

# funcs.
usage(){
	cat << EOS >&2
Usage:

	OPTION:
		-d			Debug flag
		-h			Help
EOS
exit 0
}

copy_tmp_cert() {
    cp -p $1 ${TMP_CERT}
}

remove_tmp_cert() {
    rm -f ${TMP_CERT}
}

cleanup() {
    remove_tmp_cert
}

trap "cleanup" 1 2 3 15

## Opts. ##
while getopts d OPT; do
	case ${OPT} in
		d) debug_flag=1;;
		h) usage;;
		*) usage;;
	esac
done
shift `expr $OPTIND - 1`

# main

# 13-1
run_test_for_single "13-1" "client" \
    "${TOP_DIR}/tls-test \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --mutual_authentication" ${debug_flag}

if [ $? -ne 0 ]; then
	fail_num=`expr ${fail_num} + 1`
fi


# 13-2
run_test "13-2" \
    "${TOP_DIR}/tls-test -s \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --tls_certificate_file ${ENV_DIR}/A/server_under_root/server.crt \
    --tls_key_file ${ENV_DIR}/A/server_under_root/server.key \
    --build_chain \
    --proxy_cert \
    --mutual_authentication" \
    "X509_USER_PROXY=${ENV_DIR}/A/client_under_root/client_cat_all.crt \
    ${TOP_DIR}/tls-test \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --proxy_cert \
    --mutual_authentication" ${debug_flag}

if [ $? -ne 0 ]; then
	fail_num=`expr ${fail_num} + 1`
fi


# 13-3
copy_tmp_cert ${ENV_DIR}/A/client_under_root/client_cat_all.crt

run_test "13-3" \
    "${TOP_DIR}/tls-test -s \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --tls_certificate_file ${ENV_DIR}/A/server_under_root/server.crt \
    --tls_key_file ${ENV_DIR}/A/server_under_root/server.key \
    --build_chain \
    --proxy_cert \
    --mutual_authentication" \
    "${TOP_DIR}/tls-test \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --proxy_cert \
    --mutual_authentication" ${debug_flag}

if [ $? -ne 0 ]; then
	fail_num=`expr ${fail_num} + 1`
fi

remove_tmp_cert


# 13-4
copy_tmp_cert ${ENV_DIR}/A/client_under_root/client_cat_all.crt

run_test "13-4" \
    "${TOP_DIR}/tls-test -s \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --tls_certificate_file ${ENV_DIR}/A/server_under_root/server.crt \
    --tls_key_file ${ENV_DIR}/A/server_under_root/server.key \
    --build_chain \
    --mutual_authentication" \
    "${TOP_DIR}/tls-test \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --proxy_cert \
    --mutual_authentication" ${debug_flag}

if [ $? -ne 0 ]; then
	fail_num=`expr ${fail_num} + 1`
fi

remove_tmp_cert


# 13-5
run_test "13-5" \
    "${TOP_DIR}/tls-test -s \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --tls_certificate_file ${ENV_DIR}/A/server_under_root/server.crt \
    --tls_key_file ${ENV_DIR}/A/server_under_root/server.key \
    --build_chain \
    --mutual_authentication" \
    "X509_USER_PROXY=${ENV_DIR}/A/client_under_root/client_cat_all.crt \
    ${TOP_DIR}/tls-test \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --tls_certificate_file ${ENV_DIR}/A/client_under_root/client.crt \
    --tls_key_file ${ENV_DIR}/A/client_under_root/client.key \
    --proxy_cert \
    --mutual_authentication" ${debug_flag}

if [ $? -ne 0 ]; then
	fail_num=`expr ${fail_num} + 1`
fi


# 13-6
run_test "13-6" \
    "${TOP_DIR}/tls-test -s \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --tls_certificate_file ${ENV_DIR}/A/server_under_root/server.crt \
    --tls_key_file ${ENV_DIR}/A/server_under_root/server.key \
    --build_chain \
    --proxy_cert \
    --mutual_authentication" \
    "X509_USER_PROXY=${ENV_DIR}/A/client_under_root/client_cat_all.crt \
    ${TOP_DIR}/tls-test \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --tls_certificate_file ${ENV_DIR}/A/client_under_root/client.crt \
    --tls_key_file ${ENV_DIR}/A/client_under_root/client.key \
    --proxy_cert \
    --mutual_authentication" ${debug_flag}

if [ $? -ne 0 ]; then
	fail_num=`expr ${fail_num} + 1`
fi


# 13-7
copy_tmp_cert ${ENV_DIR}/A/client_under_root/client_cat_all_bad_permissions.crt

run_test_for_single "13-7" "client" \
    "${TOP_DIR}/tls-test \
    --once \
    --verify_only \
    --allow_no_crl \
    --tls_ca_certificate_path ${ENV_DIR}/A/cacerts_root/ \
    --proxy_cert \
    --mutual_authentication" ${debug_flag}

if [ $? -ne 0 ]; then
	fail_num=`expr ${fail_num} + 1`
fi

remove_tmp_cert


exit ${fail_num}
