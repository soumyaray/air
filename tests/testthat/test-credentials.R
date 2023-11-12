test_that("BAD: catches an invalid API key", {
  bad <- \() {
    vcr::use_cassette("openai-bad-invalid-api-key", {
      air::howto("How do I get the first element of a list?")
    })
  }

  # Unset API key env var, and let VCR will use fake replacement key
  key <- Sys.getenv("OPENAI_KEY")
  Sys.setenv("OPENAI_KEY" = "foobar")
  # Should throw a helpful error
  expect_error(bad(), "Incorrect")
  Sys.setenv("OPENAI_KEY" = key)
})

test_that("BAD: catches an missing API key", {
  bad <- \() {
    vcr::use_cassette("openai-bad-missing-api-key", {
      air::howto("How do I get the first element of a list?")
    })
  }

  # Unset API key env var, and let VCR will use fake replacement key
  key <- Sys.getenv("OPENAI_KEY")
  Sys.unsetenv("OPENAI_KEY")
  # Should throw a helpful error
  expect_error(bad(), "set your OpenAI key and model")
  Sys.setenv("OPENAI_KEY" = key)
})
