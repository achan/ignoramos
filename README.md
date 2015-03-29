Ignoramos: A static-site generator
==================================

[![Build Status](https://travis-ci.org/achan/ignoramos.svg?branch=master)](https://travis-ci.org/achan/ignoramos)
[![Code Climate](https://codeclimate.com/github/achan/ignoramos/badges/gpa.svg)](https://codeclimate.com/github/achan/ignoramos)
[![Coverage Status](https://coveralls.io/repos/achan/ignoramos/badge.png)](https://coveralls.io/r/achan/ignoramos)
[![Gem Version](https://badge.fury.io/rb/ignoramos.svg)](http://badge.fury.io/rb/ignoramos)

Getting started
===============

```
~ $ gem install ignoramos
~ $ ignoramos new mysite
```

The `new` command will create a directory with the name provided and the
directory structure below.

Directory structure
===================

```
.
├── _config.yml
├── _drafts
|   ├── not-ready-to-be-published.md
|   └── to-be-reviewed-by-editor.md
├── _includes
|   ├── footer.html
|   └── header.html
├── _layouts
|   ├── default.html
|   └── post.html
├── _posts
|   ├── 2014-06-22-hello-world.md
|   └── 2014-07-19-hello-world-pt-2.md
└── _site
    └── <point web root here>
```

```
~ $ ignoramos build
```

The `build` command is expected to be run at the root directory of the
application. It will generate all posts in the `_posts` directory and copy
every file not prefixed with `_` into `_site`.

How posts are built
===================

 - Load the markdown file
 - Parse the post for YAML to determine layout
 - Render layout as content
 - Render liquid layout (header, footer, content)

After all posts and pages are generated, all remaining files that are not from
a folder prefixed with `_` will be copied over to `_site`. Custom files take
precedence, so if your files conflict with generated ones, yours will overwrite
the generated file.

Microblogging
===============

Currently, the only external microblogging platform that is supported is Twitter:

```
~ $ ignoramos tweet "hello world #testing"
```

This command will post to twitter and create a micro blog in your `_posts`
directory with filename: `tweet-#{twitter_id}.md` with the following contents:

```
---
title: tweet 526064479298396163
timestamp: 2014-10-25T13:35:20-04:00
layout: tweet
tweet: https://twitter.com/amoschan/status/526064479298396163
---

hello world #testing
```

Similarly, you can import existing tweets into your blog after the fact:

```
~ $ ignoramos import_tweet 526064479298396163
```

It is them up to your theme to support the `tweet` layout and optionally use the
`tweet` variable to link back to Twitter.

For an example of tweets in action, see the [achan/amoschan][ac] theme.

[ac]: https://github.com/achan/amoschan/commit/f15c149e531a35f9c3a38f8c49311a0f3ce7c612
