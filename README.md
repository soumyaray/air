# Air - AI help for R coding

Air is an R package that lets you ask R related questions to OpenAI and get working code.

It's main feature is to find solutions to simple "how-to" questions and direclty providing working code:

```R
howto("get a vector of the second element from a list of vectors")
# sapply(list_of_vectors, function(v) v[2])

howto("extract the second largest number from a vector")
# vec <- c(1, 5, 3, 9, 7)
# sort(unique(vec), decreasing = TRUE)[2]
```

Air requires your OpenAI API key (see Setup direcitons below), which it stores securely in your operating system's keyring.

Future features under consideration:

- Ask for explanation of what given R code does (e.g, `whatis()`).
- Provide code and explanation for R problems (e.g., `teachme()`).
- Keep conversation session so we can ask followup questions.
- General AI role (e.g., `tellme()`).
- Create custom roles (store in `.Renviron`?)
- Optionally store OpenAI keys in `.Renviron`; check from both environment and keyring.

Feel free to leave issues or reach out to maintainers with any questions.

## Installation

Air is currently only available from Github. Use your favorite installer tool as follows:

Using `pak`:

```R
# install.packages("pak") - if you haven't already
pak::pkg_install("github::soumyaray/air")
```

or, Using `devtools`:

```R
# install.packages("devtools") - if you haven't already
devtools::install_github("soumyaray/air")
```

## Setup

Air needs your API key for OpenAI.

### Creating an OpenAI Key

If you already have an OpenAI acount:

1. Make sure your billing information with OpenAI is uptodate:
   <https://platform.openai.com/account/billing/overview>
2. Create an OpenAI API key:
   <https://platform.openai.com/api-keys>

### Securely storing your OpenAI key locally

Then store your key securely in your operating system's keyring using Air:

We recommend you use your system's keyring function to enter it safely in a system popup window:

```R
air::set_key()
```

Or, you can do so programatically at the console, but note that it might be stored in your `.Rhistory` file where it could get compromised:

```R
air::set_key("api-key-goes-here")
```

## Usage

```R
library(air)

howto("zip vectors foo and bar together, creating a list of vectors which are pairs of elements from the original two vectors")
# zip_list <- mapply(c, foo, bar, SIMPLIFY=FALSE)
```
