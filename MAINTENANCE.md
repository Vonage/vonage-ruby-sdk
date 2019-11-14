# Maintenance

* New commits are pushed to the `develop` branch or their own feature branch and merged into `develop`.
* The `master` branch is to be kept up to date with the latest release on [RubyGems.org](https://rubygems.org).
* Publish a new release using the following steps:
  * Update the gem version in `lib/nexmo/version.rb` and the changelog in `CHANGES.md`
  * Build the gem
  * Push the built gem to https://rubygems.org
  * Tag the new release
  * Merge the `develop` branch into the `master` branch
  * Push the new tag to GitHub
  * Push the `master` branch to GitHub
  * Push the `develop` branch to GitHub
