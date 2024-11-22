> [!WARNING]
> This project is under active development and is subject to change!

<div align="center">
    <img alt="Banner" src=".github/banner.png">
    <br>
    <p>
        <i>Control <a href="https://dagster.io">Dagster</a> directly from Neovim.</i>
    </p>
</div>

# dagster.nvim

## Setup

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cmpadden/dagster.nvim",
  opts = {
    dagster_binary = 'dagster'  -- path to `dagster` binary (default: 'dagster')
  }
}
```

## Usage

### `:Dagster [ARGS]...`

Any `dagster` can be run through the `:Dagster` command. See an example of running `dagster definitions validate` in the screenshot below.

[![asciicast](https://asciinema.org/a/691688.svg)](https://asciinema.org/a/691688)

### `:Materialize <SELECT>`

Assets can be materialized by using the `:Materialize` user command and supplying a selector string.

Or by creating a visual selection, and then running the command `:'<,'>Materialize`.

[![asciicast](https://asciinema.org/a/691691.svg)](https://asciinema.org/a/691691)
