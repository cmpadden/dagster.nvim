![Banner](.github/banner.png)

# dagster.nvim

> [!WARNING]
> This project is under active development and is subject to change!

## Setup

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cmpadden/dagster.nvim",
  config = function()
    require('dagster').setup()
  end
}
```


## Usage

### `:Materialize`

Assets can be materialized by using the `:Materialize` user command.

![:Materialize Example](.github/screenshot-materialize.png)
