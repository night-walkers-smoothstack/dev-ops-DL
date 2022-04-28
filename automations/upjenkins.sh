set -e

test ${2} || (echo "usage 'sh ${0} <NAME> <VERSION> <REGISTRY> <AWS_REGION> <SUBMODULE-PATH>'" && false)

sed -e "s/<NAME>/${1}/g" \
    -e "s/<VERSION>/${2}/g" \
    -e "s/<AWS_REGION>/${3}/g" \
    templates/Jenkinsfile > "${4}/Jenkinsfile"

echo 'Jenkinsfiles updated'