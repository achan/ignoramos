Ignoramos: A static-site generator
==================================

[![Build
Status](https://travis-ci.org/achan/ignoramos.svg?branch=master)](https://travis-ci.org/achan/ignoramos)
[![Code
Climate](https://codeclimate.com/github/achan/ignoramos/badges/gpa.svg)](https://codeclimate.com/github/achan/ignoramos)
[![Coverage
Status](https://img.shields.io/coveralls/achan/ignoramos.svg)](https://coveralls.io/r/achan/ignoramos)

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
$ ignoramos build
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
