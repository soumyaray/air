test_that("BAD: catches an invalid API key", {
  bad_invalid_api_key <- \() {
    vcr::use_cassette("openai-bad-invalid-api-key", {
      air::howto("How do I get the first element of a list?")
    })
  }

  # Unset API key env var, and let VCR will use fake replacement key
  key <- Sys.getenv("OPENAI_KEY")
  Sys.setenv("OPENAI_KEY" = "foobar")
  # Should throw a helpful error
  expect_error(bad_invalid_api_key(), "Incorrect")
  Sys.setenv("OPENAI_KEY" = key)
})

test_that("BAD: catches an missing API key", {
  bad_no_api_key <- \() {
    key <- Sys.getenv("OPENAI_KEY")
    on.exit(Sys.setenv("OPENAI_KEY" = key))

    vcr::use_cassette("openai-bad-missing-api-key", {
      Sys.unsetenv("OPENAI_KEY")
      air::howto("How do I get the first element of a list?")
    })
  }

  expect_error(bad_no_api_key(), "set your OpenAI key and model")
})
