set -e

test ${2} || (echo "usage 'sh ${0} <NAME> <VERSION> <REGISTRY> <AWS_REGION> <SUBMODULE-PATH>'" && false)

sed -e "s/<NAME>/${1}/g" \
    -e "s/<VERSION>/${2}/g" \
    -e "s/<REGISTRY>/${3}/g" \
    -e "s/<AWS_REGION>/${4}/g" \
    templates/Jenkinsfile > "${5}/Jenkinsfile"

echo 'Jenkinsfiles updated'