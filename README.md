bmd
=========

bmd is a Markdown language for birders to make their electronic field notes as computer friendly as they are read- and writable by humans.

Version
----

pre-Everything


Use
--------------

Install jison:

```sh
npm install -g jison
```

Fetch code:

```sh
git clone https://github.com/recumbentbirder/bmd.git
```

Compile parser:

```sh
jison bmd.jison
```

Run bmd (e.g. on 'test.bmd' example file):

```sh
nodejs bmd.js test.bmd
```

The output is a JSON string that you can process further with any JSON tool, like 'jq'.
