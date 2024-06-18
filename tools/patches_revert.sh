for patch_file in ./patches/*.patch; do
    # Revert the patch using git
    git apply -R "$patch_file"
done
