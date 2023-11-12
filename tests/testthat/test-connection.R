test_that("SAD: catches API connectivity error", {
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
