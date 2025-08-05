# rndm - A Random Number Generator (for a Bashly tutorial)

Check the plan in [#1](https://github.com/meleu/rndm/issues/1).

## Commit History

### Very basic bashly.yml

[link to commit](https://github.com/meleu/rndm/commit/ae718c1434bbf2e1fe95bde8b570f7c125b87718)

Create a very basic bashly.yml

Run `./rndm --help` and look at the results.

We didn't write a single line of bash yet and got a professional looking
help message for a typical CLI.

If you ever wrote a bash script with such help message you know how
boring it is to write all the boilerplate code to achieve that. This is
the very first demonstration of how Bashly can make bash development
fun.

### Actual logic to print a random number

[link to commit](https://github.com/meleu/rndm/commit/54a1b81001628b90b2153884a5cd0dd3fa2e0e2c)

Note that the contents of the `root_command.sh` file is wrapped by a
function called `root_command()`.

### Add the '--web' flag

[link to commit](https://github.com/meleu/rndm/commit/bd4cfd0ef637570dc2e3649b9be7b28d1a4fdda7)

Some people take randomness very seriously (especially those who deal
with cryptography). Well, there's a web service called random.org that
is self described as "a true random number service that generates
randomness via atmospheric noise". The <https://random.org> website exists
since 1998 and is still running, then it must be true that they're good
with randomness.

They offer an HTTP API endpoint where we can send a request to get
random integers. Let's allow the users of `rndm` choose if they want
their random numbers from the `$RANDOM` variable or from random.org

First, let's add the `flag:` directive in our `bashly.yml`. Look at the
added lines and then run `./rndm --help` to see how such a simple
addition to the yaml generated a nice looking help message.

Then look at the implementation: a simple `curl` call sending a GET
request to the random.org endpoint responsible to generate integers.

The endpont was obtained from <https://www.random.org/clients/http/api/>

### List 'curl' as a dependency

[link to commit](https://github.com/meleu/rndm/commit/52675b7558b2f955582eb1ab8989211b526625ad)

As our script is now using 'curl', it's a dependency, and we should make
it explicit.

When rndm users run the script in an environment where `curl` is not
available, we should give them a clear error message.

By adding a list of dependencies in our `bashly.yml`, Bashly
automatically creates a dependency checking logic for the final script.

Running rndm in an environment without `curl` would fail with a message
like this:

```
$  ./rndm
missing dependency: curl
```

### Add the '-w' flag as a short version of '--web'

[link to commit](https://github.com/meleu/rndm/commit/b83cbce29daa4ccb567f6196d26419427e0592c7)

Bashly also allows us to easily add short versions of our flags.

### Add '--max' flag to specify maximum random number

[link to commit](https://github.com/meleu/rndm/commit/5c2e76aabff1a20cf076a4cb8323ab161da8ce94)

This is an example of how easy it is to create a flag that takes an
argument.

We are now allowing the user to specify the maximum random number to be
printed.

Look how Bashly automatically handles the mandatory argument the user
must pass to `--max` and we didn't need to spend our brain power with
such boilerplate logic!

There's a problem in our code though. If we don't explicitly specify the
maximum value our script doesn't work as expected.

Example:

```
$ ./rndm
0

$ ./rndm
0

$ ./rndm
0

$ ./rndm -w
Error: The maximum value must be an integer in the
[-1000000000,1000000000] interval
```

We need to code a default value for the `max_number`, and we're going to
do it in the next commit.

### Specify a default max value inside root_command.sh

[link to commit](https://github.com/meleu/rndm/commit/a3f39d8978ee066d292616d815bc6cb63cdc6ac4)

Here we solve the bug that was happening when not specifying the default
value for the maximum value.

### Bashly way to specify a default value

[link to commit](https://github.com/meleu/rndm/commit/fa7545f3fe57b43c2d3e212c939fc691bfca50ca)

This approach of defining a default value is slightly better, as Bashly
automatically adds such information in the help message and now the user
is aware about the default value.

We still have a problem though: What if the user passes a non-integer
value? We should make our program smart enough to not crash when the
user calls it like in this example: `rndm --max foo`. Let's address this
in the next commit.

### Validate --max argument as a positive integer

[link to commit](https://github.com/meleu/rndm/commit/2ae621fa596850c4cb4ac22a5b72305936589804)

Here we're using a regular expression to validate the input as positive
integer. This makes our program stronger but our code is starting to
become unpleasant to read.

In the next commit we're going to start using functions with clear name
to make our code easier to read and maintain.

### Move validation to a separate function

[link to commit](https://github.com/meleu/rndm/commit/ac7ff6df8423bb0ff6b2a56fbf409adb122ab9ec)

When we create a `src/lib/` dir and put bash files there, Bashly will
automatically get these files contents and put them in the final script.
This is a good way to keep our files simple and focused on specific
concerns.

Here we're creating the `src/lib/validations.sh` file.

Giving a clear name to an operation that involves regular expressions is
always good for a better reading. That's why we created the
`is_positive_integer` function.

We also created a `validate_positive_integer` function with the
responsibility to print an error message if the argument is not valid.

Now our main logic is a bit cleaner, with just one call to validate the
`max_number`.

This is separation of concerns: validation is one concern, generating
random numbers is another one.

In the next commit we're going to see how Bashly makes validations even
cleaner...

### Bashly way to validate input

[link to commit](https://github.com/meleu/rndm/commit/c3d89af0d303da9b2e96f13639f65f87982ef60d)

Bashly provides a clean way to add validation functions for our
arguments. It works like this:

- In `bashly.yml`, in the flag configuration we add a line like this:
`validate: function_name`.
- We create a function called `validate_function_name`, and now our
program run it before allowing the user input to pass.
- If the function prints any string to stdout, it is considered an
error. The string will be displayed on screen, as the error message.

In this commit we are using the `validate_positive_integer` for this
purpose.

Another benefit of validating input this way is that Bashly provides a
slightly better error message, with information about the validation
error. Example:

```
$ ./rndm --max foo
validation error in --max MAX:
The argument must be a positive integer. Given value: foo
```

### Add '--min' flag to specify minimum random number

[link to commit](https://github.com/meleu/rndm/commit/c42f2a09a51d0294a448ed6d11ae53e4d347a3d1)

We are adding the possibility to specify the minimum random number to be
generated.

Here we're also introducing short options: `-M` for `--max`, and `-m`
for `--min`.

But, what happens if the user gives a `--min` that is greater than
`--max`? Let's handle it in the next commit...
