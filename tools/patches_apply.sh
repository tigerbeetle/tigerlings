# Iterate over each patch file in the directory
for patch_file in ./patches/*.patch; do
    # Apply the patch using git
    git apply "$patch_file"
done
