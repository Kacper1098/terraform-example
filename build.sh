read -r -p "Enter project name: " project
image_name="gcr.io/${project}/app"
docker build -t  "${image_name}" .
docker push "${image_name}"

$SHELL
