bmd - Birder's Markdown
=======================

## Introduction

### What is Markdown?

There are different approaches to mark texts and their parts and typographic features. In HTML, for instance, tags are used, that are rather intrusive and make a text look more like a software program than something for humans to read.

On the other hand, since the old days of the mechanical typewriter, people used asterisks and dashes and other 'small' characters to structure their texts and emphasize certain parts and single words.

For instance, they used a line of dashes in the line below for the text to be underlined. Markdown, released in 2004 by John Gruber, transfered this idea to the computer age. Gruber wrote a small piece of software, that parsed 'Markdown' texts and translated it into HTML.

### Why Markdown for Birders?

Using simple text files for keeping your observations instead of elaborate GUI based software might not be everyone's cup of tea. For me, there were two main reasons to go that way:

1. when I started to think about that approach, there was no reasonable software solution available for Linux for bird logging. In the meantime, there is the really fine 'Scythebill' software, that is free and available for all platforms.

2. I was never content with the ways of entering observations. They seemed to be too cumbersome to me. That is why I wanted something similar to my paper bird notebook.

With bmd, I enter observations just as I do in by paper notebook: In the first line date and location, then optionally observers' names, followed by species line by line. For every species in a line, additional information can be added, and notes be attached in following lines.

bmd files are easy to write and read for humans, and are easy to parse for computers. Actually, the bmd parser creates JSON as its output from a .bmd file, a kind of database of the obsrevations. This output can subsequently be used by other tools to generate lists, counts, maps, …

## The Software

### Concept

bmd consists of several small programs, specialized to do their task at hand as good as possible, but nothing more or different. This idea complies with the Unix philosophy for software tools.

### Tools

| command  | explanation |
|:---------|:------------|
| bmd2json | Transcribes a bmd input file into a json string on standard output. The resulting string can be used as input for a NoSQL database or queries directly with JSON tools like *jq*.|

### Installation

At the moment, you have to have 'node' installed and 'jison'. Jison can be installed with `sudo npm install jison`. The parser for bmd will then be created with `jison bmdPaser.jison`.

### Use

#### bmd2json

```sh
./bmd2json test.bmd
```
Will write a JSON representation of the observation data from the .bmd file.

```sh
./bmd2json test.bmd | jq '[.[].trip]'
```
Filters the JSON output and returns an array of all trips from the .bmd file, using the third party tool *jq*.
