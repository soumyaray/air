test_that("BAD: catches an invalid API key", {
  bad_invalid_api_key <- \() {
    key <- Sys.getenv("OPENAI_KEY")
    on.exit(Sys.setenv("OPENAI_KEY" = key))

    vcr::use_cassette("openai-bad-invalid-api-key", {
      with_stubbed_credentials({
        Sys.setenv("OPENAI_KEY" = "foobar")
        air::howto("How do I get the first element of a list?")
      })
    })
  }

  # Should throw a helpful error
  expect_error(bad_invalid_api_key(), "Incorrect")
})

test_that("BAD: catches an missing API key", {
  bad_no_api_key <- \() {
    key <- Sys.getenv("OPENAI_KEY")
    on.exit(Sys.setenv("OPENAI_KEY" = key))

    with_stubbed_credentials({
      Sys.unsetenv("OPENAI_KEY")
      suppressWarnings(
        air::howto("How do I get the first element of a list?")
      )
    })
  }

  expect_error(bad_no_api_key(), "set your OpenAI key and model")
})
