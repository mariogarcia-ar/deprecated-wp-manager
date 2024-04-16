You can use the `wp-cli` command-line tool along with the `fakerpress` plugin to generate lorem ipsum data for your WordPress site. Here's how you can do it:

1. First, navigate to your WordPress directory and install the `fakerpress` plugin using `wp-cli`:

```bash
wp plugin install fakerpress --activate
```

2. Now, you can use `wp-cli` to generate posts, pages, comments, and other types of content. Here are some examples:

Generate 50 posts:

```bash
wp fakerpress generate posts --count=50
```

Generate 10 pages:

```bash
wp fakerpress generate posts --count=10 --type=page
```

Generate 100 comments:

```bash
wp fakerpress generate comments --count=100
```

You can customize these commands to generate the amount and type of content that you need.

3. When you're done generating content, you can deactivate and delete the `fakerpress` plugin:

```bash
wp plugin deactivate fakerpress
wp plugin delete fakerpress
```

Remember to replace `wp` with the actual path to your `wp-cli` executable if it's not in your PATH.