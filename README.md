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
2. Create an OpenAI **API key**:  
   <https://platform.openai.com/api-keys>
3. Note which of one of OpenAI's **models** you wish to use:  
   <https://platform.openai.com/docs/models>

Please set your API credentials (key and model) either in your your R environment, or in your system's secure keyring (suggested).

### Setting your OpenAI credentials in your R environment:

Your R environment can specify user level environment variables stored in a local `.Renviron` file. Please note that anyone with access to this file can steal your credentials – make sure not to expose it to any other processes.

Please [read about .Renviron files](https://rstats.wtf/r-startup.html#renviron) if you are unfamiliar with them. Briefly, to set your OpenAI API credentials, we suggest using `usethis::edit_r_environ()` to open the correct `.Renviron` file for editing. You may create `VAR=value` pairs to set your API key and preferred model in this file - for example:

```text
OPENAI_KEY="sk-my-api-key"
OPENAI_MODEL="gpt-4-1106-preview"
```

You will have to restart the R session for these new environment variables to be loaded. You can confirm they are present in your R environment by using:

```R
Sys.getenv("OPENAI_KEY")
Sys.getenv("OPENAI_MODEL")
```

### Securely setting OpenAI credentials in your system keyring

Alternatively, we recommend storing your key and model preference securely in your operating system's keyring using `Air`'s built-in functions for accessing the keyring.

We recommend you use your system's keyring to enter it safely in a system popup window. But you may choose to set it programatically at the console, but note that it will be stored in your `.Rhistory` file where it could get compromised:

```R
# Safely set the key in a system popup
air::set_key()

# or programatically set it:
air::set_key("api-key-goes-here")
```

You must also specify the OpenAI model you prefer to use:

```R
# Set your preferred model
set_model("gpt-4-1106-preview")

# or use the default model (see documentation)
set_model()
```

Note that your system may occasionally popup windows to get your login password to access the keyring for these credentials. We suggest using an 'always accept' option in such popups to reduce how often you see them.

You may later delete your key and model from your keyring using:

```R
# Wipes away all keyring credentials stored by this package
delete_keyring_credentials()
```

## Usage

```R
library(air)

howto("zip vectors foo and bar together, creating a list of vectors which are pairs of elements from the original two vectors")
# zip_list <- mapply(c, foo, bar, SIMPLIFY=FALSE)
```
