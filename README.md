![CI workflow](https://github.com/moniquelive/rfc.nvim/actions/workflows/ci.yml/badge.svg?event=push)

# rfc.nvim

Browse your favorite RFC's, preview them and open them up on a vim buffer.

![Screenshot](screenshot.png)

### Installation

#### Lazy

```lua
{
    "moniquelive/rfc.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim" ,
    },
    config = function()
        require("telescope").load_extension("rfc")
    end,
}

```

#### Packer

```lua
use {
    "moniquelive/rfc.nvim",
    requires = {
        { "nvim-telescope/telescope.nvim" },
    },
}

```

#### vim-plug

```viml
Plug 'moniquelive/rfc.nvim'
Plug 'nvim-telescope/telescope.nvim'

```

## Setup

```lua
require('telescope').load_extension('rfc')

```

## Available commands

```viml
:Telescope rfc

--or--

"Using lua function
lua require('telescope').extensions.rfc.rfc()<cr>

```
