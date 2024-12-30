![CI workflow](https://github.com/moniquelive/rfc.nvim/actions/workflows/ci.yml/badge.svg?event=push)

# rfc.nvim

Browse your favorite RFC's, preview them and open them up on a vim buffer.

### Installation

#### Lazy

```lua
{
    "moniquelive/rfc.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim" ,
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
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
}

```

#### vim-plug

```viml
Plug 'moniquelive/rfc.nvim'
Plug 'nvim-lua/plenary.nvim'
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
