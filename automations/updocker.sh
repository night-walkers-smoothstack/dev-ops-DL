set -e

test ${2} || (echo "usage 'sh ${0} <SERVICE-NAME> <SUBMODULE-PATH>'" && false)

sed -e "s/<SERVICE-NAME>/${1}/g" \
    templates/Dockerfile > "${2}/Dockefile"

echo 'Dockerfiles updated'