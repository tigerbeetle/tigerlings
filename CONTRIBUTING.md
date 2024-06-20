# Contributing

Thanks for contributing to Tigerlings!

## Exercise Guidelines

- Exercise file names should start with a number and have a name that at least loosely describes what is being taught.
- Each exercise should ideally teach one concept.
- Exercises should be standalone and should not interact with one another (aside from depending on a running TigerBeetle cluster).
- Exercises should fail and exit with a non-zero error code.
- Let's make them fun!

## Adding Exercises

To add a new Tigerlings exercise:

1. Write the (failing) exercise as a bash script in [exercises](./exercises/).
2. Run `chmod +x exercises/*.sh` to make your script executable.
3. Add to the [What's Covered](README.md#whats-covered) list in the main README.
4. Create a commit with that exercise.
5. Fix the exercise so that it passes and returns a status code of 0.
6. Run the [tools/patches_generate.sh](./tools/patches_generate.sh) script.
7. Use `git add patches && git commit --amend` to add the patch file to your commit.
8. Run [tools/patches_revert.sh](./tools/patches_revert.sh) to revert the fix.
9. Submit a pull request with your new exercise.
