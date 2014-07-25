Ignoramos: A static-site generator
==================================

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
