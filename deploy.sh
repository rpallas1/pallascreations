echo "--- Syncing with S3 Bucket ---"

aws s3 sync . s3://pallascreations.com --exclude ".git/*" --exclude ".DS_Store" --delete --exclude "deploy.sh" --exclude ".vscode/*"
output=$(aws cloudfront create-invalidation --distribution-id E2C690930API5P --paths "/*")
id=$(echo $output | jq -r ".Invalidation.Id")
status=$(echo $output | jq -r ".Invalidation.Status")

echo "--- Invalidating CloundFront Distribution ---"
echo "Status: $status"

while [ $(echo $output | jq -r ".Invalidation.Status") != "Completed" ]
do
    sleep 5
    output=$(aws cloudfront get-invalidation --distribution-id E2C690930API5P --id $id)
    status=$(echo $output | jq -r ".Invalidation.Status")
    echo "Status: $status"
done

echo "--- Deployment Complete ---"