bmd - Birder's Markdown
=======================

*under heavy development! Not everything described here already works*

## Introduction

### What is Markdown?

There are different approaches to mark texts and their parts and typographic features. In HTML, for instance, tags are used, that are rather intrusive and make a text look more like a software program than something for humans to read.

On the other hand, since the old days of the mechanical typewriter, people used asterisks and dashes and other 'small' characters to structure their texts and emphasize certain parts and single words.

For instance, they used a line of dashes in the line below the text to be underlined. Markdown, released in 2004 by John Gruber, transfered this idea to the computer age. Gruber wrote a small piece of software, that parsed Markdown texts and translated it into HTML.

### Why Markdown for Birders?

## The Software

### Concept

bmd consists of several small programs, specialized to do their task at hand as good as possible, but nothing more or different. This idea complies with the Unix philosophy for software tools.

### Tools

| command ||
|----------||
| bmd2json | Transcribes a bmd input file into a json string on standard output. The resulting string can be used as input for a NoSQL database or queries directly with JSON tools like *jq*.|
| bmdQuery | Runs several predifined queries on the JSON output of bmd2json, like for year list, life list, species count etc.|

### Installation

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
