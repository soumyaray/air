test_that("HAPPY: howto returns results", {
  vcr::use_cassette("howto-happy-return-results", {
    good <- air::howto("How do I get the first element of a list?") |>
      suppressMessages()
  })
  expect_true(class(good) == "character")
})

test_that("HAPPY: howto prints result message", {
  good <- \() {
    vcr::use_cassette("howto-happy-print-results", {
      good <- air::howto("How do I get the first element of a list?")
    })
  }
  expect_message(good(), ".*\n+")
})
