# Instructions to self

## Add a new Formula

Cut a release on the GitHub repo tagged as `v<x.y.z>`, e.g. `v0.1.2`

This will make the URL `https://github.com/Mahoney/<repo>/archive/refs/tags/v<x.y.z>.tar.gz`

```shell
brew create `https://github.com/Mahoney/<repo>/archive/refs/tags/v<x.y.z>.tar.gz` \
  --tap Mahoney/homebrew-tap \
  --set-name <formula-name>
```

This will create it in `$(brew --prefix)/Library/Taps/mahoney/homebrew-tap`, where you can then edit it and commit it
etc.

## Update the latest release of a Formula

## Updating the .github repos

You can run:
```shell
brew tap-new Mahoney/homebrew-tap-tmp
```

This will create `/$(brew --prefix)/Library/Taps/mahoney/homebrew-tap-tmp`, and you can then copy the `.github` files
across.
