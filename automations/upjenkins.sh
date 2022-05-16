set -e

test ${2} && (echo "usage 'sh ${0} <PATH>'" && false)
test -d ${1} || (echo "directory does not exist" && false)

cp templates/Jenkinsfile "${1}/"

echo 'Jenkinsfiles updated'