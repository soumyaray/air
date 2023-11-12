test_that("HAPPY: howto works", {
  vcr::use_cassette("open-ai", {
    good <- air::howto("How do I get the first element of a list?")
  })
  expect_true(class(good) == "character")
})

test_that("SAD: howto faces connectivity error", {
  dead_api <- \(endpoint, key, json_body) {
    result(success = FALSE, status = "Error",
           message = "Connection Error to OpenAI API")
  }

  bad <- \() {
    air::howto(
      "How do I get the first element of a list?",
      call_api = dead_api
    )
  }

  # Should throw a helpful error
  expect_error(bad(), "Connection Error")
})
