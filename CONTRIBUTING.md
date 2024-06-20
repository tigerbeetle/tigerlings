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
2. Add to the [What's Covered](README.md#whats-covered) list in the main README.
3. Create a commit with that exercise.
4. Fix the exercise so that it passes and returns a status code of 0.
5. Run the [tools/patches_generate.sh](./tools/patches_generate.sh) script.
6. Use `git add patches && git commit --amend` to add the patch file to your commit.
7. Run [tools/patches_revert.sh](./tools/patches_revert.sh) to revert the fix.
8. Submit a pull request with your new exercise.
