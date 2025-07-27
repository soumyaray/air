test_that("HAPPY: howto returns results", {
  vcr::use_cassette("howto-happy-return-results", {
    with_stubbed_credentials({
      good <- air::howto("How do I get the first element of a list?") |>
        suppressMessages()
    })
  })

  expect_true(class(good) == "character")
  air:::delete_keyring_credentials()
})

test_that("HAPPY: howto prints result message", {
  vcr::use_cassette("howto-happy-print-results", {
    happy_results <- \() {
      with_stubbed_credentials({
        air::howto("How do I get the first element of a list?")
      })
    }
    expect_message(happy_results(), ".*\n+")
  })
})
